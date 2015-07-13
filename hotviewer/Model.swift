//
//  Model.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/14.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation


class Data {
    static func getAllArticles(onComplete: (articles: [Article]?) -> ()) {
        var allArticles = [Article]()

        self.getFBPosts({
            fbPosts in
            if let posts = fbPosts {
                for post in posts {
                    allArticles.append(post)
                    
                }
                
            }
            
            self.getPTTPosts(nil, finish: {
                pttPosts in
                
                if let posts = pttPosts {
                    for post in posts {
                        allArticles.append(post)
                    }
                }
                
                self.getForumPosts({
                    forumPosts in
                    
                    if let posts = forumPosts {
                        for post in posts {
                            allArticles.append(post)
                        }
                    }
                    allArticles.shuffle()
                    onComplete(articles: allArticles)
                })
            })
        })
    }
    
    static func getFBPosts(finish: (posts: [FBPost]?) -> ()) {
        SERAPI.post(["period":"10", "token":"api_doc_token", "type": "likes"], url: "top_article/facebook", postCompleted: {
            succeeded, msg, result in
            var articles = [FBPost]()
            if let posts = result.array {
                for post in posts {
                    var article = FBPost(post: post)
                    articles.append(article)
                }
                finish(posts: articles)
            }
        })
    }
    
    static func getPTTPosts(board: String?, finish: (posts:[PTTPost]?) -> ()) {
        SERAPI.post(["period":"10", "token":"api_doc_token", "board": board], url: "top_article/ptt", postCompleted: {
            succeeded, msg, result in
            
            var articles = [PTTPost]()
            if let posts = result.array {
                for post in posts {
                    var article = PTTPost(post: post)
                    articles.append(article)
                }
            }
            finish(posts: articles)
        })
    }
    
    
    
    static func getForumPosts(finish: (posts:[ForumPost]?) -> ()) {
        SERAPI.post(["period":"10", "token":"api_doc_token"], url: "top_article/forum", postCompleted: {
            succeeded, msg, result in
            
            var articles = [ForumPost]()
            if let posts = result.array {
                for post in posts {
                    var article = ForumPost(post: post)
                    articles.append(article)
                }
            }
            finish(posts: articles)
        })
    }

}
