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
    
    let uuid: UUID
    let fullName: String
    let phoneNumber: String?
    let emailAddress: String
    let biography: String?
    let photoUrlSmall: URL?
    let photoUrlLarge: URL?
    let team: String
    let employeeType: EmployeeType
    
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
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let uuidString = try values.decodeIfPresent(String.self, forKey: .uuid)
        uuid = UUID(uuidString: uuidString!)!
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)!
        phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)!
        emailAddress = try values.decodeIfPresent(String.self, forKey: .emailAddress)!
        biography = try values.decodeIfPresent(String.self, forKey: .biography)!
        let photoUrlSmallString = try values.decodeIfPresent(String.self, forKey: .photoUrlSmall)!
        photoUrlSmall = URL(string: photoUrlSmallString)!
        let photoUrlLargeString = try values.decodeIfPresent(String.self, forKey: .photoUrlLarge)!
        photoUrlLarge = URL(string: photoUrlLargeString)!
        team = try values.decodeIfPresent(String.self, forKey: .team)!
        let employeeTypeString = try values.decodeIfPresent(String.self, forKey: .employeeType)
        employeeType = EmployeeType(rawValue: employeeTypeString!) ?? .notAvailable
        
    }
}
