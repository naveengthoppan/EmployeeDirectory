//
//  EmployeesListViewController.swift
//  EmployeeDirectory
//
//  Created by Naveen George Thoppan on 01/05/2022.
//

import UIKit

class EmployeesListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var employees: [Employee] = []
    var networkClient: EmployeeClient = EmployeeClient.shared
    var dataTask: URLSessionDataTask?
    lazy var imageService = ImageService(maximumCacheSize: 512 * 1024)
    
    
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
      
    func getEmployeeDetails(for index: Int) -> Employee? {
        if employees.count > index {
            return employees[index]
        }
        return nil
    }
    
    // MARK: - Refresh
    @objc func refreshData() {
        guard dataTask == nil else { return }
      self.tableView.refreshControl?.beginRefreshing()
        dataTask = networkClient.getEmployees() { employees, error in
            
            if error == nil, let employees = employees {
                self.dataTask = nil
                self.employees = employees.employees
                
            } else {
                self.displayAlert("Error", message: error?.localizedDescription ?? "Something went wrong. Please try again")
            }
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
}

extension EmployeesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count == 0 ? 1 : employees.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if employees.count > 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeListCell") as? EmployeeListCell
            {
                if let employee = getEmployeeDetails(for: indexPath.row) {
                    cell.configureCell(name: employee.fullName, team: employee.team, thumbnailUrl: URL(string: employee.photoUrlSmall ?? "")!, imageService: imageService)
                    return cell
                }
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeListErrorCell") {
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}
