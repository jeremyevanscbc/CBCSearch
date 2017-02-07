//
//  LineupCollectionViewDelegate.swift
//  Pods
//
//  Created by Jeremy Evans on 2017-01-30.
//
// Test Viviane

import Foundation

public  protocol LineupModel {
    var title : String { get set }
    var imageURL : URL? { get set }
    var date : Date { get set }
    var flag : String {get set}
}
    
extension LineupModel {
    var imageURL : URL? {return URL(string:"https://maps.googleapis.com/maps/api/distancematrix/json?")}

}

public struct LineupItemModel : LineupModel {
    
    public var title: String
    public var imageURL: URL?
    public var date : Date
    public var flag : String
    
    public init(title:String) {
        self.title = title
        self.date = Date()
        self.flag = ""
    }
   
    public init() {
        self.title = "No Title"
        self.date = Date()
        self.flag = "Breaking"
    }
    
    public init?(title:String, imageUrl: URL?, updatedDate:Date, flag : String) {
        guard !title.isEmpty && !flag.isEmpty else {
            return nil
        }
        self.title = title
        self.imageURL = imageUrl
        self.date = updatedDate
        self.flag = flag
    }
}
