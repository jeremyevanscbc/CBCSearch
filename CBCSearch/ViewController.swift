//
//  ViewController.swift
//  CBCSearch
//
//  Created by Jeremy Evans on 2017-01-31.
//  Copyright © 2017 cbc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: Properties
    var lineUpModel: LineupModel!
    var lineUpModelArray:[LineupModel] = []
    var searchTerm = ""
    var searchMode = "ByRelevance"
    var query = ""
    var topStoryArray:[String] = []
    
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        prepareLayout()
        parseJSONTopStory()
    }
    
    
    //MARK: Prepare Layout
    
    func prepareLayout(){
        self.segmentedControl.isHidden = true
        self.noResultsLabel.isHidden = true
        self.view.bringSubview(toFront: self.progressIndicator)
        self.progressIndicator.isHidden = true
        self.searchBar.barTintColor = UIColor.red
        self.searchBar.placeholder = "Search"
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
    func parseJSONTopStory(){
        self.topStoryArray = []
        self.collectionView.isHidden = true
        self.tableView.isHidden = true
        self.noResultsLabel.isHidden = true
        self.progressIndicator.isHidden = false
        self.progressIndicator.startAnimating()
        let baseUrl = "https://api-gw-dev.radio-canada.ca/experimental-aggregate-content/v1/top-searches"
        let requestURL: URL = URL(string: baseUrl)!
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
                            if let term = article["term"] as? String {
                                self.topStoryArray.append(term)
                            }
                        }
                    }
                    DispatchQueue.main.async(execute: {
                        self.progressIndicator.stopAnimating()
                        self.progressIndicator.isHidden = true
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    })
                }
                catch {
                    print("error serializing JSON: \(error)")
                }
            }
            print(self.topStoryArray)
        }
        task.resume()
    }
    
    
    
    func parseJSON(){
        self.lineUpModelArray = []
        self.collectionView.isHidden = true
        self.tableView.isHidden = true
        self.noResultsLabel.isHidden = true
        self.progressIndicator.isHidden = false
        self.progressIndicator.startAnimating()
        let baseUrl = "https://api-gw.radio-canada.ca/aggregate-content/v1/items?q="
        
        if self.searchMode == "ByRelevance" {
            self.query = self.searchTerm
        } else {
            self.query = self.searchTerm + "&sortOrder=byRecency"
        }
        
        let encodedQuery = self.query.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        let requestURL: URL = URL(string: baseUrl + encodedQuery!)!
        print(requestURL)
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
                                        if let publishedDate = article["publishedAt"] as? Double {
                                            var lineupItem = LineupItemModel(title: title)
                                            let date = NSDate(timeIntervalSince1970: TimeInterval(publishedDate/1000))
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
                        self.progressIndicator.stopAnimating()
                        self.progressIndicator.isHidden = true

                        if self.lineUpModelArray.count == 0 {
                            self.noResultsLabel.isHidden = false
                            self.collectionView.isHidden = true
                            self.segmentedControl.isHidden = true
                        } else {
                            self.noResultsLabel.isHidden = true
                            self.collectionView.isHidden = false
                            self.collectionView.reloadData()
                        }
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
        
        let imageURL = self.lineUpModelArray[indexPath.row].imageURL
        if imageURL != nil {
            if let imageData = NSData(contentsOf: self.lineUpModelArray[indexPath.row].imageURL!) {
                cell.imageView.image = UIImage(data: imageData as Data)
            } else {
                cell.imageView.image = UIImage(named: "placeholder")
            }
        }
        else {
            cell.imageView.image = UIImage(named: "placeholder")
        }
        cell.titleLabel.text = self.lineUpModelArray[indexPath.row].title
        return cell
    }
    
    
    
    // MARK: TableView
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topStoryArray.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topStoryCell") as! TopStoriesTableViewCell
        cell.topStoryLabel.text = topStoryArray[indexPath.row]
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell = self.tableView.cellForRow(at: indexPath) as! TopStoriesTableViewCell!
        self.searchTerm = (cell?.topStoryLabel.text)!
        self.searchBar.text = (cell?.topStoryLabel.text)!
        parseJSON()
        self.searchBar.endEditing(true)
        self.segmentedControl.isHidden = false
        self.collectionView.isHidden = true
        self.tableView.isHidden = true
    }
    
    
    // MARK: SearchBar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchTerm = (searchBar.text?.lowercased())!
        parseJSON()
        self.searchBar.endEditing(true)
        self.segmentedControl.isHidden = false
        self.collectionView.isHidden = true
        self.tableView.isHidden = true
    }
    
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.segmentedControl.isHidden = true
        self.collectionView.isHidden = true
        self.tableView.isHidden = false
    }
    
    
    // MARK: Segmented Control
    
    @IBAction func handleSegmentedControl(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.searchMode = "ByRelevance"
            parseJSON()
        case 1:
            self.searchMode = "ByDate"
            parseJSON()
        default:
            break
        }
        
    }
    
}

