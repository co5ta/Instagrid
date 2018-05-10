//
//  GridView.swift
//  Instagrid
//
//  Created by co5ta on 06/05/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import UIKit

/// GridView represents square containing all images views of the application
class GridView: UIView {

    /// Dispositions that can be taken by the GridView
    enum LayoutStyle {
        case oneRectangleTwoSquare, twoSquareOneRectangle, fourSquare
    }
    
    /// Sizes that can be taken by image containers
    enum ContainerSize {
        case normal, wide
    }
    
    /// The layout selected for the GridView
    var layout: LayoutStyle = .twoSquareOneRectangle {
        didSet {
            setLayout(layout)
        }
    }
    
    /// Reorganise positions of image containers according to the layout selected
    private func setLayout(_ layoutSelected: LayoutStyle) {
        var layoutAnimation: () -> ()
        
        switch layout {
        case .oneRectangleTwoSquare:
            layoutAnimation = {
                self.switchToOneRectangleTwoSquare()
            }
        case .twoSquareOneRectangle:
            layoutAnimation = {
                self.switchToTwoSquareOneRectangle()
            }
        case .fourSquare:
            layoutAnimation = {
                self.switchToFourSquare()
            }
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [], animations: layoutAnimation, completion: nil)
    }
    
    /// Move an image container to a new position
    private func move(container: UIView, to position: UIView) {
        if let reference = container.superview {
            let destination = convert(position.frame.origin, to: reference)
            container.frame.origin = destination
        }
    }
    
    /// Resize an image container
    private func resize(container: UIView, to size: ContainerSize) {
        if let reference = container.superview {
            switch size {
            case .wide:
                container.frame.size = CGSize(width: (reference.frame.width * 2) + 15, height: reference.frame.height)
            case .normal:
                container.frame.size = CGSize(width: (reference.frame.width), height: reference.frame.height)
            }
        }
    }
    
    /// Switch the grid view to the oneRectangleTwoSquare layout
    private func switchToOneRectangleTwoSquare() {
        move(container: containerImage3, to: position1)
        move(container: containerImage1, to: position3)
        move(container: containerImage2, to: position4)
        
        containerImage2.isHidden = false
        containerImage4.isHidden = true
        
        resize(container: containerImage3, to: .wide)
        resize(container: containerImage1, to: .normal)
    }
    
    /// Switch the grid view to the twoSquareOneRectangle layout
    private func switchToTwoSquareOneRectangle() {
        move(container: containerImage3, to: position1)
        move(container: containerImage1, to: position3)
        move(container: containerImage2, to: position2)
        
        containerImage2.isHidden = false
        containerImage4.isHidden = true
        
        resize(container: containerImage3, to: .normal)
        resize(container: containerImage1, to: .wide)
    }
    
    /// Switch the grid view to the FourSquare layout
    private func switchToFourSquare() {
        move(container: containerImage1, to: position1)
        move(container: containerImage2, to: position2)
        move(container: containerImage3, to: position3)
        
        containerImage2.isHidden = false
        containerImage4.isHidden = false
        
        resize(container: containerImage1, to: .normal)
        resize(container: containerImage3, to: .normal)
    }
    
    /// Default positions of image containers
    @IBOutlet weak var position1: UIView!
    @IBOutlet weak var position2: UIView!
    @IBOutlet weak var position3: UIView!
    @IBOutlet weak var position4: UIView!
    
    /// Image containers of the GridView
    @IBOutlet weak var containerImage1: UIView!
    @IBOutlet weak var containerImage2: UIView!
    @IBOutlet weak var containerImage3: UIView!
    @IBOutlet weak var containerImage4: UIView!

    
}
