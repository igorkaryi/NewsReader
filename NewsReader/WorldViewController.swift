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
                        if let title = articleFromJson["title"] as? String, let desc = articleFromJson["content"] as? String, let date = articleFromJson["date"] as? String, let urlToImage = articleFromJson["thumbnail"] as? String {
                            
                            let str = desc.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) // - убрать теги
                            print(str)
                            
                            wArticle.descWorld = str
                            wArticle.headLineWorld = title
                            wArticle.dateWorld = date
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
        cell.dateWorldLabel.text = self.worldArticles?[indexPath.item].dateWorld
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailWorld" {
            let detailVC: DetailAllNewsVC? = segue.destination as? DetailAllNewsVC
            let cell: WorldTableViewCell? = sender as? WorldTableViewCell
            
            if cell != nil && detailVC != nil {
                detailVC?.contentDescr = cell?.descWorldLabel!.text
                detailVC?.contentText = cell?.titleWorldLabel!.text
                detailVC?.contentDate = cell?.dateWorldLabel!.text
                detailVC?.contentImage = cell?.imgWorldView!.image
            }
        }
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
