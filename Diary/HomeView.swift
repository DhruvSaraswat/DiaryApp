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

            Button(action: {}, label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .tint(Color.brown)
            })
        }
    }
}

// TODO: Use `AsyncImage` instead of synchronously downloading the image
struct NetworkImage: View {
    let url: URL?

    var body: some View {
        if let url = url,
           let data = try? Data(contentsOf: url),
           let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthenticationViewModel())
}
