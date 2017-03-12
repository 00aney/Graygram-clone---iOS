//
//  MainTabBarController.swift
//  Graygram-clone-iOS
//
//  Created by aney on 2017. 3. 12..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

final class MainTabBarController: UITabBarController {
  
  let feedViewController = FeedViewController()
  
  /// 업로드 버튼을 할 가짜 뷰 컨트롤러. 실제로 선택되지는 않습니다.
  let fakeUploadViewController = UIViewController().then {
    $0.tabBarItem.image = UIImage(named: "tab-upload")
    $0.tabBarItem.imageInsets.top = 5
    $0.tabBarItem.imageInsets.bottom = -5
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
    self.delegate = self
    
    self.viewControllers = [
      UINavigationController(rootViewController: self.feedViewController),
      self.fakeUploadViewController,
    ]
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


// MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {
  
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    // `fakeUploadViewController` 탭을 선택하면 실제로 탭을 선택하는 대신 `PostEditorViewController`를 띄웁니다.
    if viewController === self.fakeUploadViewController {
      print("업로드 버튼 선택!")
      return false
    }
    
    return true
  }
  
}
