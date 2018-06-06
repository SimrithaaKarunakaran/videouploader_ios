//
//  AudioManager.swift
//  iOS
//
//  Created by Haik Kalantarian on 6/6/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import Foundation
import AVFoundation


/// Manages all audio played throughout the app.
public class AudioManager : NSObject {

    var URLChime   : URL
    var URLClick   : URL
    var URLMarimba : URL
    
    var SoundChime   : AVAudioPlayer?
    var SoundClick   : AVAudioPlayer?
    var SoundMarimba : AVAudioPlayer?

    override init(){
        
        // Lets pre-load the resources so they are available when needed!
        let PathChime   = Bundle.main.path(forResource: "chime.wav"  , ofType:nil)!;
        let PathClick   = Bundle.main.path(forResource: "click.wav"  , ofType:nil)!;
        let PathMarimba = Bundle.main.path(forResource: "marimba.wav", ofType:nil)!;
        
        URLChime   = URL(fileURLWithPath: PathChime)
        URLClick   = URL(fileURLWithPath: PathClick)
        URLMarimba = URL(fileURLWithPath: PathMarimba)
        
        do {
            SoundChime = try AVAudioPlayer(contentsOf: URLChime)
            print("[AUDIO] Loaded URLChime.")
            SoundChime?.prepareToPlay()
        } catch {
            print("[AUDIO] Could not load URLChime.")
        }
        
        do {
            SoundClick = try AVAudioPlayer(contentsOf: URLClick)
            print("[AUDIO] Loaded URLClick.")
            SoundClick?.prepareToPlay()
        } catch {
            print("[AUDIO] Could not load URLClick.")
        }
        
        do {
            SoundMarimba = try AVAudioPlayer(contentsOf: URLMarimba)
            print("[AUDIO] Loaded URLMarimba.")
            SoundMarimba?.prepareToPlay()
        } catch {
            print("[AUDIO] Could not load URLMarimba.")
        }
        
    }

    func PlayChime(){
        SoundChime?.prepareToPlay()
        SoundChime?.play()
    }
    
    func PlayClick(){
        SoundClick?.play()
    }
    
    func PlayMarimba(){
        SoundMarimba?.play()
    }
}
