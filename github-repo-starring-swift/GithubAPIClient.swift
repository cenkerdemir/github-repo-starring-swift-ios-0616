//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    //star repository
    class func starRepository(fullName: String, completion:()->()) {
        //create a session
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        //create the url
        let urlString = "\(Secrets.githubStarApiUrl)/\(fullName)"
        let userURL = NSURL(string: urlString)
        guard let unwrappedURL = userURL else { fatalError("Invalid URL") }
        
        //create a request
        let request = NSMutableURLRequest(URL: unwrappedURL)
        request.HTTPMethod = "PUT"
        request.addValue(Secrets.myAccessToken, forHTTPHeaderField: "Authorization")
        
        //create the task with request
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard let responseValue = response as? NSHTTPURLResponse else {
                assertionFailure("response could not get assigned")
                return
            }
            if responseValue.statusCode == 204 {
                print("starred")
                completion()
            }
            else {
                print("other status code: \(responseValue.statusCode)")
            }
        }
        task.resume()
    }
    
    //unstar repository
    class func unstarRepository(fullName: String, completion:()->()) {
        //create a session
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        //create the url
        let urlString = "\(Secrets.githubStarApiUrl)/\(fullName)"
        let userURL = NSURL(string: urlString)
        guard let unwrappedURL = userURL else { fatalError("Invalid URL") }
        
        //create a request
        let request = NSMutableURLRequest(URL: unwrappedURL)
        request.HTTPMethod = "DELETE"
        request.addValue(Secrets.myAccessToken, forHTTPHeaderField: "Authorization")
        
        //create the task with request
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard let responseValue = response as? NSHTTPURLResponse else {
                assertionFailure("response could not get assigned")
                return
            }
            if responseValue.statusCode == 204 {
                completion()
            }
            else {
                print("other status code: \(responseValue.statusCode)")
            }
        }
        task.resume()
    }

    
    class func checkIfRepositoryIsStarred(fullName: String, completion: (Bool) -> ()) {
        //create a session
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        //create the url
        let urlString = "\(Secrets.githubStarApiUrl)/\(fullName)"
        let userURL = NSURL(string: urlString)
        guard let unwrappedURL = userURL else { fatalError("Invalid URL") }
        
        //create a request
        let request = NSMutableURLRequest(URL: unwrappedURL)
        request.HTTPMethod = "GET"
        request.addValue(Secrets.myAccessToken, forHTTPHeaderField: "Authorization")
        
        //create the task with request
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard let responseValue = response as? NSHTTPURLResponse else {
                assertionFailure("response could not get assigned")
                return
            }
            switch responseValue.statusCode {
            case 204:
                completion(true)
            case 404:
                completion(false)
            default:
                print("other status code: \(responseValue.statusCode)")
            }
        }
        task.resume()
    }

    
    class func getRepositoriesWithCompletion(completion: (NSArray) -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/repositories?client_id=\(Secrets.clientID)&client_secret=\(Secrets.clientSecret)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }
        task.resume()
    }
}

