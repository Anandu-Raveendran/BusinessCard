//
//  UserDataDao.swift
//  BusinessCard
//
//  Created by Nandu on 2021-10-25.
//

import Foundation

struct UserDataDao :Codable{
    var name:String
    var phone:String
    var job_title:String
    var company_website:String
    var linkedIn:String
    var email:String
    var uid:String
    
    init(uid:String, email:String, name:String, phone:String, job:String, company:String, linkedIn:String) {
        self.uid = uid
        self.email = email
        self.name = name
        self.phone = phone
        self.company_website = company	
        self.job_title = job
        self.linkedIn = linkedIn
    }
    init(contact:Contact){
        self.uid = contact.uid!
        self.name = contact.name!
        self.phone = contact.phone!
        self.job_title = contact.job_title!
        self.company_website = contact.companyUrl!
        self.linkedIn = contact.linkedInUrl!
        self.email = contact.email!
            
    }
    
    init() {
        self.uid = ""
        self.email = ""
        self.name = ""
        self.phone = ""
        self.company_website = ""
        self.job_title = ""
        self.linkedIn = ""
    }
    
}
