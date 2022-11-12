//
//  ContentView.swift
//  Energram
//
//  Created by Alex Antipov on 12.11.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var uuidLasttDayJson = UUID()
    @State private var uuidDebug = UUID()
    
    
    var body: some View {
        VStack {
            TabView {
                
                LastDayJsonView()
                    .tabItem {
                        Label("Latest Price", systemImage: "chart.xyaxis.line")
                    }
                    .tag(uuidLasttDayJson)
                
                
                DebugView()
                    .tabItem {
                        Label("Debug screen", systemImage: "gearshape.2.fill")
                    }
                    .tag(uuidDebug)
                    //.badge(6)
            }
        }
        .background(Palette.background)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
