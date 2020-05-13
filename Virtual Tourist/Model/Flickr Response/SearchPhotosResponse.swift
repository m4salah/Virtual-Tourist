//
//  SearchPhotosResponse.swift
//  Virtual Tourist
//
//  Created by Mohamed Abdelkhalek Salah on 5/8/20.
//  Copyright © 2020 Mohamed Abdelkhalek Salah. All rights reserved.
//

import Foundation

struct SearchPhotosResponse: Codable {
    let photos: PhotosDetails
    let stat: String
}

struct PhotosDetails: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [Photo]
}

struct Photo: Codable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
}
