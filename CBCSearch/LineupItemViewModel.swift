//
//  LineupDataDelegate.swift
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

}

// MARK:- UICollectionView DataSource

extension LineupItemViewModel : UICollectionViewDataSource {


    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.gray
        return cell
    }
}

// MARK:- UICollectionViewDelegate Methods

extension LineupItemViewModel : UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
        
//        let cell = collectionView.cellForItem(at indexPath: indexPath) 
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        highlightCell(cell, flag: true)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        highlightCell(cell, flag: false)
    }
}

func highlightCell(_ cell: UICollectionViewCell, flag: Bool) {
    if flag {
        cell.contentView.backgroundColor = UIColor.magenta
    } else {
        cell.contentView.backgroundColor = nil
    }
}

// MARK:- UICollectioViewDelegateFlowLayout methods

extension LineupItemViewModel: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (UIScreen.main.bounds.width-15)/2
        return CGSize(width : length, height : length);
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

func handleImageDownloadCompletion(notification : NSNotification) {
    var lineupItemViewModelInstance : LineupItemViewModel? = LineupItemViewModel()
    if lineupItemViewModelInstance != nil  {
        let userInfo:Dictionary<String,String?> = notification.userInfo as! Dictionary<String,String?>
        let id = userInfo["id"]
    }
}

