//
//  BaseTableViewCell.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 24/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    var menuItem: HomeMenuItems? {
        didSet {
            guard let item = menuItem else { return }
            let view = UIView()
            view.backgroundColor = item.backgroundColor.withAlphaComponent(0.4)
            selectedBackgroundView = view
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupView() {
        
        backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        
        valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        valueLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
    }
    
}












