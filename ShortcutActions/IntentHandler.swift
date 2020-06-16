//
//  IntentHandler.swift
//  ShortcutActions
//
//  Created by Chris Brind on 14/06/2020.
//  Copyright © 2020 DuckDuckGo. All rights reserved.
//

import Intents
import Core

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        
        if intent is PrivateSearchIntent {
            return PrivateSearchIntentHandler()
        } else if intent is OpenURLsIntent {
            return OpenURLsIntentHandler()
        }
        
        return self
    }
    
}

class OpenURLsIntentHandler: NSObject, OpenURLsIntentHandling {
    
    func resolveUrls(for intent: OpenURLsIntent, with completion: @escaping ([OpenURLsUrlsResolutionResult]) -> Void) {
        print(#function, intent.urls as Any)
        let urls = intent.urls
        let result = urls?.map { OpenURLsUrlsResolutionResult.success(with: $0) }
        completion(result ?? [ OpenURLsUrlsResolutionResult.unsupported(forReason: .noUrls) ])
    }
        
    func handle(intent: OpenURLsIntent, completion: @escaping (OpenURLsIntentResponse) -> Void) {
        print(#function, intent.urls ?? "<nil>")
        let activity = NSUserActivity(activityType: ActivityTypes.openUrls)
        activity.userInfo = [
            ActivityTypes.ParamNames.urls: intent.urls as Any,
            ActivityTypes.ParamNames.clearData: intent.clearData as Any
        ]
        completion(.init(code: .continueInApp, userActivity: activity))
    }
    
    func resolveClearData(for intent: OpenURLsIntent, with completion: @escaping (INBooleanResolutionResult) -> Void) {
        let clearData = intent.clearData as? Bool ?? false
        completion(.success(with: clearData))
    }
    
}

class PrivateSearchIntentHandler: NSObject, PrivateSearchIntentHandling {
        
    func handle(intent: PrivateSearchIntent, completion: @escaping (PrivateSearchIntentResponse) -> Void) {
        print(#function, intent.query ?? "<nil>")
        let activity = NSUserActivity(activityType: ActivityTypes.search)
        activity.userInfo = [
            ActivityTypes.ParamNames.query: intent.query as Any,
            ActivityTypes.ParamNames.clearData: intent.clearData as Any
        ]
        completion(.init(code: .continueInApp, userActivity: activity))
    }
    
    func resolveClearData(for intent: PrivateSearchIntent, with completion: @escaping (INBooleanResolutionResult) -> Void) {
        let clearData = intent.clearData as? Bool ?? false
        print(#function, clearData)
        completion(.success(with: clearData))
    }
    
    func resolveQuery(for intent: PrivateSearchIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        print(#function, intent.query ?? "<nil>")
        completion(.success(with: intent.query ?? ""))
    }
        
}
