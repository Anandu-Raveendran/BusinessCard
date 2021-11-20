//
//  UserDataDao.swift
//  BusinessCard
//
//  Created by Nandu on 2021-10-25.
//

import Foundation

class UserDataDao :NSObject{
    var name:String
    var phone:Int64
    var job_title:String
    var company_website:String
    var linkedIn:String
    var email:String
    var uid:String
    
    init(uid:String, email:String, name:String, phone:Int64, job:String, company:String, linkedIn:String) {
        self.uid = uid
        self.email = email
        self.name = name
        self.phone = phone
        self.company_website = company	
        self.job_title = job
        self.linkedIn = linkedIn
    }
    
    override init() {
        self.uid = ""
        self.email = ""
        self.name = ""
        self.phone = 0
        self.company_website = ""
        self.job_title = ""
        self.linkedIn = ""
    }
    
}
