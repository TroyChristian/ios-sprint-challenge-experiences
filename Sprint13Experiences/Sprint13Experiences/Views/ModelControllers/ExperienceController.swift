//
//  ExperienceController.swift
//  Sprint13Experiences
//
//  Created by Lambda_School_Loaner_219 on 2/14/20.
//  Copyright © 2020 Lambda_School_Loaner_219. All rights reserved.
//

import Foundation
import CoreLocation


class ExperienceController {
    var experiences = [Experience]()
    
    func createExperience(title: String, mediaType:MediaType, geotag: CLLocationCoordinate2D?) {
        let experience = Experience(title:title, mediaType:mediaType, geotag:geotag)
        experiences.append(experience)
    }
}
