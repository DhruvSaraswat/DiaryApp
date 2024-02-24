//
//  LoginView.swift
//  Diary
//
//  Created by Dhruv Saraswat on 23/02/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            Spacer()

            Text("Welcome to your Diary!")
                .fontWeight(.black)
                .foregroundStyle(Color(.systemIndigo))
                .font(.largeTitle)
                .multilineTextAlignment(.center)

            Text("Track your thoughts on a daily basis.")
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            GoogleSignInButton()
                .padding()
                .onTapGesture {
                    viewModel.signIn()
                }
        }
    }
}

#Preview {
    LoginView()
}
