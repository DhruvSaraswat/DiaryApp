//
//  ContentView.swift
//  Diary
//
//  Created by Dhruv Saraswat on 20/02/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel

    var body: some View {
        switch viewModel.state {
        case .signedIn:
            HomeView()
        case .signedOut:
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
