//
//  SceneDelegate.swift
//  DragonBallPractica
//
//  Created by Luis Eduardo Herrera Lillo on 29-10-23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let storyboard = UIStoryboard.storyboard(.splash)
        let splashViewController: SplashViewController = storyboard.instantiateViewController()
        let isLoggedUseCase = IsLoggedUseCase()
        let splashViewModel = SplashViewModel(isLoggedUseCase: isLoggedUseCase)
        splashViewController.viewModel = splashViewModel
        let rootViewController = UINavigationController(rootViewController: splashViewController)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}
