//
//  WithViewModel.swift
//  Module
//
//  Created by Mateusz Małek on 12.01.2018.
//  Copyright © 2018 Mateusz Małek. All rights reserved.
//

import Foundation

public protocol ViewWithViewModel {
    associatedtype ViewModel
    
    var viewModel: ViewModel {get set}
}
