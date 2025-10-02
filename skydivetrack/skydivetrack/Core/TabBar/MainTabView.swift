//
//  MainTabView.swift
//  Skydivetrack
//
//  Created by Jabba on 10/1/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    var body: some View {
        TabView(selection: $selectedTab){
            Text("Feed")
                .tabItem {
                    VStack{
                        Image(systemName: "house")
                            .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                        Text("Home")
                    }
                }
            
            Text("Friends")
                .tabItem {
                    VStack{
                        Image(systemName: "person.2")
                        Text("Friends")
                    }
                }
            
            Text("Upload")
                .tabItem {
                    VStack{
                        Image(systemName: "plus")
                        Text("Upload")
                    }
                }
            Text("Notifications")
                .tabItem {
                    VStack{
                        Image(systemName: "heart")
                        Text("Notifications")
                    }
                }
            Text("Profile")
                .tabItem {
                    VStack{
                        Image(systemName: "person")
                        Text("Profile")
                    }
                }
             
        }
    }
}

#Preview {
    MainTabView()
}
