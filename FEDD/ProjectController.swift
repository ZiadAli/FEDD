//
//  ProjectController.swift
//  FEDD
//
//  Created by Ziad Ali on 9/27/17.
//  Copyright © 2017 ZiadCorp. All rights reserved.
//

import UIKit

class ProjectController: UITableViewController {
    
    var teams:[Team]!

    override func viewDidLoad() {
        super.viewDidLoad()
        teams = [Team]()
        let team1 = Team()
        team1.name = "Team #1"
        let team2 = Team()
        team2.name = "Team #2"
        teams.append(team1)
        teams.append(team2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTeams(teams:[Team]) {
        self.teams = teams
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath)
        let team = teams[indexPath.row]
        cell.textLabel?.text = team.name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "toTeamController", sender: nil)
    }

}
