//
//  Extensions.swift
//  NewsFeed
//
//  Created by Deepak Sahu on 07/08/18.
//  Copyright © 2018 Deepak Sahu. All rights reserved.
//

import UIKit
import MBProgressHUD

extension MBProgressHUD
{
    class func showTextMessage(message:String, adddedTo:UIView) -> Void {
        let hud:MBProgressHUD = MBProgressHUD.showAdded(to: adddedTo, animated: true)
        hud.bezelView.backgroundColor = .black;
        hud.contentColor = .white;
        hud.mode = .text;
        hud.label.text = message;
        hud.label.numberOfLines = 5;
        hud.offset = CGPoint(x: 0, y: MBProgressMaxOffset);
        hud.hide(animated: true, afterDelay: 2.0)
    }
}
