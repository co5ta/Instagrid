//
//  GridViewController.swift
//  Instagrid
//
//  Created by co5ta on 04/05/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import UIKit

/// Class which manage the GridView Scene
class GridViewController: UIViewController {
    // MARK: Outlets
    
    /// The GridView contains images to assemble
    @IBOutlet weak var gridView: GridView!
    
    /// The label mentionning the swipe direction to share the GridView
    @IBOutlet weak var swipeToShareLabel: UILabel!
    
    /// Button to choose a layout style
    @IBOutlet weak var OneRectangleTwoSquareButton: UIButton!
    
    /// Button to choose a layout style
    @IBOutlet weak var TwoSquareOneRectangleButton: UIButton!
    
    /// Button to choose a layout style
    @IBOutlet weak var FourSquareButton: UIButton!
    
    /// Images of the GridView
    @IBOutlet var gridImages: [UIButton]!
    
    
    // MARK: Properties
    
    /// Image tapped in the GridView
    var imageTapped: UIButton?
    
    /// Return true if the GridView is filled
    var isFilled: Bool {
        for buttonImage in gridImages where !buttonImage.isSelected {
            if buttonImage == gridView.image1 || buttonImage == gridView.image3 {
                return false
            }
            if buttonImage == gridView.image2 && gridView.layout != .oneRectangleTwoSquare {
                return false
            }
            if buttonImage == gridView.image4 && gridView.layout != .twoSquareOneRectangle {
                return false
            }
        }
        return true
    }
    
    /// Swipe direction required to run share functionnality
    var swipeDirectionRequired: UISwipeGestureRecognizer.Direction {
        let isLandscape = UIScreen.main.bounds.height < UIScreen.main.bounds.width ? true: false
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad ? true : false
        
        if (isLandscape && !isIpad) {
            return .left
        } else {
            return .up
        }
    }
}

// MARK: - Lyfe cycle

extension GridViewController {
    // Init view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridView.addShadow()
        selectNewLayout(TwoSquareOneRectangleButton)
        
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
    
    // Before the view appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // Before the view disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver( self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}

// MARK: - Orientation

extension GridViewController {
    /// Update scene on device rotation
    @objc func deviceRotated() {
        setShareLabel()
        setEmptyGridImage()
    }
    
    /// Set the share label according to the device orientation
    private func setShareLabel() {
        let direction = swipeDirectionRequired == .up ?  "up" : "left"
        swipeToShareLabel.text = "Swipe \(direction) to share"
    }
    
    /// Change the default image in empty grid images
    private func setEmptyGridImage() {
        let emptyImage = swipeDirectionRequired == .up ? #imageLiteral(resourceName: "plus blue") : #imageLiteral(resourceName: "plus gray")
        for image in gridImages where !image.isSelected {
            image.setImage(emptyImage, for: .normal)
        }
    }
}

// MARK: - Layout

extension GridViewController {
    /// Enable the layout change when
    @IBAction func layoutButtonTapped(_ sender: UIButton) {
        if !sender.isSelected {
            unselectLayoutButtons()
            selectNewLayout(sender)
        }
    }
    
    /// Unselect all buttons
    private func unselectLayoutButtons() {
        for button in [OneRectangleTwoSquareButton, TwoSquareOneRectangleButton, FourSquareButton] {
            button?.isSelected = false
        }
    }
    
    /// Give the layout selected to the GridView
    private func selectNewLayout(_ button: UIButton) {
        button.isSelected = true
        
        switch button {
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

// MARK: - ImagePicker

extension GridViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// Get the image choosen by the user
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        for image in gridImages where image == imageTapped {
            image.setImage(selectedImage, for: .normal)
            image.isSelected = true
            imageTapped = nil
            break
        }
        dismiss(animated: true)
    }
    
    /// Insert the image choosen by the user in the GridView
    @IBAction func insertImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Choose a photo", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.addSourceType(title: "Camera", imagePicker: imagePicker, sourceType: .camera, alert: alert)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.addSourceType(title: "Photo library", imagePicker: imagePicker, sourceType: .photoLibrary, alert: alert)
        }
        
        alert.popoverPresentationController?.sourceView = sender
        alert.popoverPresentationController?.permittedArrowDirections = .down
        alert.popoverPresentationController?.sourceRect = CGRect(x: sender.bounds.midX, y: sender.bounds.midY, width: 0, height: 0)
        
        present(alert, animated: true)
        imageTapped = sender
    }
    
    /**
     Add a SourceType to the imagePicker
     - Parameters:
        - title : name of the SourceType
        - imagePicker: imagePicker to handle
        - sourceType: SourceType to add
        - alert: UIAlertController that will suggest the sourceTypes
    */
    private func addSourceType(title: String, imagePicker: UIImagePickerController, sourceType: UIImagePickerController.SourceType, alert: UIAlertController) {
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in
            imagePicker.sourceType = sourceType
            self.present(imagePicker, animated: true)
        }))
    }
}

// MARK: - Share

extension GridViewController {
    /// Swipe the GridView
    @objc private func swipeGridView(_ sender: UISwipeGestureRecognizer) {
        guard let transform = getGridViewTranslationDirection(swipeDirection: sender.direction) else { return }
        guard isFilled else {
            presentAlert(title: "Grid is not filled", message: "Fill the grid to share it")
            return }
        
        UIView.animate(withDuration: 0.5, animations: { self.gridView.transform = transform }) { (success) in
            if success {
                self.shareGridView()
            }
        }
    }
    
    /// Give to the GridView the appropriate translation according to the swipe done
    private func getGridViewTranslationDirection(swipeDirection: UISwipeGestureRecognizer.Direction) -> CGAffineTransform? {
        var transform: CGAffineTransform? = nil
        
        if swipeDirection == .up && swipeDirectionRequired == .up {
            transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height * -1)
        } else if swipeDirection == .left  && swipeDirectionRequired == .left {
            transform = CGAffineTransform(translationX: UIScreen.main.bounds.width * -1, y: 0)
        }
        return transform
    }
    
    /// Present an activity view controller to share the GridView
    private func shareGridView() {
        guard let imageToShare = convertToImage() else {
            presentAlert(title: "Error", message: "Can't convert grill to image")
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            self.repositionGridViewToDefaultPlace()
        }
        present(activityViewController, animated: true)
    }
    
    /// Present an alert
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    /// Generate an image of the GridView
    private func convertToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(gridView.bounds.size, true, 0)
        gridView.drawHierarchy(in: gridView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// Reposition the GridView to its initial place
    private func repositionGridViewToDefaultPlace() {
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.6,
            options: [],
            animations: { self.gridView.transform = .identity }
        )
    }
}
