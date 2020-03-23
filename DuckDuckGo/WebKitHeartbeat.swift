//
//  WebKitHeartbeat.swift
//  DuckDuckGo
//
//  Copyright © 2020 DuckDuckGo. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import Core

class WebKitHeartbeat {
    
    struct Constants {
        public static let waitTime: TimeInterval = 5
    }
    
    private var sendDetailedInfo = false
    
    private var workItem: DispatchWorkItem?
    private var heartbeats = [String]()
    
    func startListening(shouldSendInfo: Bool = false) {
        sendInfoIfNeeded()
        sendDetailedInfo = shouldSendInfo
        
        workItem?.cancel()
        heartbeats.removeAll()
        
        workItem = DispatchWorkItem(block: { [weak self] in
            self?.issueDetected()
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.waitTime,
                                      execute: workItem!)
    }
    
    func didRecieveHeartbeat(from source: String) {
        workItem?.cancel()
        heartbeats.append(source)
    }
    
    private func sendInfoIfNeeded() {
        guard sendDetailedInfo else { return }
        sendDetailedInfo = false
        
        let params = ["hb": heartbeats.joined(separator: ",")]
        Pixel.fire(pixel: .heartbeatReport, withAdditionalParameters: params)
    }
    
    private func issueDetected() {
        Pixel.fire(pixel: .heartbeatNotDetected)
        sendInfoIfNeeded()
    }
}
