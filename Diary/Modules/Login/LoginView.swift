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
    @State private var showSignUpView: Bool = false

    private let loginTitle: String = "Welcome to your Diary!"
    private let signUpTitle: String = "Sign Up"
    private let emailPlaceholderTextLogin: String = "Email"
    private let emailPlaceholderTextSignUp: String = "Enter Email"
    private let passwordPlaceholderTextLogin: String = "Password"
    private let passwordPlaceholderTextSignUp: String = "Enter Password"
    private let bottomHelperTextLogin: String = "Not a member ?"
    private let bottomHelperTextSignUp: String = "Already a member ?"
    private let signUpText: String = "Sign Up"
    private let loginText: String = "Login"
    private let signInText: String = "Sign In"
    private let createAccountText: String = "Create Account"

    var body: some View {
        ZStack {
            Image("journal")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            HStack {
                Spacer()
                    .frame(width: 10)

                VStack {
                    Text(showSignUpView ? signUpTitle : loginTitle)
                        .font(.largeTitle)
                        .padding()

                    HStack {
                        Spacer()
                            .frame(width: 10)

                        VStack(spacing: 0) {
                            CustomTextField(isPassword: false,
                                            placeholderText: showSignUpView ? emailPlaceholderTextSignUp : emailPlaceholderTextLogin,
                                            binding: $viewModel.username,
                                            showDivider: true,
                                            image: Image(systemName: "envelope"))

                            CustomTextField(isPassword: true,
                                            placeholderText: showSignUpView ? passwordPlaceholderTextSignUp : passwordPlaceholderTextLogin,
                                            binding: $viewModel.password,
                                            showDivider: false,
                                            image: Image(systemName: "lock"))
                        }
                        .background(RoundedRectangle(cornerRadius: 8).fill(Constants.Colors.bgColor))
                        .padding()

                        Spacer()
                            .frame(width: 10)
                    }

                    Button(action: {
                        if !showSignUpView {
                            viewModel.signInWithCredentials()
                        } else {
                            viewModel.createAccount()
                        }
                    }, label: {
                        Text(showSignUpView ? createAccountText : signInText)
                            .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
                            .foregroundStyle(Constants.Colors.textColor)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Constants.Colors.bgColor))
                    })

                    if showSignUpView {
                        Text("or")
                            .font(.subheadline)
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                    }

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
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0))

                    HStack(spacing: 0) {
                        Text(showSignUpView ? bottomHelperTextSignUp : bottomHelperTextLogin)
                            .font(.subheadline)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 5))
                            .foregroundStyle(Constants.Colors.textColor)

                        Button(action: {
                            withAnimation(.smooth) {
                                showSignUpView.toggle()
                            }
                        }, label: {
                            Text(showSignUpView ? loginText : signUpText)
                                .font(.subheadline)
                                .fontWeight(.heavy)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                                .foregroundStyle(Constants.Colors.textColor)
                        })
                    }
                }
                .background(RoundedRectangle(cornerRadius: 8).fill(Constants.Colors.bgColor))

                Spacer()
                    .frame(width: 10)
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
        HStack {
            if let image = image {
                image
                    .font(.title3)
                    .frame(width: 20)
                    .padding()
            }

            if isPassword {
                SecureField(placeholderText, text: binding)
                    .font(.title3)
            } else {
                TextField(placeholderText, text: binding)
                    .font(.title3)
                    .minimumScaleFactor(0.1)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled(true)
                    .textContentType(.oneTimeCode)
                    .textInputAutocapitalization(.never)
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
        .environmentObject(AuthenticationViewModel())
}
