//
//  VideoLineupItemModel.swift
//  Pods
//
//  Created by Jeremy Evans on 2017-01-31.
//
//

import Foundation

protocol VideoModel : LineupModel {
    var videoURL :URL { get set}
}

struct VideoItemModel : VideoModel {
    var title: String
    var imageURL: URL?
    var date : Date
    var videoURL :URL
    var flag : String
}

