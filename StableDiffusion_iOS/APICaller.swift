//
//  APICaller.swift
//  StableDiffusion_iOS
//
//  Created by Mukesh Shama on 2023-01-14.
//

import Foundation
import UIKit

let BASEURL: String = "https://api.stability.ai"

class APICaller {
    
    static let shared: APICaller = APICaller()
    
    private init() {
        
    }
    
    func text2Image(_ prompt: String, _ completionHandelr : @escaping (Data?) -> Void ) {
        //v1alpha/generation/:engine_id/text-to-image
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "{\n  \"cfg_scale\": 7,\n  \"clip_guidance_preset\": \"FAST_BLUE\",\n  \"height\": 512,\n  \"sampler\": \"K_DPM_2_ANCESTRAL\",\n  \"samples\": 1,\n  \"seed\": 0,\n  \"steps\": 75,\n  \"text_prompts\": [\n    {\n      \"text\": \"\(prompt)\",\n      \"weight\": 1\n    }\n  ],\n  \"width\": 512\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "\(BASEURL)/v1alpha/generation/stable-diffusion-512-v2-0/text-to-image")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("", forHTTPHeaderField: "Authorization")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
//            print(data.base64EncodedString())
            semaphore.signal()
            if error != nil {
                completionHandelr(nil)
            }
            completionHandelr(data)
        }

        task.resume()
        semaphore.wait()
    }
}
