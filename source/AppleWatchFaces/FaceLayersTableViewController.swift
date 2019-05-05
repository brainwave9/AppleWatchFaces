//
//  FaceLayersTableViewController.swift
//  AppleWatchFaces
//
//  Created by Michael Hill on 5/4/19.
//  Copyright © 2019 Michael Hill. All rights reserved.
//

import UIKit

class FaceLayersTableViewController: UITableViewController {

    func addNewItem( layerType: FaceLayerTypes) {
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(row: SettingsViewController.currentFaceSetting.faceLayers.count-1, section: 0)], with: .automatic)
        self.tableView.endUpdates()
    }
    
    func redrawPreview() {
        NotificationCenter.default.post(name: SettingsViewController.settingsChangedNotificationName, object: nil, userInfo:["settingType":"itemReorder"])
    }
    
    func reload() {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //important only select one at a time
        self.tableView.allowsMultipleSelection = false
        self.tableView.allowsSelectionDuringEditing = true
        self.setEditing(true, animated: true)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return SettingsViewController.currentFaceSetting.faceLayers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = FaceLayerTableViewCell()
        
        let faceLayer = SettingsViewController.currentFaceSetting.faceLayers[indexPath.row]
        
        if (faceLayer.layerType == .ShapeRing) {
            cell = tableView.dequeueReusableCell(withIdentifier: "faceLayerShapeID", for: indexPath) as! FaceLayerShapeTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "LayerCellID", for: indexPath) as! FaceLayerTableViewCell
        }
    
        cell.titleLabel.text = FaceLayer.descriptionForType(faceLayer.layerType)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceRow = sourceIndexPath.row;
        let destRow = destinationIndexPath.row;
        
            let object = SettingsViewController.currentFaceSetting.faceLayers[sourceRow]
            SettingsViewController.currentFaceSetting.faceLayers.remove(at: sourceRow)
            SettingsViewController.currentFaceSetting.faceLayers.insert(object, at: destRow)
        
        redrawPreview()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sourceRow = indexPath.row;
            //let trashedSetting = clockSettings.ringSettings[sourceRow]
            SettingsViewController.currentFaceSetting.faceLayers.remove(at: sourceRow)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            redrawPreview()
        }
    }

}
