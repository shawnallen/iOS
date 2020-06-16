//
//  IntentHandler.swift
//  ShortcutActions
//
//  Created by Chris Brind on 14/06/2020.
//  Copyright © 2020 DuckDuckGo. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        
        if intent is PrivateSearchIntent {
            return PrivateSearchIntentHandler()
        }
        
        return self
    }
    
}

class PrivateSearchIntentHandler: NSObject, PrivateSearchIntentHandling {
    
    func resolveClearData(for intent: PrivateSearchIntent, with completion: @escaping (INBooleanResolutionResult) -> Void) {
        let clearData = intent.clearData as? Bool ?? false
        print(#function, clearData)
        completion(.success(with: clearData))
    }
    
    func handle(intent: PrivateSearchIntent, completion: @escaping (PrivateSearchIntentResponse) -> Void) {
        print(#function, intent.query ?? "<nil>")
        let activity = NSUserActivity(activityType: ActivityTypes.search)
        activity.userInfo = [
            ActivityTypes.ParamNames.query: intent.query as Any,
            ActivityTypes.ParamNames.clearData: intent.clearData as Any
        ]
        completion(.init(code: .continueInApp, userActivity: activity))
    }
    
    func resolveQuery(for intent: PrivateSearchIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        print(#function, intent.query ?? "<nil>")
        completion(.success(with: intent.query ?? ""))
    }
        
}
