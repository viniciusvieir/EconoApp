//
//  ViewController.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 23/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit
import Timepiece

struct HomeMenuItems {
    let title: HomeMenuTitle
    let image: UIImage?
    let subtitle: String? // https://ideas.repec.org/zimm/courses/symbols.pdf
    let backgroundColor: UIColor
    let secondColor: UIColor
}

enum HomeMenuTitle: String {
    case gdp = "PIB"
    case gdpPerCapita = "PIB per Capita"
    case inflation = "Inflação"
    case juros = "SELIC"
    case employment = "Emprego"
}

class ViewController: UIViewController {

    let cellId = "MenuCell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var menuItems: [HomeMenuItems]!
    
    var selectedCell: HomeMenuTableViewCell!
    
    let transition = CircularTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupInfo()
//        HTMLReaper.getSELIC { (selicArray) in
//            guard let selicArray = selicArray else { return }
//        }
        
//        let dates = [(Date() - 1.month)!, (Date() - 2.months)!, (Date() - 3.months)!]
//        _ = SidraAPI(tableIndex: .ipca15, dates: dates) { (json) in
//            if let json = json {
//                print(json)
//            }
//        }
        
//        _ = MinimumWageBrazil { (info) in
//            if let info = info {
//                print(info["2010"] ?? "")
//            }
//        }
        
//        _ = WorldBankAPI(searchType: .gdpPerCapita)
        
    }
    
    func setupView() {
        tableView.register(HomeMenuTableViewCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)
        tableView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    func setupInfo() {
        
        let gdp = HomeMenuItems(title: .gdp, image: nil, subtitle: "Y", backgroundColor: UIColor().darkCerulean, secondColor: UIColor().ivoryWhite)
        let gdpPerCapita = HomeMenuItems(title: .gdpPerCapita, image: nil, subtitle: "y", backgroundColor: UIColor().laurelGreen, secondColor: UIColor().ivoryWhite)
        let inflation = HomeMenuItems(title: .inflation, image: nil, subtitle: "π", backgroundColor: UIColor().brickRed, secondColor: UIColor().stilDeGrainYellow)
        let selic = HomeMenuItems(title: .juros, image: nil, subtitle: "i", backgroundColor: UIColor().ivoryWhite, secondColor: UIColor().darkCerulean)
        let employment = HomeMenuItems(title: .employment, image: nil, subtitle: "N", backgroundColor: UIColor().roseTaupe, secondColor: UIColor().ivoryWhite)
        
        menuItems = [gdp, gdpPerCapita, selic, inflation, employment]
        //menuItems.sort { $0.title.rawValue < $1.title.rawValue }
    }
    
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = selectedCell.center
        transition.circleColor = selectedCell.backgroundColor!
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = selectedCell.center
        transition.circleColor = selectedCell.backgroundColor!
        return transition
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeMenuTableViewCell
        
        cell.info = menuItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! HomeMenuTableViewCell
        
        selectedCell = cell
        
        let vc = TesteViewController()
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        
        self.present(vc, animated: true, completion: nil)
    }
    
}


















