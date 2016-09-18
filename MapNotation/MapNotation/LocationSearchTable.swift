//
//  LocationSearchTable.swift
//  MapNotation
//
//  Created by Gabriel Cavalcante on 17/09/16.
//  Copyright © 2016 Yuri Saboia Felix Frota. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable: UITableViewController {
    var mapItems: [MKMapItem] = []
    var mapView: MKMapView?
    var handleSearchDelegate: HandleMapSearchProtocol?
    let locationSection: [String] = ["Pokémon", "Location"]
    var pokemonItems: [MKAnnotation] = []
}

extension LocationSearchTable: UISearchResultsUpdating {
    
    //Updating when change string from UISearchControll
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else { return }
        
        //Request for MapKit with string from searchBar with a languege and region(at this case is the mapView)
        
        
        
        
        //Search through the request and getting a response from MKLocalCompletionHandler
        
        
        
        
        //Complete the pokemonItems with MapView Annotations
        
        
        
        
    }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            //Make a selectedItem from mapItems and handle it
            
            
            
            
        } else if indexPath.section == 0 {
            //Make a selectedItem from pokemonItems and handle it
            
            
            
            
        }
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsMap = mapItems.count
        var rowsPokemon = pokemonItems.count
        
        if mapItems.count == 0 {
            rowsMap = 1
        }
        if pokemonItems.count == 0 {
            rowsPokemon = 1
        }
        
        return (section == 1) ? rowsMap : rowsPokemon
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        if indexPath.section == 1 {
            if self.mapItems.count == 0 {
                cell.textLabel?.text = "Not Found"
                cell.detailTextLabel?.text = "Not Found"
            } else {
                //Fill the cell with places from mapItems
                
                
                
                
            }
        } else if indexPath.section == 0{
            if self.pokemonItems.count == 0 {
                cell.textLabel?.text = "Not Found"
                cell.detailTextLabel?.text = "Not Found"
            } else {
                //Fill the cell with pokemon from pokemonItems
                
                
                
                
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return (section == 0) ? locationSection.first : locationSection.last
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return locationSection.count
    }
}

extension LocationSearchTable {
    //You will need this function to organize the subtitle from location cell
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : " "
        
        let addressLine = String(
            
            format:"%@%@%@%@%@%@%@",
        
        // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
        
        // street name
            selectedItem.thoroughfare ?? "",
            comma,
        
        // city
            selectedItem.locality ?? "",
            secondSpace,
        
        // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}
