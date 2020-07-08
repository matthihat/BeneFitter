//
//  ConfirmButton.swift
//  Activation
//
//  Created by Mattias Törnqvist on 2020-06-22.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

class ConfirmButton: UIButton {
    
//    MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 5
        setTitleColor(.white, for: .normal)
        backgroundColor = .systemBlue
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
