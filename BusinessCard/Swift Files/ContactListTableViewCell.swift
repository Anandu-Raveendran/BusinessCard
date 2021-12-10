//
//  ContactListTableViewCell.swift
//  BusinessCard
//
//  Created by Anandu on 2021-12-09.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dpImageView: UIImageView!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
