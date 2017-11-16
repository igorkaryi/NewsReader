//
//  UkraineViewController.swift
//  NewsReader
//
//  Created by Igor Karyi on 11/9/17.
//  Copyright © 2017 Igor Karyi. All rights reserved.
//

import UIKit

class UkraineViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var ukraineArticles: [UkraineArticle]? = []
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        fetchArticles()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Оновлення інформації")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        myTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
        fetchArticles()
    }
    
    func fetchArticles(){
        let urlRequest = URLRequest(url: URL(string: "http://pravdyvo.com/archives/category/ukraine?json=1")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print("error")
                return
            }
            
            self.ukraineArticles = [UkraineArticle]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let articlesFromJson = json["posts"] as? [[String : AnyObject]] {
                    for articleFromJson in articlesFromJson {
                        let article = UkraineArticle()
                        if let title = articleFromJson["title"] as? String, let desc = articleFromJson["content"] as? String, let date = articleFromJson["date"] as? String, let urlToImage = articleFromJson["thumbnail"] as? String {
                            
                            let str = desc.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) // - убрать теги
                            print(str)
                            
                            article.descUkraine = str
                            article.headLineUkraine = title
                            article.dateUkraine = date
                            article.imageURLUkraine = urlToImage
                        }
                        self.ukraineArticles?.append(article)
                    }
                }
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "UkraineCell", for: indexPath) as! UkraineViewCell
        
        cell.titleUkraineLabel.text = self.ukraineArticles?[indexPath.item].headLineUkraine
        cell.descUkraineLabel.text = self.ukraineArticles?[indexPath.item].descUkraine
        cell.dateUkraineLabel.text = self.ukraineArticles?[indexPath.item].dateUkraine
        cell.imgUkraineView.downloadImageUkraine(from: (self.ukraineArticles?[indexPath.item].imageURLUkraine!)!)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ukraineArticles?.count ?? 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailUkraine" {
            let detailVC: DetailAllNewsVC? = segue.destination as? DetailAllNewsVC
            let cell: UkraineViewCell? = sender as? UkraineViewCell
            
            if cell != nil && detailVC != nil {
                detailVC?.contentDescr = cell?.descUkraineLabel!.text
                detailVC?.contentText = cell?.titleUkraineLabel!.text
                detailVC?.contentDate = cell?.dateUkraineLabel!.text
                detailVC?.contentImage = cell?.imgUkraineView!.image
            }
        }
    }
    
}

extension UIImageView {

    func downloadImageUkraine(from url: String){

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

