//
//  RecimeChallengeApp.swift
//  RecimeChallenge
//
//  Created by LIZ on 1/16/26.
//

import SwiftUI
import UIKit

@main
struct RecimeChallengeApp: App {
    init() {
        printAvailableFonts()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }

    /// Debug: Print all available fonts to find the correct PostScript name
    private func printAvailableFonts() {
        #if DEBUG
        for family in UIFont.familyNames.sorted() {
            let fontNames = UIFont.fontNames(forFamilyName: family)
            if !fontNames.isEmpty {
                print("Font Family: \(family)")
                for name in fontNames {
                    print("  - \(name)")
                }
            }
        }
        #endif
    }
}
