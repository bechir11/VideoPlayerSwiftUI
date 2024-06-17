//
//  MainView.swift
//  VideoPlayerSwiftUI
//
//  Created by Michael Gauthier on 2021-01-06.
//

import SwiftUI
import AVKit
import Down

struct MainView: View {
    
    @StateObject var viewModel = MainViewModel()
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @State private var webViewDidFinishLoading = false
    
    var body: some View {
        NavigationView {
            Group {
                GeometryReader { geometry in
                    if viewModel.videos.isEmpty {
                        HStack {
                            VStack {
                                Spacer()
                                Image("logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width/2, alignment: .center)
                                    .padding()
                                ProgressView()
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        }

                        
                    } else {
                        ZStack {
                            VStack {
                                ZStack {
                                    playerView()
                                    HStack {
                                        playerButtons(image: "previous", size: 55)
                                            .onTapGesture {
                                                viewModel.isPlaying = false
                                                viewModel.player.pause()
                                                if viewModel.playerIndex > 0 {
                                                    viewModel.playerIndex -= 1
                                                    if let url = URL(string: viewModel.videos[viewModel.playerIndex].fullURL) {
                                                        viewModel.player = AVPlayer(url: url)
                                                    }
                                                }
                                            }
                                            .opacity(viewModel.playerIndex == 0 ? 0.3 : 1)
                                            .disabled(viewModel.playerIndex == 0)
                                        if !viewModel.isPlaying {
                                            playerButtons(image: "play", size: 80)
                                                .onTapGesture {
                                                    viewModel.player.play()
                                                    viewModel.isPlaying = true
                                                    viewModel.displayPlayerControllers = false
                                                }
                                        } else {
                                            playerButtons(image: "pause", size: 80)
                                                .onTapGesture {
                                                    viewModel.player.pause()
                                                    viewModel.isPlaying = false
                                                    viewModel.displayPlayerControllers = true
                                                }
                                        }

                                        playerButtons(image: "next", size: 55)
                                            .onTapGesture {
                                                viewModel.isPlaying = false
                                                viewModel.player.pause()
                                                if viewModel.playerIndex < viewModel.videos.count-1 {
                                                    viewModel.playerIndex += 1
                                                    if let url = URL(string: viewModel.videos[viewModel.playerIndex].fullURL) {
                                                        viewModel.player = AVPlayer(url: url)
                                                    }
                                                }
                                            }
                                            .opacity(viewModel.playerIndex == viewModel.videos.count-1 ? 0.3 : 1)
                                            .disabled(viewModel.playerIndex == viewModel.videos.count-1)
                                    }
                                    .opacity(viewModel.displayPlayerControllers ? 1:0)
                                }
                                .frame(width: geometry.size.width, height: verticalSizeClass == .compact ? geometry.size.height/3 : geometry.size.width * 9 / 16)
                                .animation(.easeOut(duration: 1.0), value: viewModel.displayPlayerControllers)
                                
                                let htmlContent = convertMarkdownToHTML(
                                                               title: viewModel.videos[viewModel.playerIndex].title,
                                                               authorName: viewModel.videos[viewModel.playerIndex].author.name,
                                                               description: viewModel.videos[viewModel.playerIndex].description)
                                WebViewRepresentable(htmlContent: htmlContent, didFinishLoading: $webViewDidFinishLoading)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .padding(5)
                            }
                            .opacity(webViewDidFinishLoading ? 1:0)
                            if !webViewDidFinishLoading {
                                VStack {
                                    Spacer()
                                    Image("logo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geometry.size.width/2, alignment: .center)
                                        .padding()
                                    ProgressView()
                                    Spacer()
                                }
                                
                            }
                        }
                    }
                }
            }
            .navigationTitle(webViewDidFinishLoading ? "Video Player" : "VideoPlayerSwiftUI")
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert(isPresented:$viewModel.didFailToFetch) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.errorMessage ?? ""),
                  dismissButton: .default(Text("Refresh")) {
                    viewModel.getVideosList()
                  })
        }
    }
    
    fileprivate func playerView() -> some View {
        CustomVideoPlayer(player: viewModel.player)
            .onTapGesture {
                if viewModel.isPlaying {
                    viewModel.displayPlayerControllers.toggle()
                }
            }
    }
    
    fileprivate func playerButtons(image: String, size: Double) -> some View {
        Image(image)
            .clipShape(Circle())
            .frame(width: size, height: size)
            .background(Circle().fill(.background))
            .overlay(Circle().stroke(Color.black, lineWidth: 0.5))
            .padding()
    }
    
    fileprivate func convertMarkdownToHTML(title: String, authorName: String, description: String) -> String {
        let markdownString = """
        \(title)\n\n
        \(authorName)\n\n
        \(description)
        """
        let down = Down(markdownString: markdownString)
        return try! down.toHTML()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

