//
//  TeamController.swift
//  FEDD
//
//  Created by Shreyas Zagade on 10/11/17.
//  Copyright © 2017 ZiadCorp. All rights reserved.
//

import UIKit

class TeamController: UIViewController {

    @IBOutlet weak var teamNameTitle: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    var sectionTitle = ["Players","Scores"]
    var teamMates = ["Name 1","Name 2","Name 3","Name 4"]
    var judges = ["Judge 1","Judge 2","Judge 3"]
    var scores = [10,20,30]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
    @IBAction func publishClicked(_ sender: UIButton) {
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
        return cell
    }
}
