//
//  KitchenObject.swift
//  CTFrontEnd
//
//  Created by Raymond Gatz on 12/5/17.
//  Copyright © 2017 RayzorDragon. All rights reserved.
//

import Foundation

class KitchenObject {
	
	let name: String
	let location: Location
	let forecast: Array<Forecast>
	
	init(withName name: String, location: Location, forecast: Array<Forecast>) {
		self.name = name
		self.location = location
		self.forecast = forecast
	}
	
}

struct Kitchen: Codable {
	var name: String
	var location: Location
	var timeOffset: Int
}

struct Location: Codable {
	var lat: Double
	var lng: Double
}

class Forecast {
	let day: Day
	let weather: WeatherType
	let isLastDay: Bool		// Only YES if it is the last day of the month
	
	init(withDay day: Day, weather: WeatherType, lastDay: Bool)
	{
		self.day = day
		self.weather = weather
		self.isLastDay = lastDay
	}
	
	func calcInfluence() -> Int {
		var influence = 0
		
		// day factor
		switch day {
		case .Monday:
			influence=influence+1
		case .Tuesday:
			influence=influence+2
		case .Wednesday, .Saturday, .Sunday:
			influence=influence+3
		case .Thursday:
			influence=influence+4
		case .Friday:
			influence=influence+5
		default:
			print("Error: No Day Selected")
		}
		
		// weather factor
		
		switch weather {
		case .Nice:
			influence=influence-2
		case .Raining:
			influence=influence+4
		case .Snow:
			influence=influence+5
		default:
			print("Error: No Weather Selected")
		}
		
		// last day factor
		
		if (isLastDay) {
			influence = influence+5
		}
		
		return influence
	}
}

enum Day {
	case Monday
	case Tuesday
	case Wednesday
	case Thursday
	case Friday
	case Saturday
	case Sunday
	
	func name() -> String {
		switch self {
		case .Monday:
			return "Monday"
		case .Tuesday:
			return "Tuesday"
		case .Wednesday:
			return "Wednesday"
		case .Thursday:
			return "Thursday"
		case .Friday:
			return "Friday"
		case .Saturday:
			return "Saturday"
		case .Sunday:
			return "Sunday"
		}
	}
}

enum WeatherType {
	case Nice
	case Raining
	case Snow
}
