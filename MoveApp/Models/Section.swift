//
//  Section.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 12.05.2022.
//

import UIKit

protocol BaseSectionProtocol {
    
}

struct Section: Decodable, Hashable, BaseSectionProtocol {    
    let type: String
    let title: String
    let items: [Movie]
}
