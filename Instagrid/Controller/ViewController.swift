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
    
    /// The label mentionning the swipe direction to share the GridView
    @IBOutlet weak var swipeToShareLabel: UILabel!
    
    /// Buttons to choose the GridView layout
    @IBOutlet weak var OneRectangleTwoSquareButton: UIButton!
    @IBOutlet weak var TwoSquareOneRectangleButton: UIButton!
    @IBOutlet weak var FourSquareButton: UIButton!
    
    /// Images in the GridView
    @IBOutlet var gridImages: [UIButton]!
    
    /// Image tapped in the GridView
    var gridViewImageSelected: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridView.addShadow()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    /// Apply some changes on views when device is rotated
    func deviceRotated() {
        gridView.setLayout(gridView.layout)
        updateShareLabel()
        updateEmptyGridImage()
    }
    
    /// Change the label indicating the swipe direction to share GridView
    private func updateShareLabel() {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            swipeToShareLabel.text = "Swipe left to share"
        } else {
            swipeToShareLabel.text = "Swipe up to share"
        }
    }
    
    /// Change the default image in empty grid images
    private func updateEmptyGridImage() {
        for buttonImage in gridImages {
            if buttonImage.isSelected == false {
                if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
                    buttonImage.setImage(#imageLiteral(resourceName: "plus gray"), for: .normal)
                } else {
                    buttonImage.setImage(#imageLiteral(resourceName: "plus blue"), for: .normal)
                }
            }
        }
    }

    /// Enable the layout change
    @IBAction func changeLayout(_ sender: UIButton) {
        unselectButtons()
        activateSelectedLayout(sender)
    }
    
    /// Unselect layout switcher buttons
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
    
    /// Insert a photo in the box tapped in the GridView
    @IBAction func setGridImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Choose a photo", message: "", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.addSource(title: "Camera", imagePicker: imagePicker, sourceType: .camera, alert: alert)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.addSource(title: "Photo library", imagePicker: imagePicker, sourceType: .photoLibrary, alert: alert)
        }
        
        alert.popoverPresentationController?.sourceView = sender
        alert.popoverPresentationController?.sourceRect = CGRect(x: sender.bounds.midX, y: sender.bounds.midY, width: 0, height: 0)
        alert.popoverPresentationController?.permittedArrowDirections = .down
        
        present(alert, animated: true, completion: nil)
        
        gridViewImageSelected = sender
    }
    
    /// Add source to the image picker where user can choose a photo
    private func addSource(title: String, imagePicker: UIImagePickerController, sourceType: UIImagePickerControllerSourceType, alert: UIAlertController) {
        let action = UIAlertAction(title: title, style: .default) { (action) in
            imagePicker.sourceType = sourceType
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        alert.addAction(action)
    }
    
    /// Put the choosen image to the selected place of the GridView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        for buttonImage in gridImages {
            if buttonImage == gridViewImageSelected {
                buttonImage.setImage(selectedImage, for: .normal)
                buttonImage.isSelected = true
                gridViewImageSelected = nil
                break
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    /// Swipe the GridView
    @objc private func swipeGridView(_ sender: UISwipeGestureRecognizer) {
        guard checkIfGridViewIsFilled() else {
            alertGridNotFilled()
            return
        }
        guard let transform = getGridViewTranslationDirection(swipeDirection: sender.direction) else {
            return
        }
       
        UIView.animate(withDuration: 0.5, animations: {
            self.gridView.transform = transform
        }) { (success) in
            if success {
                self.shareGridView()
            }
        }
    }
    
    /// Verify if all boxes of the GridView are filled
    private func checkIfGridViewIsFilled() -> Bool {
        let notFilled = false
        
        for buttonImage in gridImages {
            if buttonImage.isSelected == false {
                guard buttonImage == gridView.image4 else {
                    return notFilled
                }
                guard gridView.layout != .fourSquare else {
                    return notFilled
                }
            }
        }
        
        return true
    }
    
    /// Present an alert indicating the GridView must be filled to be shared
    private func alertGridNotFilled() {
        let alert = UIAlertController(title: "Grid is not filled", message: "You must fill the grid entirely if you want to share it", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    /// Give to the GridView a suitable translation according to the swipe done
    private func getGridViewTranslationDirection(swipeDirection: UISwipeGestureRecognizerDirection) -> CGAffineTransform? {
        var transform: CGAffineTransform? = nil
        
        if swipeDirection == .left  && UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            transform = CGAffineTransform(translationX: UIScreen.main.bounds.width * -1, y: 0)
        }
        else if swipeDirection == .up && UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height * -1)
        }
        
        return transform
    }
    
    /// Present an activity view controller to share the GridView
    private func shareGridView() {
        guard let imageToShare = convertGridViewToImage() else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            self.repositionGridViewToDefaultPlace()
        }
        
        activityViewController.popoverPresentationController?.sourceView = view
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    /// Convert GridView to image
    private func convertGridViewToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(gridView.bounds.size, true, 0)
        
        gridView.drawHierarchy(in: gridView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// Reposition the GridView to its initial place
    private func repositionGridViewToDefaultPlace() {
        self.gridView.transform = .identity
        self.gridView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.gridView.transform = .identity
        }, completion: nil)
    }
    
}

