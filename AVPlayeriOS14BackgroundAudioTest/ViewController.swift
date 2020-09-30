//
//  ViewController.swift
//  AVPlayeriOS14BackgroundAudioTest
//
//  Created by Patrick Gatewood on 9/30/20.
//

import UIKit
import AVKit

class PlayerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}

class ViewController: UIViewController {
    let playerView = PlayerView()
    let asset = AVAsset(url: URL(string: "https://multiplatform-f.akamaihd.net/i/multi/will/bunny/big_buck_bunny_,640x360_400,640x360_700,640x360_1000,950x540_1500,.f4v.csmil/master.m3u8")!)
    lazy var playerItem = AVPlayerItem(asset: asset)
    lazy var player = AVPlayer(playerItem: playerItem)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerView.player = player
        playerView.playerLayer.frame = view.bounds

        view.addSubview(playerView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        } catch {
            print(error.localizedDescription)
        }
        
        playerView.player?.play()
    }

    @objc func didEnterBackground() {
        print("didEnterBackground")
        playerView.player = nil
    }

    @objc func willEnterForeground() {
        print("willenterForeground")
        playerView.player = player
    }
}
