//
//  Text2ImageViewController.swift
//  StableDiffusion_iOS
//
//  Created by Mukesh Shama on 2023-01-14.
//

import UIKit
import Alamofire


class Text2ImageViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var outputImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        textView.resignFirstResponder()
    }
    
    @IBAction func generateImageAction(_ sender: UIButton) {
        textView.resignFirstResponder()
        APICaller.shared.text2Image(textView.text) { result in
            DispatchQueue.main.async {
                guard let cData = result else {
                    return
                }
                if let imageBase64String = cData.base64EncodedString().fromBase64() {
                    if let data = imageBase64String.data(using: .utf8) {
                            do {
                                let dictionary =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                                if let tempDict: [String: AnyObject] = ((dictionary!["artifacts"] as! [Any]).first as? [String: AnyObject]) {
                                    if let temp2: String = tempDict["base64"] as? String {
                                        self.outputImage.image = UIImage(data: Data(base64Encoded: (temp2).data(using: .utf8)!)!)
                                    }
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        }

                }
            }
        }
    }
}

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self.replacingOccurrences(of: "_", with: "="), options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
    
    var paddedForBase64Decoding: String {
            appending(String(repeating: "=", count: (4 - count % 4) % 4))
        }
}
