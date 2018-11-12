//
//  Movie.swift
//  Lab4
//
//  Created by Reis Sirdas on 3/8/17.
//  Copyright © 2017 sirdas. All rights reserved.
//

import UIKit

class Movie: NSObject, NSCoding {
    var title: String
    var imdbID: String
    var url: String
    var year: String = ""
    var plot: String = ""
    var runtime: String = ""
    var poster: UIImage?
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("movies")
    
    init?(title: String, imdbID: String, url: String, year: String, plot: String, runtime: String, poster: UIImage?) {
        
        self.title = title
        self.imdbID = imdbID
        self.url = url
        self.year = year
        self.plot = plot
        self.runtime = runtime
        self.poster = poster
    }

    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(imdbID, forKey: "imdbID")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(year, forKey: "year")
        aCoder.encode(plot, forKey: "plot")
        aCoder.encode(runtime, forKey: "runtime")
        aCoder.encode(poster, forKey: "poster")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: "title") as? String else {
            return nil
        }
        guard let imdbID = aDecoder.decodeObject(forKey: "imdbID") as? String else {
            return nil
        }
        let url = aDecoder.decodeObject(forKey: "url") as! String
        let year = aDecoder.decodeObject(forKey: "year") as! String
        let plot = aDecoder.decodeObject(forKey: "plot") as! String
        let runtime = aDecoder.decodeObject(forKey: "runtime") as! String
        let poster = aDecoder.decodeObject(forKey: "poster") as? UIImage
        
        // Must call designated initializer.
        self.init(title: title, imdbID: imdbID, url: url, year: year, plot: plot, runtime: runtime, poster: poster)
        
    }
}
