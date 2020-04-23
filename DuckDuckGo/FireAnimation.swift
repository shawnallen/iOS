//
//  FireAnimation.swift
//  DuckDuckGo
//
//  Copyright © 2017 DuckDuckGo. All rights reserved.
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

import UIKit
import Lottie
import Core

extension FireAnimation: NibLoading {}

class AnimationSettings {

    @UserDefaultsWrapper(key: .animation, defaultValue: 0)
    var animation: Int

}

class FireAnimation: UIView {

    @IBOutlet var image: UIImageView!
    @IBOutlet var offset: NSLayoutConstraint!

    struct Constants {
        static let animationDuration = 1.2
        static let endDelayDuration = animationDuration + 0.2
        static let endAnimationDuration = 0.2
    }

    static let fireAnim = Animation.named("fire-v3b-dark")!
    static let dinoAnim = Animation.named("dinofire")!
    static let lightningAnim = Animation.named("lightning")!

    static let provider = AnimationProvider()

    static func preload() {
        DispatchQueue.global(qos: .background).async {
            _ = fireAnim.size
            _ = dinoAnim.size
            _ = lightningAnim.size
        }
    }

    static func animate(completion: @escaping () -> Void) {

        guard let window = UIApplication.shared.keyWindow else {
            completion()
            return
        }

        guard let snapshot = window.snapshotView(afterScreenUpdates: false) else {
            completion()
            return
        }

        window.addSubview(snapshot)

        let settings = AnimationSettings()

        let anim: Animation
        if settings.animation == -1 {
            anim = lightningAnim
        } else if settings.animation >= 3 {
            anim = dinoAnim
            settings.animation = 0
        } else {
            anim = fireAnim
            settings.animation += 1
        }

        let animView = AnimationView(animation: anim)
        animView.imageProvider = provider
        animView.textProvider = provider
        animView.contentMode = .scaleAspectFill
        animView.frame = window.bounds
        window.addSubview(animView)

        if anim === fireAnim {
            animView.play(fromFrame: 0, toFrame: 35, loopMode: .playOnce) { _ in
                animView.play(fromFrame: 35, toFrame: 60, loopMode: .playOnce) { _ in
                    animView.removeFromSuperview()
                    completion()
                }
                snapshot.removeFromSuperview()
            }
        } else {
            animView.play { _ in
                animView.removeFromSuperview()
                completion()
                snapshot.removeFromSuperview()
            }
        }

    }

    private static var animatedImages: [UIImage] {
        var images = [UIImage]()
        for i in 1...20 {
            let filename = String(format: "flames00%02d", i)
            let image = #imageLiteral(resourceName: filename)
            images.append(image)
        }
        return images
    }

}

class AnimationProvider: AnimationImageProvider, AnimationTextProvider {

    func textFor(keypathName: String, sourceText: String) -> String {
        print("***", #function, keypathName, sourceText)
        return ""
    }

    func imageForAsset(asset: ImageAsset) -> CGImage? {
        print("***", #function, asset.name)
        return nil
    }

}
