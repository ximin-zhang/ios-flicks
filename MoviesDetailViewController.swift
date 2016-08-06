//
//  MoviesDetailViewController.swift
//  Flicks
//
//  Created by ximin_zhang on 8/2/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit
import AFNetworking
//import Player
import AVKit
import AVFoundation

class MoviesDetailViewController: UIViewController, UIScrollViewDelegate {
  @IBOutlet weak var posterImage: UIImageView!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var overviewLabel: UILabel!
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var detailView: UIView!
  
  @IBOutlet weak var iconUpArrow: UIImageView!
  
  @IBOutlet weak var maskView: UIView!
  
  @IBOutlet weak var videoView: UIView!
  
  @IBOutlet weak var videoPlayImageView: UIImageView!

  @IBOutlet weak var videoTitleLabel: UILabel!

  @IBOutlet weak var origTitleLabel: UILabel!

  @IBOutlet weak var langTitleLabel: UILabel!

  @IBOutlet weak var popularityTitle: UILabel!

  @IBOutlet weak var releaseDateTitleLabel: UILabel!

  @IBOutlet weak var summaryUIView: UIView!

  @IBOutlet weak var backdropImageView: UIImageView!

  var movie: NSDictionary!
  var videoUrl: NSURL!

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

      videoPlayImageView.image = UIImage(named: "IconPlay")

      // Summary view shadow drop effect
      self.summaryUIView.layer.shadowOffset = CGSize(width: 3, height: 3)
      self.summaryUIView.layer.shadowOpacity = 0.7
      self.summaryUIView.layer.shadowRadius = 2
      self.summaryUIView.layer.shadowPath = UIBezierPath(rect: self.summaryUIView.bounds).CGPath
      self.summaryUIView.layer.shouldRasterize = true

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

//      // Detail view: Backdrop image setting
//      if let backdropPath = movie["backdrop_path"] as? String {
//
//        // Load image with fade in effect
//        let baseUrl = "http://image.tmdb.org/t/p/w342"
//        let backdropUrl = NSURL(string: baseUrl + backdropPath)
//        let imageRequest = NSURLRequest(URL: backdropUrl!)
//        self.backdropImageView.setImageWithURLRequest(
//          imageRequest,
//          placeholderImage: nil,
//          success: { (imageRequest, imageResponse, image) -> Void in
//
//            // imageResponse will be nil if the image is cached
//            if imageResponse != nil {
//              print("Image was NOT cached, fade in image")
//              self.backdropImageView.alpha = 0.0
//              self.backdropImageView.image = image
//              UIView.animateWithDuration(0.3, animations: { () -> Void in
//                self.backdropImageView.alpha = 1.0
//              })
//            } else {
//              print("Image was cached so just update the image")
//              self.backdropImageView.image = image
//            }
//          },
//          failure: { (imageRequest, imageResponse, error) -> Void in
//            // do something for the failure condition
//        })
//      }

      let iconUpArrowIcon = UIImageView(image: UIImage(named: "IconUpArrow.png"))
      self.scrollView.zoomScale = 1
      
      iconUpArrow.image = iconUpArrowIcon.image
      iconUpArrow.alpha = 0
      self.summaryUIView.alpha = 0
      
      // Video setup
      var videos: [NSDictionary]!

      if movie != nil {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        print(movie)
        let id = self.movie["id"]!
        print(id)
        // default
        videoUrl = NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")

        let url = NSURL(string: "http://api.themoviedb.org/3/movie/\(id)/videos?api_key=\(apiKey)")!
        print(url)
        let request = NSURLRequest(
          URL: url,
          cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
          timeoutInterval: 10)

        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
          configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
          delegate:nil,
          delegateQueue:NSOperationQueue.mainQueue()
        )

        let task: NSURLSessionDataTask =
          session.dataTaskWithRequest(request, completionHandler:
            { (dataOrNil, response, error) in
              if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                  data, options:[]) as? NSDictionary {
                  videos = responseDictionary["results"] as! [NSDictionary]
                  print (videos.endIndex)
                  if videos.endIndex > 0{
                    print(videos[0])
                    let key = videos[0]["key"] as! String
                    self.videoUrl = NSURL(string:"https://www.youtube.com/watch?v=\(key)")!
                    self.videoTitleLabel.text = videos[0]["name"] as? String

                    let origTitle = self.movie["original_title"] as? String
                    let lang = self.movie["original_language"] as? String
//                    let popularity = self.movie["popularity"] as? String
                    let releaseDate = self.movie["release_date"] as? String


                    self.origTitleLabel.text = "Original title: " + origTitle!
                    self.langTitleLabel.text = "Language: " + lang!
                    self.popularityTitle.text = "Popularity: "
                    self.releaseDateTitleLabel.text = "Release date: " + releaseDate!




                  }else{
                  }
                }
              }else{
//                print("error")
              }
          });
        task.resume()
      }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(2) {
            // self.posterImage.alpha = 0.5
          self.maskView.alpha = 0.5
          self.summaryUIView.alpha = 0.75
        }
        
        UIView.animateWithDuration(8) {
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

//    @IBAction func clipOnTap(sender: AnyObject) {
//        let videoURL = NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
//        let player = AVPlayer(URL: videoURL!)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.view.bounds
//        self.view.layer.addSublayer(playerLayer)
//        player.play()
//    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
      let destination = segue.destinationViewController as! PlayerViewController
      destination.videoUrl = self.videoUrl
      print(self.videoUrl)
    }

}
