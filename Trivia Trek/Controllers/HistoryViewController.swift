//
//  HistoryViewController.swift
//  Trivia Trek
//
//  Created by Arthur Lafrance on 5/9/19.
//  Copyright © 2019 Homestead FBLA. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HistoryViewController: UITableViewController {

    var games: [Date : Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let db = Firestore.firestore()
        
        let query = db.collection("games").whereField("user", isEqualTo: Auth.auth().currentUser?.uid)
        query.getDocuments(completion: { result, error in
            if error != nil {
                print("\(error?.localizedDescription)")
            }
            else {
                for doc in result!.documents {
                    let score = doc.get("score") as! Int
                    let date = (doc.get("date") as! Timestamp).dateValue()
                    
                    self.games[date] = score
                }
                self.tableView.reloadData()

            }
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.games.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)

        // Configure the cell...
        let index = indexPath.row
        
        let date = Array(self.games.keys)[index]
        let score = self.games[date]!
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        cell.textLabel?.text = "You finished in \(score) turns on \(formatter.string(from: date))"
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        return cell
    }

    @IBAction func rewindToHome(_ sender: Any) {
        self.performSegue(withIdentifier: "rewindToHome", sender: sender)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
