//
//  MoviesDetailViewController.swift
//  Flicks
//
//  Created by ximin_zhang on 8/2/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesDetailViewController: UIViewController, UIScrollViewDelegate {
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
        
        // Pinch to zoom
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.25
        scrollView.maximumZoomScale = 2
        
        // Scroll effect
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: detailView.frame.origin.y + detailView.frame.size.height)

        // Do any additional setup after loading the view.
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        if let posterPath = movie["poster_path"] as? String {
            /* Load image without fade-in effect
            let baseUrl = "http://image.tmdb.org/t/p/w342"
            let imageUrl = NSURL(string: baseUrl + posterPath)
            posterImage.setImageWithURL(imageUrl!)
            */
            
            // Load image with fade in effect
            let baseUrl = "http://image.tmdb.org/t/p/w342"
            let imageUrl = NSURL(string: baseUrl + posterPath)
            let imageRequest = NSURLRequest(URL: imageUrl!)
            posterImage.setImageWithURLRequest(
                imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        self.posterImage.alpha = 0.0
                        self.posterImage.image = image
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.posterImage.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        self.posterImage.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
        }
        
        // let image = UIImage(named: "IconUpArrow.png")
        let iconUpArrowIcon = UIImageView(image: UIImage(named: "IconUpArrow.png"))
//        self.scrollView.contentSize = image!.size
//        self.scrollView.addSubview(iconUpArrowIcon)
        self.scrollView.zoomScale = 1
        
        iconUpArrow.image = iconUpArrowIcon.image
        iconUpArrow.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(2) {
            // self.posterImage.alpha = 0.5
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
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.posterImage
    }

    @IBAction func onPinch(sender: AnyObject) {
        // On pinch, mask view disapear for zoom effect
        // Mask view is on top of posterImage view
        self.maskView.hidden = true
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
