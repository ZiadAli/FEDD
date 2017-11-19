//
//  File.swift
//  FEDD
//
//  Created by Ziad Ali on 10/11/17.
//  Copyright © 2017 ZiadCorp. All rights reserved.
//

import Foundation

class Score {
    
    var name:String!
    var max:Int!
    var openPoints = false
    
    init(name:String, max:Int) {
        self.name = name
        self.max = max
    }
    
}

class Formulas {
    
    static func calculateTotal(project:String, scores:[String:Double]) -> Double {
        var total = 0.0
        if formulas[project] == false {
            for score in Array(scores.values) {
                total += score
            }
        }
        else {
            
        }
        
        return total
    }
    
    static let formulas = [
        "3D Printing":false,
        "Animatronics":false,
        "Arcade Game":false,
        "Automatic Chicken Coop Door":false,
        "Bubble Blowing Machine":false,
        "Collapsible Bridge":true,
        "Concrete Canoe":false,
        "Educational Computer Game":true,
        "Fabric Bucket":true,
        "Fountain":false,
        "Hovercraft":true,
        "Mechanical Music Machine":false,
        "Nuclear Power Probe":true,
        "Precision Launcher":true,
        "Toy Design":false
    ]
}

class Scores {
    
    static let rubrics = [
        "3D Printing":Scores.get3DPrinting(),
        "Animatronics":Scores.getAnimatronics(),
        "Arcade Game":Scores.getArcadeGame(),
        "Automatic Chicken Coop Door":Scores.getChickenCoop(),
        "Bubble Blowing Machine":Scores.getBubbleMachine(),
        "Collapsible Bridge":Scores.getCollapsibleBridge(),
        "Concrete Canoe":Scores.getConcreteCanoe(),
        "Educational Computer Game":Scores.getEducationalGame(),
        //"Fabric Bucket":Scores.getHovercraft(),
        "Fountain":Scores.getFountain(),
        "Hovercraft":Scores.getHovercraft(),
        "Mechanical Music Machine":Scores.getMusicMaker(),
        //"Nuclear Power Probe":Scores.getnuc,
        //"Precision Launcher",
        "Toy Design":Scores.getToyDesign()
    ]
    
    static func get3DPrinting() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Successfully completes function #1", max: 20))
        scores.append(Score(name: "Successfully completes function #2", max: 20))
        scores.append(Score(name: "Creativity/Originality", max: 20))
        scores.append(Score(name: "Craftsmanship", max: 20))
        scores.append(Score(name: "Utilization of 3D Printing", max: 20))
        return (scores, true)
    }
    
    static func getAnimatronics() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Function", max: 25))
        scores.append(Score(name: "Clear intent", max: 25))
        scores.append(Score(name: "Creativity and artistic value", max: 25))
        scores.append(Score(name: "Craftsmanship", max: 25))
        return (scores, true)
    }
    
    static func getArcadeGame() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Meets game action specifications (4 actions, 1 requiring skill)", max: 25))
        scores.append(Score(name: "Entertainment value (fun, decoration, difficulty, challenge)", max: 25))
        scores.append(Score(name: "Creativity and artistic value", max: 25))
        scores.append(Score(name: "Craftsmanship and materials used", max: 25))
        return (scores, true)
    }
    
    static func getChickenCoop() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Meets regulation standards", max: 25))
        scores.append(Score(name: "User-friendliness", max: 25))
        scores.append(Score(name: "Creativity and artistic value", max: 25))
        scores.append(Score(name: "Craftsmanship and materials used", max: 25))
        return (scores, true)
    }
    
    static func getBubbleMachine() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Aters bubble size (small to large)", max: 5))
        scores.append(Score(name: "Alters bubble frequency (slow to fast)", max: 5))
        scores.append(Score(name: "Bubble volume (number of bubbles within 1 minute)", max: 10))
        scores.append(Score(name: "Creativity in concept (patent research, music, lights)", max: 10))
        scores.append(Score(name: "Power source is other than commercial electrochemical batteries", max: 15))
        scores.append(Score(name: "Craftsmanship", max: 20))
        return (scores, false)
    }

    static func getCollapsibleBridge() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Total amount of weight born in excess of 60 lb", max: 0))
        scores.append(Score(name: "Total bridge weight", max: 0))
        scores.append(Score(name: "Excellence in design", max: 0))
        return (scores, false)
    }
    
    static func getConcreteCanoe() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Total flotation (amount of weight held before sinking)", max: 0))
        return (scores, false)
    }
    
    static func getEducationalGame() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Quality of Project Poster (completeness, detail, organization)", max: 20))
        scores.append(Score(name: "Length of game (1 pt earned for each minute, up to a max of 10 pts)", max: 10))
        scores.append(Score(name: "Interactivity of game (average 1 interaction per 10 seconds, minimum)", max: 10))
        scores.append(Score(name: "STEM content taught (relevant, interesting, original, and effective)", max: 20))
        scores.append(Score(name: "Fun for all (Is it fun? Will many user-groups enjoy playing?)", max: 20))
        scores.append(Score(name: "Overall Quality (esthetics, completeness, details)", max: 20))
        return (scores, true)
    }
    
    //static func getFabricBucket() -> (scores:[Score], bonusPresent:Bool) {
    //
    //}
    
    static func getFountain() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Craftsmanship", max: 10))
        scores.append(Score(name: "Incorporates free-flowing liquid movement against gravity", max: 5))
        scores.append(Score(name: "Meets requirement Engineering Components", max: 15))
        scores.append(Score(name: "Creativity in operation", max: 10))
        scores.append(Score(name: "Creativity in concept", max: 10))
        scores.append(Score(name: "Creativity in sound", max: 2))
        scores.append(Score(name: "Creativity in light/illumination", max: 2))
        scores.append(Score(name: "Creativity in color", max: 2))
        scores.append(Score(name: "Creativity in movement", max: 2))
        scores.append(Score(name: "Creativity in other", max: 2))
        scores.append(Score(name: "Deductions for splashing (negative points)", max: -5))
        return (scores, false)
    }
 
    static func getHovercraft() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Course completion time in seconds", max: 0))
        scores.append(Score(name: "Craftsmanship", max: 5))
        scores.append(Score(name: "Number of times craft violated course boundary", max: 0))
        scores.append(Score(name: "Hovercraft remotely navigated", max: 0))
        scores.append(Score(name: "On-board power source", max: 0))
        return (scores, false)
    }
    
    static func getMusicMaker() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Design Creativity", max: 34))
        scores.append(Score(name: "Construction Quality", max: 33))
        scores.append(Score(name: "Music Quality", max: 33))
        scores.append(Score(name: "Bonus for volume control", max: 10))
        scores.append(Score(name: "Bonus to verify notes or scale", max: 10))
        return (scores, true)
    }

    //static func getPrecisionLauncher() {
    //
    //}
    
    //static func getNuclearProbe() {
    //
    //}
    
    static func getToyDesign() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Research component", max: 34))
        scores.append(Score(name: "Entertainment Value", max: 33))
        scores.append(Score(name: "Concept originality/creativity", max: 33))
        scores.append(Score(name: "Craftsmanship/Aesthetics/Safety", max: 10))
        scores.append(Score(name: "Test process/assessments/meets size and cost restrictions", max: 10))
        scores.append(Score(name: "Meets learning objective", max: 10))
        return (scores, true)
    }
}
