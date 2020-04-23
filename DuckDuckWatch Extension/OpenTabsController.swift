//
//  OpenTabsController.swift
//  DuckDuckWatch
//
//  Created by Chris Brind on 23/04/2020.
//  Copyright © 2020 DuckDuckGo. All rights reserved.
//

import WatchKit

class OpenTabsController: WKInterfaceController {
    
    @IBOutlet weak var table: WKInterfaceTable!
    
    override func didAppear() {
        super.didAppear()
        table.setNumberOfRows(1, withRowType: "TabDetail")
    }
    
}
