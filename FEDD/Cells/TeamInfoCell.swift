//
//  TeamInfoCell.swift
//  FEDD
//
//  Created by Ziad Ali on 11/19/17.
//  Copyright © 2017 ZiadCorp. All rights reserved.
//

import UIKit

class TeamInfoCell: UITableViewCell {

    var responses = [String:String]()
    var sendInfoBackDelegate:GetTeamInfo!
    @IBOutlet var infoField: UITextField! {
        didSet {
            infoField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        guard let placeholder = infoField.placeholder else {return}
        sendInfoBackDelegate.getTeamInfo(prompt: placeholder, info: text)
    }

}
