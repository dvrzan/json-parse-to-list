//
//  Product.swift
//  json-parse-to-list
//
//  Created by Danijela Vrzan on 2019-09-14.
//  Copyright © 2019 Danijela Vrzan. All rights reserved.
//
import UIKit

struct Product : Decodable {
    
    var name : String
    var cashBack : Double
    var imageUrl : String
    
}

//Wrapper
struct Products : Decodable {
    var batchId : Int
    var offers : [Product]
}
