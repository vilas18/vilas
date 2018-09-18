//
//  InsuranceCell.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 21/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class InsuranceCell: UITableViewCell
{

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var account: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var select: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
