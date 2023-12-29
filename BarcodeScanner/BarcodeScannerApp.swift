//
//  BarcodeScannerApp.swift
//  BarcodeScanner
//
//  Created by ayush on 29/12/23.
//

import SwiftUI

@main
struct BarcodeScannerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
