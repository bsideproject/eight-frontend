//
//  ReplyView.swift
//  EightFront
//
//  Created by wargi on 2022/12/25.
//

import Then
import SnapKit
import UIKit
//MARK: ReplyView
final class ReplyView: UIView {
    //MARK: - Properties
    let titleLabel = UILabel().then {
        $0.font = Fonts.Pretendard.regular.font(size: 12)
        $0.textColor = UIColor(red: 182, green: 179, blue: 179)
    }
    let replyCancelButton = UIButton().then {
        $0.setImage(Images.Report.delete.image)
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        backgroundColor = UIColor(colorSet: 245)
        addSubview(titleLabel)
        addSubview(replyCancelButton)
        
        replyCancelButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
            $0.size.equalTo(20)
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.right.equalTo(replyCancelButton.snp.left).offset(-8)
        }
    }
}
