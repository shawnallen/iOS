//
//  VoiceSearchViewController.swift
//  DuckDuckGo
//
//  Created by Chris Brind on 05/03/2020.
//  Copyright © 2020 DuckDuckGo. All rights reserved.
//

import UIKit
import Lottie
import Speech

protocol VoiceSearchDelegate: NSObjectProtocol {
    
    func voiceSearchComplete(_ controller: VoiceSearchViewController)
    
}

class VoiceSearchViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var animContainer: UIView!
    
    weak var delegate: VoiceSearchDelegate?
        
    var text: String? {
        return label.text
    }
    
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lottie = LOTAnimationView(name: "speech")
        lottie.loopAnimation = true
        lottie.play()
        view.insertSubview(lottie, at: 0)
        
        lottie.center = view.center
        button.isEnabled = false

        request()
    }
    
    @IBAction func cancel() {
        if !Thread.current.isMainThread {
            DispatchQueue.main.async {
                self.cancel()
            }
            return
        }
        
        dismiss(animated: true)
        stopListening()
    }
    
    @IBAction func duckIt() {
        delegate?.voiceSearchComplete(self)
    }
    
    private func request() {
        SFSpeechRecognizer.requestAuthorization { result in
            switch result {
            case .authorized:
                self.startListening()
                
            default:
                self.cancel()
            }
        }
    }
    
    // https://www.appcoda.com/siri-speech-framework/
    private func startListening() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            cancel()
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            cancel()
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                DispatchQueue.main.async {
                    self.label.text = result?.bestTranscription.formattedString
                    self.button.isEnabled = true
                    self.submitIfDuckIt()
                }
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.stopListening()
            }
        })
        
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            cancel()
            return
        }
        
        DispatchQueue.main.async {
            self.label.text = "Qwack away!"
        }
    }
    
    private func submitIfDuckIt() {
        guard let text = text else { return }
        if text.hasSuffix("duck it") && text.count > 7 {
            label.text = text.dropSuffix(suffix: "duck it")
            duckIt()
        }
    }
    
    private func stopListening() {
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.audioEngine.stop()
        self.recognitionRequest = nil
        self.recognitionTask = nil
    }
    
}
