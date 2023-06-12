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
                .foregroundColor(.red)
                .onTapGesture {
                    showDetails.toggle()
                }
                .sheet(isPresented: $showDetails) {
                    CourseDetailsView(course: course, showViews: $showDetails)
                        .presentationDetents([.fraction(0.65)])
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
    
    @Binding var showViews: Bool
    private let compulsoryCourse = "Compulsory Course"
    private let electiveCourse = "Elective Course"
    private let orignialHeight: CGFloat = 120
    private let detailHeight: CGFloat = 245
    
    func deleteUnapprovedCourse() {
        
        let userManager = UserManager()
        
        userManager.removeUnapprovedCourses(ID: course.id)
    }
    
    func addNewCourse() {
        let userManager = UserManager()
        
        userManager.adminAddNewCourse(course: course)
        
        userManager.removeUnapprovedCourses(ID: course.id)
    }
    
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
            
            Button {
                addNewCourse()
                showViews.toggle()
            } label: {
                Text("Approve")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(height: 70)
                    .frame(maxWidth: .infinity)
                    .padding(.all, 40.0)
                    .background(.blue)
            }
            .frame(maxHeight: 70)
            .background(.blue)
            .aspectRatio(16, contentMode: .fill)
            .listRowInsets(EdgeInsets())
            .buttonStyle(.borderedProminent)
            
            Button {
                deleteUnapprovedCourse()
                showViews.toggle()
            } label: {
                Text("Turn Down")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.all)
            }
            .frame(maxHeight: 70)
            .background(.red)
            .aspectRatio(16, contentMode: .fill)
            .listRowInsets(EdgeInsets())
            .buttonStyle(.borderedProminent)
        }
    }
}

struct CoursesView: View {
    
    @State private var coursesArray: [Course] = []
    
    func initInfo() async {
        
        let userManager = UserManager()
        
        coursesArray.removeAll()
        
        userManager.getAllUnapprovedCourses() { results in
            self.coursesArray = results
        }
    }
    
    var body: some View {
        
        NavigationStack {
        
            VStack {
                if coursesArray.isEmpty {
                    Image("second_image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.all)
                    Text("There is nothing new...")
                        .font(.headline)
                } else {
                    ForEach(coursesArray, id: \.self) { course in
                        OriginalView(course: course)
                    }
                    Spacer()
                }
            }
            .padding(.all)
            .navigationBarTitle("Management")
            .onAppear {
                Task {
                    await initInfo()
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
