//
//  Employee.swift
//  EmployeeDirectory
//
//  Created by Naveen George Thoppan on 01/05/2022.
//

import Foundation

enum EmployeeType: String, Decodable {
    case fullTime = "FULL_TIME"
    case partTime = "PART_TIME"
    case contractor = "CONTRACTOR"
    case notAvailable = "Not Available"
}

struct Employees: Decodable {
    let employees: [Employee]
}

struct Employee: Decodable {
    
    var uuid: String
    var fullName: String
    var phoneNumber: String?
    var emailAddress: String
    var biography: String?
    var photoUrlSmall: String?
    var photoUrlLarge: String?
    var team: String
    var employeeType: EmployeeType
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case emailAddress = "email_address"
        case biography
        case photoUrlSmall = "photo_url_small"
        case photoUrlLarge = "photo_url_large"
        case team
        case employeeType = "employee_type"
    }
}
