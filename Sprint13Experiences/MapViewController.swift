//
//  MapViewController.swift
//  Sprint13Experiences
//
//  Created by Lambda_School_Loaner_219 on 2/14/20.
//  Copyright © 2020 Lambda_School_Loaner_219. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var experienceController: ExperienceController?
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self as? MKMapViewDelegate 
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
        
        getExperiences()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
    }
    
    func getExperiences() {
        let experiences = ExperienceController.shared.experiences
        if  experiences.count != 0 {
        
        DispatchQueue.main.async {
            self.mapView.addAnnotations(experiences)
        }
        
        guard let experience = experiences.first else { return }

        let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
       let region = MKCoordinateRegion(center: experience.coordinate, span: span)
       self.mapView.setRegion(region, animated: true)
            
            mapView.addAnnotations(experiences)
    }
        else { return }


    
    

    



}

func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       guard let _ = annotation as? Experience  else {
           fatalError("Only Experience objects are supported right now")
       }
       
  guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceView") as? MKMarkerAnnotationView else {
          fatalError("Missing a registered annotationView")
   }
    return annotationView
}
}
