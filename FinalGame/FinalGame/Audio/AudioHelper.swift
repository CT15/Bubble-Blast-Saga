//
//  AudioHelper.swift
//  FinalGame
//
//  Created by Calvin Tantio on 4/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit
import AVFoundation

struct AudioHelper {
    static func setupPlayer(fileName: String, loop: Int) -> AVAudioPlayer? {

        let player: AVAudioPlayer!

        let audioPath = Bundle.main.path(forResource: fileName, ofType: "wav")

        do {
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        } catch {
            return nil
        }

        guard let audioPlayer = player else {
            return nil
        }

        audioPlayer.numberOfLoops = loop
        audioPlayer.play()
        return audioPlayer
    }
}
