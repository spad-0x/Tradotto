import Cocoa
import Foundation
import AppKit

class ViewController: NSViewController, NSTextFieldDelegate {
    
    @IBOutlet weak var inputTextField: NSTextField!
    @IBOutlet weak var toLanPopUpButton: NSPopUpButton!
    
    @IBOutlet var translatedLabel: NSTextView!
    
    
    
    @IBAction func exitBtn(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.delegate = self
        translatedLabel.textColor = NSColor.white;
    }
    
    
    // Copy text from label in clipboard
    @IBAction func copyTranslation(_ sender: Any) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(translatedLabel.string, forType: .string)
    }
    
    
    
    
    // Exec translation when enter pressed
    func controlTextDidEndEditing(_ obj: Notification) {
        if let textField = obj.object as? NSTextField, textField == inputTextField {
            let text = textField.stringValue
            let targetLang = UtilityFunctions.getLanguageCode(from: self.toLanPopUpButton.titleOfSelectedItem ?? "")
            self.translateText(text: text, targetLang: targetLang)
        }
    }
    
    
    func fetchDynamicCookies(completion: @escaping ([HTTPCookie]) -> Void) {
        let url = URL(string: "https://translate.google.com")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse,
               let headerFields = httpResponse.allHeaderFields as? [String: String],
               let url = response?.url {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
                completion(cookies)
            } else {
                completion([])
            }
        }
        task.resume()
    }
    
    
    
    func translateText(text: String, targetLang: String) {
        fetchDynamicCookies { cookies in
            let headers = [
                "authority": "translate.google.com",
                "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
                "accept-language": "it-IT,it;q=0.9,en-US;q=0.8,en;q=0.7",
                "referer": "https://translate.google.com/m?sl=auto&tl=it&hl=it&q=ciao+come+va%3F",
                "sec-ch-ua": "\"Google Chrome\";v=\"113\", \"Chromium\";v=\"113\", \"Not-A.Brand\";v=\"24\"",
                "sec-ch-ua-arch": "\"x86\"",
                "sec-ch-ua-bitness": "\"64\"",
                "sec-ch-ua-full-version": "\"113.0.5672.126\"",
                "sec-ch-ua-full-version-list": "\"Google Chrome\";v=\"113.0.5672.126\", \"Chromium\";v=\"113.0.5672.126\", \"Not-A.Brand\";v=\"24.0.0.0\"",
                "sec-ch-ua-mobile": "?0",
                "sec-ch-ua-model": "\"\"",
                "sec-ch-ua-platform": "\"macOS\"",
                "sec-ch-ua-platform-version": "\"14.5.0\"",
                "sec-ch-ua-wow64": "?0",
                "sec-fetch-dest": "document",
                "sec-fetch-mode": "navigate",
                "sec-fetch-site": "same-origin",
                "sec-fetch-user": "?1",
                "upgrade-insecure-requests": "1",
                "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36",
                "x-client-data": "CKy1yQEIjLbJAQimtskBCKmdygEImOvKAQiSocsBCIagzQEIucrNAQ==",
            ]

            let params = [
                "sl": "auto",
                "tl": targetLang,
                "hl": targetLang,
                "q": text // UtilityFunctions.prepareTextForHeader(from: text),
            ]

            print(targetLang)
            var urlComponents = URLComponents(string: "https://translate.google.com/m")!
            urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }

            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers

            let cookieHeader = HTTPCookie.requestHeaderFields(with: cookies)
            request.allHTTPHeaderFields?.merge(cookieHeader) { (current, _) in current }

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error)
                } else if let data = data {
                    if let str = String(data: data, encoding: .utf8) {
                        // print(str)
                        DispatchQueue.main.async {
                            // print(data)
                            self.translatedLabel.string = UtilityFunctions.parseTranslation(from: str) ?? "Translation Error"
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
