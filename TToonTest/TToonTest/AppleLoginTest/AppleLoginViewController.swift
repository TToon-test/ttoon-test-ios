//
//  AppleLoginViewController.swift
//  TToonTest
//
//  Created by 임승섭 on 4/8/24.
//

// 2S9WHYP486com.TToon.TToonTest

import UIKit
import SnapKit

import AuthenticationServices

class AppleLoginViewController: UIViewController {
    
    
    let button = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        checkAutoLogin()
        
        view.backgroundColor = .white
        button.backgroundColor = .black
        
        
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.center.equalTo(view)
        }
        
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
}

extension AppleLoginViewController {
    // 자동 로그인 체크
    func checkAutoLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: "000061.c525b75cb14b46a893be5485a1bf0d82.0152") { credentialState, error in
            
            switch credentialState {
            case .revoked:
                print("revoked")
            case .authorized:
                print("autorized")
                print("바로 로그인 성공 화면으로 넘어갈 것")
            case .notFound:
                print("notFound")
                
            case .transferred:
                print("transfered")
            }
            
            
        }
        
    }
    
    
    
}

extension AppleLoginViewController: ASAuthorizationControllerDelegate {
    
    @objc
    func buttonClicked() {
        print("hi")
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    // 로그인 성공
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let identityTokenData = appleIDCredential.identityToken,
           let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
            
            print("애플 로그인 성공")
            print("로그인 토큰 : \(identityTokenString)")
            
            print("user 고유 식별자 : \(appleIDCredential.user)")

            
            let vc = AppleLoginSuccessViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 로그인 실패")
        print("에러 내용 : \(error.localizedDescription)")
    }
    
}

extension AppleLoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
}
