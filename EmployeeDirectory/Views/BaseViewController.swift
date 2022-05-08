//
//  BaseViewController.swift
//  EmployeeDirectory
//
//  Created by Naveen George Thoppan on 05/05/2022.
//

import UIKit

class BaseViewController: UIViewController {

    
    func displayAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
                self.dismiss(animated: true)
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
