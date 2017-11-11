//
//  WorldViewController.swift
//  NewsReader
//
//  Created by Igor Karyi on 11/9/17.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

import UIKit

class WorldViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var worldTableView: UITableView!
    
    var worldArticles: [WorldArticle]? = []
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        fetchArticles()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Оновлення інформації")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        worldTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
        fetchArticles()
    }
    
    func fetchArticles(){
        let urlRequest = URLRequest(url: URL(string: "http://pravdyvo.com/archives/category/world?json=1")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print("error")
                return
            }
            
            self.worldArticles = [WorldArticle]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let articlesFromJson = json["posts"] as? [[String : AnyObject]] {
                    for articleFromJson in articlesFromJson {
                        let wArticle = WorldArticle()
                        if let title = articleFromJson["title"] as? String, let desc = articleFromJson["content"] as? String, let url = articleFromJson["url"] as? String, let urlToImage = articleFromJson["thumbnail"] as? String {
                            
                            let str = desc.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) // - убрать теги
                            print(str)
                            
                            wArticle.descWorld = str
                            wArticle.headLineWorld = title
                            wArticle.urlWorld = url
                            wArticle.imageURLWorld = urlToImage
                        }
                        self.worldArticles?.append(wArticle)
                    }
                }
                DispatchQueue.main.async {
                    self.worldTableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
                
            } catch let error {
                print(error)
            }
        }
        
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = worldTableView.dequeueReusableCell(withIdentifier: "WorldCell", for: indexPath) as! WorldTableViewCell
        
        cell.titleWorldLabel.text = self.worldArticles?[indexPath.item].headLineWorld
        cell.descWorldLabel.text = self.worldArticles?[indexPath.item].descWorld
        cell.imgWorldView.downloadImageWorld(from: (self.worldArticles?[indexPath.item].imageURLWorld!)!)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.worldArticles?.count ?? 0
    }
    
}

extension UIImageView {
    
    func downloadImageWorld(from url: String){
        
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
