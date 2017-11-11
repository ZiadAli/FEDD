//
//  ProjectController.swift
//  FEDD
//
//  Created by Ziad Ali on 9/27/17.
//  Copyright © 2017 ZiadCorp. All rights reserved.
//

import UIKit

class ProjectController: UIViewController {
    
    var teams:[Team]!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var morningAfterNoonSegmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        teams = [Team]()
        let team1 = Team()
        team1.name = "Team #1"
        team1.sessionTime = "morning_projects"
        team1.project = "Animatronics"
        team1.id = "Team1"
        let team2 = Team()
        team2.name = "Team #2"
        teams.append(team1)
        teams.append(team2)
        
        let score = Score()
        score.name = "TestScore"
        DBManager.addScore(team: team1, score: score)
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTeams(teams:[Team]) {
        self.teams = teams
    }
    
    @IBAction func morningAfterNoonStatusChanged(_ sender: Any) {
        print("morning AfterNoon")
        //Change data source
    }
    
}

extension ProjectController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath)
        let team = teams[indexPath.row]
        cell.textLabel?.text = team.name
        
        return cell
    }

}

extension ProjectController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "toTeamController", sender: nil)
    }
}
