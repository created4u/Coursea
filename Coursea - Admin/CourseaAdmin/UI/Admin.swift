//
//  student.swift
//  Coursea
//
//  Created by Milo Song on 5/11/23.
//

import SwiftUI

struct admin: View {
    
    @State private var currentView = 1
    
    var body: some View {
        TabView(selection: $currentView) {
            CoursesView()
            .tabItem {
                VStack {
                    Image(systemName: "graduationcap")
                    Text("Management")
                }
            }
            .tag(1)
            
            AccountView()
            .tabItem {
                VStack {
                    Image(systemName: "person")
                    Text("Account")
                }
            }
            .tag(2)
        }
    }
}

struct student_Previews: PreviewProvider {
    static var previews: some View {
        admin()
    }
}
