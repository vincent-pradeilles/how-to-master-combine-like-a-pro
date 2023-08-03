//
//  Code.swift
//  TestingPublishers
//
//  Created by Vincent on 03/08/2023.
//

import Combine
import Foundation

func evenNumbersPublisher() -> some Publisher<Int, Never> {
    [2, 4, 6, 8, 10].publisher
}

func oddNumbersPublisher() -> some Publisher<Int, Never> {
    [1, 3, 5, 7, 9].publisher
}

func run() {
    Task {
        for await number in evenNumbersPublisher().values {
            print("\(number)")
        }
    }
}
