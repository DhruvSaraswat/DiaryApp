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

    private let user = GIDSignIn.sharedInstance.currentUser

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NetworkImage(url: user?.profile?.imageURL(withDimension: 200))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Capsule())

                    VStack(alignment: .leading) {
                        Text(user?.profile?.name ?? "")
                            .font(.headline)

                        Text(user?.profile?.email ?? "")
                            .font(.subheadline)
                    }

                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding()

                Spacer()

                Button(action: viewModel.signOut) {
                    Text("Sign Out")
                        .foregroundStyle(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemIndigo))
                        .clipShape(Capsule())
                        .padding()
                }
            }
            .navigationTitle("Diary")
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
