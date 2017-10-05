//
//  HomeScreenController.swift
//  FEDD
//
//  Created by Shreyas Zagade on 9/27/17.
//  Copyright © 2017 ZiadCorp. All rights reserved.
//

import UIKit

class HomeScreenController: UIViewController {

    var categories = ["Category 1","Category 2","Category 3","Category 4","Category 5","Category 6"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        print("DOne loading")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
//    func collectionView(_ collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
//
//    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width / 2 - 6, height: 200)
    }
}
