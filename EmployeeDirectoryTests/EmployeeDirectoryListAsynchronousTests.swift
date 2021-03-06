//
//  EmployeeDirectoryTests.swift
//  EmployeeDirectoryTests
//
//  Created by Naveen George Thoppan on 02/05/2022.
//

import XCTest
@testable import EmployeeDirectory

class EmployeeDirectoryListAsynchronousTests: XCTestCase {

    let timeOut: TimeInterval = 2
    var expectation: XCTestExpectation!
    
    override func setUp() {
        expectation = expectation(description: "Server is responding within the timeout interval")
    }

    func test_noServerResponse() {
        URLSession.shared.dataTask(with: URL(string: "employeesList")!) { data, response, error in
            defer { self.expectation.fulfill() }
            XCTAssertNil(data)
            XCTAssertNil(response)
            XCTAssertNotNil(error)
        }.resume()
        waitForExpectations(timeout: timeOut)
    }
    
    func test_403() {
        URLSession.shared.dataTask(with: URL(string: "https://s3.amazonaws.com/sq-mobile-interview/people.json")!) { data, response, error in
            
            defer { self.expectation.fulfill() }
            
            XCTAssertNil(error)
            
            do {
                let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode, 403)
            } catch { }
            
        }.resume()
        
        waitForExpectations(timeout: timeOut)
    }
    
    func test_decodeEmployees() {
        URLSession.shared.dataTask(with: URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees.json")!) { data, response, error in
            defer { self.expectation.fulfill() }
            XCTAssertNil(error)
            
            do {
                let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode, 200)
                
                let data = try XCTUnwrap(data)
                XCTAssertNoThrow(
                    try JSONDecoder().decode(Employees.self, from: data)
                )
            } catch {}
        }.resume()
        waitForExpectations(timeout: timeOut)
    }
    
    func test_decodeEmployeesFailure() {
        URLSession.shared.dataTask(with: URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json")!) { data, response, error in
            defer { self.expectation.fulfill() }
            XCTAssertNil(error)
            
            do {
                let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode, 200)
                
                let data = try XCTUnwrap(data)
                    _ = try JSONDecoder().decode(Employees.self, from: data)
            } catch {
                switch error {
                case DecodingError.keyNotFound(let key, _):
                  XCTAssertEqual(key.stringValue, "team")
                default:
                  XCTFail("\(error)")
                }
            }
        }.resume()
        waitForExpectations(timeout: timeOut)
    }
    
    func test_emptyEmployeeResponse() {
        URLSession.shared.dataTask(with: URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json")!) { data, response, error in
            defer { self.expectation.fulfill() }
            XCTAssertNil(error)
            
            do {
                let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode, 200)
                
                let data = try XCTUnwrap(data)
                XCTAssertNoThrow(
                    try JSONDecoder().decode(Employees.self, from: data)
                )
            } catch {}
        }.resume()
        waitForExpectations(timeout: timeOut)
    }

}
