//
//  ImageViewController.swift
//  Sprint13Experiences
//
//  Created by Lambda_School_Loaner_219 on 2/14/20.
//  Copyright © 2020 Lambda_School_Loaner_219. All rights reserved.
//

import UIKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins

enum FilterType {
    case sepia
    case blur
    case sharpen
   
}

protocol ImageViewControllerDelegate {
   func addImageButtonTapped() 
    
    
}

class ImageViewController:UIViewController {
    var experienceController: ExperienceController?
    var delegate: ImageViewControllerDelegate?
    private var context = CIContext(options:nil)
    var imageHeightConstraint: NSLayoutConstraint!
   
    //MARK: Variables
    private var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else { return }
            var scaledSize = imageView.bounds.size
            let scale = UIScreen.main.scale
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
       
    }
     var filterType:FilterType?
    
    private var scaledImage: UIImage? {
        didSet {
            updateImage()
            if ((imageView?.image) != nil) {
                chooseImageButton.isHidden = true
            }
        }
    }
    
    
    //MARK: LIFECYCLE
   override func viewDidLoad() {
           setImageViewHeight(with: 1.0)
          super.viewDidLoad()

          // Do any additional setup after loading the view.
      }
    
    
    
    
    //MARK: IBOUTLETS
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageTitleTextField: UITextField!
    
    
    @IBOutlet weak var valueSlider: UISlider!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    //outlet for upload image
    @IBOutlet weak var chooseImageButton: UIButton!
    
    //MARK: IBActions
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
                    return
                }
                
                self.presentImagePickerController()
            }
            
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. Your device's restrictions do not allow access.")
            
        }
        presentImagePickerController()
    }
    @IBAction func sepiaButtonTapped(_ sender: UIButton) {
        originalImage = imageView.image
        valueSlider.minimumValue = 0
        valueSlider.maximumValue = 1
        valueSlider.value = 0
        filterType = .sepia
    }
    
  
    
    
    @IBAction func blurButtonTapped(_ sender: UIButton) {
        originalImage = imageView.image
        valueSlider.minimumValue = 0
        valueSlider.maximumValue = 100
        valueSlider.value = 0
        filterType = .blur
        
    }
    
    
    @IBAction func sharpenButtonTapped(_ sender: UIButton) {
        originalImage = imageView.image
        let filter = CIFilter.sharpenLuminance()
        print(filter.attributes)
        valueSlider.minimumValue = 0
        valueSlider.maximumValue = 2
        valueSlider.value = 0.4
        filterType = .sharpen
        
    }
    
    

    
    @IBAction func valueSliderChanged(_ sender: UISlider) {
        updateImage()
    }
    

   
    
    
    // MARK: FUNCTIONS
    func filter(_ image: UIImage, for type: FilterType) -> UIImage? {
           switch type {
           case .sepia:
           guard let cgImage = image.cgImage else { return nil }
           let ciImage = CIImage(cgImage: cgImage)
           let filter = CIFilter.sepiaTone()
           filter.inputImage = ciImage
           filter.intensity = valueSlider.value
           guard let outputCIImage = filter.outputImage else { return nil }
           guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return nil }
               return UIImage(cgImage: outputCGImage)
               
       
           case .blur:
               guard let cgImage = image.cgImage else { return nil }
               let ciImage = CIImage(cgImage: cgImage)
               let filter = CIFilter.gaussianBlur()
               filter.inputImage = ciImage
               filter.radius = valueSlider.value
               guard let outputCIImage = filter.outputImage else { return nil }
               guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return nil }
                   return UIImage(cgImage: outputCGImage)
               
           case .sharpen:
               guard let cgImage = image.cgImage else { return nil }
                      let ciImage = CIImage(cgImage: cgImage)
                      let filter = CIFilter.sharpenLuminance()
                      filter.inputImage = ciImage
                      filter.sharpness = valueSlider.value
                      guard let outputCIImage = filter.outputImage else { return nil }
                      guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return nil }
                          return UIImage(cgImage: outputCGImage)
               
//           case .negative:
//               guard let cgImage = image.cgImage else { return nil }
//               let ciImage = CIImage(cgImage: cgImage)
//               let filter = CIFilter.colorInvert()
//               filter.inputImage = ciImage
//               guard let outputCIImage = filter.outputImage else { return nil }
//               guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return nil }
//                   return UIImage(cgImage: outputCGImage)
               
           }
       }
       
       private func updateImage() {
           if let scaledImage = scaledImage {
               switch filterType {
               case .sepia:
                   imageView.image = filter(scaledImage, for: .sepia)
//               case .blackAndWhite:
//                   imageView.image = filter(scaledImage, for: .blackAndWhite)
               case .blur:
                   imageView.image = filter(scaledImage, for: .blur)
                   
               case .sharpen:
                   imageView.image = filter(scaledImage, for: .sharpen)
               
//               case .negative:
//                   imageView.image = filter(scaledImage, for: .negative)
               default:
                   break
               }
           } else {
               imageView.image = nil
           }
       }
    
   
  

    
    
    func setImageViewHeight(with aspectRatio: CGFloat) {
        
        //imageHeightConstraint.constant = imageView.frame.size.width * aspectRatio
        
        view.layoutSubviews()
    }
       
    private func presentImagePickerController() {
          
          guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
              presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
              return
          }
        DispatchQueue.main.async{
          let imagePicker = UIImagePickerController()
          
          imagePicker.delegate = self
          
          imagePicker.sourceType = .photoLibrary
          
            self.present(imagePicker, animated: true, completion: nil)
      }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //chooseImageButton.setTitle("", for: [])
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        imageView.image = image
        
       // setImageViewHeight(with: image.ratio)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
