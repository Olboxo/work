//
//  PictureLoader.swift
//  ewewewewee
//
//  Created by Olga
//

import Foundation
import UIKit

//Picture view data
struct PictureViewData
{
    var title: String? = nil
    var image: UIImage? = nil
}

/*enum PictureLoadResult
{
    case success
    case error
}*/

//loads picture from given URL
class PictureLoader
{
    func loadPictureViewData(pictureData: Picture, completion: @escaping (PictureViewData?, Bool) -> Void)
    {
        guard let imgURL = URL(string: pictureData.url) else {
            completion(nil, false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: imgURL) { (data, response, error) in
            guard error == nil else {
                completion(nil, false)
                return
            }
            guard let data = data else {
                completion(nil, false)
                return
            }
            let pictureViewData = PictureViewData(title: pictureData.title, image: UIImage(data: data))
            return completion(pictureViewData, true)
        }
        task.resume()
    }
}

