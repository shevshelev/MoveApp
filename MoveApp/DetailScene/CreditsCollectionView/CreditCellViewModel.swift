//
//  CreditCellViewModel.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 24.05.2022.
//

import Foundation

protocol CreditCellViewModelProtocol {
    var profilePath: String? { get }
    var name: String? { get }
    var job: String? { get }
    init(staff: Staff)
}

class CreditCellViewModel: CreditCellViewModelProtocol {
    
    private let staff: Staff
    
    var profilePath: String? {
        staff.profilePath
    }
    
    var name: String? {
        staff.name
    }
    
    var job: String? {
        if let job = staff.job {
            return job
        } else {
            return staff.character
        }
    }
    
    required init(staff: Staff) {
        self.staff = staff
    }
    
    
}
