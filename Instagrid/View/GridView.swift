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
            setLayout()
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
    func setLayout() {
        switch layout {
        case .oneRectangleTwoSquare:
            hide(image2)
            show(image4)
        case .twoSquareOneRectangle:
            show(image2)
            hide(image4)
        case .fourSquare:
            show(image2)
            show(image4)
        }
    }
}

// MARK: - Animations

extension GridView {
    // Show an image of the GridView
    private func show(_ image: UIButton) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            image.isHidden = false
            image.superview?.layoutIfNeeded()
            image.transform = .identity
        })
    }
    
    // Hide an image of the GridView
    private func hide(_ image: UIButton) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            image.isHidden = true
        }, completion: { success in
            image.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        })
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
}
