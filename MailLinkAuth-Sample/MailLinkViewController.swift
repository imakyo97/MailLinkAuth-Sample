//
//  MailLinkViewController.swift
//  MailLinkAuth-Sample
//
//  Created by 今村京平 on 2021/11/12.
//

import UIKit
import Firebase
import FirebaseAuth

class MailLinkViewController: UIViewController {

    @IBOutlet private weak var mailTextField: UITextField!

    private var actionCodeSettings: ActionCodeSettings!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActionCode()
    }

    private func setupActionCode() {
        actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://maillinkauthapp.page.link/openLogin")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
    }
    
    @IBAction private func didTapSendButton(_ sender: Any) {
        guard !mailTextField.text!.isEmpty else { return }
        let mail = mailTextField.text!
        Auth.auth().sendSignInLink(toEmail: mail,
                                   actionCodeSettings: actionCodeSettings) { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.presentAlert(title: "\(error.localizedDescription)")
                return
            }
            // リンクは正常に送信されました。ユーザーに通知します。
            // メールをローカルに保存して、同じデバイスでリンクを開いた場合にユーザーに
            // 再度メールを要求する必要がないようにします。
            UserDefaults.standard.set(mail, forKey: "Email")
            strongSelf.presentAlert(title: "認証メールを送信しました。")
        }
    }

    private func presentAlert(title: String) {
        let alert = UIAlertController(
            title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
