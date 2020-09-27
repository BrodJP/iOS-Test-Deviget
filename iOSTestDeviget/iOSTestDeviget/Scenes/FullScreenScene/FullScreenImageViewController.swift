//
//  FullScreenImageViewController.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/27/20.
//

import UIKit
import Photos

class FullScreenImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!
    
    let imageDownloader: ImageDownloader = ImageDownloader()
    
    lazy var viewModel: FullScreenImageViewModel = {
        FullScreenImageViewModel(imageURL: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadImage()
    }
    
    private func setupView() {
        saveButton.setTitle(viewModel.saveButtonTitle, for: .normal)
    }
    
    private func loadImage() {
        saveButton.isEnabled = false
        guard let imageURL = viewModel.imageURL else {
            activityIndicator.stopAnimating()
            return
        }
        print(imageURL)
        activityIndicator.startAnimating()
        imageDownloader.loadImageWithUrl(imageURL,
                                         onComplete: { [weak self] result in
                                            DispatchQueue.main.async {
                                                self?.handleImageDownloadResult(result)
                                            }
                                         })
    }
    
    private func handleImageDownloadResult(_ result: Result<UIImage, Error>) {
        switch result {
        case .success(let image):
            imageView.image = image
            saveButton.isEnabled = true
        case .failure:
            imageView.image = nil
            saveButton.isEnabled = false
        }
        activityIndicator.stopAnimating()
    }
    
    private func presentAlertWithMessage(_ message: String) {
        let alert = UIAlertController(title: message,
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onSaveButtonPressed(_ sender: Any) {
        guard let snapshot = imageView.image else {
            return
        }

        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: snapshot)
        }, completionHandler: { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.presentAlertWithMessage("Image saved!")
                } else {
                    self?.presentAlertWithMessage("Failed to save image")
                }
            }
        })
    }
}
