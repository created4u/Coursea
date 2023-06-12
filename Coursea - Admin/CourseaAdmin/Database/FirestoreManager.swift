//
//  FirestoreManager.swift
//  Coursea
//
//  Created by Milo Song on 5/17/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserManager {
    
    func createStudent(student: Student) {
        
        let db = Firestore.firestore()
        
        print(student)
        
        do {
            try db.collection("student").document(student.account).setData(from: student)
        } catch {
            print("Student created successfully... [ FirestoreManager.swift -> createStudent ]")
        }
    }
    
    func createTeacher(teacher: Teacher) {
        
        let db = Firestore.firestore()
        
        do {
            try db.collection("teacher").document(teacher.account).setData(from: teacher)
        } catch {
            print("Teacher created successfully... [ FirestoreManager.swift -> createTeacher ]")
        }
    }
    
    func getStudent(account: String) async -> Student {
        
        let db = Firestore.firestore()
        var student: Student = Student(first_name: "", last_name: "", gender: "", birth_date: Date(), account: "", major: "", phone_number: "", passed_courses: [], studying_courses: [])
        
        do {
            let doc = db.collection("student").document(account)
            student = try await doc.getDocument().data(as: Student.self)
        } catch {
            print("Get student failed... [ FirestoreManager.swift -> getStudent ]")
        }
        
        print("Hope it works...")
        print(student)
        return student
    }
    
    func getTeacher(account: String) async -> Teacher {
        
        let db = Firestore.firestore()
        var teacher: Teacher = Teacher(first_name: "", last_name: "", gender: "", account: "", major: "", phone_number: "", courses_taught: [])
        
        do {
            let doc = db.collection("teacher").document(account)
            teacher = try await doc.getDocument().data(as: Teacher.self)
        } catch {
            print("Get teacher failed... [ FirestoreManager.swift -> getTeacher ]")
            print(error)
        }
        
        print("Hope it works...")
        print("THIS IS ACCOUNT \(account)")
        print(teacher)
        return teacher
    }
    
    func updateBasicInfo(account: String, birthDate: Date, phoneNumber: String) {
        
        let db = Firestore.firestore()
        let doc = db.collection("student").document(account)
        
        doc.updateData([
            "birth_date": birthDate,
            "phone_number": phoneNumber
        ]) { err in
            if err != nil {
                print("Update failed... [ FirestoreManager.swift -> updateBasicInfo ]")
            } else {
                print("Updated... [ FirestoreManager.swift -> updateBasicInfo ]")
            }
        }
    }
    
    // grade the ungraded course
    func gradeCourse(ID: String, grades: [String : Float]) {
        
        let db = Firestore.firestore()
        let doc = db.collection("courses").document(ID)
        
        doc.updateData([
            "studentsAndGPA": grades,
            "graded": true
        ]) { err in
            if err != nil {
                print("Update failed... [ FirestoreManager.swift -> gradeCourse ]")
            } else {
                print("Updated... [ FirestoreManager.swift -> gradeCourse ]")
            }
        }
        
    }
    
    func updateTeacherBasicInfo(account: String, phoneNumber: String) {
        
        let db = Firestore.firestore()
        let doc = db.collection("teacher").document(account)
        
        doc.updateData([
            "phone_number": phoneNumber
        ]) { err in
            if err != nil {
                print("Update failed... [ FirestoreManager.swift -> updateTeacherBasicInfo ]")
            } else {
                print("Updated... [ FirestoreManager.swift -> updateTeacherBasicInfo ]")
            }
        }
    }
    
    
    // add new course from teacher
    func teacherAddNewCourse(course: Course) {
        
        let db = Firestore.firestore()
        
        do {
            try db.collection("temp_courses").document(course.id).setData(from: course)
        } catch {
            print("A new temp course adds successfully... [ FirestoreManager.swift -> teacherAddNewCourse ]")
        }
    }
    
    // add new course from teacher
    func adminAddNewCourse(course: Course) {
        
        let db = Firestore.firestore()
        
        do {
            try db.collection("courses").document(course.id).setData(from: course)
        } catch {
            print("A new temp course adds successfully... [ FirestoreManager.swift -> adminAddNewCourse ]")
        }
    }
    
    // change the GPA
    func correctGPAForStudents(gradeDict: [String : Float], ID: String) {
        
        let db = Firestore.firestore()
        
        do {
            try db.collection("temp_grade").document(ID).setData(gradeDict)
        } catch {
            print("The new grade has been submitted... [ FirestoreManager.swift -> correctGPAForStudents ]")
        }
    }
    
    // get studying courses
    func getStudyingCoursesInfo(courseID: String) async -> Course {
        
        let db = Firestore.firestore()
        let doc = db.collection("courses").document(courseID)
        
        var course: Course = Course(belong_to: "", teach_by: "", name: "", id: "", start_class: 0, end_class: 0, start_week: 0, end_week: 0, place: "", credit: 0, max_person: 0, choose_person: 0, must_choose: false, studentsAndGPA: [ : ], canBeCreated: false, canChangeGPA: false, graded: false)
        
        do {
            course = try await doc.getDocument().data(as: Course.self)
        } catch {
            print("\(error) Get studying courses failed... [ FirestoreManager.swift -> UserManager -> getStudyingCoursesInfo ]")
        }
   
        return course
    }
    
    // get teacher taught courses
    func getTeacherTaughtCoursesInfo(courseID: String) async -> Course {
        
        let db = Firestore.firestore()
        let doc = db.collection("courses").document(courseID)
        
        var course: Course = Course(belong_to: "", teach_by: "", name: "", id: "", start_class: 0, end_class: 0, start_week: 0, end_week: 0, place: "", credit: 0, max_person: 0, choose_person: 0, must_choose: false, studentsAndGPA: [ : ], canBeCreated: false, canChangeGPA: false, graded: false)
        
        do {
            course = try await doc.getDocument().data(as: Course.self)
        } catch {
            print("\(error) Get studying courses failed... [ FirestoreManager.swift -> UserManager -> getTeacherTaughtCoursesInfo ]")
        }
   
        return course
    }
    
    // get those courses that haven't been approved by the admin
    func getUnapprovedCourses(account: String, completion: @escaping([Course]) -> Void) {
        
        print("===== [1] Main body of the function ===== \n")
        
        let db = Firestore.firestore()
        var coursesArray: [Course] = []
        
        db.collection("temp_courses").whereField("teach_by", isEqualTo: account)
            .getDocuments() { (querySnapshot, err) in
                for document in querySnapshot!.documents {
                    do {
                        let singleCourse: Course = try document.data(as: Course.self)
                        print("===== [2] Append an element ===== \n")
                        coursesArray.append(singleCourse)
                    } catch {
                        print("Place A error... [ FirestoreManager.swift -> UserManager -> getUnapprovedCourses ]")
                    }
                    print("\(document.documentID) => \(document.data())")
                }
                completion(coursesArray)
            }
    }
    
    func getAllUnapprovedCourses(completion: @escaping([Course]) -> Void) {
        
        print("===== [1] Main body of the function ===== \n")
        
        let db = Firestore.firestore()
        var coursesArray: [Course] = []
        
        db.collection("temp_courses").getDocuments() { (querySnapshot, err) in
                for document in querySnapshot!.documents {
                    do {
                        let singleCourse: Course = try document.data(as: Course.self)
                        print("===== [2] Append an element ===== \n")
                        coursesArray.append(singleCourse)
                    } catch {
                        print("Place A error... [ FirestoreManager.swift -> UserManager -> getAllUnapprovedCourses ]")
                    }
                    print("\(document.documentID) => \(document.data())")
                }
                completion(coursesArray)
            }
    }
    
    func getAllUnapprovedGrades(completion: @escaping([String : Float], String) -> Void) {
        
        print("===== [1] Main body of the function ===== \n")
        
        let db = Firestore.firestore()
        var newGrades: [String : Float] = [ : ]
        var keysOfTheDict: [String] = []
        var ID: String = ""
//        var valuesOfTheKeys: [Float] = []
        
        db.collection("temp_grade").getDocuments() { (querySnapshot, err) in
                for document in querySnapshot!.documents {
                    do {
                        //let singleGrade: [String : Float] = try document.data()
                        //newGrades = document.data()
                        keysOfTheDict = try Array(document.data().keys)
                        for singleKey in keysOfTheDict {
                            var tempDict: [String : Any] = try document.data().filter({$0.key == singleKey})
                            
                            newGrades[singleKey] = Float(tempDict[singleKey] as! Float)
                        }
                        ID = document.documentID
                        print("===== [2] Append an element ===== \n")
                        print("THIS IS DICTIONARY \(newGrades)")
                        //coursesArray.append(singleCourse)
                    } catch {
                        print("Place A error... [ FirestoreManager.swift -> UserManager -> getAllUnapprovedGrades ]")
                    }
                    print("\(document.documentID) => \(document.data())")
                }
                completion(newGrades, ID)
            }
    }
    
    // remove the course
    func removeUnapprovedCourses(ID: String) {
        
        let db = Firestore.firestore()
        
        db.collection("temp_courses").document(ID).delete() { err in
            if let err = err {
                print("Place A error... [ FirestoreManager.swift -> UserManager -> removeUnapprovedCourses ]")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    // get passed courses
    func getPassedCoursesInfo(courseID: String) async -> Course {
        
        let db = Firestore.firestore()
        let doc = db.collection("courses").document(courseID)
        
        var course: Course = Course(belong_to: "", teach_by: "", name: "", id: "", start_class: 0, end_class: 0, start_week: 0, end_week: 0, place: "", credit: 0, max_person: 0, choose_person: 0, must_choose: false, studentsAndGPA: [ : ], canBeCreated: false, canChangeGPA: false, graded: false)
        
        do {
            course = try await doc.getDocument().data(as: Course.self)
        } catch {
            print("\(error) Get passed courses failed... [FirestoreManager.swift -> UserManager -> getPassedCoursesInfo ]")
        }
   
        return course
    }
    
    // add a passed course
    func updateStudentPassedCoursesInfo(account: String, passedCourses: String) async {
        
        let db = Firestore.firestore()
        let doc = db.collection("student").document(account)
        var originalPassedCourses: [String] = []
        
        do {
            originalPassedCourses = try await doc.getDocument().data(as: Student.self).passed_courses
        } catch {
            print("Get passed courses failed... [FirestoreManager.swift -> UserManager -> updateStudentPassedCoursesInfo ]")
        }
        originalPassedCourses.append(passedCourses)
        
        doc.updateData([
            "passed_courses": originalPassedCourses
        ]) { err in
            if err != nil {
                print("Update failed... [ FirestoreManager.swift -> UserManager -> updateStudentPassedCoursesInfo ]")
            } else {
                print("Updated... [ FirestoreManager.swift -> UserManager -> updateStudentPassedCoursesInfo ]")
            }
        }
    }
    
    // add a studying course
    func updateStudentStudyingCoursesInfo(account: String, studyingCourses: String) async {
        
        let db = Firestore.firestore()
        let doc = db.collection("student").document(account)
        var originalStudyingCourses: [String] = []
        
        do {
            originalStudyingCourses = try await doc.getDocument().data(as: Student.self).studying_courses
        } catch {
            print("Get studying courses failed... [FirestoreManager.swift -> UserManager -> updateStudentStudyingCoursesInfo ]")
        }
        originalStudyingCourses.append(studyingCourses)
        
        doc.updateData([
            "studying_courses": originalStudyingCourses
        ]) { err in
            if err != nil {
                print("Update failed... [ FirestoreManager.swift -> UserManager -> updateStudentStudyingCoursesInfo ]")
            } else {
                print("Updated... [ FirestoreManager.swift -> UserManager -> updateStudentStudyingCoursesInfo ]")
            }
        }
    }
    
    // remove a studying course
    func removeStudentStudyingCoursesInfo(account: String, studyingCourses: String) async {
        
        let db = Firestore.firestore()
        let doc = db.collection("student").document(account)
        var originalStudyingCourses: [String] = []
        
        do {
            originalStudyingCourses = try await doc.getDocument().data(as: Student.self).studying_courses
        } catch {
            print("Get studying courses failed... [FirestoreManager.swift -> UserManager -> updateStudentStudyingCoursesInfo ]")
        }
        
        var position: Int = 0
        
        if originalStudyingCourses[position] != studyingCourses {
            position += 1
        }
        
        originalStudyingCourses.remove(at: position)
        
        doc.updateData([
            "studying_courses": originalStudyingCourses
        ]) { err in
            if err != nil {
                print("Update failed... [ FirestoreManager.swift -> UserManager -> removeStudentStudyingCoursesInfo ]")
            } else {
                print("Updated... [ FirestoreManager.swift -> UserManager -> removeStudentStudyingCoursesInfo ]")
            }
        }
    }

    // add a certain course taught by teacher
    func updateTeacherTaughtCoursesInfo(account: String, taughtCourses: String) async {
        
        let db = Firestore.firestore()
        let doc = db.collection("teacher").document(account)
        var originalTaughtCourses: [String] = []
        
        do {
            originalTaughtCourses = try await doc.getDocument().data(as: Teacher.self).courses_taught
        } catch {
            print("Get taught courses failed... [FirestoreManager.swift -> UserManager -> updateTeacherTaughtCoursesInfo ]")
        }
        originalTaughtCourses.append(taughtCourses)
        
        doc.updateData([
            "courses_taught": originalTaughtCourses
        ]) { err in
            if err != nil {
                print("Update failed... [ FirestoreManager.swift -> UserManager -> updateTeacherTaughtCoursesInfo ]")
            } else {
                print("Updated... [ FirestoreManager.swift -> UserManager -> updateTeacherTaughtCoursesInfo ]")
            }
        }
    }
    
    
    // remove a certain course taught by teacher
    func removeTeacherTaughtCoursesInfo(account: String, taughtCourses: String) async {
        
        let db = Firestore.firestore()
        let doc = db.collection("temp_courses").document(account).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed! [ FirestoreManager.swift -> UserManager -> removeTeacherTaughtCoursesInfo ]")
            }
        }
    }
}
