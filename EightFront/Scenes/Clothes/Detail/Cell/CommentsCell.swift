//
//  CommentsCell.swift
//  EightFront
//
//  Created by wargi on 2022/11/18.
//

import Then
import SnapKit
import UIKit
//MARK: 댓글 모음 셀
final class CommentsCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: ReportPopupOpenDelegate?
    weak var replyDelegate: CommentCellDelegate?
    var comments = [Comment]()
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        CommentCell.register($0)
    }
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with comments: [Comment]?) {
        self.comments = comments ?? []
        
        tableView.reloadData()
    }
    
    //MARK: - Make UI
    private func makeUI() {
        selectionStyle = .none
        contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.bottom.right.equalToSuperview()
        }
    }
}

extension CommentsCell {
    static func height(with comments: [Comment]?) -> CGFloat {
        guard let comments, !comments.isEmpty else { return 4.0 }
        
        var height: CGFloat = 4.0
        
        for comment in comments {
            height += 64.0
            let isParent = comment.parentId == 0
            var width = UIScreen.main.bounds.width
            width -= isParent ? 30.0 : 79.0
            height += UILabel.textHeight(withWidth: width,
                                         font: Fonts.Templates.body1.font,
                                         text: comment.comment ?? "")
        }
        
        return height
    }
}

extension CommentsCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CommentCell.height(with: comments[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withType: CommentCell.self, for: indexPath)
        
        cell.delegate = self
        cell.replyDelegate = self
        cell.configure(with: comments[indexPath.row])
        
        return cell
    }
}

extension CommentsCell: ReportPopupOpenDelegate {
    func openPopup() {
        delegate?.openPopup()
    }
}

extension CommentsCell: CommentCellDelegate {
    func reply(comment: Comment?) {
        replyDelegate?.reply(comment: comment)
    }
}
