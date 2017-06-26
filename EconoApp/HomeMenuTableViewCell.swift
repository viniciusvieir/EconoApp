//
//  HomeMenuTableViewCell.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 23/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit

class HomeMenuTableViewCell: UITableViewCell {
    
    var info: HomeMenuItems? {
        didSet {
            guard let info = info else { return }
            titleLabel.text = NSLocalizedString(info.title.rawValue, comment: "Cell Text")
            if let image = info.image {
                iconImageView.image = image
                subtitleLabel.isHidden = true
                iconImageView.isHidden = false
            } else if let subtitle = info.subtitle {
                subtitleLabel.text = subtitle
                iconImageView.isHidden = true
                subtitleLabel.isHidden = false
            }
            
            backgroundColor = info.backgroundColor
            
            titleLabel.textColor = info.secondColor
            subtitleLabel.textColor = info.secondColor
        }
    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Avenir-Black", size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let subtitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "HoeflerText-BlackItalic", size: 44)
        label.textAlignment = .center
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupView() {
        
        selectionStyle = .none
        
        addSubview(titleLabel)
        addSubview(iconImageView)
        addSubview(subtitleLabel)
        
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        
        _ = iconImageView.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: -20, rightConstant: -20, widthConstant: 80, heightConstant: 0)
        _ = subtitleLabel.anchor(iconImageView.topAnchor, left: iconImageView.leftAnchor, bottom: iconImageView.bottomAnchor, right: iconImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }

}
