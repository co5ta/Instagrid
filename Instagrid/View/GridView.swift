//
//  GridView.swift
//  Instagrid
//
//  Created by co5ta on 06/05/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import UIKit

/// GridView is a view where you can add images in several layouts
class GridView: UIView {
    // MARK: Outlets
    
    /// An image location of the GridView
    @IBOutlet weak var container1: UIView!
    
    /// An image location of the GridView
    @IBOutlet weak var container2: UIView!
    
    /// An image location of the GridView
    @IBOutlet weak var container3: UIView!
    
    /// An image location of the GridView
    @IBOutlet weak var container4: UIView!
    
    /// An image of the GridView
    @IBOutlet weak var image1: UIButton!
    
    /// An image of the GridView
    @IBOutlet weak var image2: UIButton!
    
    /// An image of the GridView
    @IBOutlet weak var image3: UIButton!
    
    /// An image of the GridView
    @IBOutlet weak var image4: UIButton!
    
    
    // MARK: Properties
    
    /// The layout selected for the GridView
    var layout: LayoutStyle = .twoSquareOneRectangle {
        didSet {
            setLayout(layout)
        }
    }
}

// MARK: - Layout styles

extension GridView {
    /// Dispositions that can be taken by the GridView
    enum LayoutStyle {
        /// GridView layout
        case oneRectangleTwoSquare, twoSquareOneRectangle, fourSquare
    }
    
    /**
     Reorganise positions of image containers according to the layout selected
     - Parameter selectedLayout: The layout selected
     */
    func setLayout(_ selectedLayout: LayoutStyle) {
        let layoutAnimation = getLayoutAnimation(for: selectedLayout)
        
        UIView.animate( withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: [],
            animations: layoutAnimation,
            completion: nil
        )
    }
}

// MARK: - Animations

extension GridView {
    /**
     Get the animation wich makes transition to the layout
     - Parameter layout: The targeted layout
     */
    private func getLayoutAnimation(for layout: LayoutStyle) -> () -> Void {
        switch layout {
        case .oneRectangleTwoSquare:
            return { self.switchToOneRectangleTwoSquare() }
        case .twoSquareOneRectangle:
            return { self.switchToTwoSquareOneRectangle() }
        case .fourSquare:
            return { self.switchToFourSquare() }
        }
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
    
    /**
     Move an image to a new position
     - Parameters:
        - image: The image to move
        - container: The location to reach
     */
    private func move(_ image: UIButton, to container: UIView) {
        image.frame.origin = container.frame.origin
    }
    
    /**
     Hide an image from the GridView
     - Parameters:
        - image: The image to hide
     */
    private func hide(_ image: UIButton) {
        image.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }
    
    /**
     Resize an image to the same size as a container
     - Parameters:
     - image: The image to move
     - container: The location to reach
     */
    private func resize(_ image: UIButton, toFit container: UIView) {
        image.frame.size = container.frame.size
    }
}

// MARK: - Extra features

extension GridView {
    /// Add a shadow behind GrivView
    func addShadow() {
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4.0
    }
    
    /// Generate an image of the GridView
    func convertToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
