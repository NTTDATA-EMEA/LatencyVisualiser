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
    
    func connect() {
        //var request = URLRequest(url: URL(string: "wss://x56l2wxg6h.execute-api.eu-central-1.amazonaws.com/Prod")!)
        var request = URLRequest(url: URL(string: "ws://localhost:8080")!)
        request.timeoutInterval = 5
        self.socket = WebSocket(request: request)
        self.socket?.delegate = self
        self.socket?.connect()
    }
    
    func disconnect() {
        self.socket?.disconnect()
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
          print("connected \(headers)")
        case .disconnected(let reason, let closeCode):
          print("disconnected \(reason) \(closeCode)")
        case .text(let text):
          print("received text: \(text)")
        case .binary(let data):
          print("received data: \(data)")
        case .pong(let pongData):
            print("received pong: \(String(describing: pongData))")
        case .ping(let pingData):
            print("received ping: \(String(describing: pingData))")
        case .error(let error):
            print("error \(String(describing: error))")
        case .viabilityChanged:
          print("viabilityChanged")
        case .reconnectSuggested:
          print("reconnectSuggested")
        case .cancelled:
          print("cancelled")
        }
    }
    
    func sendMessage(message: String) {
        self.socket?.write(string: message)
    }
}
