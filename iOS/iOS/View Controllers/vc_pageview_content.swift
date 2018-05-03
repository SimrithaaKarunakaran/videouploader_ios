//
//  vc_pageview_content.swift
//  iOS
//
//  Created by Haik Kalantarian on 4/26/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit

class vc_pageview_content: UIViewController {

    
    var pageIndex: Int = 0
    var strTitle: String!
    var strPhotoName: String!
    
    @IBOutlet weak var ImageViewOutlet: UIImageView!
    @IBOutlet weak var LabelOutlet: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ImageViewOutlet.image = UIImage(named: strPhotoName)
        LabelOutlet.text   = strTitle + ", " +  String(pageIndex);
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
