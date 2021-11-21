//
//  ContactTableViewCell.swift
//  BusinessCard
//
//  Created by Anandu on 2021-11-20.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var dpimageField: UIImageView!
    @IBOutlet weak var phoneField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
