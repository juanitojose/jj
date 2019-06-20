/**
  * Copyright (c) 2019 The StreamX Project
  * <p>
  * Licensed to the Apache Software Foundation (ASF) under one
  * or more contributor license agreements. See the NOTICE file
  * distributed with this work for additional information
  * regarding copyright ownership. The ASF licenses this file
  * to you under the Apache License, Version 2.0 (the
  * "License"); you may not use this file except in compliance
  * with the License. You may obtain a copy of the License at
  * <p>
  * http://www.apache.org/licenses/LICENSE-2.0
  * <p>
  * Unless required by applicable law or agreed to in writing,
  * software distributed under the License is distributed on an
  * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  * KIND, either express or implied. See the License for the
  * specific language governing permissions and limitations
  * under the License.
  */

package com.streamxhub.spark.core

import java.io.StringReader
import java.util.Properties

import com.streamxhub.spark.core.util.SystemPropertyUtil
import com.streamxhub.spark.monitor.api.HeartBeat
import com.streamxhub.spark.monitor.api.util.{PropertiesUtil, ZooKeeperUtil}

import scala.collection.JavaConverters._
import org.apache.spark.SparkConf
import org.apache.spark.sql.SparkSession
import org.apache.spark.streaming.{Seconds, StreamingContext}

import scala.annotation.meta.getter
import scala.collection.mutable.ArrayBuffer
import scala.util.{Failure, Success, Try}

/**
  *
  * Spark Streaming 入口封装
  *
  */
trait XStreaming {

  protected final def args: Array[String] = params

  private final var params: Array[String] = _

  private final var sparkConf: SparkConf = _

  private val sparkListeners = new ArrayBuffer[String]()

  // checkpoint目录
  private var checkpointPath: String = ""

  // 从checkpoint 中恢复失败，则重新创建
  private var createOnError: Boolean = true


  @(transient@getter)
  var sparkSession: SparkSession = _

  /**
    * 初始化，函数，可以设置 sparkConf
    *
    * @param sparkConf
    */
  def configure(sparkConf: SparkConf): Unit = {}

  /**
    * StreamingContext 运行之前执行
    *
    * @param ssc
    */
  def beforeStarted(ssc: StreamingContext): Unit = {}

  /**
    * StreamingContext 运行之后执行
    */
  def afterStarted(ssc: StreamingContext): Unit = {
    HeartBeat(ssc).start()
  }

  /**
    * StreamingContext 停止后 程序停止前 执行
    */
  def beforeStop(ssc: StreamingContext): Unit = {
    HeartBeat(ssc).stop()
  }

  /**
    * 处理函数
    *
    * @param ssc
    */
  def handle(ssc: StreamingContext)

  /**
    * 创建 Context
    *
    * @return
    */

  private[this] def initialize(args: Array[String]): Unit = {
    this.params = args
    var argv = args.toList
    while (argv.nonEmpty) {
      argv match {
        case ("--checkpointPath") :: value :: tail =>
          checkpointPath = value
          argv = tail
        case ("--createOnError") :: value :: tail =>
          createOnError = value.toBoolean
          argv = tail
        case Nil =>
        case tail =>
          System.err.println(s"Unrecognized options: ${tail.mkString(" ")}")
          printUsageAndExit()
      }
    }
    sparkConf = new SparkConf()
    sparkConf.set("spark.user.args", args.mkString("|"))
    //通过vm -Dspark.conf传入配置文件的默认当作本地调试模式
    val (isDebug, conf) = SystemPropertyUtil.get("spark.conf", "") match {
      case "" => (false, sparkConf.get("spark.conf"))
      case path => (true, path)
      case _ => throw new IllegalArgumentException("[StreamX] Usage:properties-file error")
    }
    val config = conf.split("\\.").last match {
      case "properties" => PropertiesUtil.getPropertiesFromFile(conf)
      case "yml" => PropertiesUtil.getPropertiesFromYaml(conf)
      case _ => throw new IllegalArgumentException("[StreamX] Usage:properties-file format error,muse be properties or yml")
    }
    val mode = config.getOrElse("spark.app.conf.mode", "local")
    mode match {
      /**
        * 直接读取本地的配置文件...
        */
      case "local" => sparkConf.setAll(config)

      /**
        * 从配置中心获取配置文件,如果从配置文件中读取失败,则依旧从本地加载配置文件...
        */
      case _ =>
        Try {
          val appId = config("spark.app.myid")
          val zookeeperURL = config("spark.monitor.zookeeper")
          val path = s"/StreamX/spark/conf/$appId"
          val cloudConf = ZooKeeperUtil.get(path, zookeeperURL)
          if (cloudConf.matches("(^\\s+|^)spark.app.*")) {
            val properties = new Properties()
            properties.load(new StringReader(cloudConf))
            properties.stringPropertyNames().asScala.map(k => (k, properties.getProperty(k).trim)).toMap
          } else {
            PropertiesUtil.getPropertiesFromYamlText(cloudConf)
          }
        } match {
          case Success(value) => sparkConf.setAll(value)
          case Failure(_) => sparkConf.setAll(config)
        }
    }
    //debug mode
    if (isDebug) {
      val appName = sparkConf.get("spark.app.name")
      sparkConf.setAppName(s"[LocalDebug] $appName").setMaster("local[*]")
      sparkConf.set("spark.streaming.kafka.maxRatePerPartition", "10")
    }
    sparkConf.set("spark.app.conf", PropertiesUtil.getFileSource(conf))
    sparkConf.set("spark.app.conf.mode", mode)
    sparkConf.set("spark.app.debug", isDebug.toString)
  }

  def creatingContext(): StreamingContext = {
    val extraListeners = sparkListeners.mkString(",") + "," + sparkConf.get("spark.extraListeners", "")
    if (extraListeners != "") sparkConf.set("spark.extraListeners", extraListeners)
    sparkSession = SparkSession.builder().config(sparkConf).getOrCreate()
    // 时间间隔
    val duration = sparkConf.get("spark.batch.duration").toInt
    val ssc = new StreamingContext(sparkSession.sparkContext, Seconds(duration))
    handle(ssc)
    ssc
  }

  private def printUsageAndExit(): Unit = {
    System.err.println(
      """
        |"Usage: Streaming [options]
        |
        | Options are:
        |   --checkpointPath <checkpoint 目录设置>
        |   --createOnError <从 checkpoint 恢复失败,是否重新创建 true|false>
        |""".stripMargin)
    System.exit(1)
  }

  def main(args: Array[String]): Unit = {
    initialize(args)
    configure(sparkConf)
    val context = checkpointPath match {
      case "" => creatingContext()
      case ck =>
        val ssc = StreamingContext.getOrCreate(ck, creatingContext, createOnError = createOnError)
        ssc.checkpoint(ck)
        ssc
    }
    beforeStarted(context)
    context.start()
    afterStarted(context)
    context.awaitTermination()
    beforeStop(context)
  }
}
