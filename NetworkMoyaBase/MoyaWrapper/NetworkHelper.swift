//
//  NetworkHelper.swift
//  SwiftAppBase
//
//  Created by anthony zhu on 2023/8/9.
//

import Foundation
import Moya
import Alamofire
import HandyJSON
import SwiftyJSON

public let kNZReachabilityChangedNotification = "kNZSWReachabilityChangedNotification"

public let NC = NetworkConfigure.default

public typealias NZNetDataCallBack = (_ data:BaseNetData) -> Void

public let expiryDateTime = "2024/02/07 00:00:00"

private func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
        return String(data: data, encoding: .utf8) ?? ""
    }
}


open class NetworkHelper {
    
    public static var netStatus:Alamofire.NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
    
    private static let dispatchQueue = DispatchQueue(label: "com.sab.networkhelper.completion-queue")
    
    private static let secHosts:[String] = ["https://xxx.xxx.com", "https://xxxx.xxx.com"]
    
    private static var certExpiry:Bool {
        get {
            Date() > expiryDateTime.toDate("yyyy/MM/dd HH:mm:ss")
        }
    }
    
    public static var verifyOff:Bool = false;
    
    private static let defaultSession:Session = {
        let config:URLSessionConfiguration = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 60;
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.httpShouldUsePipelining = true
        config.httpShouldSetCookies = false
        return Session(configuration: config, rootQueue:dispatchQueue)
    }()
    /// ServerTrustSession with timeout 60s and public key trust based on host
    private static let serverTrustSession:Session = {
        /// serverTrustSession with timeout 60s ,cachepolicy ignore local cachedata, request should use pipeline and not set cookies
        let config:URLSessionConfiguration = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 60;
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.httpShouldUsePipelining = true
        config.httpShouldSetCookies = false
        let secTrustEval:PublicKeysTrustEvaluator = PublicKeysTrustEvaluator(validateHost: true)
        let secTrustManager:ServerTrustManager = ServerTrustManager(allHostsMustBeEvaluated:false, evaluators: ["api.infzm.com":secTrustEval,"passport.infzm.com":secTrustEval])
        return Session(configuration: config,rootQueue: dispatchQueue, serverTrustManager: secTrustManager)
    }()
    /// downloadSession with timeout 120s
    private static let downloadSession:Session = {
        let config:URLSessionConfiguration = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 120;
        return Session(configuration: config, rootQueue: dispatchQueue)
    }()
    /// uploadSession with timeout 120s
    private static let uploadSession:Session = {
        let config:URLSessionConfiguration = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 120;
        return Session(configuration: config, rootQueue: dispatchQueue)
    }()
    
    public static let defaultTargetProvider = MoyaProvider<MoyaMethodTarget>(session:defaultSession,plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter),logOptions: .verbose))])

    public static let secTrustTargetProvider = MoyaProvider<MoyaMethodTarget>(session:serverTrustSession,plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter),logOptions: .verbose))])

    public static let downloadTargetProvider = MoyaProvider<MoyaMethodTarget>(session:downloadSession,plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter),logOptions: .verbose))])

    public static let uploadTargetProvider = MoyaProvider<MoyaMethodTarget>(session:uploadSession,plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter),logOptions: .verbose))])

    
    /// Reachablity manager for host www.apple.com
    public static let reachability:NetworkReachabilityManager? = NetworkReachabilityManager(host:"www.apple.com")
    
    /// get baseUrl
    @discardableResult public static func get(baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, completion:@escaping Completion) -> Cancellable {
        if self.needsCertVerification(baseUrl.rawValue) {
            return secTrustTargetProvider.request(MoyaMethodTarget.get(.urlComb(baseUrl,path),parameters,bodyData,NC.defaultHeaders),completion:completion)
        } else {
            return defaultTargetProvider.request(MoyaMethodTarget.get(.urlComb(baseUrl,path),parameters,bodyData,NC.defaultHeaders), completion: completion)
        }
    }

    @discardableResult public static func get<T: HandyJSON>(type:T.Type = T.self,baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return get(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }
    @discardableResult public static func get(baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return get(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }

    /// get UrlString
    public static func get(urlString:String,parameters:[String:Any]? = nil,bodyData:Any? = nil, completion:@escaping Completion) -> Cancellable {
        if self.needsCertVerification(urlString) {
            return secTrustTargetProvider.request(MoyaMethodTarget.get(.urlStr(urlString),parameters,bodyData,NC.defaultHeaders), completion: completion)
        } else {
            return defaultTargetProvider.request(MoyaMethodTarget.get(.urlStr(urlString),parameters,bodyData,NC.defaultHeaders), completion: completion)
        }
    }
    
    @discardableResult public static func get<T: HandyJSON>(type:T.Type = T.self,urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return get(urlString: urlString, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }

    @discardableResult public static func get(urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return get(urlString: urlString, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }

    /// post baseUrl
    public static func post(baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, completion:@escaping Completion) -> Cancellable {
        if self.needsCertVerification(baseUrl.rawValue) {
            return secTrustTargetProvider.request(MoyaMethodTarget.post(.urlComb(baseUrl,path),parameters,bodyData,NC.defaultHeaders), completion: completion)
        } else {
            return defaultTargetProvider.request(MoyaMethodTarget.post(.urlComb(baseUrl,path),parameters,bodyData,NC.defaultHeaders), completion: completion)
        }
    }

    @discardableResult public static func post(baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return post(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }

    @discardableResult public static func post<T: HandyJSON>(type:T.Type = T.self,baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return post(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }

    /// post urlString
    public static func post(urlString:String, parameters:[String:Any]? = nil,bodyData:Any? = nil, completion:@escaping Completion) -> Cancellable {
        if self.needsCertVerification(urlString) {
            return secTrustTargetProvider.request(MoyaMethodTarget.post(.urlStr(urlString),parameters,bodyData,NC.defaultHeaders), completion: completion)
        } else {
            return defaultTargetProvider.request(MoyaMethodTarget.post(.urlStr(urlString),parameters,bodyData,NC.defaultHeaders), completion: completion)
        }
    }

    @discardableResult public static func post(urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return post(urlString: urlString, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }

    @discardableResult public static func post<T: HandyJSON>(type:T.Type = T.self,urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return post(urlString: urlString, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }
    
    /// put baseurl
    public static func put(baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, completion:@escaping Completion) -> Cancellable {
        if self.needsCertVerification(baseUrl.rawValue) {
            return secTrustTargetProvider.request(MoyaMethodTarget.put(.urlComb(baseUrl,path),parameters,bodyData,NC.defaultHeaders), completion: completion)
        } else {
            return defaultTargetProvider.request(MoyaMethodTarget.put(.urlComb(baseUrl,path),parameters,bodyData,NC.defaultHeaders), completion: completion)
        }
    }
    
    @discardableResult public static func put(baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return put(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }

    @discardableResult public static func put<T: HandyJSON>(type:T.Type = T.self,baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return put(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }

    /// put urlstring
    public static func put(urlString:String, parameters:[String:Any]? = nil,bodyData:Any? = nil, completion:@escaping Completion) -> Cancellable {
        if self.needsCertVerification(urlString) {
            return secTrustTargetProvider.request(MoyaMethodTarget.put(.urlStr(urlString),parameters,bodyData,NC.defaultHeaders), completion: completion)
        } else {
            return defaultTargetProvider.request(MoyaMethodTarget.put(.urlStr(urlString),parameters,bodyData,NC.defaultHeaders), completion: completion)
        }
    }

    @discardableResult public static func put(urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return put(urlString: urlString, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }

    @discardableResult public static func put<T: HandyJSON>(type:T.Type = T.self,urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return put(urlString: urlString, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }
    
    /// delete baseUrl
    @discardableResult public static func delete(baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, completion:@escaping Completion) -> Cancellable {
        if self.needsCertVerification(baseUrl.rawValue) {
            return secTrustTargetProvider.request(MoyaMethodTarget.delete(.urlComb(baseUrl,path),parameters,bodyData,NC.defaultHeaders),completion:completion)
        } else {
            return defaultTargetProvider.request(MoyaMethodTarget.delete(.urlComb(baseUrl,path),parameters,bodyData,NC.defaultHeaders), completion: completion)
        }
    }

    @discardableResult public static func delete<T: HandyJSON>(type:T.Type = T.self,baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return delete(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }
    @discardableResult public static func delete(baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return delete(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }

    /// delete UrlString
    public static func delete(urlString:String,parameters:[String:Any]? = nil,bodyData:Any? = nil, completion:@escaping Completion) -> Cancellable {
        if self.needsCertVerification(urlString) {
            return secTrustTargetProvider.request(MoyaMethodTarget.delete(.urlStr(urlString),parameters,bodyData,NC.defaultHeaders), completion: completion)
        } else {
            return defaultTargetProvider.request(MoyaMethodTarget.delete(.urlStr(urlString),parameters,bodyData,NC.defaultHeaders), completion: completion)
        }
    }
    
    @discardableResult public static func delete<T: HandyJSON>(type:T.Type = T.self,urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return delete(urlString: urlString, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }

    @discardableResult public static func delete(urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return delete(urlString: urlString, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }

    /// head baseUrl
    @discardableResult public static func head(baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, completion:@escaping Completion) -> Cancellable {
        if self.needsCertVerification(baseUrl.rawValue) {
            return secTrustTargetProvider.request(MoyaMethodTarget.head(.urlComb(baseUrl,path),parameters,bodyData,NC.defaultHeaders),completion:completion)
        } else {
            return defaultTargetProvider.request(MoyaMethodTarget.head(.urlComb(baseUrl,path),parameters,bodyData,NC.defaultHeaders), completion: completion)
        }
    }

    @discardableResult public static func head<T: HandyJSON>(type:T.Type = T.self,baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return head(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }
    @discardableResult public static func head(baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return head(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }

    /// delete UrlString
    public static func head(urlString:String,parameters:[String:Any]? = nil,bodyData:Any? = nil, completion:@escaping Completion) -> Cancellable {
        if self.needsCertVerification(urlString) {
            return secTrustTargetProvider.request(MoyaMethodTarget.head(.urlStr(urlString),parameters,bodyData,NC.defaultHeaders), completion: completion)
        } else {
            return defaultTargetProvider.request(MoyaMethodTarget.head(.urlStr(urlString),parameters,bodyData,NC.defaultHeaders), completion: completion)
        }
    }
    
    @discardableResult public static func head<T: HandyJSON>(type:T.Type = T.self,urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return head(urlString: urlString, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }

    @discardableResult public static func head(urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return head(urlString: urlString, parameters:parameters, bodyData: bodyData) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }

    ///download baseurl
    @discardableResult public static func download(baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, destination:@escaping DownloadDestination,progress: ProgressBlock? = .none, completion:@escaping Completion) -> Cancellable {
        return downloadTargetProvider.request(MoyaMethodTarget.download(.urlComb(baseUrl,path), parameters, destination,NC.defaultHeaders),progress:progress,completion: completion)
    }

    @discardableResult public static func download<T: HandyJSON>(type:T.Type = T.self,baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, destination:@escaping DownloadDestination,progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return download(baseUrl: baseUrl, path: path, destination: destination) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }

    @discardableResult public static func download(baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, destination:@escaping DownloadDestination,progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return download(baseUrl: baseUrl, path: path, destination: destination) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }
    
    ///downloadurlString
    @discardableResult public static func download(urlString:String, parameters:[String:Any]? = nil, destination:@escaping DownloadDestination,progress: ProgressBlock? = .none, completion:@escaping Completion) -> Cancellable {
        return downloadTargetProvider.request(MoyaMethodTarget.download(.urlStr(urlString), parameters, destination,NC.defaultHeaders),progress:progress,completion: completion)
    }
    
    @discardableResult public static func download<T: HandyJSON>(type:T.Type = T.self,urlString:String, parameters:[String:Any]? = nil, destination:@escaping DownloadDestination,progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return download(urlString:urlString, destination: destination) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }

    @discardableResult public static func download(urlString:String, parameters:[String:Any]? = nil, destination:@escaping DownloadDestination,progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return download(urlString:urlString, destination: destination) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }

    ///uploadFile baseurl
    @discardableResult public static func uploadFileData(baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, data:Data,name:String,fileName:String?,mimeType:String?,progress: ProgressBlock? = .none, completion:@escaping Completion) -> Cancellable {
        return uploadTargetProvider.request(MoyaMethodTarget.uploadFileData(.urlComb(baseUrl, path), parameters, data, name, fileName, mimeType, NC.defaultHeaders), completion: completion)
    }

    @discardableResult public static func uploadFileData<T: HandyJSON>(type:T.Type = T.self,baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, data:Data,name:String,fileName:String?,mimeType:String?,progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return uploadFileData(baseUrl: baseUrl, path: path, data: data, name: name, fileName: fileName, mimeType: mimeType) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }

    @discardableResult public static func uploadFileData(baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, data:Data,name:String,fileName:String?,mimeType:String?,progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return uploadFileData(baseUrl: baseUrl, path: path, data: data, name: name, fileName: fileName, mimeType: mimeType) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }

    /// uploadfile urlstring
    @discardableResult public static func uploadFileData(urlString:String, parameters:[String:Any]? = nil, data:Data,name:String,fileName:String?,mimeType:String?,progress: ProgressBlock? = .none, completion:@escaping Completion) -> Cancellable {
        return uploadTargetProvider.request(MoyaMethodTarget.uploadFileData(.urlStr(urlString), parameters, data, name, fileName, mimeType, NC.defaultHeaders), completion: completion)
    }
    
    @discardableResult public static func uploadFileData<T: HandyJSON>(type:T.Type = T.self,urlString:String, parameters:[String:Any]? = nil, data:Data,name:String,fileName:String?,mimeType:String?,progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return uploadFileData(urlString:urlString, data: data, name: name, fileName: fileName, mimeType: mimeType) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }

    @discardableResult public static func uploadFileData(urlString:String, parameters:[String:Any]? = nil, data:Data,name:String,fileName:String?,mimeType:String?,progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return uploadFileData(urlString:urlString, data: data, name: name, fileName: fileName, mimeType: mimeType) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }

    ///uploadInputStream baseurl
    @discardableResult public static func uploadInputStream(baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, data:Data,length:UInt64,name:String,fileName:String?,mimeType:String?,progress: ProgressBlock? = .none, completion:@escaping Completion) -> Cancellable {
        return uploadTargetProvider.request(MoyaMethodTarget.uploadInputStreamData(.urlComb(baseUrl, path), parameters, data, length, name, fileName, mimeType, NC.defaultHeaders), completion: completion)
    }

    @discardableResult public static func uploadInputStream<T: HandyJSON>(type:T.Type = T.self,baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, data:Data,length:UInt64,name:String,fileName:String?,mimeType:String?,progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return uploadInputStream(baseUrl: baseUrl, path: path, data: data, length:length,name: name, fileName: fileName, mimeType: mimeType) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }

    @discardableResult public static func uploadInputStream(baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, data:Data,length:UInt64,name:String,fileName:String?,mimeType:String?,progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return uploadInputStream(baseUrl: baseUrl, path: path, data: data,length: length,name: name, fileName: fileName, mimeType: mimeType) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }

    /// uploadfile urlstring
    @discardableResult public static func uploadInputStream(urlString:String, parameters:[String:Any]? = nil, data:Data,length:UInt64,name:String,fileName:String?,mimeType:String?,progress: ProgressBlock? = .none, completion:@escaping Completion) -> Cancellable {
        return uploadTargetProvider.request(MoyaMethodTarget.uploadInputStreamData(.urlStr(urlString), parameters, data,length, name, fileName, mimeType, NC.defaultHeaders), completion: completion)
    }
    
    @discardableResult public static func uploadInputStream<T: HandyJSON>(type:T.Type = T.self,urlString:String, parameters:[String:Any]? = nil, data:Data,length:UInt64,name:String,fileName:String?,mimeType:String?,progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return uploadInputStream(urlString:urlString, data: data,length:length, name: name, fileName: fileName, mimeType: mimeType) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }

    @discardableResult public static func uploadInputStream(urlString:String, parameters:[String:Any]? = nil, data:Data,length:UInt64,name:String,fileName:String?,mimeType:String?,progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return uploadInputStream(urlString:urlString, data: data,length:length, name: name, fileName: fileName, mimeType: mimeType) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }

    ///uploadInputStream baseurl
    @discardableResult public static func uploadFileUrl(baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, fileUrl:URL,name:String,progress: ProgressBlock? = .none, completion:@escaping Completion) -> Cancellable {
        return uploadTargetProvider.request(MoyaMethodTarget.uploadFileUrl(.urlComb(baseUrl, path), parameters, fileUrl, name,NC.defaultHeaders), completion: completion)
    }

    @discardableResult public static func uploadFileUrl<T: HandyJSON>(type:T.Type = T.self,baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, fileUrl:URL,name:String,progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return uploadFileUrl(baseUrl: baseUrl, path: path, fileUrl: fileUrl, name: name) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }

    @discardableResult public static func uploadFileUrl(baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, fileUrl:URL,name:String,progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return uploadFileUrl(baseUrl: baseUrl, path: path, fileUrl: fileUrl,name: name) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }

    /// uploadfile urlstring
    @discardableResult public static func uploadFileUrl(urlString:String, parameters:[String:Any]? = nil, fileUrl:URL,name:String,progress: ProgressBlock? = .none, completion:@escaping Completion) -> Cancellable {
        return uploadTargetProvider.request(MoyaMethodTarget.uploadFileUrl(.urlStr(urlString), parameters, fileUrl, name, NC.defaultHeaders), completion: completion)
    }
    
    @discardableResult public static func uploadFileUrl<T: HandyJSON>(type:T.Type = T.self,urlString:String, parameters:[String:Any]? = nil, fileUrl:URL,name:String,progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return uploadFileUrl(urlString:urlString, fileUrl: fileUrl, name: name) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }

    @discardableResult public static func uploadFileUrl(urlString:String, parameters:[String:Any]? = nil, fileUrl:URL,name:String,progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return uploadFileUrl(urlString:urlString, fileUrl: fileUrl,name: name) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }

    /// upload baseurl
    @discardableResult public static func upload(baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, formDatas:[Moya.MultipartFormData],progress: ProgressBlock? = .none, completion:@escaping Completion) -> Cancellable {
        return uploadTargetProvider.request(MoyaMethodTarget.upload(.urlComb(baseUrl,path), parameters, formDatas, NC.defaultHeaders), completion: completion)
    }
    
    @discardableResult public static func upload<T: HandyJSON>(type:T.Type = T.self,baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, formDatas:[Moya.MultipartFormData],progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return upload(baseUrl: baseUrl, path: path, parameters: parameters, formDatas: formDatas, progress: progress) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }

    @discardableResult public static func upload(baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, formDatas:[Moya.MultipartFormData],progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return upload(baseUrl: baseUrl, path: path, parameters: parameters, formDatas: formDatas, progress: progress) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }

    /// upload urlstring
    @discardableResult public static func upload(urlString:String, parameters:[String:Any]? = nil, formDatas:[Moya.MultipartFormData],progress: ProgressBlock? = .none, completion:@escaping Completion) -> Cancellable {
        return uploadTargetProvider.request(MoyaMethodTarget.upload(.urlStr(urlString), parameters, formDatas, NC.defaultHeaders), completion: completion)
    }
    
    @discardableResult public static func upload<T: HandyJSON>(type:T.Type = T.self,urlString:String, parameters:[String:Any]? = nil, formDatas:[Moya.MultipartFormData],progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return upload(urlString:urlString, parameters: parameters, formDatas: formDatas, progress: progress) { result in
            callback(self.encodeBaseNetData(type:T.self,result))
        }
    }

    @discardableResult public static func upload(urlString:String, parameters:[String:Any]? = nil, formDatas:[Moya.MultipartFormData],progress: ProgressBlock? = .none, callback:@escaping NZNetDataCallBack) -> Cancellable? {
        guard netStatus != .notReachable else {
            callback(BaseNetData.badNetData())
            return nil
        }
        return upload(urlString:urlString, parameters: parameters, formDatas: formDatas, progress: progress) { result in
            callback(self.encodeBaseNetData(type:BaseNetRawData.self,result))
        }
    }


    private static func encodeBaseNetData<T: HandyJSON>(type:T.Type = T.self,_ result: Result<Moya.Response, MoyaError>) -> BaseNetData {
        do {
            let response = try result.get()
            let json = JSON(response.data)
            if let mappedObject = JSONDeserializer<BaseNetData>.deserializeFrom(json:json.description) {
                mappedObject.rawData = json.dictionaryValue
                mappedObject.encodeBizModel(type: T.self)
                return mappedObject
            } else {
                let object = BaseNetData()
                object.code = 200
                object.message = ""
                object.rawData = json.dictionaryValue
                return object
            }
        } catch {
            return BaseNetData.errorData()
        }
    }
    private static func needsCertVerification(_ baseUrl:String) -> Bool {
        guard !certExpiry && !verifyOff else {
            return false
        }
        var result:Bool = false
        self.secHosts.forEach { host in
            if baseUrl .hasPrefix(host) {
                result = true
            }
        }
        return result
    }
}

extension NetworkHelper {
    public static func startMonitoring(listener:@escaping (_ netStatus:Alamofire.NetworkReachabilityManager.NetworkReachabilityStatus) -> Void) {
        guard let status = self.reachability?.status else {
            return
        }
        netStatus = status
        NotificationCenter.default.post(name: Notification.Name(rawValue: kNZReachabilityChangedNotification), object: status)

        self.reachability?.startListening(onUpdatePerforming: { status in
            netStatus = status
            listener(netStatus)
            NotificationCenter.default.post(name: Notification.Name(rawValue: kNZReachabilityChangedNotification), object: status)
        })
    }
}



open class NetworkConfigure {
    public static let `default` = NetworkConfigure()

    struct HeaderKeys {
        static let contentType = "Content-Type"
        static let accept = "Accept"
        static let token = "PET-SESSION-TOKEN"
        static let sign = "X-XCLOUD-SIGN"
        static let userId = "User-Id"
        static let userAgent = "User-Agent"
        static let platform = "platform"
    }
    
    public var defaultHeaders:[String:String] = [HeaderKeys.accept:"application/json"]
    
    public var contentType:String? {
        get {
            defaultHeaders[HeaderKeys.contentType]
        }
        set {
            defaultHeaders[HeaderKeys.contentType] = newValue
        }
    }
    
    public var accept:String? {
        get {
            defaultHeaders[HeaderKeys.accept]
        }
        set {
            defaultHeaders[HeaderKeys.accept] = newValue
        }
    }
    
    public var token:String? {
        get {
            defaultHeaders[HeaderKeys.token]
        }
        set {
            defaultHeaders[HeaderKeys.token] = newValue
        }
    }
    
    public var sign:String? {
        get {
            defaultHeaders[HeaderKeys.sign]
        }
        set {
            defaultHeaders[HeaderKeys.sign] = newValue
        }
    }

    public var userId:String? {
        get {
            defaultHeaders[HeaderKeys.userId]
        }
        set {
            defaultHeaders[HeaderKeys.userId] = newValue
        }
    }

    public var userAgent:String? {
        get {
            defaultHeaders[HeaderKeys.userAgent]
        }
        set {
            defaultHeaders[HeaderKeys.userAgent] = newValue
        }
    }

    public var platform:String? {
        get {
            defaultHeaders[HeaderKeys.platform]
        }
        set {
            defaultHeaders[HeaderKeys.platform] = newValue
        }
    }
}

extension String {
    public func toDate(_ format:String) -> Date {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self) ?? Date()
    }
}
