//
//  PhotoModel.swift
//  BT-Photos
//
//  Created by apple on 06/03/24.
//

import Foundation

struct Photo: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

