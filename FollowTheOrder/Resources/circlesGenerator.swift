//
//  circlesGenerator.swift
//  FollowTheOrder
//
//  Created by Даниил on 27.11.2022.
//

import Foundation

class circlesGenerator {
    // MARK: - Properties
    private let minX: CGFloat
    private let maxX: CGFloat
    private let minY: CGFloat
    private let maxY: CGFloat
    // MARK: - init 
    init(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
        self.minX = minX
        self.maxX = maxX
        self.minY = minY
        self.maxY = maxY
    }
    // MARK: - generate circles to show selector
    func generateCircles(count: Int, size: CGSize) -> [CGPoint]? {
        var frames: [CGRect] = []
        /// Add elements while their amount will not fit the needed amount of the elements per level
        while frames.count < count {
            let randomX = CGFloat.random(in: minX..<maxX)
            let randomY = CGFloat.random(in: minY..<maxY)
            let newСircle = CGRect(origin: CGPoint(x: randomX, y: randomY), size: size)
            
            var isIntersected = false
            /// Check if the newly generated circle does not intersect with any of the already generated circles
            for frame in frames {
                if frame.intersects(newСircle) {
                    isIntersected = true
                    break
                }
            }
            if !isIntersected {
                frames.append(newСircle)
            }
        }
        return frames.map({$0.origin})
    }
}
