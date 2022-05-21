//
//  ImageCellViewModel.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 21.05.2022.
//

import Foundation

protocol ImageCellViewModelProtocol {
    var imageEndpoin: String? { get }
    init(image: ImageProtocol)
}

class ImageCellViewModel: ImageCellViewModelProtocol {
    
    private let image: ImageProtocol
    
    var imageEndpoin: String? {
        image.filePath
    }
    
    required init(image: ImageProtocol) {
        self.image = image
    }
    
    
}
