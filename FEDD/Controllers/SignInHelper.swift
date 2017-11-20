//
//  SignInHelper.swift
//  FEDD
//
//  Created by Dipansha  on 11/11/17.
//  Copyright © 2017 ZiadCorp. All rights reserved.
//

import Foundation

class SignInHelper {
    
    static var isLoggedIn : Bool {
        get {
            return UserDefaults.standard.bool(forKey: "loggedIn")
        }
    }
    
    static func startFlow() {
        let loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
        if loggedIn == true {
            showLeaderboard()
        }
        else {
            let testController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = testController
        }
    }
    
    static func showLeaderboard() {
        let testController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeScreenController") as! HomeScreenController
        let nav = UINavigationController.init(rootViewController: testController)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nav
    }
    
}
