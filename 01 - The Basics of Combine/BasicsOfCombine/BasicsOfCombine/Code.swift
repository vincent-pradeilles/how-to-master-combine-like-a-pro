//
//  Code.swift
//  BasicsOfCombine
//
//  Created by Vincent on 27/07/2023.
//

import Combine
import Foundation

var cancellables = Set<AnyCancellable>()

func run() {
//     Just(42)
//        .delay(for: 1, scheduler: DispatchQueue.main)
//        .sink { value in
//            print(value)
//        }
//        .store(in: &cancellables)
    
    [1, 2, 3, 4, 5]
        .publisher
        .filter { value -> Bool in value.isMultiple(of: 2) == false }
        .map { $0 * $0 }
        .sink { value in
            print(value)
        }
        .store(in: &cancellables)
}
