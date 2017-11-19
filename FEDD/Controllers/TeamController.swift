//
//  TeamController.swift
//  FEDD
//
//  Created by Shreyas Zagade on 10/11/17.
//  Copyright © 2017 ZiadCorp. All rights reserved.
//

import UIKit
import FirebaseFirestore

class TeamController: UIViewController {

    @IBOutlet weak var teamNameTitle: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    var sectionTitle = ["Members","Scores"]
    var project:String!
    var session:String!
    var teamId:String!
    var teamName:String!
    var teamMates = [String]()
    var judges = [String]()
    var scores = [Double]()
    var keys = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = teamName
        
        view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        tableView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        let footerView = UIView()
        footerView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        //footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: footerHeight)
        tableView.tableFooterView = footerView
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addScore(_ sender: Any) {
        performSegue(withIdentifier: "toScoreController", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func disqualifyClicked(_ sender: UIButton) {
        DBManager.publishScore(project: project, session: session, teamId: teamId, score: -1000.0)
    }
    
    @IBAction func publishClicked(_ sender: UIButton) {
        var averageScore = 0.0
        var totalScore = 0.0
        for score in scores {
            totalScore += score
        }
        averageScore = totalScore/Double(scores.count)
        DBManager.publishScore(project: project, session: session, teamId: teamId, score: averageScore)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toScoreController" {
            let inputScoreController = segue.destination as! InputScoreViewController
            if let (scores, bonusPresent) = Scores.rubrics[project] {
                inputScoreController.project = project
                inputScoreController.session = session
                inputScoreController.teamId = teamId
                
                if let scoreRow = sender as? Int {
                    inputScoreController.scoreId = keys[scoreRow]
                    inputScoreController.scoreName = judges[scoreRow]
                    inputScoreController.pullScores = true
                }
                else {
                    let scoreId = Firestore.firestore().collection("Projects").document(project).collection(session).document(teamId).collection("Scores").document().documentID
                    print(scoreId)
                    inputScoreController.scoreId = scoreId
                    let name = UserDefaults.standard.value(forKey: "fullName") as? String ?? "--"
                    inputScoreController.scoreName = name
                    inputScoreController.pullScores = false
                }
                inputScoreController.rubrics = scores
            }
            //inputScoreController.isBonusPresent = bonusPresent
        }
    }
    
}

extension TeamController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return teamMates.count// Number of Students
        }else{
            return judges.count// Number of judges
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let scoreId = keys[indexPath.row]
            DBManager.deleteScore(project: project, session: session, teamId: teamId, scoreId: scoreId)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamViewCell") as! TeamViewCell
        if( indexPath.section == 0){
            cell.leftLabel.text = teamMates[indexPath.row]
            cell.rightLabel.text = ""
        }else{
            cell.leftLabel.text = judges[indexPath.row]
            cell.rightLabel.text = scores[indexPath.row].description
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
}
extension TeamController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTitleCell") as! TeamViewSectionCell
        cell.titleLabel.text = sectionTitle[section]
        cell.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let row = indexPath.row
            print("Key: \(keys[row])")
            performSegue(withIdentifier: "toScoreController", sender: row)
        }
    }
}
