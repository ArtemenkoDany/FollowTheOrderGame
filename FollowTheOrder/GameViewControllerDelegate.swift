//
//  GameViewControllerDelegate.swift
//  FollowTheOrder
//
//  Created by Даниил on 28.11.2022.
//

import Foundation

protocol GameViewControllerDelegate: AnyObject {
    func showFailureView()
    func showSuccesView()
}
