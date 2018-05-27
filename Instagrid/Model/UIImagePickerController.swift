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
    override open var shouldAutorotate: Bool {
        return true
    }
    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .all
    }
}
