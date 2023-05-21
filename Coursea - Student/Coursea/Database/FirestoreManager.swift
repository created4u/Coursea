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
        }
        
        print("Hope it works...")
        print(teacher)
        return teacher
    }
    
    func updateBasicInfo(account: String, birthDate: Date, phoneNumber: String) {
        
        let db = Firestore.firestore()
        let doc = db.collection("teacher").document(account)
        
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
    
    // get studying courses
    func getStudyingCoursesInfo(courseID: String) async -> Course {
        
        let db = Firestore.firestore()
        let doc = db.collection("courses").document(courseID)
        
        var course: Course = Course(belong_to: "", teach_by: "", name: "", id: "", start_class: 0, end_class: 0, start_week: 0, end_week: 0, place: "", credit: 0, max_person: 0, choose_person: 0, must_choose: false, studentsAndGPA: [ : ], canBeCreated: false, canChangeGPA: false, graded: false)
        
        do {
            course = try await doc.getDocument().data(as: Course.self)
        } catch {
            print("\(error) Get studying courses failed... [FirestoreManager.swift -> UserManager -> getStudyingCoursesInfo ]")
        }
   
        return course
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
            "teaught_courses": originalTaughtCourses
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
        let doc = db.collection("teacher").document(account)
        var originalTaughtCourses: [String] = []
        
        do {
            originalTaughtCourses = try await doc.getDocument().data(as: Teacher.self).courses_taught
        } catch {
            print("Get studying courses failed... [FirestoreManager.swift -> UserManager -> updateStudentStudyingCoursesInfo ]")
        }
        
        var position: Int = 0
        
        if originalTaughtCourses[position] != taughtCourses {
            position += 1
        }
        
        originalTaughtCourses.remove(at: position)
        
        doc.updateData([
            "taught_courses": originalTaughtCourses
        ]) { err in
            if err != nil {
                print("Update failed... [ FirestoreManager.swift -> UserManager -> removeTeacherTaughtCoursesInfo ]")
            } else {
                print("Updated... [ FirestoreManager.swift -> UserManager -> removeTeacherTaughtCoursesInfo ]")
            }
        }
    }
    
}
