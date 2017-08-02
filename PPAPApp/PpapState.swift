//
//  PpapState.swift
//  PPAPApp
//
//  Created by 藤井陽介 on 2016/12/05.
//  Copyright © 2016年 touyou. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation


final class PpapGenerator: NSObject {
    var talker: AVSpeechSynthesizer!
    var imageView: UIImageView!
    var textView: UILabel!
    fileprivate var state: PpapState = .initial
    var flag = 0
    
    init(_ imgView: UIImageView, _ txtView: UILabel) {
        super.init()
        talker = AVSpeechSynthesizer()
        talker.delegate = self
        imageView = imgView
        textView = txtView
    }
    
    fileprivate enum Word: String, EnumEnumerable {
        case pen
        case pineapple
        case apple
    }

    fileprivate enum PpapState {
        case initial, p, pp, ppa, ppap
        
        func transition(_ next: Word) -> PpapState {
            switch (next, self) {
            case (.pen, .initial): return .p
            case (.pineapple, .p): return .pp
            case (.apple, .pp): return .ppa
            case (.pen, .ppa): return .ppap
            default: return .initial
            }
        }
    }
    
    let itemImage = [#imageLiteral(resourceName: "pen1"), #imageLiteral(resourceName: "pen2"), #imageLiteral(resourceName: "pineapple"), #imageLiteral(resourceName: "apple")]
    
    func ppapMachine() {
        if state != .ppap {
            let num = Int(arc4random_uniform(UInt32(Word.count)))
            let word = Word.cases[num]
            state = state.transition(word)
            let str = generateSentence(word)
            speakWord(str)
            textView.text = str
            if num == 0 {
                imageView.image = itemImage[num + Int(arc4random_uniform(UInt32(1)))]
            } else {
                imageView.image = itemImage[num + 1]
            }
        }
    }
    
    func stopMachine() {
        state = .ppap
        flag = 100
        talker.stopSpeaking(at: .immediate)
        talker = AVSpeechSynthesizer()
    }
    
    let obj = ["Apple pen", "Pineapple pen", "Uh!", "Pen Pineapple Apple Pen!"]
    let waitMin = [2, 3.5, 1, 0]
    let resultImage = [#imageLiteral(resourceName: "applepen"), #imageLiteral(resourceName: "pineapplepen"), #imageLiteral(resourceName: "uh"), #imageLiteral(resourceName: "penpineappleapplepen")]
    
    func finalCall() {
        speakWord(obj[flag])
        textView.text = obj[flag]
        imageView.image = resultImage[flag]
        RunLoop.main.run(until: Date(timeIntervalSinceNow: waitMin[flag]))
        flag += 1
    }
    
    fileprivate func generateSentence(_ word: Word) -> String {
        switch word {
        case .apple:
            return "I have an \(word.rawValue)"
        default:
            return "I have a \(word.rawValue)"
        }
    }
    
    fileprivate func speakWord(_ string: String) {
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        talker.speak(utterance)
    }
}

extension PpapGenerator: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if state != .ppap {
            ppapMachine()
        } else if flag < 4{
            finalCall()
        }
        return
    }
}
