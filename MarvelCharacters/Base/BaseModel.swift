//
//  BaseModel.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import Foundation
import RxSwift

class BaseModel {
    
    var dataManager: DataManager?
    var disposeBag = DisposeBag()
    
    init(dataManager: DataManager?) {
        self.dataManager = dataManager
    }
}
