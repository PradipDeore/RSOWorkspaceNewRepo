//
//  GalleryEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 31/07/24.
//

import Foundation
//https://finance.ardemos.co.in/rso/api/location-gallery?locationID=2

enum GalleryEndPoint {
    case locationGallery(locationID:Int)
}
extension GalleryEndPoint: EndPointType {
    var path: String {
        switch self {
        case .locationGallery(let locationID):
            return "location-gallery?locationID=\(locationID)"
        }
    }
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    var method: HTTPMethods {
        switch self {
        case .locationGallery:
            return .get
        }
    }
    var body: Encodable? {
        switch self {
        case .locationGallery:
            return nil
        }
    }
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
