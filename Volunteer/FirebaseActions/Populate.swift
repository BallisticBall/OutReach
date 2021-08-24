//
//  Populate.swift
//  Volunteer
//
//  Created by Matthew Daniele on 7/24/21.
//

import Foundation
import Firebase
import FirebaseDatabase

//MARK: Populate Class
class Populate {

    let educationLevel = ["High School Graduate", "Some College", "Associate Degree", "Bachelor's Degree", "Master's Degree", "Higher Degree"]

    let interestTags = ["Animal Welfare", "Childcare", "Community Development", "Education", "Elderly care", "Health/Wellness", "Home Improvement", "Other", "Poverty/Hunger", "Religion", "Technology","Testing123"]

    // 
    let ref = Database.database().reference()
    init() {
        
    }
    
    func fetchData2(completion: @escaping(([String:Any]) ->())){
        
        var data : [String:Any] = [:]
        
            ref.child("interest-tags").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    let value = snap.value
                    print("key = \(key)  value = \(value!)")
                    data.updateValue( value!, forKey: key)

                }
            }
            else {
                print("No data available")

            }
            completion(data)
        }
        
    }
    //Closures example
    func fetchData(dbref: DatabaseReference,completion: @escaping(([String:Any]) ->())){
        
        var data : [String:Any] = [:]
        
        dbref.getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    let value = snap.value
                    data.updateValue( value!, forKey: key)

                }
            }
            else {
                print("No data available")

            }
            completion(data)
        }
        
    }

    
    func fetchUsers(){
        let userRef = ref.child("users")
        
        fetchData(dbref:userRef) { tags in
            for tag in tags{
                print("uid",tag.key)
                let values = tag.value as! NSDictionary
                for value in values{
                    print(value.key, value.value)
                }
            }
        }
    }
    
    func fetchTags(){
        let userRef = ref.child("interest-tags")
        fetchData(dbref:userRef) { tags in
            print(tags)
        }
    }
    
    func addTags(){
        
    }

    func test(){
        print("users")
        fetchUsers()
        print("\n\n\n\n\n")
        print("tags")
        fetchTags()
    }
}
