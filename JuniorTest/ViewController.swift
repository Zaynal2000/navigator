//
//  ViewController.swift
//  JuniorTest
//
//  Created by Зайнал Гереев on 21.08.2021.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    let mapView : MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let addAdressButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let goButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "go"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    let resetAdressButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "reset"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    var annotationsArray = [MKPointAnnotation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self // как прочитать/понять эту сточку? вопрос про self
        
        setContstaints()
        
        addAdressButton.addTarget(self, action: #selector(addAdressButtonTapped), for: .touchUpInside)
        goButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
        resetAdressButton.addTarget(self, action: #selector(resetAdressTapped), for: .touchUpInside)
        
        
        
    }
    
    @objc func addAdressButtonTapped() {
        alertAdd(title: "Дщбавить", placeholder: "Введите адрес") { [self] (text) in
            setupPlacemark(adressPlace: text)
        }
    }
    
    @objc func goButtonTapped() {
        
        for index in 0...annotationsArray.count - 2 {
            
            createDirectionRequest(startCoordinate: annotationsArray[index].coordinate, destinationCoordinate: annotationsArray[index + 1].coordinate)
        }
        
        mapView.showAnnotations(annotationsArray, animated: true)
        
        
    }
    
    @objc func resetAdressTapped() {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        annotationsArray = [MKPointAnnotation]()
        goButton.isHidden = true
        resetAdressButton.isHidden = true
    }
    
    
    private func setupPlacemark(adressPlace: String) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(adressPlace) { [self] placemarks, error in
            
            
            
            if let error = error {
                print(error)
                alertError(title: "Ошибка", messege: "Сервер не отвечает, попробуйте добавить адрес еще раз")
                return
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = "\(adressPlace)"
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            
            annotationsArray.append(annotation)
            
            if annotationsArray.count > 2 {
                goButton.isHidden = false
                resetAdressButton.isHidden = false
            }
            
            mapView.showAnnotations(annotationsArray, animated: true)
            
        }
    }
    
    private func createDirectionRequest(startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D){
        
        let startLocation = MKPlacemark(coordinate: startCoordinate)
        let destinationLocation = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destinationLocation)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        let diraction = MKDirections(request: request)
        diraction.calculate { (responce, error) in
            if let error = error {
                print (error)
                return
            }
            guard let responce = responce else {
                self.alertError(title: "Ошибка", messege: "Маршрут недоступен")
                return
            }
            
            var minRoute = responce.routes[0]
            for route in responce.routes{
                minRoute = (route.distance < minRoute.distance) ? route : minRoute
            }
            
            self.mapView.addOverlay(minRoute.polyline)
            
        }
    }
}
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .green
        return renderer
    }
    
}

extension ViewController {
    
    func setContstaints() {
        
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
        
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        mapView.addSubview(addAdressButton)
        NSLayoutConstraint.activate([
            addAdressButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 50),
            addAdressButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            addAdressButton.heightAnchor.constraint(equalToConstant: 70),
            addAdressButton.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        mapView.addSubview(resetAdressButton)
        NSLayoutConstraint.activate([
            resetAdressButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -50),
            resetAdressButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            resetAdressButton.heightAnchor.constraint(equalToConstant: 70),
            resetAdressButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        mapView.addSubview(goButton)
        NSLayoutConstraint.activate([
            goButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -50),
            goButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            goButton.heightAnchor.constraint(equalToConstant: 70),
            goButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        
        
    }
}
