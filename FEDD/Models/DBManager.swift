//
//  DBManager.swift
//  FEDD
//
//  Created by Ziad Ali on 10/11/17.
//  Copyright © 2017 ZiadCorp. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class DBManager {
    
    static let projectNames = [
        "3D Printing",
        "Animatronics",
        "Arcade Game",
        "Automatic Chicken Coop Door",
        "Bubble Blowing Machine",
        "Collapsible Bridge",
        "Concrete Canoe",
        "Educational Computer Game",
        "Fabric Bucket",
        "Fountain",
        "Hovercraft",
        "Mechanical Music Machine",
        "Nuclear Power Probe",
        "Precision Launcher",
        "Toy Design"
    ]
    
    static var listeners = [FIRListenerRegistration]()
    static var projects:[String:Project] = [:]
    
    static func initialize() {
        for projectName in DBManager.projectNames {
            projects[projectName] = Project(name: projectName)
        }
    }
    
    static func updateLeaderboard(project:String) {
        let ref = Firestore.firestore().collection("Projects").document(project)
        let morningListener = ref.collection("Morning").addSnapshotListener { (collectionSnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        
            guard let collection = collectionSnapshot else {return}
            let documents = collection.documents
            
            for document in documents {
                let teamId = document.documentID
                let data = document.data()
                let name = data["Name"] as? String ?? "[Blank]"
                let totalScore = data["Total"] as? Double ?? 0.0
                
                guard let morningTeams = projects[project]?.morningTeams else {return}
                if let team = morningTeams[teamId] {
                    team.score = totalScore
                }
                else {
                    let team = Team()
                    team.name = name
                    team.id = teamId
                    team.sessionTime = "Morning"
                    team.project = project
                    team.score = totalScore
                    
                    projects[project]?.morningTeams[teamId] = team
                }
                
                print("Team: \(name) Score: \(totalScore)")
            }
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "Leaderboard Updated")))
        }
        
        let afternoonListener = ref.collection("Afternoon").addSnapshotListener { (collectionSnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let collection = collectionSnapshot else {return}
            let documents = collection.documents
            
            for document in documents {
                let teamId = document.documentID
                let data = document.data()
                let name = data["Name"] as? String ?? "[Blank]"
                let totalScore = data["Total"] as? Double ?? 0.0
                
                guard let afternoonTeams = projects[project]?.afternoonTeams else {return}
                if let team = afternoonTeams[teamId] {
                    team.score = totalScore
                }
                else {
                    let team = Team()
                    team.name = name
                    team.id = teamId
                    team.sessionTime = "Afternoon"
                    team.project = project
                    team.score = totalScore
                    
                    projects[project]?.afternoonTeams[teamId] = team
                }
                
                print("Team: \(name) Score: \(totalScore)")
            }
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "Leaderboard Updated")))
        }
        listeners.append(morningListener)
        listeners.append(afternoonListener)
    }
    
    static func removeListeners() {
        for listener in listeners {
            listener.remove()
        }
    }
    
    static func addScore(team:Team, score:Score) {
        let sessionTime = team.sessionTime!
        let project = team.project!
        let ref = Firestore.firestore().collection(sessionTime).document(project).collection("Teams").document(team.id).collection("Scores").document(score.name)
        
        ref.setData(["Score1":45])
    }
    
}
