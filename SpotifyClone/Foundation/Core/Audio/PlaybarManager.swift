//
//  AudioPlayer.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 20/02/24.
//

import AVFoundation

@Observable class PlaybarManager {
    
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timeObserverToken: Any?
    var status: PlaybarStatus = .stop
    var state: PlaybarState = .hidden
    var currentPlaybackTime: CMTime = .zero
    var playbarUi: PlaybarUi
    
    init(playbarUi: PlaybarUi = PlaybarUi()) {
        self.playbarUi = playbarUi
    }
    
    deinit {
        removeTimeObserver()
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        var playbackDurationSeconds = playerItem?.duration.seconds ?? .zero
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentPlaybackTime = time
            if !playbackDurationSeconds.isNumber() {
                playbackDurationSeconds = self?.playerItem?.duration.seconds ?? .zero
            }
            if playbackDurationSeconds.isNumber() && Int(time.seconds) == Int(playbackDurationSeconds) {
                self?.status = .stop
                self?.removeTimeObserver()
            }
        }
    }
    
    private func removeTimeObserver() {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    func play(playbarUi: PlaybarUi) {
        guard let url = URL(string: playbarUi.previewUrl) else { return }
        self.playbarUi = playbarUi
        removeTimeObserver()
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        addTimeObserver()
        status = .play
        state = .visible
    }
    
    func play() {
        switch status {
        case .pause:
            player?.play()
            status = .play
        case .stop:
            play(playbarUi: playbarUi)
        default:
            break
        }
    }
    
    func pause() {
        player?.pause()
        status = .pause
    }
    
    func showPlaybar() {
        guard !playbarUi.id.isEmpty else {
            state = .hidden
            return
        }
        state = .visible
    }
    
    func hidePlaybar() {
        state = .hidden
    }
    
    func isVisible() -> Bool {
        state == .visible
    }
}

extension PlaybarManager {
    
    enum PlaybarStatus {
        case play
        case pause
        case stop
    }
    
    enum PlaybarState {
        case visible
        case hidden
    }
}
