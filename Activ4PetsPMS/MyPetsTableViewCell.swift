//
//  MyPetsTableViewCell.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class MyPetsTableViewCell: UITableViewCell
{

    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petType: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var owner: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
