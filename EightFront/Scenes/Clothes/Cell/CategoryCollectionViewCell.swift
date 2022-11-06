//
//  CategoryCollectionViewCell.swift
//  EightFront
//
//  Created by wargi on 2022/11/05.
//

import Then
import SnapKit
import UIKit
//MARK: CategoryCollectionViewCell
final class CategoryCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.textColor = Colors.gray004.color
        $0.textAlignment = .center
        $0.font = Fonts.Templates.body2.font
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? Colors.gray001.color : .white
            titleLabel.textColor = isSelected ? Colors.point.color : Colors.gray004.color
        }
    }
    
    //MARK: - Initializer
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentView.backgroundColor = .white
        titleLabel.textColor = Colors.gray004.color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.layer.cornerRadius = 17.5
        contentView.layer.borderColor = Colors.gray006.color.cgColor
        contentView.layer.borderWidth = 1.0
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(name: String?) {
        titleLabel.text = name
    }
    
    static func width(text: String) -> CGFloat {
        return UILabel.textSize(font: Fonts.Templates.body2.font, text: text, height: 34.0).width + 30.0
    }
}

