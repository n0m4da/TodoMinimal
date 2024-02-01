//
//  TodoMinimalApp.swift
//  TodoMinimal
//
//  Created by Luis Rivera on 31/01/24.
//

import SwiftUI

@main
struct TodoMinimalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Todo.self)
    }
}
