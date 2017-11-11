//
//  ProjectController.swift
//  FEDD
//
//  Created by Ziad Ali on 9/27/17.
//  Copyright © 2017 ZiadCorp. All rights reserved.
//

import UIKit

class ProjectController: UITableViewController {
    
    var project:String!
    var morningTeams:[String:Team] = [String:Team]()
    var morningTeamsList:[Team] = [Team]()
    var afternoonTeams:[String:Team] = [String:Team]()
    var afternoonTeamsList:[Team] = [Team]()
    var currentSession = "Morning"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        project = "3D Printing"
        morningTeams = (DBManager.projects[project]?.morningTeams)!
        afternoonTeams = (DBManager.projects[project]?.afternoonTeams)!
        updateTeamList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTeamList), name: NSNotification.Name(rawValue: "Leaderboard Updated"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTeamList() {
        morningTeams = (DBManager.projects[project]?.morningTeams)!
        afternoonTeams = (DBManager.projects[project]?.afternoonTeams)!
        
        morningTeamsList = Array(morningTeams.values)
        afternoonTeamsList = Array(afternoonTeams.values)
        morningTeamsList.sort {$0.score > $1.score}
        afternoonTeamsList.sort {$0.score > $1.score}
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if currentSession == "Morning" {
            return morningTeamsList.count
        }
        return afternoonTeamsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath)
        var teamList = morningTeamsList
        if currentSession == "Afternoon" {
            teamList = afternoonTeamsList
        }
        let team = teamList[indexPath.row]
        cell.textLabel?.text = "\(team.name) \(team.score)"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "toTeamController", sender: nil)
    }

}
