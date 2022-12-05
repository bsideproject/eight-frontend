//
//  IntroClothesView.swift
//  EightFront
//
//  Created by wargi on 2022/12/22.
//

import Then
import SnapKit
import UIKit
//MARK: 버릴까말까 안내페이지
final class IntroClothesView: UIView {
    //MARK: - Properties
    let swipeImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = Images.Trade.swipe.image
    }
    let swipeDirectionImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = Images.Trade.swipeDirection.image
    }
    let keepLabel = UILabel().then {
        $0.text = "보관해요"
        $0.font = Fonts.Pretendard.medium.font(size: 16)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    let dropLabel = UILabel().then {
        $0.text = "버릴래요"
        $0.font = Fonts.Pretendard.medium.font(size: 16)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    let firstIntroLabel = UILabel().then {
        $0.text = "버릴지 말지 고민되는 옷,"
        $0.font = Fonts.Pretendard.medium.font(size: 18)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    let secondIntroLabel = UILabel().then {
        $0.text = "함께  골라주세요!"
        $0.font = Fonts.Pretendard.medium.font(size: 18)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    let backgroundView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.7)
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
        backgroundColor = .clear
        
        addSubview(backgroundView)
        addSubview(swipeImage)
        addSubview(swipeDirectionImage)
        addSubview(keepLabel)
        addSubview(dropLabel)
        addSubview(firstIntroLabel)
        addSubview(secondIntroLabel)
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        swipeDirectionImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(102)
            $0.height.equalTo(158)
        }
        swipeImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(swipeDirectionImage.snp.centerY).offset(-20)
            $0.width.equalTo(250)
            $0.height.equalTo(36)
        }
        keepLabel.snp.makeConstraints {
            $0.left.equalTo(swipeImage).offset(-28)
            $0.top.equalTo(swipeImage.snp.bottom).offset(15)
        }
        dropLabel.snp.makeConstraints {
            $0.right.equalTo(swipeImage).offset(28)
            $0.top.equalTo(swipeImage.snp.bottom).offset(15)
        }
        firstIntroLabel.snp.makeConstraints {
            $0.top.equalTo(swipeDirectionImage.snp.bottom).offset(47)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(26)
        }
        secondIntroLabel.snp.makeConstraints {
            $0.top.equalTo(firstIntroLabel.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(26)
        }
    }
}
