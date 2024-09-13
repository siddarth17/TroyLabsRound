//
//  ContentView.swift
//  TroyLabsHackathon
//
//  Created by Siddarth Rudraraju on 9/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
    }
}


#Preview {
    ContentView()
}
