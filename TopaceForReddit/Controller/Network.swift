//
//  DownloadController.swift
//  TopaceForReddit
//
//  Created by hesham on 11/17/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import Foundation

class Network {
    
    enum downloadStatus {
        case success
        case failure
        case blankData
    }
    
    private var accessToken : String?
    var dataJSON : Data?
    private var postsData : PostData?

    func getAccessToken() -> String? {
        return accessToken
    }

    func getPostData() -> PostData? {
        return postsData
    }
    
    private func downloadDataAndGetStatus(url: URL, completionHandler: @escaping (downloadStatus) -> ()) {
        let timeout = 15
        let token = "bearer \(accessToken!)"
        var request = URLRequest(url: url)
        request.addValue(token, forHTTPHeaderField: "Authorization")

        // timeout
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(timeout)
        config.timeoutIntervalForResource = TimeInterval(timeout)
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request) {
            [weak self](data,response,error) in
            if error != nil {
                print("Network:downloadDataAndGetStatus: error not nil")
                completionHandler(.failure)
            }
            else if data == nil {
                print("Network:downloadDataAndGetStatus: data is nil")
                completionHandler(.blankData)
            }
            else {
                self?.dataJSON = data
                completionHandler(.success)
            }
        }
        task.resume()
    }

    func decodeJSONAndSetPosts() {
        let decoder = JSONDecoder()
        self.postsData = try? decoder.decode(PostData.self, from: dataJSON!)
    }

    private func makeAccessToken(completionHandler: @escaping (_ accessToken : String?) -> ()){
        let CLIENT_ID = ""
        let ACCESS_TOKEN_URL = "https://www.reddit.com/api/v1/access_token"
        let GRANT_TYPE = "https://oauth.reddit.com/grants/installed_client"
        let DONT_TRACK = "DO_NOT_TRACK_THIS_DEVICE"
        let timeout = 15
        let uncodedClientIDAndPassword = "\(CLIENT_ID):"
        let encodedClientIDAndPassword = uncodedClientIDAndPassword.toBase64()
        let authStr = "Basic \(encodedClientIDAndPassword!)"
        guard let serviceUrl = URL(string: ACCESS_TOKEN_URL) else {
            completionHandler(nil)
            return
        }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(authStr, forHTTPHeaderField: "Authorization")
        let param = "grant_type=\(GRANT_TYPE)&device_id=\(DONT_TRACK)"
        let data = param.data(using: .utf8)
        request.httpBody = data
        // timeout
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(timeout)
        config.timeoutIntervalForResource = TimeInterval(timeout)
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { [weak self] (data, response, error) in
            if data != nil {
                do {
                    if let json = (try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] {
                        self?.accessToken = json["access_token"] as? String
                    } else {
                        self?.accessToken = nil
                    }
                }
            }
            completionHandler(self?.getAccessToken())
            }.resume()
    }

    func downloadPosts(redditURL : RedditURL, completionHandler : @escaping (_ downloadStatus : Network.downloadStatus)->()) {
        if accessToken == nil {
            makeAccessToken() {
                [weak self]
                accessToken in
                if accessToken != nil {
                    self?.downloadDataAndGetStatus(url: redditURL.url!) {
                        downloadStatus in
                        completionHandler(downloadStatus)
                    }
                } else {
                    completionHandler(.failure)
                }
            }
        }
        else {
            self.downloadDataAndGetStatus(url: redditURL.url!) {
                downloadStatus in
                completionHandler(downloadStatus)
            }
        }
    }
}

extension String {
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}
