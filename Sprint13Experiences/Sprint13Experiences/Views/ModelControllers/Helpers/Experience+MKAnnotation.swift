//
//  Experience+MKAnnotation.swift
//  Sprint13Experiences
//
//  Created by Lambda_School_Loaner_219 on 2/14/20.
//  Copyright © 2020 Lambda_School_Loaner_219. All rights reserved.
//

import MapKit

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        guard let geotag = geotag else { return CLLocationCoordinate2D()}
        return CLLocationCoordinate2D(latitude:geotag.latitude, longitude: geotag.longitude)
    }
    
    
    var experienceTitle: String? {
        title 
    }
}
