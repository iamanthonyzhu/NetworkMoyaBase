//
//  NetworkHelper+Combine.swift
//  SwiftAppBase
//
//  Created by anthony zhu on 2023/8/29.
//

import Foundation
import Combine
import Moya
import HandyJSON

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)

// MARK: get publish extension
public extension NetworkHelper {
    
     static func getResponsePublish(baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<Moya.Response, Moya.MoyaError> {
        return MoyaPublisher { subscriber in
            NetworkHelper.get(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData, completion:{ result in
                switch result {
                case let .success(response):
                    _ = subscriber.receive(response)
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })
        }.eraseToAnyPublisher()
    }
    
     static func getResponsePublish(urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<Moya.Response, Moya.MoyaError> {
        return MoyaPublisher { subscriber in
            NetworkHelper.get(urlString: urlString, parameters:parameters, bodyData: bodyData, completion:{ result in
                switch result {
                case let .success(response):
                    _ = subscriber.receive(response)
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })
        }.eraseToAnyPublisher()
    }
    
     static func getPublish<T: HandyJSON>(type:T.Type = T.self,baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.get(type:T.self, baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }
    
     static func getPublish(baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.get(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }
    
     static func getPublish<T: HandyJSON>(type:T.Type = T.self,urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.get(type:T.self, urlString:urlString, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }
    
     static func getPublish(urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.get(urlString:urlString, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }
}

// MARK: post publish
public extension NetworkHelper {

     static func postResponsePublish(baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<Moya.Response, Moya.MoyaError> {
        return MoyaPublisher { subscriber in
            NetworkHelper.post(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData, completion:{ result in
                switch result {
                case let .success(response):
                    _ = subscriber.receive(response)
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })
        }.eraseToAnyPublisher()
    }
    
     static func postResponsePublish(urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<Moya.Response, Moya.MoyaError> {
        return MoyaPublisher { subscriber in
            NetworkHelper.post(urlString: urlString, parameters:parameters, bodyData: bodyData, completion:{ result in
                switch result {
                case let .success(response):
                    _ = subscriber.receive(response)
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })
        }.eraseToAnyPublisher()
    }

     static func postPublish(baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.post(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }

     static func postPublish<T: HandyJSON>(type:T.Type = T.self,baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.post(type:T.self, baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }

    /// post urlString
     static func postPublish(urlString:String, parameters:[String:Any]? = nil,bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.post(urlString:urlString, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }
    
     static func postPublish<T: HandyJSON>(type:T.Type = T.self,urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.get(type:T.self, urlString:urlString, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }
}

// MARK: put extension
public extension NetworkHelper {
    
     static func putResponsePublish(baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<Moya.Response, Moya.MoyaError> {
        return MoyaPublisher { subscriber in
            NetworkHelper.put(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData, completion:{ result in
                switch result {
                case let .success(response):
                    _ = subscriber.receive(response)
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })
        }.eraseToAnyPublisher()
    }
    
     static func putResponsePublish(urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<Moya.Response, Moya.MoyaError> {
        return MoyaPublisher { subscriber in
            NetworkHelper.put(urlString: urlString, parameters:parameters, bodyData: bodyData, completion:{ result in
                switch result {
                case let .success(response):
                    _ = subscriber.receive(response)
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })
        }.eraseToAnyPublisher()
    }

     static func putPublish(baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.put(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }

     static func putPublish<T: HandyJSON>(type:T.Type = T.self,baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.put(type:T.self, baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }

     static func putPublish(urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.put(urlString:urlString, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }

     static func putPublish<T: HandyJSON>(type:T.Type = T.self,urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.put(type:T.self, urlString:urlString, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }
}

// MARK: delete publish
public extension NetworkHelper {

     static func deleteResponsePublish(baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<Moya.Response, Moya.MoyaError> {
        return MoyaPublisher { subscriber in
            NetworkHelper.delete(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData, completion:{ result in
                switch result {
                case let .success(response):
                    _ = subscriber.receive(response)
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })
        }.eraseToAnyPublisher()
    }
    
     static func deleteResponsePublish(urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<Moya.Response, Moya.MoyaError> {
        return MoyaPublisher { subscriber in
            NetworkHelper.delete(urlString: urlString, parameters:parameters, bodyData: bodyData, completion:{ result in
                switch result {
                case let .success(response):
                    _ = subscriber.receive(response)
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })
        }.eraseToAnyPublisher()
    }

    /// delete baseUrl
     static func deletePublish<T: HandyJSON>(type:T.Type = T.self,baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.delete(type:T.self, baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }
    
     static func deletePublish(baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.delete(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }

    /// delete UrlString
     static func deletePublish<T: HandyJSON>(type:T.Type = T.self,urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.delete(type:T.self, urlString:urlString, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }

     static func deletePublish(urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.delete(urlString:urlString, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }
}

// MARK: head publish
public extension NetworkHelper {
    
     static func headResponsePublish(baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<Moya.Response, Moya.MoyaError> {
        return MoyaPublisher { subscriber in
            NetworkHelper.head(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData, completion:{ result in
                switch result {
                case let .success(response):
                    _ = subscriber.receive(response)
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })
        }.eraseToAnyPublisher()
    }
    
     static func headResponsePublish(urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<Moya.Response, Moya.MoyaError> {
        return MoyaPublisher { subscriber in
            NetworkHelper.head(urlString: urlString, parameters:parameters, bodyData: bodyData, completion:{ result in
                switch result {
                case let .success(response):
                    _ = subscriber.receive(response)
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })
        }.eraseToAnyPublisher()
    }

    /// head baseUrl
     static func headPublish<T: HandyJSON>(type:T.Type = T.self,baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.head(type:T.self, baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }
    
     static func headPublish(baseUrl:MoyaBaseURL,path:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.head(baseUrl: baseUrl, path: path, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }

    /// delete UrlString
    
     static func headPublish<T: HandyJSON>(type:T.Type = T.self,urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.delete(type:T.self, urlString:urlString, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }

     static func headPublish(urlString:String, parameters:[String:Any]? = nil, bodyData:Any? = nil) -> AnyPublisher<BaseNetData, Never> {
        return NetworkPublish { subscriber in
            NetworkHelper.delete(urlString:urlString, parameters:parameters, bodyData: bodyData, callback: { data in
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            })
        }.eraseToAnyPublisher()
    }
}

// MARK: download publish
public extension NetworkHelper {
    static func downloadPublish(baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, destination:@escaping DownloadDestination,progress: ProgressBlock? = .none) -> AnyPublisher<Moya.ProgressResponse, Moya.MoyaError> {
        let progressBlock: (AnySubscriber<ProgressResponse, MoyaError>) -> (ProgressResponse) -> Void = { subscriber in
            return { progress in
                _ = subscriber.receive(progress)
            }
        }

        let response = MoyaPublisher<ProgressResponse> { subscriber in
            let cancellableToken = NetworkHelper.download(baseUrl: baseUrl, path: path, destination: destination, progress: progressBlock(subscriber), completion: { result in
                switch result {
                case .success:
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })

            return cancellableToken
        }

        // Accumulate all progress and combine them when the result comes
        return response
            .scan(ProgressResponse()) { last, progress in
                let progressObject = progress.progressObject ?? last.progressObject
                let response = progress.response ?? last.response
                return ProgressResponse(progress: progressObject, response: response)
            }
            .eraseToAnyPublisher()

    }
    
    static func downloadPublish(urlString:String, parameters:[String:Any]? = nil, destination:@escaping DownloadDestination,progress: ProgressBlock? = .none) -> AnyPublisher<Moya.ProgressResponse, Moya.MoyaError> {
        let progressBlock: (AnySubscriber<ProgressResponse, MoyaError>) -> (ProgressResponse) -> Void = { subscriber in
            return { progress in
                _ = subscriber.receive(progress)
            }
        }

        let response = MoyaPublisher<ProgressResponse> { subscriber in
            let cancellableToken = NetworkHelper.download(urlString: urlString, destination: destination, progress: progressBlock(subscriber), completion: { result in
                switch result {
                case .success:
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })

            return cancellableToken
        }

        // Accumulate all progress and combine them when the result comes
        return response
            .scan(ProgressResponse()) { last, progress in
                let progressObject = progress.progressObject ?? last.progressObject
                let response = progress.response ?? last.response
                return ProgressResponse(progress: progressObject, response: response)
            }
            .eraseToAnyPublisher()
    }

}

// MARK: upload publish
public extension NetworkHelper {
    static func uploadFileDataPublish(baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, data:Data,name:String,fileName:String?,mimeType:String?,progress: ProgressBlock? = .none) -> AnyPublisher<Moya.ProgressResponse, Moya.MoyaError> {
        let progressBlock: (AnySubscriber<ProgressResponse, MoyaError>) -> (ProgressResponse) -> Void = { subscriber in
            return { progress in
                _ = subscriber.receive(progress)
            }
        }

        let response = MoyaPublisher<ProgressResponse> { subscriber in
            let cancellableToken = NetworkHelper.uploadFileData(baseUrl:baseUrl, path:path, parameters:parameters, data:data,name:name,fileName:fileName,mimeType:mimeType, progress: progressBlock(subscriber), completion: { result in
                switch result {
                case .success:
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })

            return cancellableToken
        }

        // Accumulate all progress and combine them when the result comes
        return response
            .scan(ProgressResponse()) { last, progress in
                let progressObject = progress.progressObject ?? last.progressObject
                let response = progress.response ?? last.response
                return ProgressResponse(progress: progressObject, response: response)
            }
            .eraseToAnyPublisher()
    }

    static func uploadFileDataPublish(urlString:String, parameters:[String:Any]? = nil, data:Data,name:String,fileName:String?,mimeType:String?,progress: ProgressBlock? = .none) -> AnyPublisher<Moya.ProgressResponse, Moya.MoyaError> {
        let progressBlock: (AnySubscriber<ProgressResponse, MoyaError>) -> (ProgressResponse) -> Void = { subscriber in
            return { progress in
                _ = subscriber.receive(progress)
            }
        }

        let response = MoyaPublisher<ProgressResponse> { subscriber in
            let cancellableToken = NetworkHelper.uploadFileData(urlString:urlString, parameters:parameters, data:data,name:name,fileName:fileName,mimeType:mimeType, progress: progressBlock(subscriber), completion: { result in
                switch result {
                case .success:
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })

            return cancellableToken
        }

        // Accumulate all progress and combine them when the result comes
        return response
            .scan(ProgressResponse()) { last, progress in
                let progressObject = progress.progressObject ?? last.progressObject
                let response = progress.response ?? last.response
                return ProgressResponse(progress: progressObject, response: response)
            }
            .eraseToAnyPublisher()
    }
    
    static func uploadInputStreamPublish(baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, data:Data,length:UInt64,name:String,fileName:String?,mimeType:String?,progress: ProgressBlock? = .none) -> AnyPublisher<Moya.ProgressResponse, Moya.MoyaError> {
        let progressBlock: (AnySubscriber<ProgressResponse, MoyaError>) -> (ProgressResponse) -> Void = { subscriber in
            return { progress in
                _ = subscriber.receive(progress)
            }
        }

        let response = MoyaPublisher<ProgressResponse> { subscriber in
            let cancellableToken = NetworkHelper.uploadInputStream(baseUrl:baseUrl,path:path,parameters:parameters, data:data,length:length,name:name,fileName:fileName,mimeType:mimeType, progress: progressBlock(subscriber), completion: { result in
                switch result {
                case .success:
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })

            return cancellableToken
        }

        // Accumulate all progress and combine them when the result comes
        return response
            .scan(ProgressResponse()) { last, progress in
                let progressObject = progress.progressObject ?? last.progressObject
                let response = progress.response ?? last.response
                return ProgressResponse(progress: progressObject, response: response)
            }
            .eraseToAnyPublisher()
    }
    
    static func uploadInputStreamPublish(urlString:String, parameters:[String:Any]? = nil, data:Data,length:UInt64,name:String,fileName:String?,mimeType:String?,progress: ProgressBlock? = .none) -> AnyPublisher<Moya.ProgressResponse, Moya.MoyaError> {
        let progressBlock: (AnySubscriber<ProgressResponse, MoyaError>) -> (ProgressResponse) -> Void = { subscriber in
            return { progress in
                _ = subscriber.receive(progress)
            }
        }

        let response = MoyaPublisher<ProgressResponse> { subscriber in
            let cancellableToken = NetworkHelper.uploadInputStream(urlString:urlString,parameters:parameters, data:data,length:length,name:name,fileName:fileName,mimeType:mimeType, progress: progressBlock(subscriber), completion: { result in
                switch result {
                case .success:
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })

            return cancellableToken
        }

        // Accumulate all progress and combine them when the result comes
        return response
            .scan(ProgressResponse()) { last, progress in
                let progressObject = progress.progressObject ?? last.progressObject
                let response = progress.response ?? last.response
                return ProgressResponse(progress: progressObject, response: response)
            }
            .eraseToAnyPublisher()

    }

    static func uploadFileUrlPublish(baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, fileUrl:URL,name:String,progress: ProgressBlock? = .none) -> AnyPublisher<Moya.ProgressResponse, Moya.MoyaError> {
        let progressBlock: (AnySubscriber<ProgressResponse, MoyaError>) -> (ProgressResponse) -> Void = { subscriber in
            return { progress in
                _ = subscriber.receive(progress)
            }
        }

        let response = MoyaPublisher<ProgressResponse> { subscriber in
            let cancellableToken = NetworkHelper.uploadFileUrl(baseUrl:baseUrl,path:path,parameters:parameters, fileUrl: fileUrl,name:name,progress: progressBlock(subscriber), completion: { result in
                switch result {
                case .success:
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })

            return cancellableToken
        }

        // Accumulate all progress and combine them when the result comes
        return response
            .scan(ProgressResponse()) { last, progress in
                let progressObject = progress.progressObject ?? last.progressObject
                let response = progress.response ?? last.response
                return ProgressResponse(progress: progressObject, response: response)
            }
            .eraseToAnyPublisher()

    }

    static func uploadFileUrlPublish(urlString:String, parameters:[String:Any]? = nil, fileUrl:URL,name:String,progress: ProgressBlock? = .none) -> AnyPublisher<Moya.ProgressResponse, Moya.MoyaError> {
        let progressBlock: (AnySubscriber<ProgressResponse, MoyaError>) -> (ProgressResponse) -> Void = { subscriber in
            return { progress in
                _ = subscriber.receive(progress)
            }
        }

        let response = MoyaPublisher<ProgressResponse> { subscriber in
            let cancellableToken = NetworkHelper.uploadFileUrl(urlString:urlString,parameters:parameters, fileUrl: fileUrl,name:name,progress: progressBlock(subscriber), completion: { result in
                switch result {
                case .success:
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })

            return cancellableToken
        }

        // Accumulate all progress and combine them when the result comes
        return response
            .scan(ProgressResponse()) { last, progress in
                let progressObject = progress.progressObject ?? last.progressObject
                let response = progress.response ?? last.response
                return ProgressResponse(progress: progressObject, response: response)
            }
            .eraseToAnyPublisher()

    }


    static func uploadPublish(baseUrl:MoyaBaseURL, path:String, parameters:[String:Any]? = nil, formDatas:[Moya.MultipartFormData],progress: ProgressBlock? = .none) -> AnyPublisher<Moya.ProgressResponse, Moya.MoyaError> {
        let progressBlock: (AnySubscriber<ProgressResponse, MoyaError>) -> (ProgressResponse) -> Void = { subscriber in
            return { progress in
                _ = subscriber.receive(progress)
            }
        }

        let response = MoyaPublisher<ProgressResponse> { subscriber in
            let cancellableToken = NetworkHelper.upload(baseUrl:baseUrl,path:path,parameters:parameters,formDatas: formDatas,progress: progressBlock(subscriber), completion: { result in
                switch result {
                case .success:
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })

            return cancellableToken
        }

        // Accumulate all progress and combine them when the result comes
        return response
            .scan(ProgressResponse()) { last, progress in
                let progressObject = progress.progressObject ?? last.progressObject
                let response = progress.response ?? last.response
                return ProgressResponse(progress: progressObject, response: response)
            }
            .eraseToAnyPublisher()

    }

    static func uploadPublish(urlString:String, parameters:[String:Any]? = nil, formDatas:[Moya.MultipartFormData],progress: ProgressBlock? = .none) -> AnyPublisher<Moya.ProgressResponse, Moya.MoyaError> {
        let progressBlock: (AnySubscriber<ProgressResponse, MoyaError>) -> (ProgressResponse) -> Void = { subscriber in
            return { progress in
                _ = subscriber.receive(progress)
            }
        }

        let response = MoyaPublisher<ProgressResponse> { subscriber in
            let cancellableToken = NetworkHelper.upload(urlString:urlString,parameters:parameters,formDatas: formDatas,progress: progressBlock(subscriber), completion: { result in
                switch result {
                case .success:
                    subscriber.receive(completion: .finished)
                case let .failure(error):
                    subscriber.receive(completion: .failure(error))
                }
            })

            return cancellableToken
        }

        // Accumulate all progress and combine them when the result comes
        return response
            .scan(ProgressResponse()) { last, progress in
                let progressObject = progress.progressObject ?? last.progressObject
                let response = progress.response ?? last.response
                return ProgressResponse(progress: progressObject, response: response)
            }
            .eraseToAnyPublisher()

    }

}
