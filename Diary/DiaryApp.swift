//
//  DiaryApp.swift
//  Diary
//
//  Created by Dhruv Saraswat on 20/02/24.
//

import Firebase
import SwiftUI
import SwiftData

@main
struct DiaryApp: App {
    @StateObject var viewModel = AuthenticationViewModel()
    private let dataProvider = CachedDataProvider.shared

    init() {
        setupAuthentication()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.createCachedDataHandler, dataProvider.createCachedDataHandler())
                .environmentObject(viewModel)
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
        .modelContainer(dataProvider.sharedModelContainer)
    }
}

extension DiaryApp {
    private func setupAuthentication() {
        FirebaseApp.configure()
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = (connectedScenes.first as? UIWindowScene)?.windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}
