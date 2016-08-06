//
//  PlayerViewController.swift
//  Flicks
//
//  Created by ximin_zhang on 8/5/16.
//  Copyright © 2016 ximin_zhang. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import youtube_parser
import MediaPlayer

class PlayerViewController: AVPlayerViewController {
  var videoUrl: NSURL!
  var videoTitle: String!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    playVideoWithYoutubeURL(videoUrl)
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  func playVideoWithYoutubeURL(url: NSURL) {
    Youtube.h264videosWithYoutubeURL(url, completion: { (videoInfo, error) -> Void in
      if let
        videoURLString = videoInfo?["url"] as? String,
        videoTitle = videoInfo?["title"] as? String {
//          self.moviePlayer.contentURL = NSURL(string: videoURLString)
        let player = AVPlayer(URL: NSURL(string: videoURLString)!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true) {
          playerViewController.player!.play()
        }

      }
    })
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
