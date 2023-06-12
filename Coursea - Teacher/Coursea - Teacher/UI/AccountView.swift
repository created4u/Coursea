//
//  AccountView.swift
//  Coursea
//
//  Created by Milo Song on 5/16/23.
//

import SwiftUI

struct AccountView: View {
    
    @State private var haveSignedOut = false
    @State private var name: String = ""
    @State private var major: String = ""
    @State private var gender: String = ""
    @State private var birthDate: Date = Date()
    @State private var account: String = ""
    @State private var phoneNumber: String = ""
    //@State private var student: Student = Student(first_name: "", last_name: "", gender: "", birth_date: Date(), account: "", major: "", phone_number: "", passed_courses: [], studying_courses: [])
    @State private var teacher: Teacher = Teacher(first_name: "", last_name: "", gender: "", account: "", major: "", phone_number: "", courses_taught: [])
    
    func getInfo() {
        
        let currentUser = AuthenticationManager()
        let dataManager = UserManager()
        
        do {
            account = try currentUser.getAuthenticatedUser().email ?? "nil"
        } catch {
            print("Cannot get current user's info... [AccountView.swift -> AccountView -> getInfo ]")
        }
        
        Task {
            teacher = await dataManager.getTeacher(account: account)
            name = teacher.first_name + " " + teacher.last_name
            major = teacher.major
            gender = teacher.gender
            phoneNumber = teacher.phone_number
        }
        
        print("Info initialized properly... [AccountView.swift -> AccountView -> getInfo ]")
    }
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.purple)
                        .frame(height: 120)
                    
                    HStack {
                        
                        Image("default_image")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80, alignment: .leading)
                            .clipShape(Circle())
                            .padding(.all)
                        
                        VStack(alignment: .leading) {
                            
                            Text(name)
                                .fontWeight(.bold)
                            
                            Text(account)
                                .fontWeight(.bold)
                                .padding(.vertical, 0.6)
                        }
                        .foregroundColor(.white)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                Form {
                    Section {
                        NavigationLink(destination: Information(name: $name, account: $account, gender: $gender, major: $major, phoneNumber: $phoneNumber)) {
                            Label("Edit My Profile", systemImage: "pencil")
                        }
                        
                        NavigationLink(destination: ChangePassword()) {
                            Label("Safty & Privacy", systemImage: "lock")
                        }
                    }
                    
                    Button(action: {
                        
                        let signOutManager = AuthenticationManager()
                        
                        signOutManager.signOut()
                        haveSignedOut = true
                        
                    },label: {
                        Text("Log Out")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(/*@START_MENU_TOKEN@*/.all, 10.0/*@END_MENU_TOKEN@*/)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    })
                    .frame(maxHeight: 70)
                    .background(.purple)
                    .aspectRatio(contentMode: .fill)
                    .listRowInsets(EdgeInsets())
                    .fullScreenCover(isPresented: $haveSignedOut) {
                        LogIn(goBack: $haveSignedOut)
                    }
                }
            }
            .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
            .navigationTitle("Account")
        }
        .onAppear {
            getInfo()
        }
    }
}

struct Information: View {
    
    @Binding var name: String
    @Binding var account: String
    @Binding var gender: String
    @Binding var major: String
    @Binding var phoneNumber: String
    @State var confirm = false
    
    var body: some View {
        Form {
            Section("General") {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(name)
                }
                HStack {
                    Text("Account")
                    Spacer()
                    Text(account)
                }
                HStack {
                    Text("Major")
                    Spacer()
                    Text(major)
                }
                HStack {
                    Text("Gender")
                    Spacer()
                    Text(gender)
                }
            }
            .headerProminence(.increased)
            
            Section("Other Information") {
                HStack {
                    Text("+86 ")
                    TextField("", text: $phoneNumber)
                }
            }
            .headerProminence(.increased)
            
            Section {
                Button(action: {
                    confirm.toggle()
                    confirmChangeInfo()
                },label: {
                    Text("Confirm")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(/*@START_MENU_TOKEN@*/.all, 10.0/*@END_MENU_TOKEN@*/)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                })
                .alert(isPresented: $confirm, content: {
                    getAlert()
                })
                .frame(maxHeight: 70)
                .background(.purple)
                .aspectRatio(contentMode: .fill)
                .listRowInsets(EdgeInsets())
            }
        }
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text("Your profile has been updated!"))
    }
    
    func confirmChangeInfo() {
        let dataManager = UserManager()
        
        dataManager.updateTeacherBasicInfo(account: account, phoneNumber: phoneNumber)
    }
}

struct ChangePassword: View {
    
    @State private var resetPassword = false
    @State var emailAddress: String?
    
    var body: some View {
        Form {
            Image("second_image")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Section {
                Text("We will send you an email soon with the URL to reset your password, please check your email in time. \n\nIf you did not receive the email, please check whether it is listed as spam.")
                    .fontWeight(.medium)
            }
            .padding(.all)
            Section {
                Button(action: {
                    let resetPasswordManager = AuthenticationManager()
                    Task {
                        do {
                            let account = try resetPasswordManager.getAuthenticatedUser().email
                            emailAddress = account
                            resetPasswordManager.sendPasswordReset(withEmail: account ?? "nil")
                            resetPassword = true
                        } catch {
                            print("Failed to hange password... [ AccountView.swift -> ChangePassword ]")
                        }
                    }
                },label: {
                    Text("Okay👌")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(/*@START_MENU_TOKEN@*/.all, 10.0/*@END_MENU_TOKEN@*/)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                })
                .frame(maxHeight: 70)
                .background(.purple)
                .aspectRatio(contentMode: .fill)
                .listRowInsets(EdgeInsets())
                .alert(isPresented: $resetPassword) {
                    reset(email: emailAddress ?? "nil")
                }
            }
        }
    }
    
    func reset(email: String) -> Alert {
        return Alert(title: Text("The reset password e-mail has been send to \(email)"))
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
