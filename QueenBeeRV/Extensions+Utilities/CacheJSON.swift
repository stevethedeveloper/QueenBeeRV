//
//  CacheJSON.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/5/23.
//

import Foundation

protocol CachableJSON {
    var cacheJSONFileName: String { get set }
    var cacheJSONHours: Int { get set }
}

// All JSON files get cached in documents folder
final public class CacheJSON {
    private var cacheFile: String
    private var cacheHours: Int

    init(cacheFile: String, cacheHours: Int) {
        self.cacheFile = cacheFile
        self.cacheHours = cacheHours
    }
    
    public func setFileName(_ cacheFile: String!) {
        self.cacheFile = cacheFile
    }
    
    public func cacheJSON(_ str: String) {
        let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        guard let fileURL = dir?.appendingPathComponent("\(cacheFile)LastLoad").appendingPathExtension("txt") else {
            return
        }
        
        do {
            try str.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            return
        }
        
        let defaults = UserDefaults.standard
        let currentTime = NSDate()
        defaults.set(currentTime, forKey: "\(cacheFile)LastLoad")
        
        return
    }
    
    public func getJSONString() -> String? {
        // Check last load time
        let defaults = UserDefaults.standard
//                defaults.set(nil, forKey: "\(cacheFile)LastLoad")
        let currentTime = NSDate() as Date
        if let lastBlogPostLoad = defaults.object(forKey: "\(cacheFile)LastLoad") as? Date {
            if currentTime > lastBlogPostLoad.addingTimeInterval(Double(cacheHours) * 60 * 60) {
                return nil
            }
        } else {
            return nil
        }

        let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        guard let fileURL = dir?.appendingPathComponent(cacheFile).appendingPathExtension("txt") else {
            return nil
        }

        var str: String? = nil
        
        do {
            str = try String(contentsOf: fileURL)
        } catch {
            return nil
        }
        
        return str ?? nil
    }
    
}
