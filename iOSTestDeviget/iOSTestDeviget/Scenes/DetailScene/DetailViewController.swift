//
//  DetailViewController.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/26/20.
//

import UIKit

class DetailViewController: UIViewController {
    
    enum SegueID {
        static let fullScreenImageIdentifier = "ShowFullScreenImage"
    }

    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var redditPostLabel: UILabel!
    @IBOutlet weak var isVideoLabel: UILabel!
    
    let imageDownloader: ImageDownloader = ImageDownloader()
    
    lazy var viewModel: DetailViewModel = {
        DefaultDetailViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? FullScreenImageViewController {
            controller.viewModel = FullScreenImageViewModel(imageURL: viewModel.contentURL)
        }
    }
    
    private func setupView() {
        switch viewModel.mediaType {
        case .image:
            setupTapGestureOnImageView()
            isVideoLabel.isHidden = true
        case .video:
            isVideoLabel.text = viewModel.isVideoString
            isVideoLabel.isHidden = false
        case .unknown:
            isVideoLabel.isHidden = true
        }
        
        authorLabel.text = viewModel.redditPostAuthor
        redditPostLabel.text = viewModel.redditPostText
        if let thumbnailURL = viewModel.redditPostThumbnailURL {
            imageDownloader.loadImageWithUrl(thumbnailURL,
                                             onComplete: { [weak self] result in
                                                DispatchQueue.main.async {
                                                    self?.handleImageDownloadResult(result)
                                                }
                                             })
        }
    }
    
    private func setupTapGestureOnImageView() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(showFullScreenImage))
        thumbnailImageView.isUserInteractionEnabled = true
        thumbnailImageView.addGestureRecognizer(tapGesture)
    }

    private func handleImageDownloadResult(_ result: Result<UIImage, Error>) {
        switch result {
        case .success(let image):
            thumbnailImageView.image = image
        case .failure:
            thumbnailImageView.image = nil
        }
    }
    
    @objc
    func showFullScreenImage() {
        performSegue(withIdentifier: SegueID.fullScreenImageIdentifier,
                     sender: nil)
    }
}
