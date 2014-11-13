//
//  Parser.swift
//  ParserJson
//
//  Created by Valerio Ferrucci on 11/11/14.
//  Copyright (c) 2014 Valerio Ferrucci. All rights reserved.
//

import Foundation

enum ReaderResult {
    case Value(NSData)
    case Error(NSError)
}

class Parser {

    // the reader is a func that receive a completion as parameter (called on finish)
    typealias ParserReader = (ReaderResult->())->()
    typealias ParserNewPhoto = (Photo)->()
    
    func handleError(error : NSError) {
        println(error.localizedDescription);
    }
    
    func handleData(data : NSData, parserNewPhoto : ParserNewPhoto) {

        var error : NSError?
        let json : AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error)

        if let _json = json as? [AnyObject] {
            
            for jsonItem in _json {
                
                if let _jsonItem = jsonItem as? [String: AnyObject] {
         
                    let titolo : AnyObject? = _jsonItem["titolo"]
                    let autore : AnyObject? = _jsonItem["autore"]
                    let latitudine : AnyObject? = _jsonItem["latitudine"]
                    let longitudine : AnyObject? = _jsonItem["longitudine"]
                    let data : AnyObject? = _jsonItem["data"]
                    let descr : AnyObject? = _jsonItem["descr"]

                    if let _titolo = titolo as String? {
                        if let _autore = autore as? String {
                            if let _latitudine = latitudine as? Double {
                                if let _longitudine = longitudine as? Double {
                                    if let _data = data as? String {
                                        if let _descr = descr as? String {
                                            
                                            let photo = Photo(titolo: _titolo, autore: _autore, latitudine: _latitudine, longitudine: _longitudine, data: _data, descr: _descr)
                                            
                                            parserNewPhoto(photo)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func start(reader : ParserReader, parserNewPhoto : ParserNewPhoto) {
        
        // read the file
        reader() { (result : ReaderResult)->() in
            
            switch result {
            case let .Error(error):
                self.handleError(error)
                
            case let .Value(fileData):
                self.handleData(fileData, parserNewPhoto)
                
            }
        }
    }
}