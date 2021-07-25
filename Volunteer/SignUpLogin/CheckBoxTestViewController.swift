//
//  CheckBoxTest.swift
//  Volunteer
//
//  Created by Matthew Daniele on 7/25/21.
//

import UIKit
import FirebaseDatabase


class CheckBoxTestViewController:UIViewController, UITableViewDataSource {
    @IBOutlet weak var CheckBoxTableView: UITableView!
    let populate = Populate()
    var Tags = [String]()
    var selectedRows = [IndexPath]()


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CheckBoxTableView.dataSource = self

        let userRef = Database.database().reference().child("interest-tags")

        self.populate.fetchData(dbref:userRef) { tags in
            print("tags_values", tags.values)
            print("tags_count", tags.count)
            for tag in tags{
                self.Tags.append(tag.value as! String)
            }
//            self.Tags.
            print("TAGSOBJ", self.Tags)
            print("TAGSCOUNT", self.Tags.count)

            self.CheckBoxTableView.reloadData()

        }
        
    }
    
    func getSelectedTags() -> [String]{
        //append values in rows to
        var selectedTags = [String]()
        for row in selectedRows{
            print(Tags[row[1]])
            selectedTags.append(Tags[row[1]])
        }
        return selectedTags
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckBoxCell", for: indexPath)

//        cell.textLabel?.text = self.Tags[indexPath.section]
//
//        if let btnChk = cell.contentView.viewWithTag(2) as? UIButton {
//            btnChk.addTarget(self, action: #selector(checkboxClicked(_ :)), for: .touchUpInside)
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckBoxCell", for: indexPath)

        if let lbl = cell.contentView.viewWithTag(1) as? UILabel {
            lbl.text = Tags[indexPath.row]
        }
        
        if let btnChk = cell.contentView.viewWithTag(2) as? UIButton {
            btnChk.addTarget(self, action: #selector(checkboxClicked(_ :)), for: .touchUpInside)
            btnChk.isSelected = false
            if selectedRows.contains(indexPath) {
              btnChk.isSelected = true
            }
        }
        
        return cell

    }
    
    @objc func checkboxClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let point = sender.convert(CGPoint.zero, to: CheckBoxTableView)
        print("point",point)

        let indxPath = CheckBoxTableView.indexPathForRow(at: point)!
        print("indxPath",indxPath)
        if selectedRows.contains(indxPath) {
            selectedRows.remove(at: selectedRows.firstIndex(of: indxPath)!)
//            selectedRows.remove(at: sele)
        } else {
            selectedRows.append(indxPath)

        }
        CheckBoxTableView.reloadRows(at: [indxPath], with: .automatic)
        print(getSelectedTags())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
