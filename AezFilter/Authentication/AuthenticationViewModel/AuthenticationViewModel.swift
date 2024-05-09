//
//  AuthenticationViewModel.swift
//  AezFilter
//
//  Created by Ilia Kurlovich on 09.05.24.
//

import Foundation
import Firebase

final class AuthenticationViewModel: ObservableObject {
    @Published var userIsLoggedIn = false
    
    @Published var session: User?
    private var handle: AuthStateDidChangeListenerHandle?
    
    func getUser() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.session = user
            }
        }
    }
    
    func deleteUser() {
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                print("Error deleting user: \(error.localizedDescription)")
            } else {
                print("User deleted successfully.")
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("User signed out successfully.")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
