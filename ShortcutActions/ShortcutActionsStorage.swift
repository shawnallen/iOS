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
        static let groupName = "group.com.duckduckgo.ShortcutActions"
    }
    
    static let shared = ShortcutActionsStorage()
    
    @UserDefaultsWrapper(key: .shortcutActionsStringsToOpen, defaultValue: [], group: Constants.groupName)
    var stringsToOpen: [String]
    
    private init() {}
    
}
