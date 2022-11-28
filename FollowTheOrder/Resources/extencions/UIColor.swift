//
//  UIImageExtencion.swift
//  FollowTheOrder
//
//  Created by Даниил on 27.11.2022.
//

import Foundation
import SpriteKit
///extencion to generate random colors
extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}
