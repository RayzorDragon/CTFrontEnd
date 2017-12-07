//
//  KitchenAPIController.swift
//  CTFrontEnd
//
//  Created by Raymond Gatz on 12/5/17.
//  Copyright © 2017 RayzorDragon. All rights reserved.
//

import Foundation

class KitchenAPIController
{
	let api = "https://api.staging.clustertruck.com/api/kitchens"
	
	public func fetch(completion: @escaping (Array<Kitchen>) -> ()) {
		let session = URLSession(configuration: .default)
		let url = URL(string: api)
		let _ = session.dataTask(with: url!) { (kitchenData, response, error) in
			print("Location Task completed")
			if kitchenData != nil {
				do {
					if let todoJSON = try JSONSerialization.jsonObject(with: kitchenData!, options: []) as? Array<Dictionary<String, Any>> {
						var kitchenArray = Array<Kitchen>()
						for dict in todoJSON {
							let locDict = dict["location"]! as! Dictionary<String, Double>
							let loc = Location.init(lat: locDict["lat"]!, lng: locDict["lng"]!)
							let kit = Kitchen.init(name: dict["name"]! as! String, location: loc, timeOffset: dict["utc_offset"]! as! Int)
							kitchenArray.append(kit)
						}
						completion(kitchenArray)
					} else {
						completion(Array<Kitchen>())
					}
				} catch let error as NSError {
					print(error.localizedDescription)
				}
			} else if let error = error {
				print(error.localizedDescription)
			}
		}.resume()
	}
}
