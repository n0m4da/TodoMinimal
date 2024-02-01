//
//  ContentView.swift
//  TodoMinimal
//
//  Created by Luis Rivera on 31/01/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            Home()
                .navigationTitle("Todo")
        }
    }
}

#Preview {
    ContentView()
}
