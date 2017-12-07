//
//  WeatherAPIController.swift
//  CTFrontEnd
//
//  Created by Raymond Gatz on 12/5/17.
//  Copyright © 2017 RayzorDragon. All rights reserved.
//

import Foundation

class WeatherAPIController
{
	
	let apiKey = "9207c312ec1e26dbc9319f5cf4fd10d1"
	
	public func fetch(kit: Kitchen, completion: @escaping (Array<Forecast>) -> ()) {
		let session = URLSession(configuration: .default)
		let api = "http://api.openweathermap.org/data/2.5/forecast?lat=\(kit.location.lat)&lon=\(kit.location.lng)&appid=\(apiKey)"
		let url = URL(string: api)
		let _ = session.dataTask(with: url!) { (weatherData, response, error) in
			print("Weather Task completed")
			if weatherData != nil {
				do {
					if let todoJSON = try JSONSerialization.jsonObject(with: weatherData!, options: []) as? Dictionary<String, Any> {
						var dayArray = Array<Forecast>()
							let list = todoJSON["list"]! as! Array<Dictionary<String, Any>>
							for listDict in list {
								// convert dt_txt to date object
								
								let timeString = listDict["dt_txt"]! as! String
								if timeString.range(of: "12:00:00") != nil {
									// get ones that are noon to represent the day

									let date = self.weatherDate(dateString: listDict["dt_txt"]! as! String, offset: kit.timeOffset)
									
									// create forecast object and add to day array
									
									let day: Day
									
									let myCal = Calendar.init(identifier: .gregorian)
									let weekday = myCal.component(.weekday, from: date)
									
									switch weekday {
									case 1:
										day = .Sunday
									case 2:
										day = .Monday
									case 3:
										day = .Tuesday
									case 4:
										day = .Wednesday
									case 5:
										day = .Thursday
									case 6:
										day = .Friday
									case 7:
										day = .Saturday
									default:
										day = .Sunday
									}
									
									var weather: WeatherType
									weather = .Nice
									
									let weatherDat = listDict["weather"]! as! Array<Dictionary<String, Any>>
										if let entry = weatherDat.first {
											let main = entry["main"]! as! String
												if main.range(of: "Snow") != nil {
													weather = .Snow
												} else if main.range(of: "Rain") != nil {
													weather = .Raining
												} else {
													weather = .Nice
												}
											
										}
									
								
									let forecast = Forecast.init(withDay: day, weather: weather, lastDay: date.isLastDayOfMonth)
									dayArray.append(forecast)
								}
								
							}
						completion(dayArray)
					} else {
						completion(Array<Forecast>())
					}
				} catch let error as NSError {
					print(error.localizedDescription)
				}
			} else if let error = error {
				print(error.localizedDescription)
			}
			}.resume()
	}
	
	private func weatherDate (dateString: String, offset: Int) -> Date {
		// 2017-12-11 09:00:00
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		let date = dateFormatter.date(from: dateString)

		return date!
	}
}

extension Date {
	var yesterday: Date {
		return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
	}
	var tomorrow: Date {
		return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
	}
	var noon: Date {
		return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
	}
	var month: Int {
		return Calendar.current.component(.month,  from: self)
	}
	var isLastDayOfMonth: Bool {
		return tomorrow.month != month
	}
}
