//
//  SearchUserCell.swift
//  Activation
//
//  Created by Mattias Törnqvist on 2020-06-28.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

class SearchUserCell: UITableViewCell {
    
//    MARK: - Properties
    static let idenitifer = "Identifier"
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    var user: User? {
        didSet {
            textLabel?.text = user?.fullname
        }
    }
    
//    MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let profileImageDiameter: CGFloat = 48
        
        addSubview(profileImageView)
        
        profileImageView.anchor(left: contentView.leftAnchor,
                          paddingLeft: 8,
                          width: profileImageDiameter,
                          height: profileImageDiameter)
        profileImageView.layer.cornerRadius = profileImageDiameter/2
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
    }
}
