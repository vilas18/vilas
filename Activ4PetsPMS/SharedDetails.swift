
//
//  SharedDetails.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 01/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

final class SharedDetails: NSObject
{
    var appt: String = ""
    var petId: String = ""
    var petName: String = ""
    var petImage: String = ""
    var apptType: String = ""
    var apptTypeId: String = ""
    var clinicName: String = ""
    var clinicLoc: String = ""
    var clinicId: String = ""
    var vetName: String = ""
    var vetId: String = ""
    var date: String = ""
    var time: String = ""
    var flag: String = ""

    static let SharedInstance = SharedDetails()

}
