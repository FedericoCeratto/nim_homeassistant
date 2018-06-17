# Copyright 2018 - Thomas T. Jarløv

import asyncdispatch
import mqtt
import strutils

import ../mqtt/mqtt_func
import ../alarm/alarm


proc mqttStartListener() =
  ## Start MQTT listener
  echo "Alarm main MQTT listener started"
  
  var mqttClientMainq = newClient(s_address, "mainalarmlisten", MQTTPersistenceType.None)
  mqttClientMainq.connect(connectOptions)
  mqttClientMainq.subscribe("alarm", QOS0)

  while true:
    try:
      var topicName: string
      var message: MQTTMessage
      let timeout = mqttClientMainq.receive(topicName, message, 10000)
      if not timeout:
        echo message.payload
        asyncCheck alarmParseMqtt(message.payload) 
        
    except:
      mqttClientMainq.disconnect(1000)
      mqttClientMainq.destroy()
      quit()

  mqttClientMainq.disconnect(1000)
  mqttClientMainq.destroy()

  echo "Alarm MQTT exited"


proc listen() =
  mqttStartListener()


when isMainModule:
  listen()
  runForever()