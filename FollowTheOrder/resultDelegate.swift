//
//  resultDelegate.swift
//  FollowTheOrder
//
//  Created by Даниил on 28.11.2022.
//

import Foundation

protocol resultDelegate: AnyObject {
    func restartLevel(vc: resultViewController, with isWin: Bool)
}
