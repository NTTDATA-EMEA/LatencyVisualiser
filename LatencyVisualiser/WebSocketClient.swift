//
//  WebSocketClient.swift
//  LatencyVisualiser
//
//  Created by Oliver Köth on 09.12.20.
//

import Foundation
import Starscream

class WebSocketClient : WebSocketDelegate {
    var socket : WebSocket?
    var url : String
    var receiver : ((String) -> Void)?
    var logger : ((String) -> Void)?

    init(url:String) {
        self.url = url
    }
    
    func connect() {
        var request = URLRequest(url: URL(string: url)!)
        //var request = URLRequest(url: URL(string: "wss://x56l2wxg6h.execute-api.eu-central-1.amazonaws.com/Prod")!)
        //var request = URLRequest(url: URL(string: "ws://localhost:8080")!)
        request.timeoutInterval = 5
        self.socket = WebSocket(request: request)
        self.socket?.delegate = self
        self.socket?.connect()
    }
    
    func disconnect() {
        self.socket?.disconnect()
    }
    
    func registerReceiver(receiver : ((String) -> Void)?) {
        self.receiver=receiver
    }
    
    func registerLogger(logger : ((String) -> Void)?) {
        self.logger=logger
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            log(text:"connected \(headers)")
        case .disconnected(let reason, let closeCode):
            log(text:"disconnected \(reason) \(closeCode)")
        case .text(let text):
            log(text:"received text: \(text)")
            receive(text:text)
        case .binary(let data):
            log(text:"ignoring received data: \(data)")
        case .pong(let pongData):
            log(text:"ignoring received pong: \(String(describing: pongData))")
        case .ping(let pingData):
            log(text:"ignoring received ping: \(String(describing: pingData))")
        case .error(let error):
            log(text:"ignoring error \(String(describing: error))")
        case .viabilityChanged:
            log(text:"ignoring viabilityChanged")
        case .reconnectSuggested:
            log(text:"ignoring reconnectSuggested")
        case .cancelled:
            log(text:"ignoring cancelled")
        }
    }
    
    func sendMessage(message: Message) {
        let json = try! JSONEncoder().encode(message)
        let string = String(data:json, encoding: .utf8)!
        self.socket?.write(string: string)
    }
    
    func receive(text:String) {
        if (receiver != nil) {
            receiver!(text)
        }
    }

    func log(text:String) {
        if (logger != nil) {
            logger!(text)
        }
    }
}
