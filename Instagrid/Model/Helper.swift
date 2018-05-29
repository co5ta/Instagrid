//
//  Helper.swift
//  Instagrid
//
//  Created by co5ta on 29/05/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import UIKit

struct Helper {
    static func convertToImage(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
