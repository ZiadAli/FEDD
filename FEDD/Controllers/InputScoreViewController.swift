//
//  InputScoreViewController.swift
//  FEDD
//
//  Created by Dipansha  on 11/10/17.
//  Copyright © 2017 ZiadCorp. All rights reserved.
//

import UIKit

protocol GetInputScore {
    func getInputScore(prompt: String, score: Double)
}

class InputScoreViewController: UIViewController {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var formTable: UITableView! {
        didSet {
            formTable.tableFooterView = UIView()
            formTable.delegate = self
            formTable.dataSource = self
            formTable.register(UINib(nibName: "PickerTableViewCell", bundle: nil), forCellReuseIdentifier: "PickerTableViewCell")
            formTable.rowHeight = UITableViewAutomaticDimension
            formTable.estimatedRowHeight = 60
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            formTable.addGestureRecognizer(tap)
        }
    }
    
    var bonusPresent = true
    var isBonusPresent = true {
        didSet {
            formTable.reloadData()
        }
    }
    
    var rubricPrompts = [String]() {
        didSet {
            formTable.reloadData()
        }
    }
    
    var rubricMax = [Int]() {
        didSet {
            formTable.reloadData()
        }
    }
    
    var scores = [String: Double]()
    var rubrics = [Score]()
    
    var pullScores = false
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Scores"
        
        isBonusPresent = bonusPresent
        for score in rubrics {
            scores[score.name] = 0.0
        }
        
        if pullScores == true {
            DBManager.getScores(project: project, session: session, teamId: teamId, scoreId: scoreId!, completionHandler: { (pulledScores) in
                self.scores = pulledScores
                print(self.scores)
                self.formTable.reloadData()
            })
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillAppear(_ notification: NSNotification) {
        if let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let inset = keyboardFrame.height // if scrollView is not aligned to bottom of screen, subtract offset
            bottomConstraint.constant = inset
        }
    }
    
    func keyboardWillDisappear(_ notification: NSNotification) {
        bottomConstraint.constant = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var project:String!
    var session:String!
    var teamId:String!
    var scoreName:String!
    var scoreId:String?
    @IBAction func submitAction(_ sender: Any) {
        print(scores)
        let total = Formulas.calculateTotal(project: project, scores: scores)
        scores["Total"] = total
        DBManager.setScores(scores: scores, project: project, session: session, teamId: teamId, scoreId: scoreId, scoreName: scoreName)
        self.navigationController?.popViewController(animated: true)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}


extension InputScoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rubrics.count + (isBonusPresent ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTableViewCell", for: indexPath) as! PickerTableViewCell
        cell.scores = scores
        if indexPath.row >= rubrics.count {
            // Is the bonus field
            cell.isBonusField = true;
            if scores.index(forKey: "Bonus") != nil
            {
                cell.value = scores["Bonus"] ?? 0.0
            }
        } else {
            let score = rubrics[indexPath.row]
            let max = score.max
            
            if max == 0 {
                cell.isBonusField = true
            }
            else if max > 0 {
                cell.isBonusField = false
                cell.maxValue = max
            }
            else {
                cell.isBonusField = false
                cell.maxValue = 10
                cell.isDiscreteField = true
                cell.pickerValues = score.pickerValues
            }
            
            let prompt = score.name!
            cell.promptText = prompt
            
            if scores.index(forKey: prompt) != nil
            {
                cell.value = scores[prompt] ?? 0.0
                if cell.value <= 0.00001 {
                    cell.valueField.text = ""
                }
                if cell.value.truncatingRemainder(dividingBy: 1.0) == 0 {
                    cell.valueField.text = "\(Int(cell.value))"
                }
            }
        }
        cell.sendInputBackDelegate = self
        return cell
        
    }
    
}

extension InputScoreViewController: GetInputScore {
    func getInputScore(prompt: String, score: Double) {
        scores.updateValue(score, forKey: prompt)
    }
}
