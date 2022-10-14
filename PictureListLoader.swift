//
//  JSONLoader.swift
//  ewewewewee
//
//  Created by RUNNWN170414 on 14/10/2022.
//

import Foundation

//JSON data structures
struct Picture: Decodable {
    var title: String
    var url: String
}

struct ResponseData: Decodable {
    var pictures: [Picture]
}

enum PictureLoadError
{
    case someError
}

protocol PictureListLoaderDelegate: AnyObject
{
    //called when all images are ready
    func didFinishLoading(imageViewData: Array<PictureViewData>?)
    func didFailedLoading(error: PictureLoadError)
}

protocol PictureListLoaderProtocol: AnyObject
{
    func loadPicturesFromJson(jsonFileName: String)
    func setDelegate(delegate: PictureListLoaderDelegate)
}

//loads picture list fron JSON file
class PictureListLoader
{
    weak var delegate: PictureListLoaderDelegate? = nil
    let group = DispatchGroup()
    
    func loadPicturesList(pictures: Array<Picture>)
    {
        var imageViews: Array<PictureViewData> = []
       //var result = PictureLoadResult.error
        let loader = PictureLoader()
        
        for picture in pictures {
            let pictureData = Picture(title: picture.title, url: picture.url)
            group.enter()
            loader.loadPictureViewData(pictureData: pictureData){ [weak self] pictureViewData, loadResult in
                if (loadResult == true)
                {
                    imageViews.append(pictureViewData!)
                   // result = PictureLoadResult.success
                }
                else
                {
                    self?.delegate?.didFailedLoading(error: PictureLoadError.someError)
                }
                self?.group.leave()
            }
        }
        group.notify(queue: .main){ [weak self] in
            self?.delegate?.didFinishLoading(imageViewData: imageViews)
        }
    }
}

extension PictureListLoader: PictureListLoaderProtocol
{
    func loadPicturesFromJson(jsonFileName fileName: String) {
        guard let url = URL(string: fileName) else {
            delegate?.didFailedLoading(error: PictureLoadError.someError)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            guard error == nil else {
                self?.delegate?.didFailedLoading(error: PictureLoadError.someError)
                return
            }
            
            guard let data = data else {
                self?.delegate?.didFailedLoading(error: PictureLoadError.someError)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                self?.loadPicturesList(pictures: jsonData.pictures)
            } catch {
                self?.delegate?.didFailedLoading(error: PictureLoadError.someError)
            }
        }
        task.resume()
    }
    
    func setDelegate(delegate: PictureListLoaderDelegate) {
        self.delegate = delegate
    }
}
