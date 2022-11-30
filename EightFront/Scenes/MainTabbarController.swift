//
//  MainTabbarController.swift
//  EightFront
//
//  Created by wargi on 2022/09/19.
//

import UIKit
import Lottie
import Firebase

final class MainTabbarController: UITabBarController {
    //MARK: - Properties
    private var ref: DatabaseReference?
    private let animationView = AnimationView(name: "splashscreen").then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = Colors.point.color
    }

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        appVersionCheck()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }

    //MARK: - Make UI
    private func makeUI() {
        delegate = self
        tabBar.backgroundColor = .white
        tabBar.tintColor = Colors.gray002.color
        tabBar.unselectedItemTintColor = Colors.gray006.color
        
        let homeVC = HomeVC()
        let homeNavi = CommonNavigationViewController(rootViewController: homeVC)
        homeNavi.tabBarItem.title = "홈"
        homeNavi.tabBarItem.image = Images.Tabbar.homeNone.image
        homeNavi.tabBarItem.selectedImage = Images.Tabbar.homeSelect.image.withRenderingMode(.alwaysOriginal)
        
        let postsVC = PostsVC()
        let postsNavi = CommonNavigationViewController(rootViewController: postsVC)
        postsNavi.tabBarItem.title = "버릴까 말까"
        postsNavi.tabBarItem.image = Images.Tabbar.feedNone.image
        postsNavi.tabBarItem.selectedImage = Images.Tabbar.feedSelect.image.withRenderingMode(.alwaysOriginal)
        
        let noticeVC = NoticeVC()
        noticeVC.tabBarItem.title = "알림"
        noticeVC.tabBarItem.image = Images.Tabbar.alarmNone.image
        noticeVC.tabBarItem.selectedImage = Images.Tabbar.alarmSelect.image.withRenderingMode(.alwaysOriginal)
        
        let myPageVC = MyPageVC()
        myPageVC.tabBarItem.title = "마이페이지"
        myPageVC.tabBarItem.image = Images.Tabbar.myPageNone.image
        myPageVC.tabBarItem.selectedImage = Images.Tabbar.myPageSelect.image.withRenderingMode(.alwaysOriginal)

        viewControllers = [homeNavi, postsNavi, noticeVC, myPageVC]
        
        view.addSubview(animationView)
        
        animationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        animationView.play { _ in
            self.animationView.removeFromSuperview()
        }
    }
    
    //MARK: - 버전 체크
    private func appVersionCheck() {
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
    
    private func checkUpdateVersion(dbdata: DBVersionData){
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
    
    private func forceUdpateAlert() {
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
    
    private func optionalUpdateAlert(version:Int) {
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

extension MainTabbarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard viewController is MyPageVC else {
            return true
        }
        
        let accessToken = KeyChainManager.shared.readAccessToken()
        
        if accessToken.isEmpty {
            let bottomSheetVC = LoginBottomSheetVC()
            bottomSheetVC.modalPresentationStyle = .overFullScreen
            bottomSheetVC.bottomSheetDelegate = self
            self.present(bottomSheetVC, animated: false)
        }
        
        return !accessToken.isEmpty
    }
}

extension MainTabbarController: BottomSheetDelegate {
    func loginSuccess() {
        self.tabBarController?.selectedIndex = 3
    }
}
