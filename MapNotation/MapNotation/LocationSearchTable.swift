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
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        
        let completionHandler: MKLocalSearchCompletionHandler = {response, error in
            if error != nil {
                print("Não Encontrado")
            } else {
                self.mapItems.removeAll()
                for item in (response?.mapItems)! {
                    self.mapItems.append(item)
                    print("\nItem name = \((item.name)!)")
                    print("Latitude = \((item.placemark.location?.coordinate.latitude)!)")
                    print("Longitude = \((item.placemark.location?.coordinate.longitude)!)")
                    print("Street Number = \(item.placemark.subThoroughfare)")
                    print("Street Name = \(item.placemark.thoroughfare)")
                    print("City = \(item.placemark.locality)")
                    print("Area = \(item.placemark.administrativeArea)")
                }
                self.tableView.reloadData()
            }
        }
        
        //Search through the request and getting a response from MKLocalCompletionHandler
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: completionHandler)
        
        pokemonItems.removeAll()
        for pokemon in mapView.annotations {
            if (pokemon.title??.contains(searchBarText))!{
                pokemonItems.append(pokemon)
            }
        }
    }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let selectedItem = self.mapItems[indexPath.row].placemark
            handleSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        } else if indexPath.section == 0 {
            let selectedItem = pokemonItems[indexPath.row]
            handleSearchDelegate?.zoomIn(coordinate: selectedItem.coordinate)
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
                let selectedItem = self.mapItems[indexPath.row].placemark
                cell.textLabel?.text = selectedItem.name
                cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
            }
        } else if indexPath.section == 0{
            if self.pokemonItems.count == 0 {
                cell.textLabel?.text = "Not Found"
                cell.detailTextLabel?.text = "Not Found"
            } else {
                let selectedItem = pokemonItems[indexPath.row]
                cell.textLabel?.text = (selectedItem.title)!
                cell.detailTextLabel?.text = (selectedItem.subtitle)!
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
