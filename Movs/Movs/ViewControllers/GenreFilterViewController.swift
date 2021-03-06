//
//  GenreFilterViewController.swift
//  Movs
//
//  Created by Alexandre Papanis on 01/04/19.
//  Copyright © 2019 Papanis. All rights reserved.
//

import UIKit

protocol GenreCellDelegate {
    func selectGenre(genre: String)
}

class GenreFilterViewController: UIViewController, GenreCellDelegate {
    
    //MARK: Variables
    var filterDelegate: FilterDelegate!
    var genreSelected: String = ""
    var genres = Defines.genres
    
    //MARK: IB Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: UIViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    //MARK: Filter Delegate
    func selectGenre(genre: String) {
        if(self.filterDelegate != nil){ //Just to be safe.
            self.filterDelegate.selectGenre(genre: genre)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}

extension GenreFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableViewController stubs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell") as! GenreCell
        
        cell.textLabel!.text = genres[indexPath.row]
        cell.delegate = self
        
        if genreSelected == genres[indexPath.row] {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if genreSelected == genres[indexPath.row] {
            genreSelected = ""
            selectGenre(genre: genreSelected)
        } else {
            genreSelected = genres[indexPath.row]
            selectGenre(genre: genreSelected)
        }
    }
    
}
