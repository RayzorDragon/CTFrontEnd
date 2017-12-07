//
//  ViewController.swift
//  CTFrontEnd
//
//  Created by Raymond Gatz on 12/5/17.
//  Copyright © 2017 RayzorDragon. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	
	let kitchen = KitchenAPIController()
	let weather = WeatherAPIController()
	var kitchens: Array<KitchenObject> = Array()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		getDataForTable()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func getDataForTable() {
		kitchens.removeAll()
		kitchen.fetch { (kitchenArray) in
			print(kitchenArray)
			let count = kitchenArray.count
			var counter = 0
			for kit in kitchenArray {
				self.weather.fetch(kit: kit, completion: { (weatherArray) in
					print(kit)
					print(weatherArray)
					
					// using kitchenarray and weatherarray, create kitchen object
					let kitchenObj = KitchenObject.init(withName: kit.name, location: kit.location, forecast: weatherArray)
					
					self.kitchens.append(kitchenObj)
					
					counter = counter+1
					
					if counter == count {
						DispatchQueue.main.async {
							self.tableView.reloadData()
						}
					}
				})
			}
			
		}
	}
	
	func getKitchenReport(forName name: String, location: Location) {
		
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return kitchens.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let kitchen = kitchens[section]
		return kitchen.forecast.count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let kitchen = kitchens[section]
		return kitchen.name
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let kitchen = kitchens[indexPath.section]
		let forecast = kitchen.forecast[indexPath.row]
		
		let cellIdentifier = "TableViewCell"
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UITableViewCell else {
			print("Error with Cell Dequeue")
		}
		
		cell.textLabel!.text = forecast.day.name()
		cell.detailTextLabel!.text = String(forecast.calcInfluence())
		
		return cell
	}
	
	


}

