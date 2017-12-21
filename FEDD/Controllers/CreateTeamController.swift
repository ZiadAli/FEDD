//
//  CreateTeamController.swift
//  FEDD
//
//  Created by Ziad Ali on 11/19/17.
//  Copyright © 2017 ZiadCorp. All rights reserved.
//

import UIKit

protocol GetTeamInfo {
    func getTeamInfo(prompt: String, info: String)
}

class CreateTeamController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var sessionSegment: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    var project:String!
    var initialSegmenet:Int!
    var responses = [
        "Team Name":"",
        "Team Member #1":"",
        "Team Member #2":"",
        "Team Member #3":"",
        "Team Member #4":"",
        "Team Member #5":""
    ]
    let promptTexts = ["Team Name", "Team Member #1", "Team Member #2", "Team Member #3", "Team Member #4", "Team Member #5",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionSegment.selectedSegmentIndex = initialSegmenet
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promptTexts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamInfoCell") as! TeamInfoCell
        cell.infoField.placeholder = promptTexts[indexPath.row]
        cell.responses = responses
        cell.sendInfoBackDelegate = self
        return cell
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        var session = "Morning"
        if sessionSegment.selectedSegmentIndex == 1 {
            session = "Afternoon"
        }
        DBManager.createTeam(project: project, session: session, info: responses)
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CreateTeamController: GetTeamInfo {
    func getTeamInfo(prompt: String, info: String) {
        responses[prompt] = info
    }
}
