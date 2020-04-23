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

extension FireAnimation: NibLoading {}

class FireAnimation: UIView {

    @IBOutlet var image: UIImageView!
    @IBOutlet var offset: NSLayoutConstraint!

    struct Constants {
        static let animationDuration = 1.2
        static let endDelayDuration = animationDuration + 0.2
        static let endAnimationDuration = 0.2
    }

    static let anim = Animation.named("fire-v3b-dark")

    static let provider = AnimationProvider()

    static func animate(newVersion: Bool, completion: @escaping () -> Void) {

        guard let window = UIApplication.shared.keyWindow else {
            completion()
            return
        }

        guard let snapshot = window.snapshotView(afterScreenUpdates: false) else {
            completion()
            return
        }

        window.addSubview(snapshot)

        if newVersion {

            print("***", anim?.size as Any)
            let animView = AnimationView(animation: anim)
            animView.imageProvider = provider
            animView.textProvider = provider
            animView.contentMode = .scaleAspectFill
            animView.frame = window.bounds
            window.addSubview(animView)

            animView.play(fromFrame: 0, toFrame: 35, loopMode: .playOnce) { _ in
                animView.play(fromFrame: 35, toFrame: 60, loopMode: .playOnce) { _ in
                    animView.removeFromSuperview()
                    completion()
                    snapshot.removeFromSuperview()
                }
                snapshot.removeFromSuperview()
            }

        } else {

            let anim = FireAnimation.load(nibName: "FireAnimation")
            anim.image.animationImages = animatedImages
            anim.image.contentMode = window.frame.width > anim.image.animationImages![0].size.width ? .scaleAspectFill : .center
            anim.image.startAnimating()

            anim.frame = window.frame
            anim.transform.ty = anim.frame.size.height
            window.addSubview(anim)

            UIView.animate(withDuration: Constants.animationDuration, delay: 0, options: .curveEaseOut, animations: {
                anim.transform.ty = -(anim.offset.constant * 2)
            }, completion: { _ in
                completion()
                snapshot.removeFromSuperview()
            })

            UIView.animate(withDuration: Constants.endAnimationDuration, delay: Constants.endDelayDuration, options: .curveEaseOut, animations: {
                anim.alpha = 0
            }, completion: { _ in
                anim.removeFromSuperview()
            })

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
