//
//  ReposDataStore.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    private init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositoriesWithCompletion(completion: () -> ()) {
        GithubAPIClient.getRepositoriesWithCompletion { (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? NSDictionary else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
                
            }
            completion()
        }
    }
    
    func printFirstElement() {
        GithubAPIClient.getRepositoriesWithCompletion { (reposArray) in
            print(reposArray.firstObject)
        }
    }
    
    func toggleStarStatusForRepository(repository: GithubRepository, toggleCompletion: (Bool) -> ()) {
        GithubAPIClient.checkIfRepositoryIsStarred(repository.fullName, completion: { (starred) in
            if starred == true {
                GithubAPIClient.unstarRepository(repository.fullName, completion: {
                    print("unstarring repository...")
                })
                toggleCompletion(false)
            }
            else {
                GithubAPIClient.starRepository(repository.fullName, completion: {
                    print("starring repository...")
                })
                toggleCompletion(true)
            }
        })
    }

}
