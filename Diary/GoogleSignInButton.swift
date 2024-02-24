//
//  GoogleSignInButton.swift
//  Diary
//
//  Created by Dhruv Saraswat on 23/02/24.
//

import SwiftUI
import GoogleSignIn

struct GoogleSignInButton: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme

    private var button = GIDSignInButton()

    func makeUIView(context: Context) -> GIDSignInButton {
        button.colorScheme = colorScheme == .dark ? .dark : .light
        return button
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        button.colorScheme = colorScheme == .dark ? .dark : .light
    }
}
