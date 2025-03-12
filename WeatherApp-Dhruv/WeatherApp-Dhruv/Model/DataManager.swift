//
//  DataManager.swift
//  WeatherApp-Dhruv
//
//  Created by Dhruv Chhatbar on 11/03/25.
//

import Foundation



//api call with completion which returns array for reload
//Collection view
//string api call


struct DataManager{
    let apiKeyId = "331866024021168ede30123c39ecd92b"
    var baseURL = "https://api.openweathermap.org/data/2.5/" //Forcast = forecast? //current = weather?
    
    func doGetForcastData(lat: String, long: String, completion: @escaping (Result<WeatherForcastModel, Error>) -> Void) {
        let urlString = "\(baseURL)forecast?lat=\(lat)&lon=\(long)&appid=\(apiKeyId)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 404, userInfo: nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(WeatherForcastModel.self, from: data)
                completion(.success(decodedData))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }
        
        task.resume()
    }
    
    func doGetCurrentWaetherData(lat: String, long: String, completion: @escaping (Result<WeatherCurrentModel, Error>) -> Void) {
        let urlString = "\(baseURL)weather?lat=\(lat)&lon=\(long)&appid=\(apiKeyId)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 404, userInfo: nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(WeatherCurrentModel.self, from: data)
                completion(.success(decodedData))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }
        
        task.resume()
    }
    
    func doGetCurrentWaetherDataByName(name: String, completion: @escaping (Result<WeatherCurrentModel, Error>) -> Void) {
        let urlString = "\(baseURL)weather?q=\(name)&appid=\(apiKeyId)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 404, userInfo: nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(WeatherCurrentModel.self, from: data)
                completion(.success(decodedData))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }
        
        task.resume()
    }
    
}
