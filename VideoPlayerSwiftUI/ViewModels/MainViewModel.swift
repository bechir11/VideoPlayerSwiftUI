//
//  MainViewModel.swift
//  VideoPlayerSwiftUI
//
//  Created by Bechir Belkahla on 17/6/2024.
//

import Foundation
import AVKit

class MainViewModel: ObservableObject {
    
    @Published var videos: [Video] = []
    @Published var playerIndex = 0
    @Published var player = AVPlayer(playerItem: nil)
    @Published var isPlaying = false
    @Published var displayPlayerControllers = true
    @Published var didFailToFetch: Bool = false
    
    var errorMessage: String?


    
    init() {
        getVideosList()
    }
    
    // getting data from the API
    func getVideosList() {
        Task {
            do {
                let videos = try await APIService.shared.fetchData(url: APIRequest.baseURL+APIEndpoint.getVideosEndpoint, type: Video.self)
                await updateContries(with: videos)
            } catch NetworkErrors.invalidURL {
                await didFail(with: NetworkErrors.invalidURL)
            } catch NetworkErrors.invalidResponse {
                await didFail(with: NetworkErrors.invalidResponse)
            } catch NetworkErrors.requestFailed {
                await didFail(with: NetworkErrors.requestFailed)
            }
        }
    }
    
    @MainActor
    //updating the view using the viewModel
    func updateContries(with videos: [Video]) {
        orderingVideosListByDate(with: videos)
        if let firstVideo = self.videos.first, let url = URL(string: firstVideo.fullURL) {
            setupPlayer(with: url)
        }
    }
    
    @MainActor
    //displaying networking errors on the view
    func didFail(with error: NetworkErrors) {
        errorMessage = error.localized
        didFailToFetch = true
    }
    
    //setup the player with the first video
    func setupPlayer(with url: URL) {
        player = AVPlayer(url: url)
        player.allowsExternalPlayback = false
    }
    
    //ordering the list by published video date
    func orderingVideosListByDate(with videos: [Video]) {
        self.videos = videos.sorted { video1, video2 in
            video1.publishedAt > video2.publishedAt
        }
    }
    
}
