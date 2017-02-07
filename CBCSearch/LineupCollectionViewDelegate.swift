//
//  LineupItemViewModel.swift
//  CBCSearch
//
//  Created by Jeremy Evans on 2017-01-31.
//  Copyright © 2017 cbc. All rights reserved.
//

import Foundation
import UIKit

extension LineupViewController  {
    fileprivate static var reuseIdentifier = "LineupItemCell"
    fileprivate static var sectionInsets = UIEdgeInsets(top: 32.0, left: 16.0, bottom: 32.0, right: 16.0)
}

// MARK:- UICollectionView DataSource

extension LineupViewController : UICollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lineUpModelArray.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LineupViewController.reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.gray
        return cell
    }
}

// MARK:- UICollectionViewDelegate Methods

extension LineupViewController : UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
        
//        let cell = collectionView.cellForItem(at indexPath: indexPath) 
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LineupViewController.reuseIdentifier, for: indexPath)

        highlightCell(cell, flag: true)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LineupViewController.reuseIdentifier, for: indexPath)
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

extension LineupViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (UIScreen.main.bounds.width-15)/2
        return CGSize(width : length, height : length);
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return LineupViewController.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LineupViewController.sectionInsets.left
    }
}

func handleImageDownloadCompletion(notification : NSNotification) {
    var lineupItemViewModelInstance : LineupItemViewModel? = LineupItemViewModel()
    if lineupItemViewModelInstance != nil  {
        let userInfo:Dictionary<String,String?> = notification.userInfo as! Dictionary<String,String?>
        let id = userInfo["id"]
    }
}

