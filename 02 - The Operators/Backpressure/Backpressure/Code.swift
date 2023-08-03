//
//  Code.swift
//  Backpressure
//
//  Created by Vincent on 03/08/2023.
//

import Foundation
import Combine

var cancellables = Set<AnyCancellable>()

func run() {
    let subject = PassthroughSubject<Int, Never>()
    
    for i in 1...100 where Bool.random() == true {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
            print("new value sent: \(i)")
            subject.send(i)
        }
    }
    
//    subject
//        .throttle(
//            for: 10,
//            scheduler: DispatchQueue.main,
//            latest: true
//        )
//        .sink { value in
//            print("new value received: \(value)")
//        }
//        .store(in: &cancellables)
    
//    subject
//        .debounce(for: 2, scheduler: DispatchQueue.main)
//        .sink { value in
//            print("new value received: \(value)")
//        }
//        .store(in: &cancellables)
    
//    subject
//        .collect(5)
//        .collect(.byTime(DispatchQueue.main, 3))
//        .collect(.byTimeOrCount(DispatchQueue.main, 10, 5))
//        .sink { value in
//            print("new value received: \(value)")
//        }
//        .store(in: &cancellables)
    
    class CustomSubscriber: Subscriber {
        typealias Input = Int
        typealias Failure = Never
        
        var subscription: Subscription?
        
        func receive(subscription: Subscription) {
            print("custom subscriber subscribed")
            self.subscription = subscription
            subscription.request(.max(1))
        }
        
        func receive(_ input: Int) -> Subscribers.Demand {
            print("custom subscriber received: \(input)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.subscription?.request(.max(2))
            }
            
            return .none
        }
        
        func receive(completion: Subscribers.Completion<Never>) {
            
        }
    }
    
    subject
        .subscribe(CustomSubscriber())
}
