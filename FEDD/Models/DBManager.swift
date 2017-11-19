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
    static var scoreListeners = [FIRListenerRegistration]()
    static var projects:[String:Project] = [:]
    static var judges = [String:String]()
    
    static func initialize() {
        for projectName in DBManager.projectNames {
            projects[projectName] = Project(name: projectName)
        }
    }
    
    static func publishScore(project:String, session:String, teamId:String, score:Double) {
        let ref = Firestore.firestore().collection("Projects").document(project).collection(session).document(teamId)
        ref.getDocument { (documentSnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let document = documentSnapshot else {return}
            var data = document.data()
            data["Total"] = score
            ref.setData(data)
            DBManager.updatedPublishedStatus(project: project, session: session, teamId: teamId, published: true)
        }
    }
    
    static func updatedPublishedStatus(project:String, session:String, teamId:String, published:Bool) {
        let ref = Firestore.firestore().collection("Projects").document(project).collection(session).document(teamId)
        ref.getDocument { (documentSnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let document = documentSnapshot else {return}
            var data = document.data()
            data["Published"] = published
            ref.setData(data)
        }
    }
    
    static func deleteScore(project:String, session:String, teamId:String, scoreId:String) {
        let ref = Firestore.firestore().collection("Projects").document(project).collection(session).document(teamId).collection("Scores").document(scoreId)
        ref.delete()
        DBManager.updatedPublishedStatus(project: project, session: session, teamId: teamId, published: false)
    }
    
    static func observeApprovedJudges() {
        let ref = Firestore.firestore().collection("Judges").document("Judges")
        ref.addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let document = documentSnapshot else {return}
            let data = document.data()
            if let judgesList = data as? [String:String] {
                judges = judgesList
            }
        }
    }
    
    static func updateLeaderboard(project:String) {
        DBManager.removeListeners()
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
                    team.name = name
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
    
    static func getTeamInfo(teamId:String, session:String, project:String, completionHandler: @escaping ([String], [String:Double], [String:String]) -> ()) {
        DBManager.removeScoreListeners()
        let ref = Firestore.firestore().collection("Projects").document(project).collection(session).document(teamId)
        ref.getDocument { (documentSnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let document = documentSnapshot else {return}
            let data = document.data()
            let members = data["Members"] as? [String] ?? [String]()
            print("Members: \(members)")
            
            ref.collection("Scores")
            let scoresListener = ref.collection("Scores").addSnapshotListener({ (collectionSnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                var scoresDictionary = [String:Double]()
                var scoresKeys = [String:String]()
                
                guard let collection = collectionSnapshot else {return}
                let documents = collection.documents
                
                for document in documents {
                    let scoreID = document.documentID
                    let data = document.data()
                    if let score = data["Total"] as? Double {
                        let name = data["Name"] as? String ?? "--"
                        scoresDictionary[scoreID] = score
                        scoresKeys[scoreID] = name
                    }
                }
                print(scoresDictionary)
                print(scoresKeys)
                completionHandler(members, scoresDictionary, scoresKeys)
            })
            scoreListeners.append(scoresListener)
        }
    }
    
    static func setScores(scores:[String:Double], project:String, session:String, teamId:String, scoreId:String?, scoreName:String) {
        var ref = Firestore.firestore().collection("Projects").document(project).collection(session).document(teamId)
        if let id = scoreId {
            ref = ref.collection("Scores").document(id)
        }
        else {
            ref = ref.collection("Scores").document()
        }
        
        var data:[String:Any] = scores
        data["Name"] = scoreName
        ref.setData(data)
        DBManager.updatedPublishedStatus(project: project, session: session, teamId: teamId, published: false)
    }
    
    static func getScores(project:String, session:String, teamId:String, scoreId:String, completionHandler: @escaping ([String:Double]) -> ()) {
        let ref = Firestore.firestore().collection("Projects").document(project).collection(session).document(teamId).collection("Scores").document(scoreId)
        ref.getDocument { (documentSnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let document = documentSnapshot else {return}
            var data = document.data()
            data.removeValue(forKey: "Name")
            data.removeValue(forKey: "Total")
            
            if let scores = data as? [String:Double] {
                completionHandler(scores)
            }
            else {
                completionHandler([String:Double]())
            }
        }
    }
    
    static func removeListeners() {
        for listener in listeners {
            listener.remove()
        }
    }
    
    static func removeScoreListeners() {
        for listener in scoreListeners {
            listener.remove()
        }
    }
    
}
