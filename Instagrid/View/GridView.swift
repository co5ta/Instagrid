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
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: [], animations: layoutAnimation, completion: nil)
    }
    
    /// Move an image container to a new position
    private func move(container: UIView, to position: UIView) {
        if let reference = container.superview {
            let destination = convert(position.frame.origin, to: reference)
            container.frame.origin = destination
        }
    }
    
    /// Switch the grid view to the oneRectangleTwoSquare layout
    private func switchToOneRectangleTwoSquare() {
        containerImage4.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        move(container: containerImage3, to: position1)
        move(container: containerImage1, to: position3)
        move(container: containerImage2, to: position4)
        
        containerImage3.frame.size = position3.frame.size
        Image3CenterXConstraint.constant = 0
    }
    
    /// Switch the grid view to the twoSquareOneRectangle layout
    private func switchToTwoSquareOneRectangle() {
        containerImage4.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        move(container: containerImage1, to: position1)
        move(container: containerImage2, to: position2)
        move(container: containerImage3, to: position3)
        
        containerImage3.frame.size = position3.frame.size
        Image3CenterXConstraint.constant = 0
    }
    
    /// Switch the grid view to the FourSquare layout
    private func switchToFourSquare() {
        containerImage4.transform = .identity
        
        move(container: containerImage1, to: position1)
        move(container: containerImage2, to: position2)
        move(container: containerImage3, to: position3)
        
        containerImage3.frame.size = position1.frame.size
        Image3CenterXConstraint.constant = (position1.frame.width + 15) / -2
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

    /// Vertical center constraint of the image in containerImage3
    @IBOutlet weak var Image3CenterXConstraint: NSLayoutConstraint!
}
