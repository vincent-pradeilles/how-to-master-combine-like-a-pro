//
//  Code.swift
//  Operators
//
//  Created by Vincent on 03/08/2023.
//

import Foundation
import Combine

var cancellables = Set<AnyCancellable>()

func run() {
    
    let evenIntegersPublisher = [2, 4, 8, 10].publisher
    
    let oddIntegersPublisher = [1, 3, 5, 7, 9].publisher
    
    Publishers.CombineLatest(
        evenIntegersPublisher,
        oddIntegersPublisher
    )
    .sink { even, odd in
        print("latest even: \(even), latest odd: \(odd)")
    }
    .store(in: &cancellables)
    
    Publishers.Zip(
        evenIntegersPublisher,
        oddIntegersPublisher
    )
    .sink { even, odd in
        print("zip even: \(even), odd: \(odd)")
    }
    .store(in: &cancellables)
    
    Publishers.Merge(
        evenIntegersPublisher,
        oddIntegersPublisher
    )
    .sink { integer in
        print("merge: \(integer)")
    }
    .store(in: &cancellables)
    
    
    let randomNumbersPublisher = Timer.publish(every: 1, on: .main, in: .default)
        .autoconnect()
        .map { _ in Int.random(in: 0..<100) }
        .share()
    
//    randomNumbersPublisher
//        .sink { randomValue in
//            print("random value A: \(randomValue)")
//        }
//        .store(in: &cancellables)
//
//    randomNumbersPublisher
//        .sink { randomValue in
//            print("random value B: \(randomValue)")
//        }
//        .store(in: &cancellables)
    
    func legacyAsyncStuff(_ completionHandler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completionHandler(Int.random(in: 1..<100))
        }
    }
    
    let legacyAsyncStuffPublisher = Future<_, Never> { promise in
        legacyAsyncStuff { number in
            promise(.success(number))
        }
    }
    
    let legacyAsyncStuffDeferredPublisher = Deferred {
        Future<_, Never> { promise in
            legacyAsyncStuff { number in
                promise(.success(number))
            }
        }
    }
    
    legacyAsyncStuffDeferredPublisher
        .sink { number in
            print("legacyAsyncStuff result A: \(number)")
        }
        .store(in: &cancellables)
    
    legacyAsyncStuffDeferredPublisher
        .sink { number in
            print("legacyAsyncStuff result B: \(number)")
        }
        .store(in: &cancellables)
    
    func repeatedLegacyAsyncStuff(_ handler: @escaping (Int) -> Void) {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + (3 * Double(i))) {
                handler(Int.random(in: 1..<100))
            }
        }
    }
    
    class Wrapper {
        private let subject = PassthroughSubject<Int, Never>()
        
        var publisher: some Publisher<Int, Never> {
            subject.eraseToAnyPublisher()
        }
        
        init() {
            repeatedLegacyAsyncStuff { [subject] number in
                subject.send(number)
            }
        }
    }
    
    Wrapper()
        .publisher
        .sink { value in
            print("wrapper: \(value)")
        }
        .store(in: &cancellables)
}
