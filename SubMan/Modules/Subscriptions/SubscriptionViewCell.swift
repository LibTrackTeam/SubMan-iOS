//
//  SubscriptionViewCell.swift
//  SubMan
//
//  Created by Hosny Savage on 28/10/2021.
//

import UIKit

class SubscriptionViewCell: UITableViewCell {

    @IBOutlet weak var subscriptionImageView: UIImageView!
    @IBOutlet weak var subscriptionNameLbl: UILabel!
    @IBOutlet weak var nextBillLbl: UILabel!
    @IBOutlet weak var subscriptionAmountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
