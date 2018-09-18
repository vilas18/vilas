//
//  CommonTableViewCell.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 21/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class CommonTableViewCell: UITableViewCell
{

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var secBtn: UIButton!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthlabel: UILabel!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var del: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
