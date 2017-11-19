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
    var max = -1
    var openPoints = false
    var pickerValues = [Int]()
    
    init(name:String, max:Int) {
        self.name = name
        self.max = max
    }
    
    init(name:String, pickerValues:[Int]) {
        self.name = name
        self.pickerValues = pickerValues
    }
    
}

class Formulas {
    
    static func calculateTotal(project:String, scores:[String:Double]) -> Double {
        var total = 0.0
        
        switch project {
        case "Hovercraft":
            for scoreKey in Array(scores.keys) {
                if scoreKey == "Number of times craft violated course boundary (penalty)" {
                    total += scores[scoreKey]! * -3.0
                }
                else if scoreKey != "Course completion time in seconds" {
                    total += scores[scoreKey]!
                }
            }
            break
        case "Nuclear Power Probe":
            for scoreKey in Array(scores.keys) {
                if scoreKey != "Calculated unknown power level" {
                    total += scores[scoreKey]!
                }
            }
            break
        case "Fabric Bucket":
            var numerator = 0.0
            var denominator = 0.0
            for scoreKey in Array(scores.keys) {
                if scoreKey == "Mass of fabric bucket when dry (g)" {
                    denominator = scores[scoreKey]!
                }
                else if scoreKey == "Mass of water held in bucket (g)" {
                    numerator = scores[scoreKey]!
                }
                else {
                    print("Score: \(scores[scoreKey]!) for key: \(scoreKey)")
                    total += scores[scoreKey]!
                }
            }
            print(numerator)
            print(denominator)
            print(total)
            total = (numerator/denominator)*(1+total/10.0)
            break
        case "Fountain":
            for scoreKey in Array(scores.keys) {
                if scoreKey == "Deductions for splashing (negative points)" {
                    total += scores[scoreKey]! * -1.0
                }
                else {
                    total += scores[scoreKey]!
                }
            }
            break
        case "Precision Launcher":
            let firstDistance = scores["First launch distance"]!
            let secondDistance = scores["Second launch distance"]!
            let thirdDistance = scores["Third launch distance"]!
            
            let firstPoints = scores["First launch points"]!
            let secondPoints = scores["Second launch points"]!
            let thirdPoints = scores["Third launch points"]!
            
            let first = getPrecisionLauncherScore(distance: firstDistance, value: firstPoints)
            let second = getPrecisionLauncherScore(distance: secondDistance, value: secondPoints)
            let third = getPrecisionLauncherScore(distance: thirdDistance, value: thirdPoints)
            
            var points = [first, second, third]
            points = points.sorted()
            let subtotal = points[1] + points[2] + scores["Bonus"]!
            var multiplier = scores["Multipliers"]!
            if multiplier == 0.0 {multiplier = 1.0}
            total = multiplier*subtotal
            break
        default:
            for score in Array(scores.values) {
                total += score
            }
        }
        
        return total
    }
    
    static func getPrecisionLauncherScore(distance:Double, value:Double) -> Double {
        var multiplier = 1.0
        if distance == 20.0 {multiplier = 0.5}
        else if distance == 10.0 {multiplier = 0.25}
        else if distance == 0.0 {multiplier = 0.0}
        
        return value*multiplier
    }
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
        "Fabric Bucket":Scores.getFabricBucket(),
        "Fountain":Scores.getFountain(),
        "Hovercraft":Scores.getHovercraft(),
        "Mechanical Music Machine":Scores.getMusicMaker(),
        "Nuclear Power Probe":Scores.getNuclearProbe(),
        "Precision Launcher":Scores.getPrecisionLauncher(),
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
        scores.append(Score(name: "Total amount of weight born in excess of 60 lb (1pt/5lbs)", max: 0))
        scores.append(Score(name: "Total bridge weight (1pt/5lbs under max)", max: 0))
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
    
    static func getFabricBucket() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Mass of fabric bucket when dry (g)", max: 0))
        scores.append(Score(name: "Mass of water held in bucket (g)", max: 0))
        scores.append(Score(name: "Most creative design", max: 1))
        scores.append(Score(name: "Lowest mass bucket of any of the teams", max: 1))
        scores.append(Score(name: "Bucket holds the largest volume of water before leaking", max: 1))
        scores.append(Score(name: "Most professional appearance of the final bucket", max: 1))
        scores.append(Score(name: "Best demonstration of the engineering design process", max: 1))
        scores.append(Score(name: "Best poster", max: 1))
        scores.append(Score(name: "Has at least three different types of textile structures in the design", max: 1))
        scores.append(Score(name: "Bucket is composed 100% of biodegradable materials", max: 1))
        scores.append(Score(name: "Bucket contains a laminated fabric which was constructed by the group", max: 1))
        scores.append(Score(name: "The group can prove that the material touching the water will not contaminate the water", max: 1))
        scores.append(Score(name: "Can be worn as a backpack when filled with at least one gallon of water", max: 1))
        return (scores, false)
    }
    
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
        scores.append(Score(name: "Deductions for splashing (negative points)", max: 5))
        return (scores, false)
    }
 
    static func getHovercraft() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Course completion time in seconds", max: 0))
        scores.append(Score(name: "Craftsmanship", max: 5))
        scores.append(Score(name: "Number of times craft violated course boundary (penalty)", max: 0))
        scores.append(Score(name: "Hovercraft remotely navigated", pickerValues: [0,5]))
        scores.append(Score(name: "On-board power source", pickerValues: [0,5]))
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

    static func getPrecisionLauncher() -> (scores:[Score], bonusPresent:Bool)  {
        let distanceValues = [0,10,20,30]
        let scoreValues = [0,5,25,50,100]
        var scores = [Score]()
        scores.append(Score(name: "First launch distance", pickerValues: distanceValues))
        scores.append(Score(name: "First launch points", pickerValues: scoreValues))
        scores.append(Score(name: "Second launch distance", pickerValues: distanceValues))
        scores.append(Score(name: "Second launch points", pickerValues: scoreValues))
        scores.append(Score(name: "Third launch distance", pickerValues: distanceValues))
        scores.append(Score(name: "Third launch points", pickerValues: scoreValues))
        scores.append(Score(name: "Multipliers", max: 0))
        return (scores, true)
    }
    
    static func getNuclearProbe() -> (scores:[Score], bonusPresent:Bool)  {
        var scores = [Score]()
        scores.append(Score(name: "Piping is PVC", max: 1))
        scores.append(Score(name: "Waterproof device", max: 1))
        scores.append(Score(name: "Graph or equation has been presented", max: 1))
        scores.append(Score(name: "Accuracy within +/- 2/5% of reactor power", max: 1))
        scores.append(Score(name: "Research component provided", max: 1))
        scores.append(Score(name: "Calculated unknown power level", max: 0))
        scores.append(Score(name: "Craftsmanship", max: 5))
        return (scores, false)
    }
    
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
