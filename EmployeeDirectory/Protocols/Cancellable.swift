//
//  Cancellable.swift
//  EmployeeDirectory
//
//  Created by Naveen George Thoppan on 03/05/2022.
//

import Foundation

protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable {
    
}
