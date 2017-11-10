//
//  ViewController.swift
//  NewsReader
//
//  Created by Igor Karyi on 11/7/17.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

import UIKit

class ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var articles: [Article]? = []
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        fetchArticles()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Оновлення інформації")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
        fetchArticles()
    }
    
    func fetchArticles() {
        let urlRequest = URLRequest(url: URL(string: "http://pravdyvo.com/api/get_recent_posts")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print("error")
                return
            }
            
            self.articles = [Article]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let articlesFromJson = json["posts"] as? [[String : AnyObject]] {
                    for articleFromJson in articlesFromJson {
                        let article = Article()
                        if let title = articleFromJson["title"] as? String, let desc = articleFromJson["content"] as? String, let url = articleFromJson["url"] as? String, let urlToImage = articleFromJson["thumbnail"] as? String {
                            
                            let str = desc.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) // - убрать теги
                            print(str)

                            article.desc = str
                            article.headLine = title
                            article.url = url
                            article.imageURL = urlToImage
                        }
                        self.articles?.append(article)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ArticleCell
        
        cell.titleLabel.text = self.articles?[indexPath.item].headLine
        cell.descLabel.text = self.articles?[indexPath.item].desc
        cell.imgView.downloadImage(from: (self.articles?[indexPath.item].imageURL!)!)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
    
}

extension UIImageView {
    
    func downloadImage(from url: String){
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print("error")
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}

