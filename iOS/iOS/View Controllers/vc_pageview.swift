//
//  vc_pageview.swift
//  iOS
//
//  Created by Haik Kalantarian on 4/25/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit

class vc_pageview: UIPageViewController {

    var arrPageTitle: NSArray = NSArray()
    var arrPagePhoto: NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrPageTitle = ["Text1", "Text2", "Text3"];
        arrPagePhoto = ["1.jpg", "2.jpg", "3.jpg"];
    
        dataSource = self
        
        
        self.setViewControllers([getViewControllerAtIndex(index:0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)

        
    }
    
    /*
     When user swipe using gesture then we have to instantiate ViewController from storyboard and assign all content data of ViewController and return it.
    */
    func getViewControllerAtIndex(index: NSInteger) -> vc_pageview_content
    {
        
        let storyboard = UIStoryboard(name: "story_pageview", bundle: nil)

        // Create a new view controller and pass suitable data.
        let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "vc_pageview_content") as! vc_pageview_content
        pageContentViewController.strTitle = "\(arrPageTitle[index])"
        pageContentViewController.strPhotoName = "\(arrPagePhoto[index])"
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



extension vc_pageview: UIPageViewControllerDataSource {
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let pageContent: vc_pageview_content = viewController as! vc_pageview_content
        var index = pageContent.pageIndex
        if (index == NSNotFound)
        {
            return nil;
        }
        index = index + 1;
        if (index == arrPageTitle.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index:index)

        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let pageContent: vc_pageview_content = viewController as! vc_pageview_content
        var index = pageContent.pageIndex
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        index = index - 1;
        return getViewControllerAtIndex(index:index)

    }
  

}
