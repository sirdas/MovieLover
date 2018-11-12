//
//  MovieViewController.swift
//  Lab4
//
//  Created by Reis Sirdas on 3/8/17.
//  Copyright © 2017 sirdas. All rights reserved.
//

import UIKit
import MBProgressHUD

class MovieViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    var movies: [Movie] = []
    var s: String = ""
    var page: Int = 1
    var totalPages: Int = 0
    var isFetching: Bool = false
    
    override func viewDidLoad() {
        self.title = "Movies"
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self

        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData(s: String, page: Int) {
        
        let json = getJSON("http://www.omdbapi.com/?s=\(s)&page=\(page)&apikey=a1ec0afb")
        if (page == 1) {
            totalPages = json["totalResults"].intValue
            if (totalPages % 10 != 0) {
                totalPages = (totalPages / 10) + 1
            } else {
                totalPages /= 10
            }
        }
        for result in json["Search"].arrayValue {
            let title = result["Title"].stringValue
            let imdbID = result["imdbID"].stringValue
            let year = result["Year"].stringValue
            let url = result["Poster"].stringValue
            movies.append(Movie(title: title, imdbID: imdbID, url: url, year: year, plot: "", runtime: "", poster: nil)!)
        }
        
    }
    
    func getJSON(_ url: String) -> JSON {
        
        if let url = URL(string: url){
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                return json
            } else {
                return JSON.null
            }
        } else {
            return JSON.null
        }
        
    }
    
    func cacheImages() {
        for i in (self.page - 1) * 10 ..< movies.count {
            print(movies[i].title)
            let url = URL(string: movies[i].url)
            if let data = try? Data(contentsOf: url!) {
                let image = UIImage(data: data)
                movies[i].poster = image
            } else {
                movies[i].poster = nil
            }
            
        }
        
        self.page += 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movies.count
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colCell", for: indexPath as IndexPath) as! MovieCollectionCell
        
        cell.titleLabel.text = movies[indexPath.row].title
        cell.posterView.image = movies[indexPath.row].poster
        return cell
    }
    
    func fetchMore() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global(qos: .userInitiated).async {
            print(self.s)
            
            self.fetchData(s: self.s, page: self.page)
            self.cacheImages()
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.isFetching = false
                self.collectionView.reloadData()
            }
            
        }
    }
    //for infinite scrolling and updating, used this guide: https://guides.codepath.com/ios/Table-View-Guide#adding-infinite-scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isFetching && page < totalPages && page != 1) {
            let scrollViewContentHeight = collectionView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - collectionView.bounds.size.height
            print("\(scrollView.contentOffset.y)  \(scrollOffsetThreshold)")
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && collectionView.isDragging) {
                isFetching = true
                fetchMore()
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        movies = []
        s = searchBar.text!
        page = 1
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchData(s: self.s, page: self.page)
            self.cacheImages()
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.collectionView.reloadData()
            }
            
        }
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! MovieCollectionCell
        let indexPath = collectionView.indexPath(for: cell)
        let movie = movies[indexPath!.row]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        detailViewController.hidesBottomBarWhenPushed = true
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
