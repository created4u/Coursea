//
//  LogIn.swift
//  Coursea
//
//  Created by Milo Song on 5/13/23.
//

import SwiftUI

struct LogIn: View {
    
    @Binding var goBack: Bool
    
    @State private var account: String = ""
    @State private var password: String = ""
    @State private var showHelp: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Coursea")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    showHelp.toggle()
                }, label: {
                    Image(systemName: "questionmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                })
                .padding(.horizontal)
                .sheet(isPresented: $showHelp, content: {
                    VStack(alignment: .leading) {
                        Spacer()
                        Text("If you do not currently have an account, please contact your college's Academic Affairs System Administrator.")
                            .fontWeight(.bold)
                            .padding([.top, .horizontal])
                        Text("After verifying your information, they will help you register a legitimate email address.")
                            .fontWeight(.bold)
                            .padding(.all)
                        Button(action: {
                            showHelp.toggle()
                        }){
                            Text("Get it!")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding(.all)
                                .font(.title2)
                        }
                        .padding([.top, .leading, .trailing])
                        .buttonStyle(.borderedProminent)
                    }
                    .presentationDetents([.fraction(0.4)])
                })
            }
            .padding(.horizontal)
            
            Form {
                Image("front_image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Section("Fill Your Information") {
                    TextField("Account", text: $account)
                        .textInputAutocapitalization(.none)
                    SecureField("Password", text: $password)
                        .textInputAutocapitalization(.none)
                }
                
                Button(action: {
                    let logInManager = AuthenticationManager()
                    logInManager.signIn(email: account, pass: password) { success in
                        if success {
                            goBack = false
                        } else {
                            showAlert = true
                        }
                    }
                },label: {
                    Text("Log In")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(/*@START_MENU_TOKEN@*/.all, 10.0/*@END_MENU_TOKEN@*/)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                })
                .alert(isPresented: $showAlert, content: {
                    getAlert()
                })
                .frame(maxHeight: 70)
                .background(.indigo)
                .aspectRatio(contentMode: .fill)
                .listRowInsets(EdgeInsets())
            }
        }
        .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
    }
    
    func getAlert() -> Alert {
        account = ""
        password = ""
        return Alert(title: Text("Sorry, wrong account or password. \nPlease try again."))
    }
}

struct LogIn_Previews: PreviewProvider {
    static var previews: some View {
        LogIn(goBack: .constant(false))
    }
}
