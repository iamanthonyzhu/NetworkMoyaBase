//
//  MoyaHelper.swift
//  SwiftAppBase
//
//  Created by anthony zhu on 2023/8/3.
//

import Foundation
import Moya

fileprivate let defaultBaseUrl = URL(string:"http://localhost")!

fileprivate let defaultDownloadDestination: DownloadDestination = { temporaryURL, response in
    let directoryURLs = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)

    if !directoryURLs.isEmpty {
        return (directoryURLs.first!.appendingPathComponent(response.suggestedFilename!), [])
    }

    return (temporaryURL, [])
}


public enum MoyaBaseURL : String {
    case base_url_Test = "base_url_Test"
    case base_url_Test_https = "base_url_Test_https"
    case base_user_url = "base_user_url"
    case base_url_Article = "base_url_Article"
    case bookInfoURL = "bookInfoURL"
    case base_url_Ad = "base_url_Ad"
    case base_url_writing_work = "base_url_writing_work"
    case log_url = "log_url"
    case base_url_Article_Magazine_http = "base_url_Article_Magazine_http"
    case base_url_Article_Magazine_https = "base_url_Article_Magazine_https"
    case bookCoverURL = "bookCoverURL"
    case base_url_Article_CourseItem_http  = "base_url_Article_CourseItem_http"
    case base_url_Article_CourseItem_https = "base_url_Article_CourseItem_https"
    case base_url_Article_http = "base_url_Article_http"
    case base_url_Article_https = "base_url_Article_https"
    case base_url_Get_App_Tpl = "base_url_Get_App_Tpl"
    case base_url_Get_App_Tpl_Work = "base_url_Get_App_Tpl_Work"
    case base_track_url = "base_track_url"
    case image_base_url = "image_base_url"
    case media_upload_url = "media_upload_url"
    case SubMoreLink = "SubMoreLink"
    case SubMoreLink2 = "SubMoreLink2"
    case url_activity_list = "url_activity_list"
    case url_pumpkin_icon = "url_pumpkin_icon"
    case url_pumpkin_icon_target = "url_pumpkin_icon_target"
    case url_newspaperpage = "url_newspaperpage"
    case url_NZMall = "url_NZMall"
    case url_aboutus = "url_aboutus"          //关于我们
    case url_user_protocol = "url_user_protocol"    //用户协议
    case url_copyright = "url_copyright"        //版权
    case url_privacy_policy = "url_privacy_policy"   //隐私权政策 协议
    case url_member_service = "url_member_service"   //付费会员服务协议
    case url_renewal = "url_renewal"          //续订合同
    case url_qa = "url_qa"               //常见问题
    case url_user_unlockSms = "url_user_unlockSms"   //解取验证码的手机号码防骚扰
    case url_Pay_Help_Ali_Pay = "url_Pay_Help_Ali_Pay"
    case url_Pay_Help_Wechat_Pay = "url_Pay_Help_Wechat_Pay"
    case url_Pay_Help_Union_Pay = "url_Pay_Help_Union_Pay"
    case url_Pumpkin_Rule = "url_Pumpkin_Rule"
    case statisticsDomainUrl = "statisticsDomainUrl"
    case url_cos = "url_cos"
}



public enum MoyaTargetUrl {
    case url(URL)
    case urlStr(String)
    case urlComb(MoyaBaseURL,String)
}


public enum MoyaMethodTarget {
    case get(MoyaTargetUrl, [String:Any]?, Any?,[String:String]?)
    case post(MoyaTargetUrl,[String:Any]?, Any?,[String:String]?)
    case put(MoyaTargetUrl,[String:Any]?, Any?,[String:String]?)
    case delete(MoyaTargetUrl,[String:Any]?, Any?,[String:String]?)
    case head(MoyaTargetUrl,[String:Any]?, Any?,[String:String]?)
    case upload(MoyaTargetUrl,[String:Any]?, [MultipartFormData],[String:String]?)
    case uploadFileData(MoyaTargetUrl,[String:Any]?,Data,String,String?,String?,[String:String]?)
    case uploadInputStreamData(MoyaTargetUrl,[String:Any]?,Data,UInt64,String,String?,String?,[String:String]?)
    case uploadFileUrl(MoyaTargetUrl,[String:Any]?,URL,String,[String:String]?)
    case download(MoyaTargetUrl,[String:Any]?,DownloadDestination?,[String:String]?)

}

extension MoyaMethodTarget:TargetType {
    public var baseURL: URL {
        switch self {
        case .get(let targetUrl,_,_,_):
            return retrieveUrl(targetUrl)
        case .post(let targetUrl, _,_,_):
            return retrieveUrl(targetUrl)
        case .put(let targetUrl,_,_,_):
            return retrieveUrl(targetUrl)
        case .delete(let targetUrl,_,_,_):
            return retrieveUrl(targetUrl)
        case .head(let targetUrl,_,_,_):
            return retrieveUrl(targetUrl)
        case .upload(let targetUrl,_,_,_):
            return retrieveUrl(targetUrl)
        case .uploadFileData(let targetUrl,_,_,_,_,_,_):
            return retrieveUrl(targetUrl)
        case .uploadInputStreamData(let targetUrl,_,_,_,_,_,_,_):
            return retrieveUrl(targetUrl)
        case .uploadFileUrl(let targetUrl, _,_, _, _):
            return retrieveUrl(targetUrl)
        case .download(let targetUrl,_,_,_):
            return retrieveUrl(targetUrl)
        }
    }
    
    public var path: String {
        switch self {
        case .get(let targetUrl,_,_,_):
            return retrievePath(targetUrl)
        case .post(let targetUrl,_,_,_):
            return retrievePath(targetUrl)
        case .put(let targetUrl,_,_,_):
            return retrievePath(targetUrl)
        case .delete(let targetUrl,_,_,_):
            return retrievePath(targetUrl)
        case .head(let targetUrl,_,_,_):
            return retrievePath(targetUrl)
        case .upload(let targetUrl,_,_,_):
            return retrievePath(targetUrl)
        case .uploadFileData(let targetUrl,_,_,_,_,_,_):
            return retrievePath(targetUrl)
        case .uploadInputStreamData(let targetUrl,_,_,_,_,_,_,_):
            return retrievePath(targetUrl)
        case .uploadFileUrl(let targetUrl,_, _, _, _):
            return retrievePath(targetUrl)
        case .download(let targetUrl,_,_,_):
            return retrievePath(targetUrl)
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .delete:
            return .delete
        case .head:
            return .head
        case .upload:
            return .post
        case .uploadFileData:
            return .post
        case .uploadInputStreamData:
            return .post
        case .uploadFileUrl:
            return .post
        case .download:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .get(_,let parameters,let bodyData,_):
            return retrieveRequestTask(invokeParameters: parameters, invokeBodyData: bodyData)
        case .post(_,let parameters, let bodyData,_):
            return retrieveRequestTask(invokeParameters: parameters, invokeBodyData: bodyData)
        case .put(_, let parameters, let bodyData,_):
            return retrieveRequestTask(invokeParameters: parameters, invokeBodyData: bodyData)
        case .delete(_, let parameters, let bodyData,_):
            return retrieveRequestTask(invokeParameters: parameters, invokeBodyData: bodyData)
        case .head(_, let parameters, let bodyData,_):
            return retrieveRequestTask(invokeParameters: parameters, invokeBodyData: bodyData)
        case .upload(_,let parameters, let formDatas,_):
            if  let params = parameters {
                return .uploadCompositeMultipart(formDatas, urlParameters: params)
            } else {
                return .uploadMultipart(formDatas)
            }
        case .uploadFileData(_, let parameters,let data,let name, let fileName, let mimeType,_):
            let multi = MultipartFormData(provider: .data(data), name: name, fileName: fileName, mimeType: mimeType)
            if  let params = parameters {
                return .uploadCompositeMultipart([multi], urlParameters: params)
            } else {
                return .uploadMultipart([multi])
            }
        case .uploadInputStreamData(_, let parameters,let data,let length,let name, let fileName, let mimeType,_):
            let multi = MultipartFormData(provider: .stream(InputStream(data: data),length), name: name, fileName: fileName, mimeType: mimeType)
            if  let params = parameters {
                return .uploadCompositeMultipart([multi], urlParameters: params)
            } else {
                return .uploadMultipart([multi])
            }
        case .uploadFileUrl(_, let parameters, let fileUrl,let name,_):
            let multi = MultipartFormData(provider: .file(fileUrl),name: name)
            if  let params = parameters {
                return .uploadCompositeMultipart([multi], urlParameters: params)
            } else {
                return .uploadMultipart([multi])
            }
        case .download(_,let parameters, let dest, _):
            if  let params = parameters {
                return .downloadParameters(parameters: params, encoding: URLEncoding.default, destination: dest ?? defaultDownloadDestination)
            } else {
                return .downloadDestination(dest ?? defaultDownloadDestination)
            }
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .get(_,_,_,let headers):
            return headers
        case .post(_,_,_,let headers):
            return headers
        case .put(_,_,_,let headers):
            return headers
        case .delete(_,_,_,let headers):
            return headers
        case .head(_,_,_,let headers):
            return headers
        case .upload(_,_,_,let headers):
            return headers
        case .uploadFileData(_,_,_,_,_,_,let headers):
            return headers
        case .uploadInputStreamData(_,_,_,_,_,_,_,let headers):
            return headers
        case .uploadFileUrl(_,_, _, _,let headers):
            return headers
        case .download(_,_,_,let headers):
            return headers
        }
    }
    
    private func retrieveUrl(_ targetUrl:MoyaTargetUrl) -> URL {
        switch targetUrl {
        case .url(let url):
            return url
        case .urlStr(let urlString):
            return URL(string: urlString) ?? defaultBaseUrl
        case .urlComb(let baseUrl, _):
            return EnvHelper.getEnvURL(baseUrl.rawValue) ?? defaultBaseUrl
        }
    }

    private func retrievePath(_ targetUrl:MoyaTargetUrl) -> String {
        switch targetUrl {
        case .url:
            return ""
        case .urlStr:
            return ""
        case .urlComb(_, let path):
            return path
        }
    }

    private func retrieveRequestTask(invokeParameters:[String:Any]?, invokeBodyData:Any?) -> Task {
        if let param = invokeParameters {
            if let bodyData = invokeBodyData as? Data {
                return .requestCompositeData(bodyData: bodyData, urlParameters: param)
            } else if let bodyData = invokeBodyData as? [String:Any] {
                return .requestCompositeParameters(bodyParameters: bodyData, bodyEncoding: JSONEncoding.default, urlParameters: param)
            } else {
                return .requestParameters(parameters: param, encoding: URLEncoding.default)
            }
        }
        if let bodyData = invokeBodyData as? [String:Any] {
            return .requestCompositeParameters(bodyParameters: bodyData, bodyEncoding: JSONEncoding.default, urlParameters: [:])
        } else if let bodyData = invokeBodyData as? Data {
            return .requestData(bodyData)
        }
        return .requestPlain
    }
    
}

extension Dictionary : AppBaseExtended {}
extension AppBaseExtension where ExtendedType == [String : Any] {
    private var deviceInfoForUrl:[String:Any] {
        var dict = ["platform":"ireader"]
        dict["device"] = GlobalHelper.getDeviceName()
        dict["version"] = GlobalHelper.getAppVersion()
        dict["system_version"] = GlobalHelper.getSystemVersion()
        return dict
    }

    public func addDeviceInfoForUrl() -> [String:Any] {
        type.merging(deviceInfoForUrl) { old, _ in
            old
        }
    }
}

