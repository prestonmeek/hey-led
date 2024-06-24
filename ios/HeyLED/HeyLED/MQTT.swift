//
//  MQTT.swift
//  HeyLED
//
//  Created by Preston Meek on 6/17/24.
//
// https://github.com/emqx/CocoaMQTT/blob/4abf2d10315dff60661a32f1db5dcc45a9df9f09/Example/Example/ViewController.swift
// https://github.com/emqx/CocoaMQTT/blob/4abf2d10315dff60661a32f1db5dcc45a9df9f09/Example/Example/ChatViewController.swift

import Foundation
import CocoaMQTT

let mqtt5 = MQTT()
let group = DispatchGroup()

class MQTT {
    let mqtt5: CocoaMQTT5
    var isConnected: Bool = false
    
    init() {
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        mqtt5 = CocoaMQTT5(clientID: clientID, host: "broker.emqx.io", port: 1883)

        let connectProperties = MqttConnectProperties()
        connectProperties.topicAliasMaximum = 0
        connectProperties.sessionExpiryInterval = 0
        connectProperties.receiveMaximum = 100
        connectProperties.maximumPacketSize = 500
        mqtt5.connectProperties = connectProperties

        mqtt5.username = ""
        mqtt5.password = ""
        mqtt5.willMessage = CocoaMQTT5Message(topic: "/will", string: "dieout")
        mqtt5.keepAlive = 60
        mqtt5.delegate = self
    }
    
    private func connect() {
        // Enter the DispatchGroup
        group.enter()
        
        // If we are already connected, do nothing
        // Leave the DispatchGroup
        if isConnected {
            group.leave()
            return
        }
        
        _ = mqtt5.connect()
        
        // async means it will run in the background
        // sync ensures it is a synchronous task
        DispatchQueue.global().async {
            DispatchQueue.global().sync {
                while !self.isConnected {
                    usleep(1000)
                }
                
                // Leave the DispatchGroup once connected
                group.leave()
            }
        }
    }
    
    func publish(msg: String) {
        connect()
        
        // Once the DispatchGroup has been left by connect(), execute code
        group.notify(queue: .main) {
            let publishProperties = MqttPublishProperties()
            // publishProperties.contentType = "JSON"
            
            self.mqtt5.publish("ermwth", withString: msg, qos: .qos1, DUP: false, retained: false, properties: publishProperties)
        }
    }
}

extension MQTT: CocoaMQTT5Delegate {
    func mqtt5(_ mqtt5: CocoaMQTT5, didConnectAck ack: CocoaMQTTCONNACKReasonCode, connAckData: MqttDecodeConnAck?) {
        if ack == .success {
            isConnected = true
            print("Connected to broker")
        }
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishMessage message: CocoaMQTT5Message, id: UInt16) {
        print("Published message:", message)
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishAck id: UInt16, pubAckData: MqttDecodePubAck?) {
        // print("didPublishAck")
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishRec id: UInt16, pubRecData: MqttDecodePubRec?) {
        // print("didPublishRec")
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveMessage message: CocoaMQTT5Message, id: UInt16, publishData: MqttDecodePublish?) {
        // print("didReceiveMessage")
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didSubscribeTopics success: NSDictionary, failed: [String], subAckData: MqttDecodeSubAck?) {
        // print("didSubTopics")
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didUnsubscribeTopics topics: [String], unsubAckData: MqttDecodeUnsubAck?) {
        // print("didUnsubTopics")
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveDisconnectReasonCode reasonCode: CocoaMQTTDISCONNECTReasonCode) {
        // print("didRecDisconn")
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveAuthReasonCode reasonCode: CocoaMQTTAUTHReasonCode) {
        // print("didRecAuth")
    }
    
    func mqtt5DidPing(_ mqtt5: CocoaMQTT5) {
        // print("ping")
    }
    
    func mqtt5DidReceivePong(_ mqtt5: CocoaMQTT5) {
        // print("pong")
    }
    
    func mqtt5DidDisconnect(_ mqtt5: CocoaMQTT5, withError err: (any Error)?) {
        isConnected = false
        print("Disconnected from broker with error: \(err!)")
    }
}
