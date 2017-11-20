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
    var categories = DBManager.projectNames
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DBManager.observeApprovedJudges()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationItem.backBarButtonItem?.title = " "
        
        
        print("oOne loading")
        DBManager.initialize()
        
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
        UserDefaults.standard.set(false, forKey: "loggedIn")
        UserDefaults.standard.set(nil, forKey: "fullName")
        UserDefaults.standard.set(nil, forKey: "email")
        SignInHelper.startFlow()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProjectScreen" {
            let projectController = segue.destination as! ProjectController
            let projectName = sender as! String
            projectController.project = projectName
        }
    }
}

extension HomeScreenController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectCell", for: indexPath) as! ProjectCell
        let projectName = categories[indexPath.row]
        cell.projectNameLabel.text = projectName
        cell.projectNameLabel.adjustsFontSizeToFitWidth = true
        cell.projectImage.image = UIImage(named: projectName)
        cell.projectImage.layer.borderWidth = 1.0
        cell.projectImage.layer.masksToBounds = false
        cell.projectImage.layer.borderColor = UIColor.white.cgColor
        cell.projectImage.layer.cornerRadius = 6.0
        cell.projectImage.clipsToBounds = true
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
        self.performSegue(withIdentifier: "toProjectScreen", sender: categories[indexPath.row])
    }
}
