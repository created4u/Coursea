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
                .foregroundColor(.indigo)
                .onTapGesture {
                    showDetails.toggle()
                }
                .sheet(isPresented: $showDetails) {
                    CourseDetailsView(course: course)
                        .presentationDetents([.fraction(0.5)])
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
    
    var body: some View {
    
        Form {
            Section {
                Label(course.name, systemImage: "graduationcap.circle.fill")
                Label("Class " + String(course.start_class) + " - Class" + String(course.end_class), systemImage: "clock.fill")
                Label(course.place, systemImage: "location.circle.fill")
                Label("Week " + String(course.start_week) + " - Week " + String(course.end_week), systemImage: "calendar.circle.fill")
                Label(course.must_choose ? compulsoryCourse : electiveCourse, systemImage: "exclamationmark.circle.fill")
                Label(course.teach_by, systemImage: "person.circle.fill")
                Label(String(course.credit) + " Credits", systemImage: "checkmark.circle.fill")
            }
            .font(.headline)
        }
    }
}

struct CoursesView: View {
    
    @State private var coursesNumber: Int = 0
    @State private var student: Student = Student(first_name: "", last_name: "", gender: "", birth_date: Date(), account: "", major: "", phone_number: "", passed_courses: [], studying_courses: [])
    @State private var account: String = ""
    @State private var coursesArray: [Course] = []
    
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
            student = await userManager.getStudent(account: account)
            coursesNumber = student.studying_courses.count - 1
            for i in 0...coursesNumber {
                print(student.studying_courses[i])
                await coursesArray.append(userManager.getStudyingCoursesInfo(courseID: student.studying_courses[i]))
            }
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
                            Button(action: {},label: {
                                Image(systemName: icons[3])
                                Text("Add Course")
                            })
                            .buttonStyle(.borderedProminent)
                            
                            Button(action: {},label: {
                                HStack{
                                    Image(systemName: icons[4])
                                    Text("Remove Course")
                                }
                            })
                            .buttonStyle(.borderedProminent)},
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
    }
}

struct coursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView()
    }
}
