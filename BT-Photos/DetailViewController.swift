//
//  DetailViewController.swift
//  BT-Photos
//
//  Created by apple on 06/03/24.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumIdLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
    }
    
    private func setupUI() {
        guard let photo = photo else { return }
//        self.title = photo.title
        titleLabel.text = "Tilte: \(photo.title)"
        albumIdLabel.text = "Album ID: \(photo.albumId)"
        idLabel.text = "Photo ID: \(photo.id)"
        loadImage()
        self.imageView.layer.cornerRadius = 8
        
    }
    
    private func loadImage() {
        guard let photo = photo else { return }
        DispatchQueue.global().async {
            if let url = URL(string: photo.url), let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
    }
}

