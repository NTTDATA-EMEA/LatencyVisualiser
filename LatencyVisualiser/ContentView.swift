//
//  ContentView.swift
//  LatencyVisualiser
//
//  Created by Oliver Köth on 09.12.20.
//

import SwiftUI

struct ContentView: View {
    private var client = WebSocketClient()
    
    @State private var connected = false

    var body: some View {
        VStack {
            Text("Hello, world!")
            .padding()
            Spacer()
            HStack() {
                Button(action: doLeft) {
                    HStack {
                        Image(systemName: "arrow.left.square.fill")
                        Text("Left")
                        .frame(minWidth: 0, maxWidth: 50)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                Button(action: doRight) {
                    HStack {
                        Text("Right")
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
    
    private func doLeft() {
        print("Left")
        if (connected) {
            client.sendMessage(message: "{\"action\":\"sendmessage\", \"data\":\"left\"}")
        }
        // Create 1st timestamp
        let start = Date()
        
        // Do remote call
        
        // Create 2nd timestamp
        let stop = Date()
        
        // Calculate diff
        print(stop.distance(to:start))
    }

    private func doRight() {
        if (connected) {
            client.sendMessage(message: "{\"action\":\"sendmessage\", \"data\":\"right\"}")
        }
    }

    private func doToggleConnect() {
        if (!self.connected) {
            client.connect()
            self.connected = true
        } else {
            client.disconnect()
            self.connected = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
