//
//  AppBaseExtension.swift
//  SwiftAppBase
//
//  Created by anthony zhu on 2023/8/7.
//

import Foundation
public struct AppBaseExtension<ExtendedType> {
    /// Stores the type or meta-type of any extended type.
    public private(set) var type: ExtendedType

    /// Create an instance from the provided value.
    ///
    /// - Parameter type: Instance being extended.
    public init(_ type: ExtendedType) {
        self.type = type
    }
}
/// Protocol describing the `af` extension points for Alamofire extended types.
public protocol AppBaseExtended {
    /// Type being extended.
    associatedtype ExtendedType

    /// Static Alamofire extension point.
    static var sab: AppBaseExtension<ExtendedType>.Type { get set }
    /// Instance Alamofire extension point.
    var sab: AppBaseExtension<ExtendedType> { get set }
}

extension AppBaseExtended {
    /// Static Alamofire extension point.
    public static var sab: AppBaseExtension<Self>.Type {
        get { AppBaseExtension<Self>.self }
        set {}
    }

    /// Instance Alamofire extension point.
    public var sab: AppBaseExtension<Self> {
        get { AppBaseExtension(self) }
        set {}
    }
}
