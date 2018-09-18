//
//  MainGalleryCell.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 31/07/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class MainGalleryCell: UICollectionViewCell
{
    var initialLoad = true
    
    // since collection view cells are recycled for memory efficiency,
    // you'll have to reset the initialLoad variable before a cell is reused
    override func prepareForReuse() {
        initialLoad = true
    }
    
    internal func configureCell() {
        
        if initialLoad {
            // set your image here
        }
        
        initialLoad = false
        
        // do everything else here
    }
    @IBOutlet var petImage: UIImageView!
    @IBOutlet var albumName: UILabel!
    @IBOutlet var photoCount: UILabel!
    @IBOutlet var selectPhoto: UIButton!
}
