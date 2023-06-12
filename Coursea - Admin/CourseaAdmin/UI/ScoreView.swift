//
//  ScoreView.swift
//  Coursea
//
//  Created by Milo Song on 5/16/23.
//

import Charts
import SwiftUI

struct gradedCourseItem: View {
    
    let course: Course
    
    @State private var displayChartData: [ScoreData] = []
    @State private var levels: [Float] = [4.0, 3.7, 3.3, 3.0, 2.7, 2.3, 2.0, 1.7, 1.3, 1, 0]
    @State private var showAnalysis: Bool = false
    
    func calculate() {
        
        displayChartData.removeAll()
        
        for level in levels {
            let count = course.studentsAndGPA.filter({$0.value == level}).count
            displayChartData.append(ScoreData(level: level, number: count))
        }
        
        print("This is GRADES \(displayChartData)")
        //maybe percentage needed
    }
    
    var body: some View {
        
        Text(course.name)
        .onTapGesture {
            showAnalysis.toggle()
        }
        .onAppear {
            calculate()
        }
        .font(.headline)
        .sheet(isPresented: $showAnalysis) {
            ChartsView(data: $displayChartData)
                .presentationDetents([.fraction(0.45)])
        }
    }
}

struct ungradedCourseItem: View {
    
    let course: Course
    
    //@State private var displayChartData: [ScoreData] = []
    
    @State private var showGradeView: Bool = false
    @State private var gradeTheCourse: Bool = false
    
//    func calculate() {
//
//        displayChartData.removeAll()
//
//        for level in levels {
//            let count = course.studentsAndGPA.filter({$0.value == level}).count
//            displayChartData.append(ScoreData(level: level, number: count))
//        }
//
//        print("This is GRADES \(displayChartData)")
//        //maybe percentage needed
//    }
    
    
    var body: some View {
        
        Text(course.name)
        .onTapGesture {
            gradeTheCourse.toggle()
        }
//        .onAppear {
//            getAllKeys()
//        }
        .font(.headline)
        .sheet(isPresented: $gradeTheCourse) {
            gradeCourses(course: course, submitGrade: $showGradeView)
        }
    }
}

struct StudentsAndGPA: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var seq: Int
}

struct gradeCourses: View {
    
    let course: Course
    
    @State private var pointer: Int = 0
    @Binding var submitGrade: Bool
    @State private var levels: [String] = ["4.0", "3.7", "3.3", "3.0", "2.7", "2.3", "2.0", "1.7", "1.3", "1.0", "0.0"]
    @State private var allStudents: [String] = []
    @State private var grade: [Float] = []
    @State private var studentsAndTheirGPA: [StudentsAndGPA] = []
    @State private var newGrades: [String : Float] = [ : ]
    
    func getAllKeys() {
        var i = 0
        allStudents = Array(course.studentsAndGPA.keys)
        for student in allStudents {
            studentsAndTheirGPA.append(StudentsAndGPA(name: student, seq: i))
            i += 1
            grade.append(0)
        }
    }
    
    func getValuesFromGrades() {
        for singleGrade in studentsAndTheirGPA {
            let name = singleGrade.name
            let seq = singleGrade.seq
            newGrades[name] = Float(grade[seq])
        }
        
        let userManager = UserManager()
        userManager.gradeCourse(ID: course.id, grades: newGrades)
    }
    
    var body: some View {
        Form {
            ForEach(studentsAndTheirGPA, id: \.self) { singleStudent in
                Picker(selection: $grade[singleStudent.seq]) {
                    ForEach(levels, id: \.self) { level in
                        Text(level)
                    }
                } label: {
                    Text(singleStudent.name)
                }

            }
            
            Section {
                Button {
                    submitGrade.toggle()
                    print("This is GRADES: \(grade)")
                    getValuesFromGrades()
                } label: {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.all)
                        .foregroundColor(.white)
                }
                .background(.red)
                .aspectRatio(16, contentMode: .fill)
                .listRowInsets(EdgeInsets())
                .buttonStyle(.borderedProminent)
                .frame(height: 70)
            }
        }
        .onAppear {
            getAllKeys()
        }
    }
}

struct ScoreData: Identifiable {
    var id = UUID()
    var level: Float
    var number: Int
}

struct ChartsView: View {
    
    @Binding var data: [ScoreData]
    
    var body: some View {
        VStack {
            Chart {
                ForEach(data) { singleData in
                    BarMark (
                        x: .value("GPA", String(singleData.level)),
                        y: .value("Number", singleData.number)
                    )
                }
            }
            .foregroundColor(.red)
        }
        .padding(.all)
    }
}

struct CorrectGradeView: View {
    
    let coursesArray: [Course]
    //let originalString: String
    
    @Binding var showView: Bool
    @State private var courseName: String = ""
    @State private var studentName: String = ""
    @State private var GPA: String = "0.0"
    @State private var levels: [String] = ["4.0", "3.7", "3.3", "3.0", "2.7", "2.3", "2.0", "1.7", "1.3", "1.0", "0.0"]
    @State private var newGrades: [String : Float] = [ : ]
    
    @State private var coursesName: [String] = []
    
    func updateInfo() {
        
        var ID: String = ""
        
        for course in coursesArray {
            if course.name == courseName {
                newGrades = course.studentsAndGPA
                ID = course.id
            }
        }
        
        newGrades[studentName] = Float(GPA)
        
        let userManager = UserManager()
        userManager.correctGPAForStudents(gradeDict: newGrades, ID: ID)
        
    }
    
    func initInfo() async {
        for singleCourse in coursesArray {
            coursesName.append(singleCourse.name)
        }
        courseName = coursesName[0]
    }
    
    var body: some View {
        Form {
            Picker(selection: $courseName) {
                ForEach(coursesName, id: \.self) { name in
                    Text(name)
                }
            } label: {
                Text("Course Name")
            }
            HStack {
                Text("Student Name")
                Spacer()
                TextField("", text: $studentName)
                    .background(.red.opacity(0.1))
                    .cornerRadius(3)
                    .padding(.leading)
            }
            Picker(selection: $GPA) {
                ForEach(levels, id: \.self) { level in
                    Text(level)
                }
            } label: {
                Text("GPA")
            }
            
            Section {
                Button {
                    updateInfo()
                    showView.toggle()
                } label: {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.all)
                        .foregroundColor(.white)
                }
                .background(.red)
                .aspectRatio(16, contentMode: .fill)
                .listRowInsets(EdgeInsets())
                .buttonStyle(.borderedProminent)
                .frame(height: 70)
            }
        }
        .onAppear {
            //courseName = coursesArray.first?.name ?? "nil"
            Task {
                await initInfo()
            }
            print("COURSENAME \(courseName)")
        }
    }
}

struct ScoreView: View {
    
    @State private var coursesNumber = 0
    @State private var account: String = ""
    @State private var teacher: Teacher = Teacher(first_name: "", last_name: "", gender: "", account: "", major: "", phone_number: "", courses_taught: [])
    @State private var coursesArray: [Course] = []
    @State private var ungradedCourses: [Course] = []
    @State private var gradedCourses: [Course] = []
    @State private var showEditGrade: Bool = false
    
    func initInfo() async {
        
        let authManager = AuthenticationManager()
        let userManager = UserManager()
        
        coursesNumber = 0
        coursesArray.removeAll()
        ungradedCourses.removeAll()
        gradedCourses.removeAll()
        
        do {
            account = try authManager.getAuthenticatedUser().email ?? "nil"
            teacher = await userManager.getTeacher(account: account)
            coursesNumber = teacher.courses_taught.count - 1
            for i in 0...coursesNumber {
                await coursesArray.append(userManager.getTeacherTaughtCoursesInfo(courseID: teacher.courses_taught[i]))
            }
            for singleCourse in coursesArray {
                if singleCourse.graded {
                    gradedCourses.append(singleCourse)
                } else {
                    ungradedCourses.append(singleCourse)
                }
            }
        } catch {
            print("Get initial info failed... [ ScoreView.swift -> ScoreView ]")
        }
    }
    
    
    var body: some View {
        NavigationStack {
            
            Form {
                
                Section("Ungraded Courses") {
                    if ungradedCourses.isEmpty {
                        Text("There is no ungraded course.")
                            .font(.headline)
                    } else {
                        ForEach(ungradedCourses, id: \.self) { course in
                            ungradedCourseItem(course: course)
                        }
                    }
                }
                .headerProminence(.increased)
                
                Section("Graded Courses") {
                    if gradedCourses.isEmpty {
                        Text("There is no graded course.")
                            .font(.headline)
                    } else {
                        ForEach(gradedCourses, id: \.self) { course in
                            gradedCourseItem(course: course)
                        }
                    }
                }
                .headerProminence(.increased)
                
                Section {
                    Button {
                        showEditGrade.toggle()
                    } label: {
                        Text("Correct Grade")
                            .frame(maxWidth: .infinity)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.all)
                            .foregroundColor(.white)
                    }
                    .background(.red)
                    .aspectRatio(16, contentMode: .fill)
                    .listRowInsets(EdgeInsets())
                    .buttonStyle(.borderedProminent)
                    .frame(height: 70)
                }
            }
            .navigationTitle("Score")
        }
        .sheet(isPresented: $showEditGrade, content: {
            CorrectGradeView(coursesArray: gradedCourses, showView: $showEditGrade)
        })
        .onAppear {
            Task {
                await initInfo()
            }
        }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView()
    }
}
