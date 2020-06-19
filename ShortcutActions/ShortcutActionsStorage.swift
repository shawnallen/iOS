//
//  OpenedURLsStorage.swift
//  ShortcutActions
//
//  Created by Chris Brind on 18/06/2020.
//  Copyright © 2020 DuckDuckGo. All rights reserved.
//

import Foundation
import Core

class ShortcutActionsStorage {
    
    struct Constants {
        static let groupName = "com.duckduckgo.ShortcutActions"
    }
    
    static let shared = ShortcutActionsStorage()
    
    @UserDefaultsWrapper(key: .shortcutActionsOpenUrls, defaultValue: [], group: Constants.groupName)
    var openUrls: [URL]
    
    private init() {}
    
}
