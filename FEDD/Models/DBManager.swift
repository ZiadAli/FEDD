//
//  DBManager.swift
//  FEDD
//
//  Created by Ziad Ali on 10/11/17.
//  Copyright © 2017 ZiadCorp. All rights reserved.
//

import Foundation
import Firebase

class DBManager {
    
    static func addScore(team:Team, score:Score) {
        let sessionTime = team.sessionTime!
        let project = team.project!
        let ref = Firestore.firestore().collection(sessionTime).document(project).collection("Teams").document(team.id).collection("Scores").document(score.name)
        
        ref.setData(["Score1":45])
    }
    
}
