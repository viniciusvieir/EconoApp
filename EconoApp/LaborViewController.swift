//
//  LaborTableViewController.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 20/06/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit

class LaborViewController: BaseHomeViewController {
    
    let cellId = "LaborMenuCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
    }
    
    func setupView() {
        self.navigationItem.title = HomeMenuTitle.employment.rawValue
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeMenuTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    fileprivate func setupData() {
        
        let wage = HomeMenuItems(title: .wage, image: nil, subtitle: "w", backgroundColor: UIColor().darkCerulean, secondColor: UIColor().ivoryWhite)
        let unemployment = HomeMenuItems(title: .unemployment, image: nil, subtitle: "U", backgroundColor: UIColor().brickRed, secondColor: UIColor().ivoryWhite)
        
        if currentCountryCode == "BR" {
            menuItems = [wage, unemployment]
        } else {
            menuItems = [unemployment]
        }
        
    }

}

extension LaborViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeMenuTableViewCell
        cell.info = menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.size.height/CGFloat(menuItems.count) - (64.0/CGFloat(menuItems.count))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCell = tableView.cellForRow(at: indexPath) as! HomeMenuTableViewCell
        
        let vc : BaseInfoViewController = {
            switch menuItems[indexPath.row].title {
            case .wage: return MinimumWageViewController()
            case .unemployment: return UnemploymentViewController()
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
