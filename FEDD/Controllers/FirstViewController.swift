//
//  FirstViewController.swift
//  FEDD
//
//  Created by Dipansha  on 11/10/17.
//  Copyright © 2017 ZiadCorp. All rights reserved.
//

import UIKit
import GoogleSignIn

class FirstViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var loginButtonView: UIView!
    @IBOutlet var leaderboardButtonView: UIView!
    
    @IBAction func leaderboard(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "loggedIn")
        SignInHelper.showLeaderboard()
    }
    
    @IBAction func loginAsJudge(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loginButton.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        
        loginButtonView.layer.shadowColor = UIColor.black.cgColor
        loginButtonView.layer.shadowOffset = CGSize(width: 2, height: 2)
        loginButtonView.layer.shadowRadius = 3
        loginButtonView.layer.shadowOpacity = 0.7
        loginButtonView.layer.cornerRadius = 5
        
        leaderboardButtonView.layer.shadowColor = UIColor.black.cgColor
        leaderboardButtonView.layer.shadowOffset = CGSize(width: 2, height: 2)
        leaderboardButtonView.layer.shadowRadius = 3
        leaderboardButtonView.layer.shadowOpacity = 0.7
        leaderboardButtonView.layer.cornerRadius = 5
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.signInSuccess), name: NSNotification.Name(rawValue: "signInSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.signInFailure), name: NSNotification.Name(rawValue: "signInFailure"), object: nil)
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        dismiss(animated: true, completion: nil)
    }
    
    func signInSuccess() {
        SignInHelper.showLeaderboard()
    }
    
    func signInFailure() {
        let alert = UIAlertController(title: "Error occured", message: "Sorry, couldn't sign in, please try again later", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
   
}
