//
//  ActivityTypes.swift
//  DuckDuckGo
//
//  Created by Chris Brind on 14/06/2020.
//  Copyright © 2020 DuckDuckGo. All rights reserved.
//

import Foundation

struct ActivityTypes {
    
    static let search = "com.duckduckgo.mobile.ios.intents.search"
    static let openUrls = "com.duckduckgo.mobile.ios.intents.openurls"

    struct ParamNames {
        
        static let query = "query"
        static let clearData = "clearData"
        static let urls = "URL"
        
    }
    
}
