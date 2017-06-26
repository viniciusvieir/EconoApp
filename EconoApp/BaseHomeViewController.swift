//
//  BaseHomeViewController.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 20/06/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit

var currentCountryCode: String?

struct HomeMenuItems {
    let title: HomeMenuTitle
    let image: UIImage?
    let subtitle: String? // https://ideas.repec.org/zimm/courses/symbols.pdf
    let backgroundColor: UIColor
    let secondColor: UIColor
}

enum HomeMenuTitle: String {
    case gdp = "GDP"
    case gdpPerCapita = "GDP per Capita"
    case inflation = "Inflation"
    case interest = "Interest"
    case employment = "Employment"
    case unemployment = "Unemployment"
    case wage = "Minimum Wage"
}

class BaseHomeViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var menuItems: [HomeMenuItems]!
    var selectedCell: HomeMenuTableViewCell!
    let transition = CircularTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayoutOnView()
    }
    
    final func setupLayoutOnView() {
        view.addSubview(tableView)
        tableView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
}

extension BaseHomeViewController: UIViewControllerTransitioningDelegate {
    
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
