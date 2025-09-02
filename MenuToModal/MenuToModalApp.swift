//
//  MenuToModalApp.swift
//  MenuToModal
//
//  Created by Yuki Sasaki on 2025/09/03.
//

import SwiftUI

@main
struct MenuToModalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
