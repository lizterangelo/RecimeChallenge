//
//  RecimeChallengeApp.swift
//  RecimeChallenge
//
//  Created by LIZ on 1/16/26.
//

import SwiftData
import SwiftUI
import UIKit

@main
struct RecimeChallengeApp: App {
    init() {
        // Set navigation bar title color to app primary (orange)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "PrimaryColor") ?? .orange]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "PrimaryColor") ?? .orange]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [GroceryItemModel.self, MealPlanModel.self, MealItemModel.self])
    }

    /// Debug: Print all available fonts to find the correct PostScript name
    // private func printAvailableFonts() {
    //     #if DEBUG
    //     for family in UIFont.familyNames.sorted() {
    //         let fontNames = UIFont.fontNames(forFamilyName: family)
    //         if !fontNames.isEmpty {
    //             print("Font Family: \(family)")
    //             for name in fontNames {
    //                 print("  - \(name)")
    //             }
    //         }
    //     }
    //     #endif
    // }
}
