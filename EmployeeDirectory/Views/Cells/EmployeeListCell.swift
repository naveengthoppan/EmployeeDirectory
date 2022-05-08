//
//  EmployeeListCell.swift
//  EmployeeDirectory
//
//  Created by Naveen George Thoppan on 03/05/2022.
//

import UIKit

class EmployeeListCell: UITableViewCell {

    private var imageRequest: Cancellable?
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activityIndicator.hidesWhenStopped = true
        thumbnailImage.layer.cornerRadius = 32
    }
    
    func configureCell(name: String, team: String, thumbnailUrl: URL, imageService: ImageService) {
        nameLabel.text = name
        teamLabel.text = team
        activityIndicator.startAnimating()
        
        imageRequest = imageService.image(for: thumbnailUrl, completion: { [weak self] image in
            self?.thumbnailImage.image = image
            self?.activityIndicator.stopAnimating()
        })
        
    }

    override func prepareForReuse() {
        thumbnailImage.image = nil
        imageRequest?.cancel()
    }

}
