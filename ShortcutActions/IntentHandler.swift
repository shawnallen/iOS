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
    
    func handle(intent: PrivateSearchIntent, completion: @escaping (PrivateSearchIntentResponse) -> Void) {
        print(#function, intent.query ?? "<nil>")
        let activity = NSUserActivity(activityType: ActivityTypes.search)
        activity.userInfo = [ActivityTypes.ParamNames.query: intent.query as Any]
        completion(.init(code: .continueInApp, userActivity: activity))
    }
    
    func resolveQuery(for intent: PrivateSearchIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        print(#function, intent.query ?? "<nil>")
        completion(.success(with: intent.query ?? ""))
    }
        
}
