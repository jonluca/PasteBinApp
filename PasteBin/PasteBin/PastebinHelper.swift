//
//  PostHelper.swift
//  PasteBin
//
//  Created by Henrik Gustavii on 04/04/2018.
//  Copyright © 2018 JonLuca De Caro. All rights reserved.
//

import Foundation
import AFNetworking

class PastebinHelper {
    
    // Save and load file/items/list methodologies...
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("SavedList.plist")
    
    func saveSavedListItems(savedList: [String]) {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(savedList)
            try data.write(to: dataFilePath!, options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array!")
        }
    }
    
    func loadSavedListItems() -> [String] {
        var savedList: [String] = []
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                savedList = try decoder.decode([String].self, from: data)
            } catch {
                print("Error decoding item array!")
            }
        }
        
        return savedList
        
    }
    
    //credit to http://stackoverflow.com/questions/39558868/check-internet-connection-ios-10
    //Simple check if internet is available
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
}
