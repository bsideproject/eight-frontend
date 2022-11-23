//
//  BlockTableViewCell.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/19.
//

import UIKit
import Combine

class BlockTableViewCell: UITableViewCell {
    
    var bag = Set<AnyCancellable>()
    
    static let identity = "BlockTableViewCell"
    
    private let usernameLabel = UILabel().then {
        $0.text = "드랍 더 옷"
        $0.font = Fonts.Templates.subheader.font
    }
    
    private let blockButtonView = UIView().then {
        $0.backgroundColor = Colors.gray001.color
        $0.layer.cornerRadius = 12
    }
    
    private let blockButtonLabel = UILabel().then {
        $0.text = "차단 해제"
        $0.textColor = Colors.point.color
        $0.font = Fonts.Templates.caption1.font
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
    }
    
    private func makeUI() {
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
        
        addSubview(blockButtonView)
        blockButtonView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
            $0.width.equalTo(74)
            $0.height.equalTo(30)
            
            blockButtonView.addSubview(blockButtonLabel)
            blockButtonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
}

