//
//  CommentCell.swift
//  EightFront
//
//  Created by wargi on 2022/11/19.
//

import Then
import SnapKit
import UIKit
//MARK: 댓글 셀
final class CommentCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: ReportPopupOpenDelegate?
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = Images.Detail.defaultProfile.image
    }
    let nicknameLabel = UILabel().then {
        $0.font = Fonts.Pretendard.semiBold.font(size: 14)
    }
    let moreButton = UIButton().then {
        $0.setImage(Images.Detail.more.image)
    }
    let commentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = Fonts.Pretendard.regular.font(size: 14)
    }
    let dateLabel = UILabel().then {
        $0.textColor = UIColor(colorSet: 117)
        $0.font = Fonts.Pretendard.regular.font(size: 12)
    }
    let replyButton = UIButton().then {
        $0.setTitle("답글쓰기")
        $0.setTitleColor(UIColor(colorSet: 117))
        $0.titleLabel?.font = Fonts.Pretendard.semiBold.font(size: 12)
    }
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
        moreButton.addTarget(self, action: #selector(moreButtonTouched), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with comment: Comment) {
        nicknameLabel.text = comment.nickname
        commentLabel.text = comment.comment
        dateLabel.text = DateManager.shared.timeString(target: comment.createdAt)
        
        let isParent = comment.type == 0
        replyButton.isHidden = !isParent
        
        profileImageView.snp.updateConstraints {
            $0.left.equalToSuperview().offset(isParent ? 10 : 56)
        }
        
        layoutIfNeeded()
    }
    
    //MARK: - Make UI
    private func makeUI() {
        selectionStyle = .none
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(moreButton)
        contentView.addSubview(commentLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(replyButton)
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(10)
            $0.size.equalTo(48)
        }
        moreButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.right.equalToSuperview().offset(-20)
            $0.size.equalTo(22)
        }
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.left.equalTo(profileImageView.snp.right).offset(3)
            $0.right.equalTo(moreButton.snp.left).offset(-3)
            $0.height.equalTo(22)
        }
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            $0.left.equalTo(nicknameLabel.snp.left)
            $0.right.equalTo(moreButton.snp.right)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(4)
            $0.left.equalTo(nicknameLabel.snp.left)
            $0.height.equalTo(18)
        }
        replyButton.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(4)
            $0.left.equalTo(dateLabel.snp.right).offset(16)
            $0.width.equalTo(42)
            $0.height.equalTo(18)
        }
    }
    
    @objc
    private func moreButtonTouched() {
        delegate?.openPopup()
    }
}

extension CommentCell {
    static func height(with comment: Comment) -> CGFloat {
        var height: CGFloat = 64.0
        let isParent = comment.type == 0
        var width = UIScreen.main.bounds.width
        width -= isParent ? 30.0 : 76.0
        height += UILabel.textHeight(withWidth: width,
                                     font: Fonts.Templates.body1.font,
                                     text: comment.comment ?? "")
        return height
    }
}
