//
//  cloudyCell.swift
//  PandaWeather
//
//  Created by Robin Allemand on 2/4/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit

protocol cloudyCellDelegate: class {
    func delete(cell: cloudyCell)
}

class cloudyCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteButtonBackgroundView: UIVisualEffectView!
    @IBOutlet weak var myImageView: UIImageView!
    
    weak var delegate: cloudyCellDelegate?
    
    func setThumbnailImage(_ thumbnailImage: UIImage){
        self.myImageView.image = thumbnailImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        deleteButtonBackgroundView.layer.cornerRadius = deleteButtonBackgroundView.bounds.width / 2.0
        deleteButtonBackgroundView.layer.masksToBounds = true
        deleteButtonBackgroundView.isHidden = !isEditing
    }
    
    var isEditing: Bool = false {
        didSet {
            deleteButtonBackgroundView.isHidden = !isEditing
        }
    }
    
    @IBAction func deleteButtonDidTap(_ sender: Any) {
        delegate?.delete(cell: self)
    }
}


