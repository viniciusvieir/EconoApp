//
//  ViewController.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 23/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit
import Planet
import Timepiece

class HomeController: BaseHomeViewController {
    
    let cellId = "MenuCell"
    
    var countryButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
        setupNavBar()
    }
    
    fileprivate func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeMenuTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    fileprivate func setupData() {
        
        let gdp = HomeMenuItems(title: .gdp, image: nil, subtitle: "Y", backgroundColor: UIColor().darkSlateGray, secondColor: UIColor().ivoryWhite)
        let gdpPerCapita = HomeMenuItems(title: .gdpPerCapita, image: nil, subtitle: "y", backgroundColor: UIColor().shinnyShamrock, secondColor: UIColor().ivoryWhite)
        let inflation = HomeMenuItems(title: .inflation, image: nil, subtitle: "π", backgroundColor: UIColor().brickRed, secondColor: UIColor().stilDeGrainYellow)
        let selic = HomeMenuItems(title: .interest, image: nil, subtitle: "i", backgroundColor: UIColor().verdeAzulado, secondColor: UIColor().ivoryWhite)
        let employment = HomeMenuItems(title: .employment, image: nil, subtitle: "N", backgroundColor: UIColor().roseTaupe, secondColor: UIColor().ivoryWhite)
        
        menuItems = [gdp, gdpPerCapita, selic, inflation, employment]
        //menuItems.sort { $0.title.rawValue < $1.title.rawValue }
    }
    
    fileprivate func setupNavBar() {
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "globe_economics"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        
        navigationItem.title = "Menu"
        navigationItem.titleView = titleImageView
        
        guard let currentCountryCode = currentCountryCode else { return }
        
        let action = #selector(countryButtonAction(_:))
        let countryImage = UIImage(named: currentCountryCode, in: Bundle.planetBundle(), compatibleWith: nil)
        countryButton = UIBarButtonItem(image: countryImage?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: action)
        
        navigationItem.leftBarButtonItem = countryButton
    }
    
    @objc fileprivate func countryButtonAction(_ sender: UIBarButtonItem) {
        let countryPickerController = CountryPickerViewController()
        countryPickerController.showsCallingCodes = false
        countryPickerController.showsCancelButton = true
        countryPickerController.delegate = self
        self.present(countryPickerController, animated: true, completion: nil)
    }
    
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeMenuTableViewCell
        cell.info = menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIScreen.main.bounds.size.height <= CGFloat(iPhoneHeights.iphone6sPlus.rawValue) {
            return self.view.bounds.size.height/CGFloat(menuItems.count) - (64.0/CGFloat(menuItems.count))
        }
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCell = tableView.cellForRow(at: indexPath) as! HomeMenuTableViewCell
        
        if menuItems[indexPath.row].title == .employment {
            let vc = LaborViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        let vc: BaseInfoViewController = {
            switch menuItems[indexPath.row].title {
            case .gdp: return GDPViewController()
            case .gdpPerCapita: return GDPPerCapitaViewController()
            case .inflation: return InflationViewController()
            case .interest: return InterestViewController()
            default: return BaseInfoViewController()
            }
        }()
        
        vc.menuItem = menuItems[indexPath.row]
        vc.currentCountryCode = currentCountryCode
        
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension HomeController: CountryPickerViewControllerDelegate {
    func countryPickerViewControllerDidCancel(_ countryPickerViewController: CountryPickerViewController) {
        countryPickerViewController.dismiss(animated: true, completion: nil)
    }
    
    func countryPickerViewController(_ countryPickerViewController: CountryPickerViewController, didSelectCountry country: Country) {
        countryButton.image = country.image?.withRenderingMode(.alwaysOriginal)
        currentCountryCode = country.isoCode
        countryPickerViewController.dismiss(animated: true, completion: nil)
    }
}





