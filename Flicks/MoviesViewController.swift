//
//  MoviesViewController.swift
//  Flicks
//
//  Created by ximin_zhang on 8/1/16.
//  Copyright © 2016 ximin_zhmovieDetailViewControllerang. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, BCOVPlaybackControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var connNetworkErrorImage: UIImageView!
    @IBOutlet weak var connStatusBar: UIView!
    @IBOutlet weak var viewSelectorControl: UISegmentedControl!
    @IBOutlet weak var selectorBarView: UIView!

    
    var movies: [NSDictionary]? // To make it optional
    var filteredMovies: [NSDictionary]? // For search display
    var endpoint: String!
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        selectorBarView.layer.shadowColor = UIColor.blackColor().CGColor
        selectorBarView.layer.shadowOpacity = 1
        selectorBarView.layer.shadowOffset = CGSizeZero
        selectorBarView.layer.shadowRadius = 10
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        let imageView = UIImageView(image: UIImage(named: "AppBkg.jpg"))
        
        let viewStyle = viewSelectorControl.selectedSegmentIndex
        switch viewStyle
        {
        case 0:
            tableView.insertSubview(refreshControl, atIndex: 0)
            collectionView.insertSubview(refreshControl, atIndex: 0)
            self.tableView.backgroundView = imageView
        case 1:
            collectionView.insertSubview(refreshControl, atIndex: 0)
            // self.collectionView.backgroundView = imageView
            
        default:
            break;
        }
        
        // Search bar
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        

        // Do any additional setup after loading the view.
        self.refreshControlAction(refreshControl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if searchController.active && searchController.searchBar.text != ""
        {
            if let filteredMovies = filteredMovies
            {
                return filteredMovies.count
            }else{
                return 0
            }
        }else
        {
            if let movies = movies
            {
                return movies.count
            }else{
                return 0
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        var movie: NSDictionary
        
        if searchController.active && searchController.searchBar.text != "" {
            movie = filteredMovies![indexPath.row]
        } else {
            movie = movies![indexPath.row]
        }
        
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let rating = movie["vote_average"] as! Double
        
        if let posterPath = movie["poster_path"] as? String {
            /* Without fade in
            let baseUrl = "http://image.tmdb.org/t/p/w342"
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterView.setImageWithURL(imageUrl!)
             */
            
            // Load image with fade in effect
            let baseUrl = "http://image.tmdb.org/t/p/w342"
            let imageUrl = NSURL(string: baseUrl + posterPath)
            let imageRequest = NSURLRequest(URL: imageUrl!)
            cell.posterView.setImageWithURLRequest(
                imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        cell.posterView.alpha = 0.0
                        cell.posterView.image = image
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            cell.posterView.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        cell.posterView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
                    print("Failed in loading")
            })
        }
        
        // Text shadow for movie title
        cell.titleLabel.text = title
        cell.titleLabel.layer.shadowOpacity = 1.0
        cell.titleLabel.layer.shadowRadius = 0.0
        cell.titleLabel.layer.shadowOffset = CGSizeMake(0.0, -2.0)
        
        cell.ratingLabel.text = "Rating: " + String(rating)
        cell.overviewLabel.text = overview
        cell.overviewLabel.sizeToFit()
        cell.backgroundColor = UIColor.clearColor()
        
        // deselect cell highlight for selection
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    // Collection View Step 1
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        if searchController.active && searchController.searchBar.text != ""
        {
            if let filteredMovies = filteredMovies
            {
                return filteredMovies.count
            }else{
                return 0
            }
        }else
        {
            if let movies = movies
            {
                return movies.count
            }else{
                return 0
            }
        }
    }
    
    
    // Collection View Step 2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != ""
        {
            if let filteredMovies = filteredMovies
            {
                return filteredMovies.count
            }else{
                return 0
            }
        }else
        {
            if let movies = movies
            {
                return movies.count
            }else{
                return 0
            }
        }
    }
    
    // Collection View Step 3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCollectionViewCell", forIndexPath: indexPath) as! MovieCollectionViewCell
        
        // Configure the cell
        var movie: NSDictionary
        if searchController.active && searchController.searchBar.text != "" {
            movie = filteredMovies![indexPath.row]
        } else {
            movie = movies![indexPath.row]
        }
        
        let title = movie["title"] as! String
        // let overview = movie["overview"] as! String
        let rating = movie["vote_average"] as! Double
        
        if let posterPath = movie["poster_path"] as? String {
            let baseUrl = "http://image.tmdb.org/t/p/w342"
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterImage.setImageWithURL(imageUrl!)
        }
        
        cell.titleLabel.text = title
        // cell.titleLabel.sizeToFit()
        cell.ratingLabel.text = String(rating)
        switch rating {
        case 0.0 ... 7.49:
            cell.ratingLabel.backgroundColor = UIColor(hue: 0.9833, saturation: 0.9, brightness: 0.7, alpha: 1.0)
            break
        case 7.5 ... 8.10:
            cell.ratingLabel.backgroundColor = UIColor(hue: 0.0889, saturation: 1, brightness: 0.98, alpha: 1.0)
            break
        case 8.11 ...   10.0:
            cell.ratingLabel.backgroundColor = UIColor(hue: 0.3167, saturation: 0.54, brightness: 0.62, alpha: 1.0)
            cell.ratingLabel.textColor = UIColor(hue: 0.9722, saturation: 0, brightness: 0.99, alpha: 1.0)
            break
        default:
            break
        }
//        cell.overviewLabel.text = overview
//        cell.overviewLabel.sizeToFit()
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let movie: NSDictionary
        let rowIndex: Int
        
        let viewStyle = viewSelectorControl.selectedSegmentIndex
        switch viewStyle
        {
        case 0:
            let cell = sender as! UITableViewCell
            rowIndex = (tableView.indexPathForCell(cell)?.row)!
            if searchController.active && searchController.searchBar.text != "" {
                movie = self.filteredMovies![rowIndex]
            } else {
                movie = self.movies![rowIndex]
            }
            let movieDetailViewController = segue.destinationViewController as! MoviesDetailViewController
            movieDetailViewController.movie = movie
        case 1:
            let cell = sender as! UICollectionViewCell
            rowIndex = (collectionView.indexPathForCell(cell)?.row)!
            if searchController.active && searchController.searchBar.text != "" {
                movie = self.filteredMovies![rowIndex]
            } else {
                movie = self.movies![rowIndex]
            }
            let movieDetailViewController = segue.destinationViewController as! MoviesDetailViewController
            movieDetailViewController.movie = movie
        default:
            break;
        }
        // let cell = sender as! UITableViewCell
        // let collectionCell = sender as! UICollectionViewCell
        // let indexPath = tableView.indexPathForCell(cell)
        // let movie = movies![rowIndex]
        
        // let movieDetailViewController = segue.destinationViewController as! MoviesDetailViewController
        // movieDetailViewController.movie = movie
    }
   
    @IBAction func onSelect(sender: AnyObject) {
        let viewStyle = viewSelectorControl.selectedSegmentIndex
        switch viewStyle
        {
        case 0:
            print("0")
            self.collectionView.hidden = true
            self.tableView.hidden = false
            self.tableView.reloadData()
        case 1:
            print("1")
            self.tableView.hidden = true
            self.collectionView.hidden = false
            self.collectionView.reloadData()
        default:
            break;
        }
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        connNetworkErrorImage.image = UIImage(named: "IconNetworkError")
        connStatusBar.hidden = true
        
        // ... Create the NSURLRequest (myRequest) ...
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)

        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask =
            session.dataTaskWithRequest(request, completionHandler:
                { (dataOrNil, response, error) in
                    if let data = dataOrNil {
                        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                            data, options:[]) as? NSDictionary {
                            
                            // Hide HUD once the network request comes back (must be done on main UI thread)
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            
                            
                            // print("response: \(responseDictionary)")
                            // parse data to dictionary
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            
                            let viewStyle = self.viewSelectorControl.selectedSegmentIndex
                            switch viewStyle
                            {
                            case 0:
                                // Reload the tableView now that there is new data
                                // self.tableView.reloadData()
                                self.collectionView.hidden = true
                                self.tableView.hidden = false
                                self.tableView.reloadData()
                            case 1:
                                // Reload the collectionView now that there is new data
                                self.tableView.hidden = true
                                self.collectionView.hidden = false
                                self.collectionView.reloadData()
                            default:
                                break;
                            }
                            
                            
                            // self.connStatusBar.hidden = true
                            // Tell the refreshControl to stop spinning
                            refreshControl.endRefreshing()
                        }
                    }else{
                        self.connStatusBar.hidden = false
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                    }
            });
        task.resume()
    }
    
    
    // Add for search
    func filterContentForSearchText(searchText: String, scope: String = "Title") {
        if movies != nil {
            self.filteredMovies = self.movies!.filter { movie in
                return movie["title"]!.lowercaseString.containsString(searchText.lowercaseString)
            }
        } else {
            self.filteredMovies = movies
        }
        
        tableView.reloadData()
    }
    
}


// Add for search
extension MoviesViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
