//
//  RecordedAudio.swift
//  Pitch Perfect 2
//
//  Created by Yu Sun on 3/31/15.
//  Copyright (c) 2015 Yu Sun. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    // model class for our recorded file to be passed from 1 controller to another
    //var filePathUrl:NSURL! //type is NSURL
    //var title:String! //type is string
    
    let filePathUrl:NSURL!
    let title:String!
    
    init(filePathUrl:NSURL!,title:String!){
        self.filePathUrl=filePathUrl
        self.title = title
    }
}