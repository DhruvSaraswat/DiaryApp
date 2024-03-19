//
//  ContentView.swift
//  Diary
//
//  Created by Dhruv Saraswat on 20/02/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        if viewModel.isUserSignedIn {
            HomeView()
                .environmentObject(HomeViewModel())
                .environmentObject(CalendarViewModel(modelContext: modelContext))
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationViewModel())
}
