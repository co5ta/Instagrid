//
//  ViewController.swift
//  Instagrid
//
//  Created by co5ta on 04/05/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /// The GridView contains images to assemble
    @IBOutlet weak var gridView: GridView!
    
    /// Buttons to choose the GridView layout
    @IBOutlet weak var OneRectangleTwoSquareButton: UIButton!
    @IBOutlet weak var TwoSquareOneRectangleButton: UIButton!
    @IBOutlet weak var FourSquareButton: UIButton!
    
    
    /// Enable the layout change
    @IBAction func changeLayout(_ sender: UIButton) {
        unselectButtons()
        activateSelectedLayout(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TwoSquareOneRectangleButton.isSelected = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// Activate button tapped to selected state and the others to unselected
    private func unselectButtons() {
        for button in [OneRectangleTwoSquareButton, TwoSquareOneRectangleButton, FourSquareButton] {
            button?.isSelected = false
        }
    }
    
    /// Give to GridView the layout selected
    private func activateSelectedLayout(_ buttonTapped: UIButton) {
        buttonTapped.isSelected = true
        
        switch buttonTapped {
        case OneRectangleTwoSquareButton:
            gridView.layout = .oneRectangleTwoSquare
        case TwoSquareOneRectangleButton:
            gridView.layout = .twoSquareOneRectangle
        case FourSquareButton:
            gridView.layout = .fourSquare
        default:
            break
        }
    }

}
