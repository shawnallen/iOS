//
//  IntentHandler.swift
//  ShortcutActions
//
//  Created by Chris Brind on 14/06/2020.
//  Copyright © 2020 DuckDuckGo. All rights reserved.
//

import Intents

@available(iOSApplicationExtension 13.0, *)
class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        
        if intent is OpenTextIntent {
            return OpenTextIntentHandler()
        }
        
        return self
    }
    
}

@available(iOSApplicationExtension 13.0, *)
class OpenTextIntentHandler: NSObject, OpenTextIntentHandling {
    
    func handle(intent: OpenTextIntent, completion: @escaping (OpenTextIntentResponse) -> Void) {
        let activity = NSUserActivity(activityType: ActivityTypes.openText)
        activity.userInfo = [
            ActivityTypes.ParamNames.text: intent.text as Any,
            ActivityTypes.ParamNames.clearData: intent.clearData as Any
        ]
        
        let launch = intent.launch as? Bool ?? false
        if !launch {
            ShortcutActionsStorage.shared.stringsToOpen += intent.text ?? []
        }
        
        completion(.init(code: launch ? .continueInApp : .success, userActivity: activity))
    }
    
    func resolveLaunch(for intent: OpenTextIntent, with completion: @escaping (INBooleanResolutionResult) -> Void) {
        completion(.success(with: intent.launch as? Bool ?? false))
    }
    
    func resolveClearData(for intent: OpenTextIntent, with completion: @escaping (INBooleanResolutionResult) -> Void) {
        completion(.success(with: intent.clearData as? Bool ?? false))
    }
    
    func resolveText(for intent: OpenTextIntent, with completion: @escaping ([OpenTextTextResolutionResult]) -> Void) {
        let result = intent.text?.map({
            OpenTextTextResolutionResult.success(with: $0)
        })
        completion(result ?? [OpenTextTextResolutionResult.unsupported(forReason: .noUrls)])
    }
  
}
