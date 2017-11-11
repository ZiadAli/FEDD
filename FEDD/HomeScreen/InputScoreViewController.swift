//
//  InputScoreViewController.swift
//  FEDD
//
//  Created by Dipansha  on 11/10/17.
//  Copyright © 2017 ZiadCorp. All rights reserved.
//

import UIKit

protocol GetInputScore {
    func getInputScore(prompt: String, score: Int)
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
    
    var scores = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rubricPrompts = ["Meets game action specifications",
                   "Meets game action specifications 1",
                   "Meets game action specifications 2",
                   "Game Entertainment Value",
                   "Game Entertainment Value 1",
                   "Game Entertainment Value 2",
                   "Game Entertainment Value 3",
                   "Game Entertainment Value 4",
                   "Game Entertainment Value 5",
                   "Game Entertainment Value 6",
                   "Game Entertainment Value 7",
                   "Game Entertainment Value 8"]
        rubricMax = [10,20,30,40,50,60,1,2,9,10,11,12]
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
    
    
    @IBAction func submitAction(_ sender: Any) {
        
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
        return rubricPrompts.count + (isBonusPresent ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTableViewCell", for: indexPath) as! PickerTableViewCell
        if indexPath.row >= rubricPrompts.count {
            // Is the bonus field
            cell.isBonusField = true;
            if scores.index(forKey: "Bonus") != nil
            {
                cell.value = scores["Bonus"] ?? 0
            }
        } else {
            cell.isBonusField = false;
            let prompt = rubricPrompts[indexPath.row]
            cell.promptText = prompt
            cell.maxValue = rubricMax[indexPath.row]
            if scores.index(forKey: prompt) != nil
            {
                cell.value = scores[prompt] ?? 0
            }
        }
        cell.sendInputBackDelegate = self
        return cell
        
    }
    
}

extension InputScoreViewController: GetInputScore {
    func getInputScore(prompt: String, score: Int) {
        scores.updateValue(score, forKey: prompt)
    }
}
