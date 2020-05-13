//
//  ImageViewCollectionCell.swift
//  Virtual Tourist
//
//  Created by Mohamed Abdelkhalek Salah on 5/8/20.
//  Copyright © 2020 Mohamed Abdelkhalek Salah. All rights reserved.
//

import UIKit

class ImageViewCollectionCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    
    func configureUI(image: UIImage?) {
        imageView.image = image
    }
}
