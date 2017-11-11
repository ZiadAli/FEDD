//
//  Project.swift
//  FEDD
//
//  Created by Ziad Ali on 11/10/17.
//  Copyright © 2017 ZiadCorp. All rights reserved.
//

import Foundation

class Project {
    
    var projectName:String!
    var morningTeams:[String:Team] = [:]
    var afternoonTeams:[String:Team] = [:]
    
    init(name:String) {
        projectName = name
    }
    
}
