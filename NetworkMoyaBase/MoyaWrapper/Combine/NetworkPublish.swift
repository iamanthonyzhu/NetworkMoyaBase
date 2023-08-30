//
//  NetworkPublish.swift
//  SwiftAppBase
//
//  Created by anthony zhu on 2023/8/29.
//

import Foundation
import Moya
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
internal class NetworkPublish<Output>: Publisher {

    internal typealias Failure = Never

    private class Subscription: Combine.Subscription {
        private let performCall: () -> Moya.Cancellable?
        private var cancellable: Moya.Cancellable?

        init(subscriber: AnySubscriber<Output, Never>, callback: @escaping (AnySubscriber<Output, Never>) -> Moya.Cancellable?) {
            performCall = { callback(subscriber) }
        }

        func request(_ demand: Subscribers.Demand) {
            guard demand > .none else { return }

            cancellable = performCall()
        }

        func cancel() {
            cancellable?.cancel()
        }
    }

    private let callback: (AnySubscriber<Output, Never>) -> Moya.Cancellable?

    init(callback: @escaping (AnySubscriber<Output, Never>) -> Moya.Cancellable?) {
        self.callback = callback
    }

    internal func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = Subscription(subscriber: AnySubscriber(subscriber), callback: callback)
        subscriber.receive(subscription: subscription)
    }
}
