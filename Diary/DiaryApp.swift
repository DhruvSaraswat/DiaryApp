//
//  DiaryApp.swift
//  Diary
//
//  Created by Dhruv Saraswat on 20/02/24.
//

import Firebase
import SwiftUI

@main
struct DiaryApp: App {
    @StateObject var viewModel = AuthenticationViewModel()

    init() {
        setupAuthentication()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

extension DiaryApp {
    private func setupAuthentication() {
        FirebaseApp.configure()
    }
}
