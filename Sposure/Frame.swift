//
//  Frame.swift
//  Sposure
//
//  Created by Kyle McCrohan on 6/9/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    
    init(center: CGPoint, size: CGSize) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: CGPoint(x: originX, y: originY), size: size)
    }
}