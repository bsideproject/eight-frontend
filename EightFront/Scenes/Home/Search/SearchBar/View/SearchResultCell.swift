//
//  SearchResultCell.swift
//  EightFront
//
//  Created by wargi on 2022/10/07.
//

import Then
import SnapKit
import UIKit
//MARK: SearchResultCell
final class SearchResultCell: UITableViewCell {
    //MARK: - Properties
    let keywordLabel = UILabel().then {
        $0.font = Fonts.Pretendard.regular.font(size: 20)
    }
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        addSubview(keywordLabel)
        
        keywordLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

