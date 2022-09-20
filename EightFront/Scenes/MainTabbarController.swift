//
//  MainTabbarController.swift
//  EightFront
//
//  Created by wargi on 2022/09/19.
//

import UIKit
import Firebase

class MainTabbarController: UITabBarController {
    //MARK: - Properties
    var ref: DatabaseReference?

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        appVersionCheck()
    }

    //MARK: - Make UI
    func makeUI() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .systemPurple
        tabBar.unselectedItemTintColor = .gray
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem.title = "홈"
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        let tradeVC = TradeViewController()
        tradeVC.tabBarItem.title = "중고거래"
        tradeVC.tabBarItem.image = UIImage(systemName: "person.3")
        tradeVC.tabBarItem.selectedImage = UIImage(systemName: "person.3.fill")
        
        let noticeVC = NoticeViewController()
        noticeVC.tabBarItem.title = "알림"
        noticeVC.tabBarItem.image = UIImage(systemName: "bell")
        noticeVC.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")
        
        let myPageVC = MyPageViewController()
        myPageVC.tabBarItem.title = "마이페이지"
        myPageVC.tabBarItem.image = UIImage(systemName: "person")
        myPageVC.tabBarItem.selectedImage = UIImage(systemName: "person.fill")

        viewControllers = [homeVC, tradeVC, noticeVC, myPageVC]
    }
    
    //MARK: - 버전 체크
    func appVersionCheck() {
        ref = Database.database().reference()
        guard let _ref = ref else { return }
        
        let data = _ref.child("version")
        
        data.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let versionData = snapshot.value as? NSDictionary,
                  let versionDic = versionData as? [String: String],
                  let lastest_version_code = versionDic["lastest_version_code"],
                  let lastest_version_name = versionDic["lastest_version_name"],
                  let minimum_version_code = versionDic["minimum_version_code"],
                  let minimum_version_name = versionDic["minimum_version_name"]
            else { return }
            
            let versionDbData = DBVersionData(lastest_version_code: lastest_version_code,
                                              lastest_version_name: lastest_version_name,
                                              minimum_version_code: minimum_version_code,
                                              minimum_version_name: minimum_version_name)
            
            self?.checkUpdateVersion(dbdata: versionDbData)
        })
    }
    
    func checkUpdateVersion(dbdata: DBVersionData){
        let appLastestVersion = dbdata.lastest_version_code
        let appMinimumVersion = dbdata.minimum_version_code
        let appLastestVersionName = dbdata.lastest_version_name
        let appMinimumVersionName = dbdata.minimum_version_name
        
        guard let infoDic = Bundle.main.infoDictionary,
              let appBuildVersion = infoDic["CFBundleVersion"] as? String,
              let appVersionName = infoDic["CFBundleShortVersionString"] as? String,
              let _appBuildVersion = Int(appBuildVersion),
              let _appMinimumVersion = Int(appMinimumVersion),
              let _appLastestVersion = Int(appLastestVersion) else { return }
        
        #if DEBUG
        return
        #else
        if (appVersionName < appMinimumVersionName) || (appVersionName == appMinimumVersionName && _appBuildVersion < _appMinimumVersion)  {
            forceUdpateAlert()
        } else if appVersionName < dbdata.lastest_version_name || (appVersionName == appLastestVersionName && _appBuildVersion < _appLastestVersion) {
            optionalUpdateAlert(version: _appLastestVersion)
        }
        #endif
    }
    
    func forceUdpateAlert() {
        let msg = "최신 버전의 앱으로 업데이트해주세요."
        let refreshAlert = UIAlertController(title: "업데이트 알림", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            let id = "" //TODO: 추후 앱 아이디 추가
            if let appURL = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id\(id)"),
               UIApplication.shared.canOpenURL(appURL) {
                UIApplication.shared.open(appURL, options: [:]) { _ in
                    exit(0)
                }
            }
        }
        
        refreshAlert.addAction(okAction)
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func optionalUpdateAlert(version:Int) {
        let msg = "새로운 버전이 출시되었습니다.\n업데이트를 하지 않는 경우 서비스 이용에 제한이 있을 수 있습니다. 업데이트를 진행하시겠습니까?"
        let refreshAlert = UIAlertController(title: "업데이트", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "지금 업데이트 하기", style: .default) { _ in
            let id = "" //TODO: 추후 앱 아이디 추가
            if let appURL = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id\(id)"),
               UIApplication.shared.canOpenURL(appURL) {
                // 유효한 URL인지 검사
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "나중에 하기", style: .destructive, handler: nil)
        refreshAlert.addAction(cancelAction)
        refreshAlert.addAction(okAction)
        
        present(refreshAlert, animated: true, completion: nil)
    }
}