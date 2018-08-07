//
//  MasterViewController.swift
//  NewsFeed
//
//  Created by Deepak Sahu on 07/08/18.
//  Copyright © 2018 Deepak Sahu. All rights reserved.
//

import UIKit
import MBProgressHUD

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var articles = [Article]()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News Feed"
        // Do any additional setup after loading the view, typically from a nib.

//        navigationItem.leftBarButtonItem = editButtonItem
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        navigationItem.rightBarButtonItem = addButton

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        let hud:MBProgressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        RestManager.request(withPath: APIHandler.Path.MostViewed, method: APIHandler.Method.GET, urlParams: nil, additionalHeaders: nil, from: nil, onSuccess: { (resposne) in
            //RestResponse
            self.articles = (resposne?.results)!
            self.tableView.reloadData()
            hud.hide(animated: true)
        }) { (error) in
             MBProgressHUD.showTextMessage(message: "Oops, Unexpected Error", adddedTo: self.view)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @objc
//    func insertNewObject(_ sender: Any) {
//        articles.insert(NSDate(), at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
//    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object:Article = self.articles[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}

//UITableViewDataSource
extension MasterViewController {
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ArticleCell = (tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell)!

        let object:Article = self.articles[indexPath.row]
        cell.txtTitle!.text = object.title ?? ""
        cell.txtByline!.text = object.byline ?? ""
        return cell
    }
}

