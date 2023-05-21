//
//  StartPage.swift
//  Coursea
//
//  Created by Milo Song on 5/15/23.
//

import SwiftUI

struct StartString: Hashable {
    let str: String
}

struct StartPage: View {
    
    @State private var role = ""
    @State private var roles = ["student", "teacher", "administrator"]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Image("second_image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.all)
                HStack {
                    Text("This is Coursea®,")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    Spacer()
                }
                .padding(.all)
                HStack {
                    Text("an awesome platform to manage your courses.")
                        .font(.title)
                        .fontWeight(.heavy)
                    Spacer()
                }
                .padding(.horizontal)
                HStack {
                    Text("I am a(n) ")
                        .font(.title)
                        .fontWeight(.heavy)
                    Spacer()
                    Picker("", selection: $role) {
                        ForEach(roles, id: \.self) { item in
                            Text(item)
                        }
                    }
                }
                .padding(.all)
                NavigationLink(value: "Start My Journey") {
                    Text("Start My Journey")
                        .font(.title2)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(height: 70)
                        .frame(maxWidth: .infinity)
                        .background(.indigo)
                        .navigationBarHidden(true)
                        .navigationTitle("")
                }
                .navigationDestination(for: String.self, destination: { textValue in
                    LogIn(role: role)
                })
                .cornerRadius(16)
                .padding(.all)
                Text("© All rights reserved.\nCode with ♥️")
                    .foregroundColor(.gray)
                    .padding(.all)
            }
            .padding(.all)
        }
    }
}

struct StartPage_Previews: PreviewProvider {
    static var previews: some View {
        StartPage()
    }
}
