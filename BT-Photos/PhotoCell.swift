//
//  PhotoCell.swift
//  BT-Photos
//
//  Created by apple on 06/03/24.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var albumIdLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    func configure(with photo: Photo) {
        DispatchQueue.global().async { [weak self] in
            if let url = URL(string: photo.thumbnailUrl), let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                    self?.imageTitle.text = photo.title
                }
            }
        }
    }
}
