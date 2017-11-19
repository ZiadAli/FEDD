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
    var project:String!
    var morningTeams:[String:Team] = [String:Team]()
    var morningTeamsList:[Team] = [Team]()
    var afternoonTeams:[String:Team] = [String:Team]()
    var afternoonTeamsList:[Team] = [Team]()
    var currentSession = "Morning"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = project
        DBManager.updateLeaderboard(project: project)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
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
    
    @IBAction func morningAfterNoonStatusChanged(_ sender: UISegmentedControl) {
        var newSession = "Morning"
        if sender.selectedSegmentIndex == 1 {
            newSession = "Afternoon"
        }
        currentSession = newSession
        updateTeamList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTeamController" {
            let teamController = segue.destination as! TeamController
            
            
            let indexPathRow = sender as! Int
            var teamList = morningTeamsList
            if currentSession == "Afternoon" {
                teamList = afternoonTeamsList
            }
            
            let team = teamList[indexPathRow]
            let teamId = team.id!
            let teamName = team.name!
            
            teamController.teamName = teamName
            
            DBManager.getTeamInfo(teamId: teamId, session: currentSession, project: project, completionHandler: { (members, scoresDictionary, scoresKeys) in
                teamController.teamMates = members
                
                var judges = [String]()
                var scores = [Double]()
                var keys = [String]()
                
                for score in Array(scoresDictionary.keys) {
                    if let scoreValue = scoresDictionary[score] {
                        if let scoreName = scoresKeys[score] {
                            keys.append(score)
                            judges.append(scoreName)
                            scores.append(scoreValue)
                        }
                    }
                }
                
                teamController.project = self.project
                teamController.session = self.currentSession
                teamController.teamId = teamId
                teamController.keys = keys
                teamController.judges = judges
                teamController.scores = scores
                teamController.tableView.reloadData()
            })
        }
    }
    
}

extension ProjectController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if currentSession == "Morning" {
            return morningTeamsList.count
        }
        return afternoonTeamsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! TeamViewCell
        var teamList = morningTeamsList
        if currentSession == "Afternoon" {
            teamList = afternoonTeamsList
        }
        let team = teamList[indexPath.row]
        cell.leftLabel.text = team.name!
        let score = Double(round(1000*team.score)/1000)
        cell.rightLabel.text = "\(score)"
        if let userEmail = UserDefaults.standard.value(forKeyPath: "email") as? String {
            let email = userEmail.lowercased()
            if let _ = DBManager.judges[email] {
                if team.published == false {
                    cell.backgroundColor = UIColor.lightGray
                }
                else {
                    cell.backgroundColor = UIColor.white
                }
            }
        }
        
        return cell
    }

}

extension ProjectController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let userEmail = UserDefaults.standard.value(forKeyPath: "email") as? String {
            let email = userEmail.lowercased()
            if let _ = DBManager.judges[email] {
                tableView.deselectRow(at: indexPath, animated: false)
                performSegue(withIdentifier: "toTeamController", sender: indexPath.row)
            }
        }
    }
}
