//
//  coursesView.swift
//  Coursea
//
//  Created by Milo Song on 5/16/23.
//

import SwiftUI

struct OriginalView: View {
    
    private let orignialHeight: CGFloat = 120

    let course: Course
    
    @State private var showDetails: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .frame(height: orignialHeight)
                .foregroundColor(.purple)
                .onTapGesture {
                    showDetails.toggle()
                }
                .sheet(isPresented: $showDetails) {
                    CourseDetailsView(course: course)
                        .presentationDetents([.fraction(0.45)])
                }
            
            VStack(alignment: .leading) {
                HStack {
                    Label(course.name, systemImage: "graduationcap.circle.fill")
                        .padding([.top, .leading, .trailing], 3.0)
                    Spacer()
                }
                Label("Class " + String(course.start_class) + " - Class " + String(course.end_class), systemImage: "clock.fill")
                    .padding(.all, 3.0)
                Label(course.place, systemImage: "location.circle.fill")
                    .padding([.leading, .bottom, .trailing], 3.0)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: orignialHeight)
            .font(.headline)
            .foregroundColor(.white)
        }
    }
}

struct CourseDetailsView: View {
    
    let course: Course
    
    private let compulsoryCourse = "Compulsory Course"
    private let electiveCourse = "Elective Course"
    private let orignialHeight: CGFloat = 120
    private let detailHeight: CGFloat = 245
    //@State private var showDeleteAlert: Bool = false
    
    var body: some View {
        
        Form {
            Section {
                Label(course.name, systemImage: "graduationcap.circle.fill")
                Label("Class " + String(course.start_class) + " - Class" + String(course.end_class), systemImage: "clock.fill")
                Label(course.place, systemImage: "location.circle.fill")
                Label("Week " + String(course.start_week) + " - Week " + String(course.end_week), systemImage: "calendar.circle.fill")
                Label(course.must_choose ? compulsoryCourse : electiveCourse, systemImage: "exclamationmark.circle.fill")
                Label(String(course.credit) + " Credits", systemImage: "checkmark.circle.fill")
            }
            .font(.headline)
            
//            Section {
//                Button {
//                    showDeleteAlert.toggle()
//                } label: {
//                    Text("Delete Course")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                        .frame(maxWidth: .infinity)
//                        .padding(.all)
//                }
//                .frame(maxHeight: 70)
//                .background(.purple)
//                .aspectRatio(16, contentMode: .fill)
//                .listRowInsets(EdgeInsets())
//                .buttonStyle(.borderedProminent)
//                .alert(isPresented: $showDeleteAlert) {
//                    showAlert()
//                }
//            }
        }
//        .alert(isPresented: $showDeleteAlert, content: {
//            showAlert()
//        })
    }
}

struct AddCourseView: View {
    
    var belong_to: String
    var teach_by: String
    
    @Binding var showWindows: Bool
    
    @State private var showAlert: Bool = false
    @State private var classArray: [String] = [
        "1", "2", "3", "4", "5", "6", "7",
        "8", "9", "10", "11", "12", "13"
    ]
    @State private var weekArray: [String] = [
        "1", "2", "3", "4", "5", "6", "7",
        "8", "9", "10", "11", "12", "13",
        "14", "15", "16", "17", "18", "19", "20"
    ]
    @State private var credits: [String] = [
        "1.0", "1.5", "2.0", "2.5", "3.0", "3.5", "4.0", "4.5", "5.0"
    ]
    @State private var name: String = ""
    @State private var ID: String = ""
    @State private var start_class: String = "1"
    @State private var end_class: String = "1"
    @State private var start_week: String = "1"
    @State private var end_week: String = "1"
    @State private var place: String = "Yifu Building"
    @State private var credit: String = "1.0"
    @State private var max_person: String = ""
    @State private var choose_person: String = ""
    @State private var must_choose: String = "Yes"
    @State private var canBeCreated: Bool = false
    @State private var buildings: Building = Building()
    @State private var course: Course = Course(belong_to: "", teach_by: "", name: "", id: "", start_class: 0, end_class: 0, start_week: 0, end_week: 0, place: "", credit: 0, max_person: 0, choose_person: 0, must_choose: false, studentsAndGPA: [ : ], canBeCreated: false, canChangeGPA: false, graded: false)
    @State private var chooseOptions: [String] = ["Yes", "No"]
    
    func initCourse() {
        course.belong_to = belong_to
        course.teach_by = teach_by
        course.name = name
        course.id = ID
        course.start_class = Int(start_class) ?? 0
        course.end_class = Int(end_class) ?? 0
        course.start_week = Int(start_week) ?? 0
        course.end_week = Int(end_week) ?? 0
        course.place = place
        course.credit = Float(credit) ?? 0
        course.max_person = Int(max_person) ?? 0
        if must_choose == "Yes" {
            course.must_choose = true
        } else {
            course.must_choose = false
        }
        print("Initialized properly... [ CoursesView.swift -> AddCourseView ]")
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text("The course information has been submitted, and students can only choose courses after the approval of the educational administration staff."))
    }
    
    var body: some View {
        Form {
            
            Section {
                
                HStack {
                    Text("Name")
                    Spacer()
                    TextField(" Course Name ", text: $name)
                        .background(.purple.opacity(0.1))
                        .cornerRadius(3)
                        .padding(.leading)
                }
                
                HStack {
                    Text("ID")
                    Spacer()
                    TextField(" Course ID", text: $ID)
                        .background(.purple.opacity(0.1))
                        .cornerRadius(3)
                        .padding(.leading)
                }
                
                HStack {
                    Text("Capacity")
                    Spacer()
                    TextField(" Max Number of Students", text: $max_person)
                        .background(.purple.opacity(0.1))
                        .cornerRadius(3)
                        .padding(.leading)
                }
                
                Picker(selection: $start_class) {
                    ForEach(classArray, id: \.self) { classNum in
                        Text(classNum)//.tag(classNum)
                    }
                } label: {
                    Text("Start Class")
                }
                
                Picker(selection: $end_class) {
                    ForEach(classArray, id: \.self) { classNum in
                        Text(classNum)//.tag(classNum)
                    }
                } label: {
                    Text("End Class")
                }
                
                Picker(selection: $start_week) {
                    ForEach(weekArray, id: \.self) { weekNum in
                        Text(weekNum)//.tag(weekNum)
                    }
                } label: {
                    Text("Start Week")
                }
                
                Picker(selection: $end_week) {
                    ForEach(weekArray, id: \.self) { weekNum in
                        Text(weekNum)//.tag(weekNum)
                    }
                } label: {
                    Text("End Week")
                }
                
                Picker(selection: $must_choose) {
                    ForEach(chooseOptions, id: \.self) { option in
                        Text(option)//.tag(num)
                    }
                } label: {
                    Text("Compulosry?")
                }
                
                Picker(selection: $credit) {
                    ForEach(credits, id: \.self) { num in
                        Text(num)//.tag(num)
                    }
                } label: {
                    Text("Credit")
                }
                
                Picker(selection: $place) {
                    ForEach(buildings.building_list, id: \.self) { building in
                        Text(building)//.tag(building)
                    }
                } label: {
                    Text("Location")
                }
                
            }
            
            Section {
                Button {
                    initCourse()
                    print("This is course ==============\n\(course)")
                    let dataManager = UserManager()
                    dataManager.teacherAddNewCourse(course: course)
                    showAlert.toggle()
                    //showWindows.toggle()
                } label: {
                    Text("Create Course")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.all)
                }
                .frame(maxHeight: 70)
                .background(.purple)
                .aspectRatio(16, contentMode: .fill)
                .listRowInsets(EdgeInsets())
                .buttonStyle(.borderedProminent)
                .alert(isPresented: $showAlert) {
                    getAlert()
                }
            }
        }
        .font(.headline)
    }
}

struct RemoveCourseView: View {
    
    let account: String
    
    @State private var coursesArray: [Course] = []
    @State private var deleteCourseItem: String = ""
    @State private var confirmDelete: Bool = false
    
    func getCouresesInfo() {
        
        let userManager = UserManager()
        
        print("===== [0] Call the function ===== \n")
        
        userManager.getUnapprovedCourses(account: account) { results in
            self.coursesArray = results
        }
        
        print("This is courseArray \(coursesArray)")
    }
    
    func deleteCourse() {
        let userManager = UserManager()
        
        for singleCourse in coursesArray {
            if singleCourse.name == deleteCourseItem {
                userManager.removeUnapprovedCourses(ID: singleCourse.id)
            }
        }
    }
    
    func showAlert() -> Alert {
        return Alert(
            title: Text("Are you sure to delete this course?")
                .font(.headline),
            primaryButton: .destructive(
                Text("Yes")
            ){
                deleteCourse()
            },
            secondaryButton: .cancel(
                Text("No")
            )
        )
    }

    var body: some View {
        VStack {
            if coursesArray.isEmpty {
                VStack(alignment: .leading) {
                    Image("second_image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Text("Oops!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                        .multilineTextAlignment(.leading)
                    Text("I cannot find any course in my memory...")
                        .font(.headline)
                }
                .padding(.all)
            } else {
                Form {
                    Image("second_image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.all)
                    
                    HStack {
                        Text("Selete the course you need to remove")
                            .font(.headline)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Picker(selection: $deleteCourseItem) {
                            ForEach(coursesArray, id: \.self.name) { course in
                                Text(course.name).tag(course.name)
                            }
                        } label: {
                            Text("")
                        }
                    }
                    
                    Section {
                        Button {
                            confirmDelete.toggle()
                        } label: {
                            Text("Delete")
                                .frame(maxWidth: .infinity)
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.all)
                                .foregroundColor(.white)
                        }
                        .background(.purple)
                        .aspectRatio(16, contentMode: .fill)
                        .listRowInsets(EdgeInsets())
                        .buttonStyle(.borderedProminent)
                        .frame(height: 70)
                        .alert(isPresented: $confirmDelete) {
                            showAlert()
                        }
                    }
                }
                .onAppear {
                    deleteCourseItem = coursesArray.first?.name ?? "nil"
                }
            }
        }
        .onAppear {
            getCouresesInfo()
        }
    }
}

struct CoursesView: View {
    
    @State private var coursesNumber: Int = 0
    @State private var teacher: Teacher = Teacher(first_name: "", last_name: "", gender: "", account: "", major: "", phone_number: "", courses_taught: [])
    @State private var account: String = ""
    @State private var coursesArray: [Course] = []
    @State private var showAddCourseView: Bool = false
    @State private var showRemoveCourseView: Bool = false
    
    let icons = [
        "graduationcap",
        "star",
        "person",
        "plus",
        "minus",
    ]
    
    func initInfo() async {
        
        let authManager = AuthenticationManager()
        let userManager = UserManager()
        
        coursesNumber = 0
        coursesArray.removeAll()
        
        do {
            account = try authManager.getAuthenticatedUser().email ?? "nil"
            teacher = await userManager.getTeacher(account: account)
            userManager.getAllTaughtCourses(account: account) { results in
                self.coursesArray = results
            }
            for singleCourse in coursesArray {
                await userManager.updateTeacherTaughtCoursesInfo(account: account, taughtCourses: singleCourse.id)
            }
//            coursesNumber = teacher.courses_taught.count - 1
//            for i in 0...coursesNumber {
//                print(teacher.courses_taught[i])
//                await coursesArray.append(userManager.getTeacherTaughtCoursesInfo(courseID: teacher.courses_taught[i]))
//            }
        } catch {
            print("Get initial info failed... [ CoursesView.swift -> CoursesView ]")
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                VStack {
                    ForEach(coursesArray, id: \.self) { singleCourse in
                        OriginalView(course: singleCourse)
                    }
                    Spacer()
                }
                .padding(.all)
                .navigationBarTitle("Courses")
                .toolbar {
                    Menu(
                        content: {
                            Button(action: {
                                showAddCourseView.toggle()
                            },label: {
                                Image(systemName: icons[3])
                                Text("Add Course")
                            })
                            
                            Button(action: {
                                showRemoveCourseView.toggle()
                            },label: {
                                Image(systemName: icons[4])
                                Text("Remove Course")
                            })
                        },
                        label: {
                            HStack{
                                Spacer()
                                Image(systemName: "ellipsis.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                            }
                        })
                }
                .onAppear {
                    Task {
                        await initInfo()
                    }
                }
            }
        }
        .sheet(isPresented: $showAddCourseView) {
            AddCourseView(belong_to: teacher.major, teach_by: teacher.account, showWindows: $showAddCourseView)
                .presentationDetents([.fraction(0.7)])
        }
        .sheet(isPresented: $showRemoveCourseView) {
            RemoveCourseView(account: teacher.account)
                .presentationDetents([.fraction(0.7)])
        }
    }
}

struct coursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView()
    }
}
