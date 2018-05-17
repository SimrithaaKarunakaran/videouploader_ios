//
//  vc_select_deck.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/4/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit

class vc_select_deck: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var ArrayTitles       = ["Emoji", "Animals", "Faces", "Sports", "Jobs", "All Decks"]
    var ArrayDifficulties = ["Medium", "Easy", "Easy", "Hard", "Hard", "Variety"]
    var ArrayImages       = [#imageLiteral(resourceName: "a2_grin.png"),#imageLiteral(resourceName: "c3_horse.png"),#imageLiteral(resourceName: "f_angry3.png"),#imageLiteral(resourceName: "d2_soccer.png"),#imageLiteral(resourceName: "e3_doctor.png"),#imageLiteral(resourceName: "a13_confused.png")]
    
    
    // Keep track of what game modes are selected
    var ArraySelected = [false, false, false, false, false, false];

    
    @IBAction func ClickNext(_ sender: Any) {
        // Direct user to screen where they can add a new player.
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_survey", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_survey1")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func ClickBack(_ sender: Any) {
        // Direct user to screen where they can add a new player.
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_pageview", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_select_player")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ArrayTitles.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! SelectDeckCellCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.LabelTitle.text      = self.ArrayTitles       [indexPath.item]
        cell.LabelDifficulty.text = self.ArrayDifficulties [indexPath.item]
        cell.ImagePreview.image   = self.ArrayImages       [indexPath.item]
        
        return cell
    }
    
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if let cell = collectionView.cellForItem(at:indexPath) as! SelectDeckCellCollectionViewCell?{
            
            let Index = indexPath.row
            
            // Toggle whether or not this game mode is selected.
            ArraySelected[Index] = !ArraySelected[Index]
            
            if(ArraySelected[Index] == true){
                // "Selected" state
                cell.backgroundColor = UIColor.cyan
            } else {
                // "Not Selected" state
                cell.backgroundColor = UIColor.white
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
