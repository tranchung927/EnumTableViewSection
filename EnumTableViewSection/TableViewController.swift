//
//  TableViewController.swift
//  EnumTableViewSection
//
//  Created by Chung Sama on 7/31/17.
//  Copyright © 2017 Chung Sama. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    enum TableViewSection: Int {
        case action = 0, comedy, drama, indie, total
    }
    
    // This is size of our header section that we will use later on
    let sectionHeaderHeight: CGFloat = 50
    
    // Data variable to track our sorted data.
    var data = [TableViewSection: [[String: String]]]()
    
    let MovieData = [
        ["title": "Jason Bourne", "cast": "Matt Damon, Alicia Vikander, Julia Stiles", "genre": "action"],
        ["title": "Suicide Squad", "cast": "Margot Robbie, Jared Leto, Will Smith", "genre": "action"],
        ["title": "Star Trek Beyond", "cast": "Chris Pine, Zachary Quinto, Zoe Saldana", "genre": "action"],
        ["title": "Deadpool", "cast": "Ryan Reynolds, Morena Baccarin, Gina Carano", "genre": "action"],
        ["title": "London Has Fallen", "cast": "Gerard Butler, Aaron Eckhart, Morgan Freeman, Angela Bassett", "genre": "action"],
        ["title": "Ghostbusters", "cast": "Kate McKinnon, Leslie Jones, Melissa McCarthy, Kristen Wiig", "genre": "comedy"],
        ["title": "Central Intelligence", "cast": "Dwayne Johnson, Kevin Hart", "genre": "comedy"],
        ["title": "Bad Moms", "cast": "Mila Kunis, Kristen Bell, Kathryn Hahn, Christina Applegate", "genre": "comedy"],
        ["title": "Keanu", "cast": "Jordan Peele, Keegan-Michael Key", "genre": "comedy"],
        ["title": "Neighbors 2: Sorority Rising", "cast": "Seth Rogen, Rose Byrne", "genre": "comedy"],
        ["title": "The Shallows", "cast": "Blake Lively", "genre": "drama"],
        ["title": "The Finest Hours", "cast": "Chris Pine, Casey Affleck, Holliday Grainger", "genre": "drama"],
        ["title": "10 Cloverfield Lane", "cast": "Mary Elizabeth Winstead, John Goodman, John Gallagher Jr.", "genre": "drama"],
        ["title": "A Hologram for the King", "cast": "Tom Hanks, Sarita Choudhury", "genre": "drama"],
        ["title": "Miracles from Heaven", "cast": "Jennifer Garner, Kylie Rogers, Martin Henderson", "genre": "drama"],
        ]
    var isSelectionHeaderSection: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        sortData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // When generating sorted table data we can easily use our TableViewSection to make look up simple and easy to read.
    func sortData() {
        data[.action] = MovieData.filter({ $0["genre"] == "action"})
        data[.comedy] = MovieData.filter({ $0["genre"] == "comedy"})
        data[.drama] = MovieData.filter({ $0["genre"] == "drama"})
        data[.indie] = MovieData.filter({ $0["genre"] == "indie"})
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return TableViewSection.total.rawValue
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let tableSection  = TableViewSection(rawValue: section), let movieData = data[tableSection], movieData.count > 0 {
            return sectionHeaderHeight
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeaderSection = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionHeaderHeight))
        viewHeaderSection.backgroundColor = UIColor.gray
        
        let titleSection = UILabel(frame: CGRect(x: sectionHeaderHeight+15, y: 0, width: tableView.bounds.width/4, height: sectionHeaderHeight))
        titleSection.font = UIFont.boldSystemFont(ofSize: 15)
        titleSection.textColor = UIColor.black
        titleSection.backgroundColor = UIColor.blue
        titleSection.textAlignment = .center
        
        let imageSection = UIImageView(frame: CGRect(x: 10, y: 0, width: sectionHeaderHeight, height: sectionHeaderHeight))
        imageSection.layer.borderWidth = 0.3
        imageSection.layer.borderColor = UIColor.blue.cgColor
        imageSection.layer.cornerRadius = imageSection.bounds.width * 0.5
        imageSection.clipsToBounds = true
        
        let buttonSection = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionHeaderHeight))
        buttonSection.backgroundColor = UIColor.clear
        buttonSection.addTarget(self, action: #selector(setRowInSection), for: .touchUpInside)
        
        if let tableSection = TableViewSection(rawValue: section) {
            switch tableSection {
            case .action:
                imageSection.image = #imageLiteral(resourceName: "Car wash")
                titleSection.text = "Action"
            case .comedy:
                imageSection.image = #imageLiteral(resourceName: "Allowance")
                titleSection.text = "Comedy"
            case .drama:
                imageSection.image = #imageLiteral(resourceName: "Doctor")
                titleSection.text = "Drama"
            case .indie:
                imageSection.image = #imageLiteral(resourceName: "Gifts")
                titleSection.text = "Indie"
            default:
                titleSection.text = ""
            }
        }
        
        viewHeaderSection.addSubview(titleSection)
        viewHeaderSection.addSubview(imageSection)
        viewHeaderSection.addSubview(buttonSection)
        
        if isSelectionHeaderSection {
            guard let tableSection = TableViewSection(rawValue: section) else { return nil }
            
            if data[tableSection] != nil, data[tableSection]!.count != 0 {
                var willRemoveIndexPaths: [IndexPath] = []
                for row in 1...data[tableSection]!.count {
                    let willRemoveIndexPath = IndexPath(row: row, section: section)
                    willRemoveIndexPaths.append(willRemoveIndexPath)
                }
                data[tableSection]?.removeAll()
                self.tableView.beginUpdates()
                tableView.deleteRows(at: willRemoveIndexPaths, with: .fade)
                self.tableView.endUpdates()
            }
        }
        
        return viewHeaderSection
    }
    
    @objc func setRowInSection() {
        isSelectionHeaderSection = !isSelectionHeaderSection
        print(isSelectionHeaderSection)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let tableViewSection = TableViewSection(rawValue: section), let movieData = data[tableViewSection] {
            return movieData.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let tableSection = TableViewSection(rawValue: indexPath.section), let movie = data[tableSection]?[indexPath.row] {
            cell.textLabel?.text = movie["title"]
            cell.detailTextLabel?.text = movie["cast"]
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
