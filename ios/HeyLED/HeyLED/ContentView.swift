//
//  ContentView.swift
//  HeyLED
//
//  Created by Preston Meek on 6/17/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Hey LED")
            
            Button("Publish test message") {
                mqtt5.publish(msg: "hi!")
            }
        }
        .padding()
        .onAppear() {
            Shortcuts.updateAppShortcutParameters()
        }
    }
}

#Preview {
    ContentView()
}
