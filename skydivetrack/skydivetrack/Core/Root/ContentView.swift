//
//  ContentView.swift
//  Skydivetrack
//
//  Created by Jabba on 10/1/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue, .green]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            VStack{
                LoginScreen()
                
            }
            .padding()
        }
    }
}
#Preview {
    ContentView()
}
