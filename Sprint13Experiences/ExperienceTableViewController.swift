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
        
        let videoAlertAction = UIAlertAction(title: "Video", style: .default) { (_) in
            self.performSegue(withIdentifier: "VideoSegue", sender: nil) }
        
        let audioAlertAction = UIAlertAction(title: "Audio", style: .default) { (_) in
        self.performSegue(withIdentifier: "AudioSegue", sender: nil) }
        
        let imageAlertAction = UIAlertAction(title: "ImageSegue", style: .default) { (_) in
        self.performSegue(withIdentifier: "ImageSegue", sender: nil) }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(videoAlertAction)
        alert.addAction(audioAlertAction)
        alert.addAction(imageAlertAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated:true, completion: nil) 
        
    }
        

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
