//
//  ConfigLoader.swift
//  Finicky
//
//  Created by John Sterling on 07/06/15.
//  Copyright (c) 2015 John Sterling. All rights reserved.
//

import Foundation
import JavaScriptCore

var FNConfigPath: String = "~/.finicky.js"

class FNConfigLoader {
    
    var configPaths: NSMutableSet;
    
    init() {
        self.configPaths = NSMutableSet()
    }
    
    func resetConfigPaths() {
        FinickyAPI.reset()
        configPaths.removeAllObjects()
        configPaths.addObject(FNConfigPath)
    }
    
    func reload() {
        self.resetConfigPaths()
        var error:NSError?
        let filename: String = FNConfigPath.stringByStandardizingPath
        var config: String? = String(contentsOfFile: filename, encoding: NSUTF8StringEncoding, error: &error)
        
        if config == nil {
            println("Config file could not be read or found")            
            return
        }
        
        if let theError = error {
            print("\(theError.localizedDescription)")
        }
        
        var ctx: JSContext = JSContext()
        
        ctx.exceptionHandler = {
            context, exception in
            println("JS Error: \(exception)")
        }
    
        self.setupAPI(ctx)
        ctx.evaluateScript(config!)
    }
    
    func setupAPI(ctx: JSContext) {
        ctx.setObject(FinickyAPI.self, forKeyedSubscript: "api")
        ctx.setObject(FinickyAPI.self, forKeyedSubscript: "finicky")
    }
}