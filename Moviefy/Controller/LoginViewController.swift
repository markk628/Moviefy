//
//  LoginViewController.swift
//  Moviefy
//
//  Created by Mark Kim on 7/8/20.
//  Copyright © 2020 Adriana González Martínez. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    @IBOutlet weak var logInLabel: UILabel!
    @IBAction func logInButton(_ sender: Any) {
        APIClient.shared.createRequestToken { (result) in
            switch result {
            case let .success(token):
                DispatchQueue.main.async {
                    print(token.request_token)
                    self.authorizeRequestToken(from: self, requestToken: token.request_token)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
    
    func authorizeRequestToken(from viewController: UIViewController, requestToken: String) {
        let url = URL(string: "https://www.themoviedb.org/authenticate/\(requestToken)?redirect_to=moviefy://auth")!
        guard let authURL = URL(string: "https://www.themoviedb.org/authenticate/\(requestToken)?redirect_to=moviefy://auth") else { return }
            let scheme = "auth"
        let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: scheme) { callBackURL, error in
            guard error == nil, let callBackURL = callBackURL else { return }
            
            let queryItems = URLComponents(string: callBackURL.absoluteString)?.queryItems
            print(queryItems)
            guard let requestToken = queryItems?.first(where: { $0.name == "request_token"})?.value else { return }
            let approved = (queryItems?.first(where: { $0.name == "approved" })?.value == "true")
            
            print("Request token \(requestToken) \(approved ? "was" : "was NOT") approved")
            
            self.startSession(requestToken: requestToken) { success in
                print("Session started")
            }
        }
        session.presentationContextProvider = self
        session.start()
    }
    
    func startSession(requestToken: String, completion: @escaping (Bool) -> Void) {
        APIClient.shared.createSession(requestToken: requestToken) { (result) in
            switch result {
            case let .success(session):
                DispatchQueue.main.async {
                    print(session.session_id)
                    self.getUserName(sessionID: session.session_id)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getUserName(sessionID: String) {
        APIClient.shared.getAccountInfo(sessionId: sessionID) { (result) in
            switch result {
            case let .success(session):
                DispatchQueue.main.async {
                    print(session.userName)
                    self.logInLabel.text = "Logged in as \(session.displayName)"
                }
            case let .failure(error):
                print(error)
            }
        }
    }

}
