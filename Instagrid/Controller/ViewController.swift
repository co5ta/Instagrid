//
//  ViewController.swift
//  Instagrid
//
//  Created by co5ta on 04/05/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    /// The GridView contains images to assemble
    @IBOutlet weak var gridView: GridView!
    
    @IBOutlet weak var swipeToShareLabel: UILabel!
    
    /// Buttons to choose the GridView layout
    @IBOutlet weak var OneRectangleTwoSquareButton: UIButton!
    @IBOutlet weak var TwoSquareOneRectangleButton: UIButton!
    @IBOutlet weak var FourSquareButton: UIButton!
    
    /// Images in the GridView
    @IBOutlet var gridImages: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activateSelectedLayout(TwoSquareOneRectangleButton)
        
        for buttonImage in gridImages {
            buttonImage.imageView?.contentMode = .scaleAspectFill
        }
        
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGridView(_:)))
        gridView.addGestureRecognizer(swipeUpGestureRecognizer)
        swipeUpGestureRecognizer.direction = .up
        
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGridView(_:)))
        gridView.addGestureRecognizer(swipeLeftGestureRecognizer)
        swipeLeftGestureRecognizer.direction = .left
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// Enable the layout change
    @IBAction func changeLayout(_ sender: UIButton) {
        unselectButtons()
        activateSelectedLayout(sender)
    }
    
    /// Insert a photo in the place selected in the GridView
    @IBAction func setGridImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Choose a photo", message: "", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            alert.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default) { (action) in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            alert.addAction(photoLibraryAction)
        }
        
        alert.popoverPresentationController?.sourceView = sender
        present(alert, animated: true, completion: nil)
        sender.isSelected = true
    }
    
    /// Swipe up the GridView
    @objc private func swipeGridView(_ sender: UISwipeGestureRecognizer) {
        var transform: CGAffineTransform? = nil
        
        print(sender.direction)
        print(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
        
        if sender.direction == .left  && UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            transform = CGAffineTransform(translationX: UIScreen.main.bounds.width * -1, y: 0)
            print("landscape")
        }
        else if sender.direction == .up && UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height * -1)
            print("portrait")
        }
        
        if transform != nil {
            UIView.animate(withDuration: 0.5, animations: {
                self.gridView.transform = transform!
            }) { (success) in
                if success {
                    self.shareGridView()
                }
            }
        }
    }
    
    /// Unselected layout switcher buttons
    private func unselectButtons() {
        for button in [OneRectangleTwoSquareButton, TwoSquareOneRectangleButton, FourSquareButton] {
            button?.isSelected = false
        }
    }
    
    /// Give the layout selected to the GridView
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

    /// Put the choosen image to the selected place of the GridView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        for image in gridImages {
            if image.isSelected == true {
                image.setImage(selectedImage, for: .normal)
                image.isSelected = false
                break
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func convertGridToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(gridView.bounds.size, true, 0)
        gridView.drawHierarchy(in: gridView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    private func shareGridView() {
        guard let imageToShare = convertGridToImage() else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            self.gridView.transform = .identity
            self.gridView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                self.gridView.transform = .identity
            }, completion: nil)
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func deviceRotated() {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            swipeToShareLabel.text = "Swipe left to share"
        } else {
            swipeToShareLabel.text = "Swipe up to share"
        }
        
        gridView.setLayout(gridView.layout)
    }
}

