//
//  ViewController.swift
//  WeatherApp-Dhruv
//
//  Created by Dhruv Chhatbar on 11/03/25.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet var imgCurrentWeather: UIImageView!
    @IBOutlet var tfSearchBar: UITextField!
    @IBOutlet var lblCurrentCity: UILabel!
    @IBOutlet var lblCurrentTemp: UILabel!
    @IBOutlet var lblCurrentWeather: UILabel!
    @IBOutlet var cvUpcomingForcast: UICollectionView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var refreshControl = UIRefreshControl()
    var locationManager = CLLocationManager()
    var dateFormatteer = DateFormatter()
    var weatherManager = DataManager()

    var arrForcasts = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.refreshControl.tintColor = UIColor.darkThemeBlack
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        self.scrollView.isScrollEnabled = true
        self.scrollView.alwaysBounceVertical = true
        scrollView.addSubview(refreshControl)
            
        cvUpcomingForcast.delegate = self
        cvUpcomingForcast.dataSource = self
        
        initLocationManager()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        self.tfSearchBar.delegate = self
        
    }
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        initLocationManager()
        //        self.getHomePageApi()
        refreshControl.endRefreshing()
    }
    
    
    @IBAction func btnCurrentLocTap(_ sender: UIButton) {
        initLocationManager()
    }
    @IBAction func btnSearchTap(_ sender: UIButton) {
        if let text = tfSearchBar.text, text.count > 0{
            weatherManager.doGetCurrentWaetherDataByName(name: text) { result in
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    switch result {
                    case .success(let success):
                        self.lblCurrentCity.text = success.name
                        self.lblCurrentTemp.text = success.main?.temp?.description
                        if let weather = success.weather, weather.count > 0{
                            self.lblCurrentWeather.text = weather.first?.main
                        }
                        break;
                    case .failure(let failure):
                        print(failure.localizedDescription)
                        print(failure.localizedDescription)
                        break;
                    }
                }
            }
        }
    }

}

extension ViewController:CLLocationManagerDelegate{
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
                locationManager.stopUpdatingLocation()
                
                    print(error)
                
            }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                locationManager.stopUpdatingLocation()
                guard let location = locations.last else { return }
                            let coord = location.coordinate
                            self.weatherManager.doGetForcastData(lat: coord.latitude.description , long: coord.longitude.description ) { result in
                                
                                DispatchQueue.main.async {
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.isHidden = true
                                    switch result {
                                    case .success(let success):
                                        self.arrForcasts = success.list ?? []
                                        self.cvUpcomingForcast.reloadData()
                                        print("success")
                                        break;
                                    case .failure(let failure):
                                        print(failure.localizedDescription)
                                        print(failure.localizedDescription)
                                        break;
                                    }
                                }
                            }
        
                            self.weatherManager.doGetCurrentWaetherData(lat: coord.latitude.description , long: coord.longitude.description ) { result in
                                
                                DispatchQueue.main.async {
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.isHidden = true
                                    switch result {
                                    case .success(let success):
                                        self.lblCurrentCity.text = success.name
                                        self.lblCurrentTemp.text = success.main?.temp?.description
                                        if let weather = success.weather, weather.count > 0{
                                            self.lblCurrentWeather.text = weather.first?.main
                                        }
                                        break;
                                    case .failure(let failure):
                                        print(failure.localizedDescription)
                                        print(failure.localizedDescription)
                                        break;
                                    }
                                }
                            }
        
//                        }
                
                
            }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("Location authorization status: Not Determined")
        case .restricted:
            print("Location authorization status: Restricted")
        case .denied:
            print("Location authorization status: Denied")
        case .authorizedAlways:
            print("Location authorization status: Authorized Always")
            manager.requestLocation()
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            print("Location authorization status: Auth'd when in use")
            manager.requestLocation()
            manager.startUpdatingLocation()
        case .authorized:
            print("Location authorization status: Authorized")
            manager.requestLocation()
            manager.startUpdatingLocation()
        @unknown default:
            fatalError("Unknown location authorization case")
        }
    }
}

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.arrForcasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherGridCell", for: indexPath) as? WeatherGridCell else{return UICollectionViewCell()}
        let data = self.arrForcasts[indexPath.item]
        cell.lblTemp.text = "\(data.main?.temp?.description ?? "") F"
        cell.lblMinMaxTemp.text = "\(data.main?.tempMin?.description ?? "")/\(data.main?.tempMax?.description ?? "") F"
        cell.lblWindSpeed.text = "Wind - \(data.wind?.speed?.description ?? "") KMPH"
        cell.lblWeatherName.text = "\(data.weather?.first?.main ?? "")"
        dateFormatteer.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatteer.date(from: data.dtTxt ?? ""){
            dateFormatteer.dateFormat = "EEEE, MMM d, yyyy"
            cell.lblDate.text = dateFormatteer.string(from: date)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 2 - 1, height: collectionView.frame.height)
    }
    
}
extension ViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.count > 0{
            weatherManager.doGetCurrentWaetherDataByName(name: text) { result in
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    switch result {
                    case .success(let success):
                        self.lblCurrentCity.text = success.name
                        self.lblCurrentTemp.text = success.main?.temp?.description
                        if let weather = success.weather, weather.count > 0{
                            self.lblCurrentWeather.text = weather.first?.main
                        }
                        break;
                    case .failure(let failure):
                        print(failure.localizedDescription)
                        print(failure.localizedDescription)
                        break;
                    }
                }
            }
        }
    }
}
