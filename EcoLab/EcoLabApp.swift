//
//  EcoLabApp.swift
//  EcoLab
//
//  Created by Juan Pablo Orihuela Araiza on 10/10/24.
//

import SwiftUI

@main
struct EcoLabApp: App {
    @StateObject private var appSettings = AppSettings()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appSettings)
        }
    }
}
