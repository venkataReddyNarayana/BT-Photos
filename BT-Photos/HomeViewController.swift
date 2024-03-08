//
//  HomeViewController.swift
//  BT-Photos
//
//  Created by apple on 06/03/24.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var albumIDLabel: UILabel!
    var albumID = 1
    var photos: [Photo] = []
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchPhotosForAlbum(albumId: albumID)
        setupErrorLabel()
        setupUIButtonCornerRadius()
    }
    
    private func setupCollectionView() {
        self.title = "BT-Photos"
     
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            
            // Calculate item width based on collection view width and spacing
            let collectionViewWidth = collectionView.bounds.width
            let itemWidth = (collectionViewWidth - 50) / 2 // Adjusted for left and right spacing
            
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            
            // Set collection view content inset for top, left, bottom, and right spacing
            collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
            // Set layout for collection view
            collectionView.collectionViewLayout = layout
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

    }
    
    @objc func refreshData() {
            refreshControl.endRefreshing()
        }

    @IBAction func previousBtnTapped(_ sender: UIButton){
        if albumIDLabel.text == "Album ID: \(1)"{
            
        }else{
            albumID = max(albumID - 1, 1)
            fetchPhotosForAlbum(albumId: albumID)
            updateAlbumIDLabel()
            self.collectionView.reloadData()
        }
       
    }
    
    @IBAction func nextBtnTapped(_ sender: UIButton){
        albumID = min(albumID + 1, 100)
        fetchPhotosForAlbum(albumId: albumID)
        updateAlbumIDLabel()
        self.collectionView.reloadData()
    }
    
    func updateAlbumIDLabel() {
            albumIDLabel.text = "Album ID: \(albumID)"
        }
    
    private func setupUIButtonCornerRadius(){
        self.nextBtn.layer.cornerRadius = 8
        self.previousBtn.layer.cornerRadius = 8
        self.albumIDLabel.layer.cornerRadius = 8
        albumIDLabel?.layer.masksToBounds = true
       
    }
    
    private func setupErrorLabel() {
        errorLabel.isHidden = true
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.font = UIFont.systemFont(ofSize: 16)
    }
    
    private func fetchPhotosForAlbum(albumId: Int) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/albums/\(albumId)/photos") else {
            showError(message: "Invalid URL")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.showError(message: "Failed to fetch data. Please try again later.")
              
                DispatchQueue.main.sync {
                    self.nextBtn.isUserInteractionEnabled = false
                    self.previousBtn.isUserInteractionEnabled = false
                }
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                self.showError(message: "Server error. Please try again later.")
                print("Error: Invalid HTTP response")
                return
            }
            
            guard let data = data else {
                self.showError(message: "No data received")
                print("Error: No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let photos = try decoder.decode([Photo].self, from: data)
                self.photos = photos
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.updateAlbumIDLabel()
                    self.errorLabel.isHidden = true
                }
            } catch {
                self.showError(message: "Failed to parse data. Please try again later.")
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    private func showError(message: String) {
        DispatchQueue.main.async {
            self.errorLabel.text = message
            self.errorLabel.isHidden = false
        }
    }
}

extension HomeViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = photos[indexPath.item]
        cell.configure(with: photo)
        cell.layer.borderColor = UIColor.blue.cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 8
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.photo = photo
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
