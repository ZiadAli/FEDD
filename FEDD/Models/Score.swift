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
            if denominator == 0.0 {
                total = 0
            }
            else {
                total = (numerator/denominator)*(1+total/10.0)
            }
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
            let firstDistance = scores["First launch distance"] ?? 0.0
            let secondDistance = scores["Second launch distance"] ?? 0.0
            let thirdDistance = scores["Third launch distance"] ?? 0.0
            
            let firstPoints = scores["First launch points"] ?? 0.0
            let secondPoints = scores["Second launch points"] ?? 0.0
            let thirdPoints = scores["Third launch points"] ?? 0.0
            
            let first = getPrecisionLauncherScore(distance: firstDistance, value: firstPoints)
            let second = getPrecisionLauncherScore(distance: secondDistance, value: secondPoints)
            let third = getPrecisionLauncherScore(distance: thirdDistance, value: thirdPoints)
            
            var points = [first, second, third]
            points = points.sorted()
            let subtotal = points[1] + points[2] + (scores["Bonus"] ?? 0.0)
            var multiplier = scores["Multipliers"] ?? 0.0
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
        "Animatronics":Scores.getAnimatronics(),
        "Arcade Game":Scores.getArcadeGame(),
        "Assistive Device":Scores.getAssistiveDevice(),
        "Automatic Chicken Coop Door":Scores.getChickenCoop(),
        "Bubble Blowing Machine":Scores.getBubbleMachine(),
        "Cisco 3D Printing":Scores.get3DPrinting(),
        "Collapsible Bridge":Scores.getCollapsibleBridge(),
        "Concrete Canoe":Scores.getConcreteCanoe(),
        "Educational Computer Game":Scores.getEducationalGame(),
        "Entrepreneurship":Scores.getEntrepreneurship(),
        "Fabric Bucket":Scores.getFabricBucket(),
        "Fountain":Scores.getFountain(),
        "Mechanical Music Machine":Scores.getMusicMaker(),
        "Nuclear Power Probe":Scores.getNuclearProbe(),
        "Precision Launcher":Scores.getPrecisionLauncher(),
        "River":Scores.getRiver(),
        "Solar Still":Scores.getSolarStill(),
        "Toy Design":Scores.getToyDesign()
    ]
    
    static let requirements = [
        "Animatronics":[
            "Within required dimensions",
            "Research component provided"
        ],
        "Arcade Game":[
            "Meets basic competition requirements",
            "Within required dimensions",
            "Research component provided"
        ],
        "Assistive Device":[
            "Design includes sketches and a working prototype",
            "Construction performed by the team",
            "Project report included",
        ],
        "Automatic Chicken Coop Door":[
            "Meets basic competition requirements",
            "Research component provided"
        ],
        "Bubble Blowing Machine":[
            "Meets basic competition requirements",
            "No commercial bubble-blowing parts",
            "Recipe submitted",
            "Automatically powered by one power source",
            "Continuously and automatically operates for 1 minute",
            "Bubbles detach from the machine (no drooling)",
            "Poster includes all research components"
        ],
        "Cisco 3D Printing":[
            "Easily portable",
            "Has two distinct functions",
            "Comprised 25% of 3D printing material Research component provided"
        ],
        "Collapsible Bridge":[
            "Disassembled Components fit within a 12”x12x12” cube",
            "Total weight of parts is less than 5lbs",
            "Can be assembled in under 60 seconds",
            "Spans 5 feet when assembled",
            "Must have a designated point at which to attach weight",
            "Bears at least 60lbs of load applied at designated point"
        ],
        "Concrete Canoe":[
            "Research component presented in required format",
            "Dimensions less than or equal to 18” (L) x 6” (W) x 5” (H)",
            "Exterior surface has smooth finish",
            "V-shaped cross section along minor axis",
            "V-shaped bow and stern when viewed in plan",
            "Resembles a canoe",
            "Entire canoe made of concrete"
        ],
        "Educational Computer Game":[
            "Research component included",
            "Computer game available for play on FEDD",
            "Project Poster presented at FEDD"
        ],
        "Entrepreneurship":[
            "Meets basic competition requirements",
            "Project Poster presented at FEDD"
        ],
        "Fabric Bucket":[
            "Portable when full of water; must be able to hang from a hook for testing",
            "Before adding water, the bucket fits completely inside a container with a lid completely closed with a width of 6 in, length of 6 in, and height of 6 in.",
            "Not larger than 30 inches in height when full of water, including the transport/hanging mechanism (handle)",
            "Holds at least one gallon of water without leaking for 1 minute",
            "Contains at least 50% of a fibrous material in the water containment area of the bucket",
            "Does not include commercial or pre-made items such as tarps, plastic bag or bottles, bags, backpacks or pre-laminated fabrics",
            "Poster on the research and design for their project that includes five references (two from peer reviewed journals). Posters also contain the materials list for the design"
        ],
        "Fountain":[
            "Continuously fountains water",
            "2'x2' footprint",
            "Provided research component (3 deliverables)"
        ],
        "Mechanical Music Machine":[
            "Safe material",
            "50% mechanical",
            "Music plays for 10 seconds",
            "Poster board advertisement",
            "Research component provided"
        ],
        "Nuclear Power Probe":[
            "Piping is PVC",
            "Waterproof Device",
            "Graph or Equation has been presented",
            "Accuracy within +/-2.5% of reactor power",
            "Research component provided"
        ],
        "Precision Launcher":[
            "Satisfies all criteria",
            "Launcher fits inside imaginary 4-foot cube"
        ],
        "Solar Still":[
            "Less than or equal to 25 lbs",
            "Less than or equal to 18 in. in all directions",
            "Within $40 budget",
            "Submitted research component",
            "Reusable"
        ],
        "River":[
            "Structure is 3-D printed and fits within the dimensions of the control volume (9.0 cm tall, 20 cm long and 7.6 cm wide).",
            "Structure has at least one contiguous opening of at least 1.3 cm.",
            "Structure can be attached to the flume similar to the existing weir.",
            "Water is able to flow through the structure.",
            "Poster on the research and design for their project that includes five references"
        ],
        "Toy Design":[
            "Satisfies all criteria",
            "Research component provided"
        ]
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
        scores.append(Score(name: "Research quality", max: 20))
        scores.append(Score(name: "Function", max: 20))
        scores.append(Score(name: "Clear intent", max: 20))
        scores.append(Score(name: "Creativity and artistic value", max: 20))
        scores.append(Score(name: "Craftsmanship", max: 20))
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
    
    static func getAssistiveDevice() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Research Quality", max: 20))
        scores.append(Score(name: "Operation of Prototype", max: 20))
        scores.append(Score(name: "Potential to Address Ability Issue", max: 20))
        scores.append(Score(name: "Potential Reliability/Robustness", max: 10))
        scores.append(Score(name: "Potential Cost", max: 10))
        scores.append(Score(name: "Craftsmanship", max: 10))
        scores.append(Score(name: "Appearance of Prototype", max: 10))
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
        return (scores, true)
    }

    static func getCollapsibleBridge() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Total amount of weight born in excess of 60 lb (1pt/5lbs)", max: 0))
        scores.append(Score(name: "Total bridge weight (1pt/5lbs under max)", max: 0))
        scores.append(Score(name: "Excellence in design", max: 0))
        return (scores, true)
    }
    
    static func getConcreteCanoe() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Total flotation (amount of weight held before sinking)", max: 0))
        return (scores, false)
    }
    
    static func getEducationalGame() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Quality of Project Poster (completeness, detail, organization)", max: 20))
        scores.append(Score(name: "Length of game (2 pts earned for each minute, up to a max of 10 pts)", max: 10))
        scores.append(Score(name: "Interactivity of game (average 1 interaction per 10 seconds, minimum)", max: 10))
        scores.append(Score(name: "STEM content taught (relevant, interesting, original, and effective)", max: 20))
        scores.append(Score(name: "Fun for all (Is it fun? Will many user-groups enjoy playing?)", max: 20))
        scores.append(Score(name: "Overall Quality (esthetics, completeness, details)", max: 20))
        return (scores, true)
    }
    static func getEntrepreneurship() -> (scores:[Score], bonusPresent:Bool) {
           var scores = [Score]()
           scores.append(Score(name: "The entrepreneurial opportunity is clearly stated and research has been used to clearly explain why the opportunity should be addressed", max: 10))
           scores.append(Score(name: "There is a product feature list that clearly illustrates what features are important and why they are necessary", max: 15))
           scores.append(Score(name: "There is an original MVP that was clearly created based on the research and interview data that was gathered", max: 10))
           scores.append(Score(name: "Customer feedback on the original MVP is clearly stated and is tied to the product changes that the team chose to make", max: 10))
           scores.append(Score(name: "There is an updated MVP that clearly shows the changes and updates", max: 10))
           scores.append(Score(name: "Clear data is provided to show the production cost of one unit ", max: 10))
           scores.append(Score(name: "Clear data is provided showing how much the product will be sold for and why that price point was chosen", max: 10))
           scores.append(Score(name: "Overall quality of the poster", max: 10))
           scores.append(Score(name: "Overall quality of the research and prototypes", max: 15))
           scores.append(Score(name: "Overall quality of the research and prototypes", max: 20))
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
        return (scores, true)
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
        return (scores, true)
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
        scores.append(Score(name: "Accuracy within +/- 2.5% of reactor power", max: 1))
        scores.append(Score(name: "Research component provided", max: 1))
        scores.append(Score(name: "Calculated unknown power level", max: 0))
        scores.append(Score(name: "Craftsmanship", max: 5))
        return (scores, true)
    }
    
    static func getSolarStill() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Weight (+2pts for each lb under 25 lbs)", max: 0))
        scores.append(Score(name: "Size (+3pts for each inch in any direction under 18 in.)", max:0))
        scores.append(Score(name: "Water Production", max: 30))
        scores.append(Score(name: "Ease of Transport", max: 10))
        scores.append(Score(name: "Creativity in Concept", max: 10))
        scores.append(Score(name: "Presentation Component", max: 20))
        return (scores, true)
    }
    static func getRiver() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Downstream velocity reduction as compared to weir installation", max: 5))
        scores.append(Score(name: "Downstream water height as compared to case with a weir", max: 5))
        scores.append(Score(name: "Creative design that mimics natural habitat", max: 2))
        scores.append(Score(name: "Ability for the design to be transferred into practice", max: 2))
        scores.append(Score(name: "Clear demonstration of the engineering design process", max: 2))
        scores.append(Score(name: "Poster clearly describes the project ", max: 2))
        return (scores, true)
    }
    
    static func getToyDesign() -> (scores:[Score], bonusPresent:Bool) {
        var scores = [Score]()
        scores.append(Score(name: "Research component", max: 10))
        scores.append(Score(name: "Entertainment value", max: 10))
        scores.append(Score(name: "Concept originality/creativity", max: 20))
        scores.append(Score(name: "Craftsmanship/Aesthetics/Safety", max: 20))
        scores.append(Score(name: "Children's testing feedback incorporated", max: 20))
        scores.append(Score(name: "Meets learning objective", max: 15))
        return (scores, true)
    }
}
