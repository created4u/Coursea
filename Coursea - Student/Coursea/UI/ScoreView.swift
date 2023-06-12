//
//  ScoreView.swift
//  Coursea
//
//  Created by Milo Song on 5/16/23.
//

import Charts
import SwiftUI

struct CourseItem: View {
    
    let course: Course
    let studentName: String
    
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
        HStack {
            Text(course.name)
            Spacer()
            Text(String(course.studentsAndGPA[studentName] ?? 0))
                .foregroundColor(.indigo)
                .fontWeight(.bold)
        }
        .onTapGesture {
            showAnalysis.toggle()
        }
        .onAppear {
            calculate()
        }
        .font(.body)
        .sheet(isPresented: $showAnalysis) {
            ChartsView(myGPA: course.studentsAndGPA[studentName] ?? 0, data: $displayChartData)
                .presentationDetents([.fraction(0.6)])
        }
    }
}

struct ScoreData: Identifiable {
    var id = UUID()
    var level: Float
    var number: Int
}

struct ChartsView: View {
    
    var myGPA: Float
    @State private var percentage: Float = 0
    @Binding var data: [ScoreData]
    @State private var totalNum: Int = 0
    @State private var belowNum: Int = 0
    
    func calculatePercentage() {
        for singleData in data {
            if singleData.level < myGPA {
                belowNum += singleData.number
            }
        }
        
        for singleData in data {
            totalNum += singleData.number
        }
        
        percentage = Float(belowNum  * 100 / totalNum)
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("You beat")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                }
                Text(String(format: "%.1f", percentage) + "%")
                    .foregroundColor(.indigo)
                    .fontWeight(.bold)
                    .font(.largeTitle)
                Text("of your classmates.")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .padding(.vertical)
            Chart {
                ForEach(data) { singleData in
                    BarMark (
                        x: .value("GPA", String(singleData.level)),
                        y: .value("Number", singleData.number)
                    )
                }
            }
            .foregroundColor(.indigo)
        }
        .padding(.all)
        .onAppear {
            calculatePercentage()
        }
    }
}

struct ScoreView: View {
    
    @State private var account: String = ""
    @State private var student: Student = Student(first_name: "", last_name: "", gender: "", birth_date: Date(), account: "", major: "", phone_number: "", passed_courses: [], studying_courses: [])
    @State private var coursesArray: [Course] = []
    @State private var GPA: Float = 0
    @State private var compulsoryCoursesCredits: Float = 0
    @State private var electiveCoursesCredits: Float = 0
    @State private var multiple: Float = 0
    
    func initInfo() async {
        
        let authManager = AuthenticationManager()
        let userManager = UserManager()
        
        coursesArray.removeAll()
        
        do {
            account = try authManager.getAuthenticatedUser().email ?? "nil"
            student = await userManager.getStudent(account: account)
            userManager.getPassedCoursesInfo(coursesID: student.passed_courses) { results in
                self.coursesArray = results
            }
        } catch {
            print("Get initial info failed... [ ScoreView.swift -> ScoreView ]")
        }
    }
    
    func calculate() {
        
        compulsoryCoursesCredits = 0
        electiveCoursesCredits = 0
        GPA = 0
        multiple = 0
        
        for singleCourse in coursesArray {
            if singleCourse.must_choose {
                compulsoryCoursesCredits += singleCourse.credit
            } else {
                electiveCoursesCredits += singleCourse.credit
            }
            multiple += (singleCourse.credit * (singleCourse.studentsAndGPA[account] ?? 0))
        }
        GPA = multiple / (electiveCoursesCredits + compulsoryCoursesCredits)
    }
    
    var body: some View {
        NavigationStack{
            Form {
                Section("Passed Courses") {
                    ForEach(coursesArray, id: \.self) { singleCourse in
                        CourseItem(course: singleCourse, studentName: account)
                    }
                }
                .headerProminence(.increased)
                
                Section("Summary") {
                    HStack {
                        Text("Compulsory Course Credits")
                            .font(.headline)
                        Spacer()
                        Text(String(compulsoryCoursesCredits))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.indigo)
                    }
                    HStack {
                        Text("Elective Course Credits")
                            .font(.headline)
                        Spacer()
                        Text(String(electiveCoursesCredits))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.indigo)
                    }
                    HStack {
                        Text("GPA")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.2f", GPA))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.indigo)
                    }
                }
                .onTapGesture {
                    calculate()
                }
                .headerProminence(.increased)
                
            }
            .navigationTitle("Score")
        }
        .onAppear {
            Task {
                await initInfo()
                calculate()
            }
        }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView()
    }
}
