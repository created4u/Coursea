//
//  Entrance.swift
//  Coursea
//
//  Created by Milo Song on 5/14/23.
//

import SwiftUI

struct Entrance: View {
    
    @State private var logInStatus = false
    
    var body: some View {
        NavigationView {
            admin()
                .onAppear {
                    let getUserManager = AuthenticationManager()
                    let authUser = try? getUserManager.getAuthenticatedUser()
                    if authUser == nil {
                        logInStatus = true
                    }
                }
                .fullScreenCover(isPresented: $logInStatus) {
                    LogIn(goBack: $logInStatus)
                }
        }
    }
}

struct Entrance_Previews: PreviewProvider {
    static var previews: some View {
        Entrance()
    }
}
