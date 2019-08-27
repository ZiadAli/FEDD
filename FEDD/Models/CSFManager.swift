//
//  CSFManager.swift
//  FEDD
//
//  Created by Ziad Ali on 11/19/18.
//  Copyright © 2018 ZiadCorp. All rights reserved.
//

import Foundation

class CSVManager {
    
    //Use to load teams from a CSV file
    func getTeams() {
        var data = readDataFromCSV(fileName: "FEDDTest", fileType: "csv")
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        print(csvRows[1][1])
        
        for i in 1..<csvRows.count{
            let data = csvRows[i]
            let project = data[3]
            
            guard project == "Fountain" else {continue}
            
            let team = data[2]
            var session = data[9]
            let member1 = "\(data[1]) \(data[0])"
            var members = [member1, data[4], data[5], data[6], data[7], data[8]]
            members = members.filter({ $0 != ""})
            print("Project: \(project), Team: \(team), Session: \(session)")
            print("Members: \(members)")
            
            if session == "M" {session = "Morning"}
            else {session = "Afternoon"}
            
            var info = [String:String]()
            info["Team Name"] = team
            for i in 0..<members.count {
                let memberString = "Team Member #\(i+1)"
                info[memberString] = members[i]
            }
            
            DBManager.createTeam(project: project, session: session, info: info)
        }
    }
    
    func readDataFromCSV(fileName:String, fileType: String)-> String! {
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                print("No File")
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch let error {
            print("File Read Error for file \(filepath)")
            print("Error: \(error)")
            return nil
        }
    }
    
    func cleanRows(file:String)->String {
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
    
}
