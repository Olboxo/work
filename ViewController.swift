//
//  ViewController.swift
//  ewewewewee
//
//  Created by Olga
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    let pictureListLoader: PictureListLoaderProtocol = PictureListLoader()
    var pictureTableData: Array<PictureViewData>? = nil
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureTableData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        
        guard let pictureTableData = pictureTableData else {return cell}
        
        cell.backgroundColor = UIColor.lightGray
        let textHeight = CGFloat(20)

        let imageView = UIImageView(image: pictureTableData[indexPath.row].image)
        let imageSize = min(cell.bounds.size.width, cell.bounds.size.height) - textHeight
        imageView.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        
        //add image title
        let textField = UITextField()
        textField.backgroundColor = UIColor.blue
        textField.text = pictureTableData[indexPath.row].title
        textField.frame = CGRect(x: 0, y: cell.bounds.size.height - textHeight, width: cell.bounds.size.width, height: textHeight)
        textField.textAlignment = NSTextAlignment.center
            
        cell.addSubview(textField)
        cell.addSubview(imageView)
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pictureListLoader.setDelegate(delegate: self)
        pictureListLoader.loadPicturesFromJson(jsonFileName: "https://github.com/Olboxo/work/blob/dd5ffbeb175bb499024d8d8cc41686bea847e2b1/pictures.json?raw=true")
        
        //setup table layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let numOfColumns = 2
        layout.minimumInteritemSpacing = 0
        
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        let cellWidth = (availableWidth / CGFloat(numOfColumns)).rounded(.down)
        let cellHeight = cellWidth
            
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.sectionInset = UIEdgeInsets(top: layout.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
}

extension ViewController: PictureListLoaderDelegate
{
    //Called when all images are loaded
    func didFinishLoading(imageViewData: Array<PictureViewData>?) {
        //update table data
        pictureTableData = imageViewData
        collectionView.reloadData()
    }
    
    //Called in case of some error
    func didFailedLoading(error: PictureLoadError) {
        print("Picture loading failed with error: ", error)
    }
}

