//
//  SERPSettingsViewController.swift
//  DuckDuckGo
//
//  Created by Chris Brind on 03/09/2020.
//  Copyright © 2020 DuckDuckGo. All rights reserved.
//

import UIKit
import WebKit

class SERPSettingsViewController: UIViewController {

    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: view.frame)
        webView.load(URLRequest(url: URL(string: "https://duckduckgo.com/settings")!))

        view.addSubview(webView)

        webView.alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.webView.alpha = 1.0
        }

        if #available(iOS 11, *) {
            hideSettingsFurniture()
        }
    }

    @available(iOS 11, *)
    private func hideSettingsFurniture() {
        guard let store = WKContentRuleListStore.default() else { return }

        let selectorsToHide = [".set-head__title", "header", ".set-main-footer" ]
        let rules = "[" +
            selectorsToHide.map({
"""
                {
                  "trigger": {
                    "url-filter": ".*",
                    "if-domain": ["*duckduckgo.com"]
                  },
                  "action": {
                    "type": "css-display-none",
                    "selector": "\($0)"
                  }
                }
"""
            }).joined(separator: ",")
        + "]"
        
        store.compileContentRuleList(forIdentifier: "hide-extension-css", encodedContentRuleList: rules) { rulesList, error in
            guard let rulesList = rulesList else {
                fatalError(String(describing: error))
            }
            self.webView.configuration.userContentController.add(rulesList)
        }
    }

}
