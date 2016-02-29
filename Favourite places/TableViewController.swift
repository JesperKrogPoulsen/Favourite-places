//
//  TableViewController.swift
//  Favourite places
//
//  Created by Jesper Poulsen on 24/02/16.
//  Copyright © 2016 krogpoulsen. All rights reserved.
//

import UIKit

var locations = [Dictionary<String, String>()]
var selectedLocation = -1

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if NSUserDefaults.standardUserDefaults().objectForKey("locations") != nil {
            locations = NSUserDefaults.standardUserDefaults().objectForKey("locations") as! [Dictionary<String, String>]
        }
        if locations.count == 1 {
            locations.removeAtIndex(0)
            locations.append(["name":"Taj Mahal","lat":"27.175277","long":"78.042128"])
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("id", forIndexPath: indexPath)

        cell.textLabel?.text = locations[indexPath.row]["name"]
        return cell
    }

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedLocation = indexPath.row
        return indexPath
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "new" {
            selectedLocation = -1
        }
    }

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
}
