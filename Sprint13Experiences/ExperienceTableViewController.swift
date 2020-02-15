//
//  ExperienceTableViewController.swift
//  Sprint13Experiences
//
//  Created by Lambda_School_Loaner_219 on 2/14/20.
//  Copyright © 2020 Lambda_School_Loaner_219. All rights reserved.
//

import UIKit

class ExperienceTableViewController: UITableViewController {
    var experienceController = ExperienceController() // the instance that the app should share.
   
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData() //* 

     
    }
    // MARK: Actions

    @IBAction func addExperienceTapped(_ sender: Any) {
        addExperience()
    }
    
    private func addExperience() {
        let alert = UIAlertController(title: "New Experience", message: "What kind of experience are you creating?", preferredStyle: .actionSheet)
        
        let videoAlertAction = UIAlertAction(title: "Video Experience", style: .default) { (_) in
            self.performSegue(withIdentifier: "VideoSegue", sender: nil) }
        
        let audioAlertAction = UIAlertAction(title: "Audio Experience ", style: .default) { (_) in
        self.performSegue(withIdentifier: "AudioSegue", sender: nil) }
        
        let imageAlertAction = UIAlertAction(title: "Image Experience", style: .default) { (_) in
        self.performSegue(withIdentifier: "ImageSegue", sender: nil) }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(videoAlertAction)
        alert.addAction(audioAlertAction)
        alert.addAction(imageAlertAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated:true, completion: nil)
        
    }
        

 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return experienceController.experiences.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = experienceController.experiences[indexPath.row].title
        cell.detailTextLabel?.text = experienceController.experiences[indexPath.row].mediaType.rawValue

        return cell
    }
    


    // MARK: - Navigation

  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "VideoSegue":
            if let destinationVC = segue.destination as? VideoViewController {
                destinationVC.experienceController = self.experienceController
                destinationVC.delegate = self as! VideoViewControllerDelegate
            }
            
        case "AudioSegue":
            if let destinationVC = segue.destination as? AudioViewController {
                destinationVC.experienceController = self.experienceController
                destinationVC.delegate = self as! AudioViewControllerDelegate
            }
            
        case "ImageSegue":
            if let destinationVC = segue.destination as? ImageViewController {
                destinationVC.experienceController = self.experienceController
                destinationVC.delegate = self as! ImageViewControllerDelegate
            }
            
        case "MapSegue":
            if let destinationVC = segue.destination as? MapViewController {
                destinationVC.experienceController = self.experienceController 
            }
        default:
            return 
        
        }
        
    }
  
}

extension ExperienceTableViewController: VideoViewControllerDelegate, AudioViewControllerDelegate, ImageViewControllerDelegate {
    func addVideoButtonTapped() {
        tableView.reloadData()
    }
    
    func addAudioButtonTapped() {
        tableView.reloadData()
    }
    
    func addImageButtonTapped() {
        tableView.reloadData()
    }
}
