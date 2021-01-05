//
//  ContentView.swift
//  LatencyVisualiser
//
//  Created by Oliver Köth on 09.12.20.
//

import SwiftUI

struct ContentView: View {
    private var edgeClient = WebSocketClient(url:"ws://localhost:8080")
    private var cloudClient = WebSocketClient(url:"wss://x56l2wxg6h.execute-api.eu-central-1.amazonaws.com/Prod")

    @State private var connected = false
    @State private var edgeLatency = "--- ms"
    @State private var cloudLatency = "--- ms"
    @State private var commonLog = "Logging started"
    
    init() {
        edgeClient.registerReceiver(receiver: self.receiveEdge)
        cloudClient.registerReceiver(receiver: self.receiveCloud)
        edgeClient.registerLogger(logger: self.appendLog)
        cloudClient.registerLogger(logger: self.appendLog)
    }

    var body: some View {
        VStack {
            HStack {
                VStack{
                    Text("Edge")
                        .fontWeight(.bold)
                    Text(self.edgeLatency)
                        .font(Font.system(size: 20, design: .monospaced))
                        .padding(5)
                }
                Spacer()
                VStack{
                    Text("Cloud")
                        .fontWeight(.bold)
                    Text(self.cloudLatency)
                        .font(Font.system(size: 20, design: .monospaced))
                        .padding(5)
                }
            }
            .padding(40)
            Spacer()
            HStack {
                TextEditor(text:self.$commonLog)
                    .frame(
                        width: UIScreen.main.bounds.size.width-20,
                        height: UIScreen.main.bounds.size.height/4,
                        alignment: .bottomLeading)
                    .font(Font.system(size: 10, design: .monospaced))
                    .padding(5)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
            }.padding(5)
            HStack() {
                Button(action: doEdge) {
                    HStack {
                        Image(systemName: "arrow.left.square.fill")
                        Text("Edge")
                        .frame(minWidth: 0, maxWidth: 50)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                Button(action: doCloud) {
                    HStack {
                        Text("Cloud")
                        .frame(minWidth: 0, maxWidth: 50)
                        Image(systemName: "arrow.right.square.fill")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
            Button(action: doToggleConnect) {
                HStack {
                    Image(systemName: self.connected ? "icloud.slash.fill" : "icloud.fill")
                    Text(self.connected ? "Disconnect" : "Connect")
                    .frame(minWidth: 0, maxWidth: 100)
                }
                .padding()
                .foregroundColor(.white)
                .background(self.connected ? Color.green : Color.blue)
                .cornerRadius(10)
            }
            .padding()
        }
    }
    
    private func doEdge() {
        let msg = Message(action:"sendmessage", data:String(Date().timeIntervalSince1970))
        if (connected) {
            edgeClient.sendMessage(message:msg)
        }
        
    }

    private func doCloud() {
        let msg = Message(action:"sendmessage", data:String(Date().timeIntervalSince1970))
        if (connected) {
            cloudClient.sendMessage(message:msg)
        }
    }

    private func doToggleConnect() {
        if (!self.connected) {
            edgeClient.connect()
            edgeClient.registerReceiver(receiver: self.receiveEdge)
            edgeClient.registerLogger(logger: self.appendLog)
            cloudClient.connect()
            cloudClient.registerReceiver(receiver: self.receiveCloud)
            cloudClient.registerLogger(logger: self.appendLog)
            self.connected = true
        } else {
            edgeClient.disconnect()
            cloudClient.disconnect()
            self.connected = false
        }
    }
    
    func formatTime(time:TimeInterval) -> String {
        return String(format: "%.3f ms", Float(time))
    }
    
    func receiveEdge(text:String) {
        let from = Date(timeIntervalSince1970:TimeInterval(text)!)
        self.edgeLatency = formatTime(time:from.distance(to:Date()))
    }
    
    func receiveCloud(text:String) {
        let from = Date(timeIntervalSince1970:TimeInterval(text)!)
        self.cloudLatency = formatTime(time:from.distance(to:Date()))
    }
    
    func appendLog(text:String) {
        self.commonLog.append("\n" + text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
