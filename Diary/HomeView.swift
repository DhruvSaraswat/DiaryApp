//
//  HomeView.swift
//  Diary
//
//  Created by Dhruv Saraswat on 23/02/24.
//

import SwiftUI
import GoogleSignIn

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var selectedDate: Date = Date.now
    private let user = GIDSignIn.sharedInstance.currentUser

    var body: some View {
        NavigationStack {
            VStack {
                CalendarView(selectedDate: selectedDate)
                    .frame(height: 400)

                HStack(alignment: .lastTextBaseline) {
                    Text("Recent Entries")
                        .font(.title)
                        .fontWeight(.regular)
                        .padding()

                    Spacer()

                    Button(action: {}, label: {
                        Text("See All")
                            .font(.callout)
                            .foregroundStyle(Color.brown)
                            .padding()
                    })
                }

                Spacer()

                NavigationLink {
                    DiaryEntryView()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .tint(Color.brown)
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthenticationViewModel())
}
