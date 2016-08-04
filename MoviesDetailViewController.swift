//
//  MoviesDetailViewController.swift
//  Flicks
//
//  Created by ximin_zhang on 8/2/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit

class MoviesDetailViewController: UIViewController {
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var iconUpArrow: UIImageView!
    
    @IBOutlet weak var maskView: UIView!
    
    
    var movie: NSDictionary!

    @IBAction func onTap(sender: AnyObject) {
        scrollView.setContentOffset(CGPoint(x: 0, y: detailView.frame.size.height), animated: true)
        // iconUpArrow.highlighted = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: detailView.frame.origin.y + detailView.frame.size.height)

        // Do any additional setup after loading the view.
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        if let posterPath = movie["poster_path"] as? String {
            let baseUrl = "http://image.tmdb.org/t/p/w342"
            let imageUrl = NSURL(string: baseUrl + posterPath)
            posterImage.setImageWithURL(imageUrl!)
        }
        
        let iconUpArrowIcon = UIImageView(image: UIImage(named: "IconUpArrow.png"))
        
        iconUpArrow.image = iconUpArrowIcon.image
        iconUpArrow.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(2) {
            self.posterImage.alpha = 0.5
            self.maskView.alpha = 0.5
        }
        
        UIView.animateWithDuration(3) {
            self.iconUpArrow.alpha = 1
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
 

}
