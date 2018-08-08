//
//  DetailViewController.swift
//  NewsFeed
//
//  Created by Deepak Sahu on 07/08/18.
//  Copyright © 2018 Deepak Sahu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = article {
            if let label = detailDescriptionLabel {
                label.text = detail.title ?? ""
            }
        }
    }
    
//    @objc
//    func backButtonPressed(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        
//        let backButton = UIBarButtonItem(image: UIImage(named: "back-button"), style: .plain, target: self, action: #selector(backButtonPressed(_:)))
//        self.navigationItem.leftBarButtonItem = backButton
//        self.navigationController?.navigationItem.hidesBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var article: Article? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

