import UIKit
import CoreData

class DataSource {
    
    public var context:NSManagedObjectContext! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var contacts:[Contact]? = nil

    func fetchContacts(filter:String) -> [Contact]?{
        let request = Contact.fetchRequest() as NSFetchRequest<Contact>
        if(!filter.isEmpty){
            request.predicate = NSPredicate(format: "name CONTAINS[c] %@ OR phone CONTAINS[c] %@ OR email CONTAINS[c] %@ OR companyUrl CONTAINS[c] %@ OR job_title CONTAINS[c] %@", filter, filter, filter, filter, filter)
        }
        do{
            contacts = try context.fetch(request)
            print("Got local data of Count: \(String(describing: contacts?.count)) with filter \(filter)")
        } catch{
            print("Error getting contacts data with filter \(filter)")
        }
        return contacts
    }
    
    func fetchContact(uid:String) -> Contact?{
        let request = Contact.fetchRequest() as NSFetchRequest<Contact>
        request.predicate = NSPredicate(format: "uid == %@ ", uid)
       
        do{
            contacts = try context.fetch(request)
            print("Got local data of Count: \(String(describing: contacts?.count)) with uid \(uid)")
        } catch{
            print("Error getting contacts data with uid \(uid)")
        }
        return contacts?[0]
    }
    
    func saveContact(userDataDao:UserDataDao, image:Data?)->Bool{
        return saveContact(uid: userDataDao.uid, name: userDataDao.name, phone: userDataDao.phone, email: userDataDao.email, companyUrl: userDataDao.company_website, linkedIn: userDataDao.linkedIn, job_title: userDataDao.job_title, image: image)
    }
    
    func saveContact(uid:String, name:String, phone:Int64, email:String, companyUrl:String, linkedIn:String, job_title:String, image:Data?)->Bool{
        
        //check if already exists in contactlist
        contacts?.forEach{ ele in
            if(ele.uid == uid){
                print("Contact already in list")
                return
            
            }
        }
        
        
        let data = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context) as! Contact
       
        data.uid = uid
        data.name = name
        data.email = email
        data.phone = phone
        data.linkedInUrl = linkedIn
        data.companyUrl = companyUrl
        data.job_title = job_title
        data.image = image
        
        do{
            try context.save()
            print("Data saved successfully \(String(describing: data.email))")
            return true
        } catch{
            print("Error saving data")
            return false
        }
    }
    
    func delete(data:Contact, index:Int) -> Bool{
        contacts?.remove(at: index)
        context?.delete(data)
        do{
            try context?.save()
            print("Delete success")
            return true
        }catch{
            print("Error while Delete data")
            return false
        }
    }
    func update(data:Contact, uid:String){
        if let index = contacts?.firstIndex(where: {$0.uid == uid}){
            update(data: data, index: index)
        }
    }
    func update(data:Contact, index:Int) -> Bool{
        print("Update contact at index \(index) contact size \(contacts?.count)")
        contacts?[index] = data
        do{
            try context?.save()
            print("Update success")
            return true
        }catch{
            print("Error while updating data")
            return false
        }
    }
}
