//
//  YoutubePlayerViewController.swift
//  Starter
//
//  Created by kira on 13/03/2022.
//

import UIKit
import YouTubePlayer

class YoutubePlayerViewController: UIViewController {
    
    @IBOutlet var videoPlayer: YouTubePlayerView!
    var youtubeId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let youtubeId = youtubeId {
            videoPlayer.loadVideoID(youtubeId)
        }
    }
    
    @IBAction func onTapDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
