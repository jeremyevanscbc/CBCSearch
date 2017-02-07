//
//  LineupItemViewModel.swift
//  CBCSearch
//
//  Created by Jeremy Evans on 2017-01-31.
//  Copyright © 2017 cbc. All rights reserved.
//

import Foundation
import UIKit

class LineupItemViewModel : NSObject {
    fileprivate let reuseIdentifier = "LineupItemCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 32.0, left: 16.0, bottom: 32.0, right: 16.0)
    var lineupItems:[LineupModel] = []  //lineupItems = [LineupModel]()
    
    /*
    // MARK:- Populate Data from json
    func populateData(items: Array<>) {
        if let path = NSBundle.mainBundle().pathForResource("", ofType: "") {
            if let dictArray = NSArray(contentsOfFile: path) {
                for item in dictArray {
                    if let dict = item as? NSDictionary {
                        let name = dict["name"] as! String
                        let group = dict["section"] as! String
                        if !groups.contains(group){
                            groups.append(group)
                        }
                        sections.append(section)
                    }
                }
            }
        }
    }

    func numberOfSections() -> Int {
        return 1
    }

    func numbeOfItemsInEachSection(index: Int) -> Int {
        return lineupItems.count
    }
    */
    
}
