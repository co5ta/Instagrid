//
//  Grid.swift
//  Instagrid
//
//  Created by co5ta on 19/05/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import UIKit

extension UIImagePickerController
{
    /// Possible orientations of ImagePicker
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
}
