//
//  RedditPostCollectionViewCell.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import UIKit

class RedditPostCollectionViewCell: UICollectionViewCell {

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

    }
    
    private func reloadCellData() {

    }
    
    @IBAction private func onDismissButtonPressed(_ sender: Any) {
        
    }
}

