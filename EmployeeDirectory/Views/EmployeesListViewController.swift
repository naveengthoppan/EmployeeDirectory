//
//  EmployeesListViewController.swift
//  EmployeeDirectory
//
//  Created by Naveen George Thoppan on 01/05/2022.
//

import UIKit

class EmployeesListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var networkClient: EmployeeClient = EmployeeClient.shared
    var dataTask: URLSessionDataTask?
    var employees: [Employee]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupRefreshControl()
    }
    
    private func setupRefreshControl() {
      let refreshControl = UIRefreshControl()
      tableView.refreshControl = refreshControl
      
      refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
      refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      refreshData()
    }
      
    // MARK: - Refresh
    @objc func refreshData() {
      guard dataTask == nil else { return }
      self.tableView.refreshControl?.beginRefreshing()
      dataTask = networkClient.getEmployees() { employees, error in
        self.dataTask = nil
          self.employees = employees?.employees
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.reloadData()
      }
    }
}

extension EmployeesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell") as? UITableViewCell {
            if let employee = employees?[indexPath.row] {
                cell.textLabel?.text = employee.fullName
                cell.detailTextLabel?.text = employee.biography
                return cell
            }
            
        }
        
        return UITableViewCell()
    }
    
    
}
