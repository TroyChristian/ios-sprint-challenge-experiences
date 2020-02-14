//
//  Experience.swift
//  Sprint13Experiences
//
//  Created by Lambda_School_Loaner_219 on 2/14/20.
//  Copyright © 2020 Lambda_School_Loaner_219. All rights reserved.
//

import Foundation
import CoreLocation

enum MediaType: String {
    case image
    case audio
    case video
}

class Experience: NSObject {
    var title:String?
    let mediaType: MediaType
    var geotag: CLLocationCoordinate2D?
    
    init(title:String?, mediaType:MediaType, geotag: CLLocationCoordinate2D?) {
        self.title = title
        self.mediaType = mediaType
        self.geotag = geotag 
    }
}
