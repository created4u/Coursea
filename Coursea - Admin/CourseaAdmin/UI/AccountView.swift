//
//  AccountView.swift
//  Coursea
//
//  Created by Milo Song on 5/16/23.
//

import SwiftUI

struct CreateStudent: View {
    
    @State private var falcuties: [String] = [
        "School of Philosophy and Sociology",
        "College of Humanities",
        "School of Archaeology",
        "College of Foreign Languages",
        "College of Arts",
        "College of Physical Education",
        "School of Foreign Language Education",
        "School of Economics",
        "School of Law",
        "College of Public Administration",
        "Business School",
        "School of Marxism Studies",
        "Northeast Asian Studies College",
        "School of International and Public Affairs",
        "School of Mathematics",
        "College of Physics",
        "College of Chemistry",
        "School of Life Sciences",
        "School of Mechanical and Aerospace Engineering",
        "College of Automotive Engineering",
        "College of Materials Science and Engineering",
        "Transportation College",
        "College of Biological and Agricultural Engineering",
        "School of Management",
        "College of Food Science and Engineering",
        "College of Electronic Science and Engineering",
        "College of Communications Engineering",
        "College of Computer Science and Technology",
        "College of Software",
        "College of Earth Sciences",
        "College of Geo-Exploration Science and Technology",
        "College of Construction Engineering",
        "College of New Energy and Environment",
        "College of Instrumentation and Electrical Engineering",
        "College of Basic Medical Sciences",
        "School of Public Health",
        "School of Pharmaceutical Sciences",
        "School of Nursing",
        "The First Hospital of Jilin University",
        "The Second Hospital of Jilin University",
        "The Third Hospital Affiliated to Jilin University",
        "Hospital of Stomatolgoy",
        "College of Veterinary Medicine",
        "College of Plant Science",
        "College of Animal Science",
        "School of Artificial Intelligence"
    ]
    
    @State private var student: Student = Student(first_name: "", last_name: "", gender: "", birth_date: Date(), account: "", major: "", phone_number: "", passed_courses: [], studying_courses: [])
    @State private var first_name: String = ""
    @State private var last_name: String = ""
    @State private var gender: String = "Male"
    @State private var birth_date: Date = Date()
    @State private var account: String = ""
    @State private var major: String = "College of Computer Science and Technology"
    @State private var phone_number: String = ""
    @State private var genders: [String] = ["Male", "Female", "Others"]
    @State private var submitInfo: Bool = false
    
    func initStudent() {
        student.account = account
        student.first_name = first_name
        student.last_name = last_name
        student.gender = gender
        student.major = major
        student.phone_number = phone_number
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text("A new student account has been created."))
    }
    
    func createAccount() {
        let authManager = AuthenticationManager()
        
        authManager.createUser(email: account, password: "Password")
        
        let userManager = UserManager()
        
        userManager.createStudent(student: student)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("General") {
                    HStack {
                        Text("First Name")
                        Spacer()
                        TextField("", text: $first_name)
                            .background(.red.opacity(0.1))
                            .cornerRadius(3)
                            .padding(.leading)
                    }
                    HStack {
                        Text("Last Name")
                        Spacer()
                        TextField("", text: $last_name)
                            .background(.red.opacity(0.1))
                            .cornerRadius(3)
                            .padding(.leading)
                    }
                    HStack {
                        Text("Unique Account")
                        Spacer()
                        TextField("", text: $account)
                            .background(.red.opacity(0.1))
                            .cornerRadius(3)
                            .padding(.leading)
                    }
                    Picker("Gender", selection: $gender) {
                        ForEach(genders, id: \.self) { singleGender in
                            Text(singleGender)
                        }
                    }
                    DatePicker("Birth Date", selection: $birth_date, displayedComponents: .date)
                    Picker("Major", selection: $major) {
                        ForEach(falcuties, id: \.self) { falcuty in
                            Text(falcuty)
                        }
                    }
                }
                .headerProminence(.increased)
                
                Section("Others") {
                    
                    HStack {
                        Text("Phone Number")
                        Text("+86")
                        Spacer()
                        TextField("", text: $phone_number)
                            .background(.red.opacity(0.1))
                            .cornerRadius(3)
                            .padding(.leading)
                    }
                }
                .headerProminence(.increased)
                
                Section {
                    Button {
                        initStudent()
                        print("THIS IS INNNFO \(student)")
                        createAccount()
                        submitInfo.toggle()
                    } label: {
                        Text("Submit")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(height: 70)
                            .frame(maxWidth: .infinity)
                            .padding(.all, 40.0)
                            .background(.red)
                    }
                    .frame(maxHeight: 70)
                    .background(.red)
                    .aspectRatio(16, contentMode: .fill)
                    .listRowInsets(EdgeInsets())
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Information")
            .alert(isPresented: $submitInfo) {
                getAlert()
            }
        }
    }
}

struct CreateTeacher: View {
    
    @State private var falcuties: [String] = [
        "School of Philosophy and Sociology",
        "College of Humanities",
        "School of Archaeology",
        "College of Foreign Languages",
        "College of Arts",
        "College of Physical Education",
        "School of Foreign Language Education",
        "School of Economics",
        "School of Law",
        "College of Public Administration",
        "Business School",
        "School of Marxism Studies",
        "Northeast Asian Studies College",
        "School of International and Public Affairs",
        "School of Mathematics",
        "College of Physics",
        "College of Chemistry",
        "School of Life Sciences",
        "School of Mechanical and Aerospace Engineering",
        "College of Automotive Engineering",
        "College of Materials Science and Engineering",
        "Transportation College",
        "College of Biological and Agricultural Engineering",
        "School of Management",
        "College of Food Science and Engineering",
        "College of Electronic Science and Engineering",
        "College of Communications Engineering",
        "College of Computer Science and Technology",
        "College of Software",
        "College of Earth Sciences",
        "College of Geo-Exploration Science and Technology",
        "College of Construction Engineering",
        "College of New Energy and Environment",
        "College of Instrumentation and Electrical Engineering",
        "College of Basic Medical Sciences",
        "School of Public Health",
        "School of Pharmaceutical Sciences",
        "School of Nursing",
        "The First Hospital of Jilin University",
        "The Second Hospital of Jilin University",
        "The Third Hospital Affiliated to Jilin University",
        "Hospital of Stomatolgoy",
        "College of Veterinary Medicine",
        "College of Plant Science",
        "College of Animal Science",
        "School of Artificial Intelligence"
    ]
    
    @State private var teacher: Teacher = Teacher(first_name: "", last_name: "", gender: "", account: "", major: "", phone_number: "", courses_taught: [])
    @State private var first_name: String = ""
    @State private var last_name: String = ""
    @State private var gender: String = "Male"
    @State private var account: String = ""
    @State private var major: String = "College of Computer Science and Technology"
    @State private var phone_number: String = ""
    @State private var genders: [String] = ["Male", "Female", "Others"]
    @State private var submitInfo: Bool = false
    
    func initTeacher() {
        teacher.first_name = first_name
        teacher.last_name = last_name
        teacher.gender = gender
        teacher.account = account
        teacher.major = major
        teacher.phone_number = phone_number
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text("A new teacher account has been created."))
    }
    
    func createAccount() {
        let authManager = AuthenticationManager()
        
        authManager.createUser(email: account, password: "Password")
        
        let userManager = UserManager()
        
        userManager.createTeacher(teacher: teacher)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("General") {
                    HStack {
                        Text("First Name")
                        Spacer()
                        TextField("", text: $first_name)
                            .background(.red.opacity(0.1))
                            .cornerRadius(3)
                            .padding(.leading)
                    }
                    HStack {
                        Text("Last Name")
                        Spacer()
                        TextField("", text: $last_name)
                            .background(.red.opacity(0.1))
                            .cornerRadius(3)
                            .padding(.leading)
                    }
                    HStack {
                        Text("Unique Account")
                        Spacer()
                        TextField("", text: $account)
                            .background(.red.opacity(0.1))
                            .cornerRadius(3)
                            .padding(.leading)
                    }
                    Picker("Gender", selection: $gender) {
                        ForEach(genders, id: \.self) { singleGender in
                            Text(singleGender)
                        }
                    }
                    Picker("Major", selection: $major) {
                        ForEach(falcuties, id: \.self) { falcuty in
                            Text(falcuty)
                        }
                    }
                }
                .headerProminence(.increased)
                
                Section("Others") {
                    
                    HStack {
                        Text("Phone Number")
                        Text("+86")
                        Spacer()
                        TextField("", text: $phone_number)
                            .background(.red.opacity(0.1))
                            .cornerRadius(3)
                            .padding(.leading)
                    }
                }
                .headerProminence(.increased)
                
                Section {
                    Button {
                        initTeacher()
                        print("THIS IS INNNFO \(teacher)")
                        createAccount()
                        submitInfo.toggle()
                    } label: {
                        Text("Submit")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(height: 70)
                            .frame(maxWidth: .infinity)
                            .padding(.all, 40.0)
                            .background(.red)
                    }
                    .frame(maxHeight: 70)
                    .background(.red)
                    .aspectRatio(16, contentMode: .fill)
                    .listRowInsets(EdgeInsets())
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Information")
            .alert(isPresented: $submitInfo) {
                getAlert()
            }
        }
    }
}

struct AccountView: View {
    
    @State private var haveSignedOut = false
    @State private var account: String = ""
    
    func getInfo() {
        
        let currentUser = AuthenticationManager()
        let dataManager = UserManager()
        
        do {
            account = try currentUser.getAuthenticatedUser().email ?? "nil"
        } catch {
            print("Cannot get current user's info... [AccountView.swift -> AccountView -> getInfo ]")
        }
        
        print("Info initialized properly... [AccountView.swift -> AccountView -> getInfo ]")
    }
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.red)
                        .frame(height: 120)
                    
                    HStack {
                        
                        Image("default_image")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80, alignment: .leading)
                            .clipShape(Circle())
                            .padding(.all)
                        
                        VStack(alignment: .leading) {
             
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
                        NavigationLink(destination: CreateStudent()) {
                            Label("Create Student Account", systemImage: "person.fill.badge.plus")
                        }
                        
                        NavigationLink(destination: CreateTeacher()) {
                            Label("Create Teacher Account", systemImage: "person.fill.badge.plus")
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
                    .background(.red)
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

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
