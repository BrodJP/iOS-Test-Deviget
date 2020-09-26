//
//  RedditPostCollectionViewCell.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import UIKit

class RedditPostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var customContentView: UIView!
    @IBOutlet private weak var unreadMarkContainerView: UIView!
    @IBOutlet private weak var unreadMarkView: UIView!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var elapsedTimeLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var postLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet private weak var totalCommentsLabel: UILabel!
    @IBOutlet weak var chevronImageView: UIImageView!
    
    let imageDownloader: ImageDownloader = ImageDownloader()
    
    var viewModel: RedditPostCollectionViewModel? {
        didSet {
            reloadCellData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
        reloadCellData()
    }
    
    private func applyStyle() {
        unreadMarkView.backgroundColor = .blue
        unreadMarkView.layer.cornerRadius = unreadMarkView.frame.size.height / 2.0
        authorLabel.textColor = .white
        authorLabel.textColor = .white
        postLabel.textColor = .white
        elapsedTimeLabel.textColor = .white
        dismissButton.setTitleColor(.white, for: .normal)
        chevronImageView.tintColor = .white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageDownloader.cancelCurrentTaskIfAny()
    }
    
    private func reloadCellData() {
        unreadMarkView.isHidden = viewModel?.isRead == true
        authorLabel.text = viewModel?.author
        elapsedTimeLabel.text = viewModel?.entryDateString
        postLabel.text = viewModel?.title
        totalCommentsLabel.text = viewModel?.numberOfCommentsString
        thumbnailImageView.image = nil
        customContentView.backgroundColor = viewModel?.isSelected == true ? UIColor.white.withAlphaComponent(0.7) : .clear
        if let thumbnail = viewModel?.thumbnailURL {
            imageDownloader.loadImageWithUrl(thumbnail, onComplete: { [weak thumbnailImageView] result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        thumbnailImageView?.image = image
                    }
                case .failure(let error):
                    debugPrint("Handle image donwload error: \(error.localizedDescription)")
                }
            })
        }
    }
    
    @IBAction private func onDismissButtonPressed(_ sender: Any) {
        viewModel?.onDismissButtonPressed()
    }
}

