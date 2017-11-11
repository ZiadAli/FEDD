//
//  HomeScreenController.swift
//  FEDD
//
//  Created by Shreyas Zagade on 9/27/17.
//  Copyright © 2017 ZiadCorp. All rights reserved.
//

import UIKit

class HomeScreenController: UIViewController {

    @IBOutlet weak var Exit: UIBarButtonItem!
    var categories = ["Category 1","Category 2","Category 3","Category 4","Category 5","Category 6"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        print("oOne loading")
        DBManager.initialize()
        DBManager.updateLeaderboard(project: "3D Printing")
        
        if SignInHelper.isLoggedIn {
            Exit.title = "Log out"
        } else {
            Exit.title = "Exit"
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitAction(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.set(nil, forKey: "loggedIn")
        UserDefaults.standard.set(nil, forKey: "fullName")
        UserDefaults.standard.set(nil, forKey: "email")
        SignInHelper.startFlow()
    }
}

extension HomeScreenController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectCell", for: indexPath) as! ProjectCell
        cell.projectNameLabel.text = categories[indexPath.row]
        return cell
    }
}

extension HomeScreenController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width / 2 - 6, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "toProjectScreen", sender: self)
    }
}
