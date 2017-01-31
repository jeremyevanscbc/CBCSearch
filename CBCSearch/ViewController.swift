//
//  ViewController.swift
//  CBCSearch
//
//  Created by Jeremy Evans on 2017-01-31.
//  Copyright © 2017 cbc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    
    // MARK: Properties
    var lineUpModel: LineupModel!
    var lineUpModelArray:[LineupModel] = []
    var searchTerm = ""

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        searchController.searchBar.delegate = self
        searchBar.delegate = self
        prepareLayout()
//        parseJSON()
    }
    
    
    //MARK: Prepare Layout
    
    func prepareLayout(){
        searchBar.barTintColor = UIColor.red
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.red
        }
        for view in searchBar.subviews {
            for subview in view.subviews {
                if subview.isKind(of: UITextField.self) {
                    let textField: UITextField = subview as! UITextField
                    textField.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                        textField.textColor = UIColor.white
                    }
                }
            }
        }
  

    

    //MARK: Parse Json
    
    func parseJSON(){
        self.lineUpModelArray = []
        let baseUrl = "https://api-gw.radio-canada.ca/aggregate-content/v1/items?q="
        let query = self.searchTerm
        let requestURL: URL = URL(string: baseUrl + query)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    if let articles = json as? [[String: AnyObject]] {
                        for article in articles {
                            if let title = article["title"] as? String {
                                if let typeAttribute = article["typeAttributes"] as? [String:AnyObject] {
                                    if let picture = typeAttribute["imageSmall"] as? String {
                                        if let publishedDate = article["publishedAt"] as? Int {
                                            var lineupItem = LineupItemModel(title: title)
                                            let date = NSDate(timeIntervalSince1970: TimeInterval(publishedDate))
                                            lineupItem.date = date as Date
                                            let urlstring = picture
                                            let url = NSURL(string: urlstring)
                                            lineupItem.imageURL = url as URL?
                                            self.lineUpModelArray.append(lineupItem)
                                        }
                                    }
                                }
                            }
                        }
                    }
                        DispatchQueue.main.async(execute: {
                        self.collectionView.reloadData()
                    })
                }
                catch {
                    print("error serializing JSON: \(error)")
                }
            }
            print(self.lineUpModelArray)
        }
        task.resume()
    }

    
    // MARK: CollectionView 
    
    // Cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 30), height:100)
    }
    
    // Datasource

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lineUpModelArray.count
    }

    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionViewCell
        
        let unformattedDate = self.lineUpModelArray[indexPath.row].date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let formattedDate = formatter.string(from: unformattedDate as Date)
        cell.timeLabel.text = String(describing: formattedDate)
        
        cell.imageView.image = UIImage(data: try! Data(contentsOf: self.lineUpModelArray[indexPath.row].imageURL!))
        cell.titleLabel.text = self.lineUpModelArray[indexPath.row].title
        
        return cell
    }
    

    
    // MARK: SearchBar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchTerm = (searchBar.text?.lowercased())!
        parseJSON()
        self.searchBar.endEditing(true)

    }

    



    
}

