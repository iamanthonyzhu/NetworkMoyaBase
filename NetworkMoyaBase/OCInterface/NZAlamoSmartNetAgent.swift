//
//  NZAlamoSmartNetAgent.swift
//  nfzm
//
//  Created by anthony zhu on 2023/4/28.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON

@objc public enum AlamoSmartNetStatus: NSInteger {
    case Unknown, NotReachable, ConnectViaEthOrWifi, ConnectViaCellular
}


//public typealias NZSmartAgentURLConstructor = (NSString, NSMutableDictionary) -> NSString
public typealias NZSmartAgentDestinationBlock = (NSURL?,URLResponse?) -> NSURL
public typealias NZSmartAgentProgressBlock = (Progress) -> ()
public typealias NZSmartAgentSuccessCallback = (URLSessionTask?, AnyObject?) -> ()
public typealias NZSmartAgentFailureCallback = (URLSessionTask?, Error?, AnyObject?) -> ()
//public typealias NZSmartMultipartsConstructor = (AWMultipartsFormData) -> ()
public typealias NZSmartNetMonitor = (AlamoSmartNetStatus)->()

@objc class NZAlamoSmartNetAgent : NSObject {
    @objc static let shared = NZAlamoSmartNetAgent()
    override private init(){}
    
    static let defaultDestinationURL: (URL) -> URL = { url in
        let filename = "SmartNetAgent_\(url.lastPathComponent)"
        let destination = url.deletingLastPathComponent().appendingPathComponent(filename)

        return destination
    }
    
    @objc public func startReachabilityMonitoring(listener:@escaping NZSmartNetMonitor) {
        NetworkHelper.startMonitoring { status in
            switch status {
            case .unknown:
                listener(AlamoSmartNetStatus.Unknown)
            case .notReachable:
                listener(AlamoSmartNetStatus.NotReachable)
            case .reachable(let conType):
                switch conType {
                case .ethernetOrWiFi:
                    listener(AlamoSmartNetStatus.ConnectViaEthOrWifi)
                case .cellular:
                    listener(AlamoSmartNetStatus.ConnectViaCellular)
                }
            }
        }
    }
}

@objc extension NZAlamoSmartNetAgent {
    ///使用缺省配置的GET方法
    @objc public func get(_ apiName:NSString, parameters:AnyObject?,success:@escaping NZSmartAgentSuccessCallback, failure:@escaping NZSmartAgentFailureCallback, timeout:NSNumber?) -> MoyaNetStub? {
           
        let stub = MoyaNetStub(NetworkHelper.get(urlString:(apiName as String), parameters: (parameters as? [String:Any]), bodyData: nil, completion:{ result in
            switch result {
            case let .success(response):
                NZAlamoSmartNetAgent.onMainAsync {
                    success(nil, NZAlamoSmartNetAgent.encodeJsonToOC(response))
                }
            case let .failure(error):
                NZAlamoSmartNetAgent.onMainAsync {
                    failure(nil, error as NSError, error.response)
                }
            }
        }))
        
        if let delay = timeout {
            DispatchQueue.main.asyncAfter(deadline:.now() + delay.doubleValue) {
                stub.cancel()
            }
        }
        
        return stub
    }

    @objc public func post(_ apiName:NSString, parameters:AnyObject?, bodyData:AnyObject?, success:@escaping NZSmartAgentSuccessCallback, failure:@escaping NZSmartAgentFailureCallback, timeout:NSNumber?) -> MoyaNetStub?{
        let stub = MoyaNetStub(NetworkHelper.post(urlString:(apiName as String), parameters: (parameters as? [String:Any]), bodyData: bodyData, completion:{ result in
            switch result {
            case let .success(response):
                NZAlamoSmartNetAgent.onMainAsync {
                    success(nil, NZAlamoSmartNetAgent.encodeJsonToOC(response))
                }
            case let .failure(error):
                NZAlamoSmartNetAgent.onMainAsync {
                    failure(nil, error as NSError, error.response)
                }
            }
        }))
        
        if let delay = timeout {
            DispatchQueue.main.asyncAfter(deadline:.now() + delay.doubleValue) {
                stub.cancel()
            }
        }
        return stub
    }

    @objc public func put(_ apiName:NSString, parameters:AnyObject?, bodyData:AnyObject?, success:@escaping NZSmartAgentSuccessCallback, failure:@escaping NZSmartAgentFailureCallback, timeout:NSNumber?) -> MoyaNetStub?{
        let stub = MoyaNetStub(NetworkHelper.put(urlString:(apiName as String), parameters: (parameters as? [String:Any]), bodyData: bodyData, completion:{ result in
            switch result {
            case let .success(response):
                NZAlamoSmartNetAgent.onMainAsync {
                    success(nil, NZAlamoSmartNetAgent.encodeJsonToOC(response))
                }
            case let .failure(error):
                NZAlamoSmartNetAgent.onMainAsync {
                    failure(nil, error as NSError, error.response)
                }
            }
        }))
        
        if let delay = timeout {
            DispatchQueue.main.asyncAfter(deadline:.now() + delay.doubleValue) {
                stub.cancel()
            }
        }
        return stub
    }

    @objc public func delete(_ apiName:NSString, parameters:AnyObject?, bodyData:AnyObject?,success:@escaping NZSmartAgentSuccessCallback, failure:@escaping NZSmartAgentFailureCallback,timeout:NSNumber?) -> MoyaNetStub?{
        let stub = MoyaNetStub(NetworkHelper.delete(urlString:(apiName as String), parameters: (parameters as? [String:Any]), bodyData: bodyData, completion:{ result in
            switch result {
            case let .success(response):
                NZAlamoSmartNetAgent.onMainAsync {
                    success(nil, NZAlamoSmartNetAgent.encodeJsonToOC(response))
                }
            case let .failure(error):
                NZAlamoSmartNetAgent.onMainAsync {
                    failure(nil, error as NSError, error.response)
                }
            }
        }))
        
        if let delay = timeout {
            DispatchQueue.main.asyncAfter(deadline:.now() + delay.doubleValue) {
                stub.cancel()
            }
        }
        return stub
    }

    @objc public func head(_ apiName:NSString, parameters:AnyObject?, bodyData:AnyObject?,success:@escaping NZSmartAgentSuccessCallback, failure:@escaping NZSmartAgentFailureCallback,timeout:NSNumber?) -> MoyaNetStub?{
        let stub = MoyaNetStub(NetworkHelper.head(urlString:(apiName as String), parameters: (parameters as? [String:Any]), bodyData: bodyData, completion:{ result in
            switch result {
            case let .success(response):
                NZAlamoSmartNetAgent.onMainAsync {
                    success(nil, NZAlamoSmartNetAgent.encodeJsonToOC(response))
                }
            case let .failure(error):
                NZAlamoSmartNetAgent.onMainAsync {
                    failure(nil, error as NSError, error.response)
                }
            }
        }))
        
        if let delay = timeout {
            DispatchQueue.main.asyncAfter(deadline:.now() + delay.doubleValue) {
                stub.cancel()
            }
        }
        return stub
    }

    @objc public func download(_ url:NSString, parameters:AnyObject?,destination: NZSmartAgentDestinationBlock?,progress: NZSmartAgentProgressBlock?,success:@escaping NZSmartAgentSuccessCallback, failure:@escaping NZSmartAgentFailureCallback,timeout:NSNumber?) -> MoyaNetStub? {
        MoyaNetStub(NetworkHelper.download(urlString:(url as String),parameters:(parameters as? [String:Any]),destination: { tempURL, response in
            if let dest = destination {
                let tempNSUrl = NSURL(string: tempURL.absoluteString)
                let customURL = dest(tempNSUrl,response)
                return (URL(string: customURL.absoluteString ?? "") ?? NZAlamoSmartNetAgent.defaultDestinationURL(tempURL),[])
            }
            return (NZAlamoSmartNetAgent.defaultDestinationURL(tempURL),[])
        }, progress: { progressResp in
            if let progressBlock = progress, let progObject = progressResp.progressObject {
                progressBlock(progObject)
            }
        }, completion:{ result in
            switch result {
            case let .success(response):
                NZAlamoSmartNetAgent.onMainAsync {
                    success(nil, NZAlamoSmartNetAgent.encodeJsonToOC(response))
                }
            case let .failure(error):
                NZAlamoSmartNetAgent.onMainAsync {
                    failure(nil, error as NSError, error.response)
                }
            }
        }))
    }

    @objc public func postFileData(_ apiName:NSString, parameters:AnyObject?,data:NSData,name:NSString,fileName:NSString?,mimeType:NSString?, progress: NZSmartAgentProgressBlock?,success:@escaping NZSmartAgentSuccessCallback, failure:@escaping NZSmartAgentFailureCallback, timeout:NSNumber?)-> MoyaNetStub? {
        let stub = MoyaNetStub(NetworkHelper.uploadFileData(urlString:(apiName as String),parameters:parameters as? [String:Any],data: data as Data, name: name as String, fileName: fileName as? String, mimeType: mimeType as? String, progress:{ progressResp in
            if let progressBlock = progress, let progObject = progressResp.progressObject {
                progressBlock(progObject)
            }
        },completion:{ result in
            switch result {
            case let .success(response):
                NZAlamoSmartNetAgent.onMainAsync {
                    success(nil, NZAlamoSmartNetAgent.encodeJsonToOC(response))
                }
            case let .failure(error):
                NZAlamoSmartNetAgent.onMainAsync {
                    failure(nil, error as NSError, error.response)
                }
            }
        }))
        if let delay = timeout {
            DispatchQueue.main.asyncAfter(deadline:.now() + delay.doubleValue) {
                stub.cancel()
            }
        }
        return stub
    }

    @objc public func postInputStreamData(_ apiName:NSString, parameters:AnyObject?,data:NSData,length:UInt64,name:NSString,fileName:NSString?,mimeType:NSString?, progress: NZSmartAgentProgressBlock?,success:@escaping NZSmartAgentSuccessCallback, failure:@escaping NZSmartAgentFailureCallback, timeout:NSNumber?)-> MoyaNetStub? {
        let stub = MoyaNetStub(NetworkHelper.uploadInputStream(urlString:(apiName as String),parameters:parameters as? [String:Any],data: data as Data, length:length, name: name as String, fileName: fileName as? String, mimeType: mimeType as? String, progress:{ progressResp in
            if let progressBlock = progress, let progObject = progressResp.progressObject {
                progressBlock(progObject)
            }
        },completion:{ result in
            switch result {
            case let .success(response):
                NZAlamoSmartNetAgent.onMainAsync {
                    success(nil, NZAlamoSmartNetAgent.encodeJsonToOC(response))
                }
            case let .failure(error):
                NZAlamoSmartNetAgent.onMainAsync {
                    failure(nil, error as NSError, error.response)
                }
            }
        }))
        if let delay = timeout {
            DispatchQueue.main.asyncAfter(deadline:.now() + delay.doubleValue) {
                stub.cancel()
            }
        }
        return stub
    }

    @objc public func postFileUrl(_ apiName:NSString, parameters:AnyObject?, fileUrl:NSURL, name:NSString, progress: NZSmartAgentProgressBlock?,success:@escaping NZSmartAgentSuccessCallback, failure:@escaping NZSmartAgentFailureCallback, timeout:NSNumber?)-> MoyaNetStub? {
        guard let url = URL(string:fileUrl.absoluteString ?? "") else {
            failure(nil, nil, nil)
            return nil
        }
        let stub = MoyaNetStub(NetworkHelper.uploadFileUrl(urlString:(apiName as String),parameters:parameters as? [String:Any],fileUrl:url, name:name as String, progress:{ progressResp in
            if let progressBlock = progress, let progObject = progressResp.progressObject {
                progressBlock(progObject)
            }
        },completion:{ result in
            switch result {
            case let .success(response):
                NZAlamoSmartNetAgent.onMainAsync {
                    success(nil, NZAlamoSmartNetAgent.encodeJsonToOC(response))
                }
            case let .failure(error):
                NZAlamoSmartNetAgent.onMainAsync {
                    failure(nil, error as NSError, error.response)
                }
            }
        }))
        if let delay = timeout {
            DispatchQueue.main.asyncAfter(deadline:.now() + delay.doubleValue) {
                stub.cancel()
            }
        }
        return stub
    }
}

extension NZAlamoSmartNetAgent {
    private static func encodeJsonToOC(_ response: Moya.Response) -> AnyObject {
        let json = JSON(response.data)
        switch(json.object) {
        case let r as [Any]:
            return r as NSArray
        case let r as [String:Any]:
            return r as NSDictionary
        case let r as String:
            return r as NSString
        default:
            return NSNull()
        }
    }
    
    private static func onMainAsync(execute work: @escaping @convention(block) () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
}

extension NZAlamoSmartNetAgent {
    @objc static func setHeader(value:NSString, key:NSString) {
        NC.defaultHeaders[key as String] = value as String
    }
    
    @objc static func removeHeader(key:NSString) {
        NC.defaultHeaders.removeValue(forKey: key as String)
    }

    @objc static func setSign(sign:NSString) {
        NC.sign = sign as String
    }

    @objc static func setSessionToken(token:NSString?) {
        NC.token = token as? String
    }

    @objc static func setUserId(userId:NSString?) {
        NC.userId = userId as? String
    }
    
    @objc static func setUserAgent(agent:NSString?) {
        NC.userAgent = agent as? String
    }

    @objc static func setPlatform(platform:NSString?) {
        NC.platform = platform as? String
    }
}

extension NZAlamoSmartNetAgent {
    @objc public static func setupEnvironment(envStr:NSString) {
        let env = envStr as String
        if env == "BUILD" {
            EnvHelper.setupEnvironment(.build)
        } else if env == "DEBUG" {
            EnvHelper.setupEnvironment(.debug)
        } else if env == "RELEASE" {
            EnvHelper.setupEnvironment(.release)
        } else if env == "UAT" {
            EnvHelper.setupEnvironment(.uat)
        }
    }
    @objc public static func setupVerifyOff(verifyOff:Int) {
        NetworkHelper.verifyOff = verifyOff > 0
    }
}


@objc public class MoyaNetStub : NSObject {
    private let stub:Cancellable?
    init (_ stub:Cancellable?) {
        self.stub = stub
    }
    
    @objc public func cancel() {
        self.stub?.cancel()
    }
}


