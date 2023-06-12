//
//  DataStructure.swift
//  Coursea
//
//  Created by Milo Song on 5/17/23.
//

import Foundation

struct Student: Codable {
    let first_name: String
    let last_name: String
    let gender: String
    let birth_date: Date
    let account: String
    var major: String
    var phone_number: String
    var passed_courses: [String]
    var studying_courses: [String]
}

struct Teacher: Codable {
    let first_name: String
    let last_name: String
    let gender: String
    let account: String
    var major: String
    var phone_number: String
    var courses_taught: [String]
}

struct Course: Codable, Hashable {
    var belong_to: String
    var teach_by: String
    var name: String
    var id: String
    var start_class: Int
    var end_class: Int
    var start_week: Int
    var end_week: Int
    var place: String
    var credit: Float
    var max_person: Int
    var choose_person: Int
    var must_choose: Bool
    var studentsAndGPA: [String : Float]
    var canBeCreated: Bool
    var canChangeGPA: Bool
    var graded: Bool
}

struct Building {
    var building_list = [
        "Yifu Building",
        "Jingxin Building",
        "Wang Xianghao Building",
        "The Third Teaching Building",
        "Cuiwen Building",
        "Lv Zhenyu Building"
    ]
}

struct College {
    var depts: [String]
    var name: String
}

struct Faculty {
    var arts_and_humanities = College(
        depts: [
            "School of Philosophy and Sociology",
            "College of Humanities",
            "School of Archaeology",
            "College of Foreign Languages",
            "College of Arts",
            "College of Physical Education",
            "School of Foreign Language Education"
        ],
        name: "Arts and Humanities")
    
    var social_sciences = College(
        depts: [
            "School of Economics",
            "School of Law",
            "College of Public Administration",
            "Business School",
            "School of Marxism Studies",
            "Northeast Asian Studies College",
            "School of International and Public Affairs"
        ],
        name: "Social Sciences")
    
    var sciences = College(
        depts: [
            "School of Mathematics",
            "College of Physics",
            "College of Chemistry",
            "School of Life Sciences"
        ],
        name: "Sciences")
    
    var engineering = College(
        depts: [
            "School of Mechanical and Aerospace Engineering",
            "College of Automotive Engineering",
            "College of Materials Science and Engineering",
            "Transportation College",
            "College of Biological and Agricultural Engineering",
            "School of Management",
            "College of Food Science and Engineering"
        ],
        name: "Engnieering")
    
    var information_sciences = College(
        depts: [
            "College of Electronic Science and Engineering",
            "College of Communications Engineering",
            "College of Computer Science and Technology",
            "College of Software"
        ],
        name: "Information Sciences")
    
    var earth_sciences = College(
        depts: [
            "College of Earth Sciences",
            "College of Geo-Exploration Science and Technology",
            "College of Construction Engineering",
            "College of New Energy and Environment",
            "College of Instrumentation and Electrical Engineering"
        ],
        name: "Earth Sciences")
    
    var medical_sciences = College(
        depts: [
            "College of Basic Medical Sciences",
            "School of Public Health",
            "School of Pharmaceutical Sciences",
            "School of Nursing",
            "The First Hospital of Jilin University",
            "The Second Hospital of Jilin University",
            "The Third Hospital Affiliated to Jilin University",
            "Hospital of Stomatolgoy"
        ],
        name: "Medical Sciences")
    
    var agriculture = College(
        depts: [
            "College of Veterinary Medicine",
            "College of Plant Science",
            "College of Animal Science"
        ],
        name: "Agriculture")
    
    var frovarntier_interdisciplinary_studies = College(
        depts: [
            "School of Artificial Intelligence"
        ],
        name: "Frontier Interdisciplinary Studies")
}
