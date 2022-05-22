//
//  ImageCellViewModel.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 21.05.2022.
//

import Foundation

protocol ImageCellViewModelProtocol {
    var imageEndpoin: String? { get }
    init(image: ImageProtocol?)
}

class ImageCellViewModel: ImageCellViewModelProtocol {
    
//    private let image: ImageProtocol?
    
    var imageEndpoin: String?
    
    required init(image: ImageProtocol?) {
//        self.image = image
        imageEndpoin = image?.filePath
    }
    convenience init(endPoint: String?) {
        self.init(image: nil)
        self.imageEndpoin = endPoint
    }
    
    
}
