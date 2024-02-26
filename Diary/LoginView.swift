//
//  LoginView.swift
//  Diary
//
//  Created by Dhruv Saraswat on 23/02/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var viewModel: AuthenticationViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        ZStack {
            Image("journal")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            VStack {
                Text("Welcome to your Diary!")
                    .font(.largeTitle)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(Constants.Colors.bgColor))

                HStack {
                    Spacer()
                        .frame(width: 10)

                    VStack {
                        CustomTextField(isPassword: false,
                                        placeholderText: "Email",
                                        binding: $username,
                                        showDivider: true,
                                        image: Image(systemName: "envelope"))

                        CustomTextField(isPassword: true,
                                        placeholderText: "Password",
                                        binding: $password,
                                        showDivider: false,
                                        image: Image(systemName: "lock"))
                    }
                    .background(RoundedRectangle(cornerRadius: 8).fill(Constants.Colors.bgColor))
                    .padding()

                    Spacer()
                        .frame(width: 10)
                }

                Button(action: {
                    viewModel.signInWithGoogle()
                }, label: {
                    Text("Sign In")
                        .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
                        .foregroundStyle(Constants.Colors.textColor)
                        .background(RoundedRectangle(cornerRadius: 16).fill(Constants.Colors.bgColor))
                })

                Button(action: {
                    viewModel.signInWithGoogle()
                }, label: {
                    HStack(spacing: 0) {
                        Text("Sign In with")
                            .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 10))
                            .foregroundStyle(Constants.Colors.textColor)

                        Image("Gmail")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    }
                    .background(RoundedRectangle(cornerRadius: 16).fill(Constants.Colors.bgColor))
                })
            }
        }
    }
}

struct CustomTextField: View {
    private var isPassword: Bool
    private var placeholderText: String
    private var binding: Binding<String>
    private var showDivider: Bool
    private var image: Image?

    init(isPassword: Bool,
         placeholderText: String,
         binding: Binding<String>,
         showDivider: Bool,
         image: Image? = nil) {
        self.isPassword = isPassword
        self.placeholderText = placeholderText
        self.binding = binding
        self.showDivider = showDivider
        self.image = image
    }

    var body: some View {
        HStack(alignment: .center) {
            if let image = image {
                image
                    .font(.title2)
                    .frame(width: 20)
                    .padding()
            }

            if isPassword {
                SecureField(placeholderText, text: binding)
                    .font(.title2)
            } else {
                TextField(placeholderText, text: binding)
                    .font(.title2)
                    .minimumScaleFactor(0.1)
            }
        }
        if showDivider {
            Divider()
                .frame(height: 1)
        }
    }
}

#Preview {
    LoginView()
}
