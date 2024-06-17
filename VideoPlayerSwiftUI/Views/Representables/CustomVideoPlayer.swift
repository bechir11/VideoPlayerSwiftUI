//
//  CustomVideoPlayer.swift
//  VideoPlayerSwiftUI
//
//  Created by Bechir Belkahla on 17/6/2024.
//

import SwiftUI
import AVKit

struct CustomVideoPlayer: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        //hiding the playback controls
        playerViewController.showsPlaybackControls = false
        // Ensures the video maintains its aspect ratio
        playerViewController.videoGravity = .resizeAspect
        return playerViewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}
