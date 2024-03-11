//
//  AuthenticationViewModel.swift
//  Diary
//
//  Created by Dhruv Saraswat on 23/02/24.
//

import Firebase
import GoogleSignIn

final class AuthenticationViewModel: ObservableObject {
    enum SignInState {
        case signedIn(userId: String)
        case signedOut
    }

    @Published var state: SignInState = .signedOut
    @Published var username: String = ""
    @Published var password: String = ""

    // TODO: Before signing in, check the username and/or password values are not empty
    func signInWithCredentials() {
        Auth.auth().signIn(withEmail: username, password: password) { [unowned self] authDataResult, error in
            if let error = error {
                debugPrint("ERROR WHILE SIGNING INTO ACCOUNT - \(error.localizedDescription)")
            } else {
                if let userId = authDataResult?.user.uid {
                    self.state = .signedIn(userId: userId)
                } else {
                    debugPrint("uId (userId) not found in Firebase response when creating account, unable to proceed further")
                }
            }
        }
    }

    // TODO: Before creating an account, verify that the username is a vald email, and the password is sufficiently complex.
    func createAccount() {
        Auth.auth().createUser(withEmail: username, password: password) { [unowned self] authDataResult, error in
            if let error = error {
                debugPrint("ERROR WHILE CREATING ACCOUNT - \(error.localizedDescription)")
            } else {
                if let userId = authDataResult?.user.uid {
                    self.state = .signedIn(userId: userId)
                } else {
                    debugPrint("uId (userId) not found in Firebase response when creating account, unable to proceed further")
                }
            }
        }
    }

    func signInWithGoogle() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            guard let clientId = FirebaseApp.app()?.options.clientID,
                  let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else { return }

            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientId)

            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] signInResult, error in
                authenticateUser(for: signInResult?.user, with: error)
            }
        }
    }

    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        if let error = error {
            debugPrint("ERROR WHILE AUTHENTICATING WITH GOOGLE - \(error.localizedDescription)")
            return
        }

        guard let idToken = user?.idToken, let accessToken = user?.accessToken else { return }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)

        Auth.auth().signIn(with: credential) { [unowned self] authDataResult, error in
            if let error = error {
                debugPrint("ERROR WHILE AUTHENTICATING WITH GOOGLE - \(error.localizedDescription)")
            } else {
                if let userId = authDataResult?.user.uid {
                    self.state = .signedIn(userId: userId)
                } else {
                    debugPrint("uId (userId) not found in Firebase response, unable to proceed further")
                }
            }
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()

        do {
            try Auth.auth().signOut()
            state = .signedOut
        } catch {
            debugPrint("ERROR WHILE SIGNING OUT - \(error.localizedDescription)")
        }
    }

    func getUserId() -> String? {
        switch state {
        case .signedIn(let userId): return userId
        case .signedOut: return nil
        }
    }
}
