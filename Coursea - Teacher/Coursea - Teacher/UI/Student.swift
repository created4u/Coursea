//
//  student.swift
//  Coursea
//
//  Created by Milo Song on 5/11/23.
//

import SwiftUI

struct student: View {
    
    @State private var currentView = 1
    
    let icons = [
        "graduationcap",
        "star",
        "person",
        "plus",
        "minus",
    ]
    
    let description = [
        "Courses",
        "Score",
        "Account"
    ]
    
    var body: some View {
        TabView(selection: $currentView) {
            CoursesView()
            .tabItem {
                VStack {
                    Image(systemName: icons[0])
                    Text(description[0])
                }
            }
            .tag(1)
            
            ScoreView()
            .tabItem {
                VStack {
                    Image(systemName: icons[1])
                    Text(description[1])
                }
            }
            .tag(2)
            
            AccountView()
            .tabItem {
                VStack {
                    Image(systemName: icons[2])
                    Text(description[2])
                }
            }
            .tag(3)
        }
    }
}

struct student_Previews: PreviewProvider {
    static var previews: some View {
        student()
    }
}
