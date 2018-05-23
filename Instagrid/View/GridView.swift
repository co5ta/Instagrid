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
    
    /// The layout selected for the GridView
    var layout: LayoutStyle = .twoSquareOneRectangle {
        didSet {
            setLayout(layout)
        }
    }
    
    /// Reorganise positions of image containers according to the layout selected
    func setLayout(_ layoutSelected: LayoutStyle) {
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
    
    /// Move an image to a new position
    private func move(_ image: UIButton, to container: UIView) {
        image.frame.origin = container.frame.origin
    }
    
    /// Hide an image from the GridView
    private func hide(_ image: UIButton) {
        image.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }
    
    /// Resize an image to same size as a container
    private func resize(_ image: UIButton, toFit container: UIView) {
        image.frame.size = container.frame.size
    }
    
    /// Switch the grid view to the oneRectangleTwoSquare layout
    private func switchToOneRectangleTwoSquare() {
        hide(image4)
        
        move(image1, to: container3)
        move(image2, to: container4)
        move(image3, to: container1)
        
        resize(image3, toFit: container3)
    }
    
    /// Switch the grid view to the twoSquareOneRectangle layout
    private func switchToTwoSquareOneRectangle() {
        hide(image4)
        
        move(image1, to: container1)
        move(image2, to: container2)
        move(image3, to: container3)
        
        resize(image3, toFit: container3)
    }
    
    /// Switch the grid view to the FourSquare layout
    private func switchToFourSquare() {
        image4.transform = .identity
        
        move(image1, to: container1)
        move(image2, to: container2)
        move(image3, to: container3)
        
        resize(image3, toFit: container1)
    }
    
    /// Default containers of image containers
    @IBOutlet weak var container1: UIView!
    @IBOutlet weak var container2: UIView!
    @IBOutlet weak var container3: UIView!
    @IBOutlet weak var container4: UIView!
    
    /// Image containers of the GridView
    @IBOutlet weak var image1: UIButton!
    @IBOutlet weak var image2: UIButton!
    @IBOutlet weak var image3: UIButton!
    @IBOutlet weak var image4: UIButton!
}
