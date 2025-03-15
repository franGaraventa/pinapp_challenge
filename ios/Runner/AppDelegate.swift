import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let methodChannelName = "com.pinapp.challenge.pinapp_challenge.service"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: methodChannelName, binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { [weak self] (call, result) in
          if call.method == "getComments" {
            if let args = call.arguments as? [String: Any], let urlString = args["url"] as? String {
              self?.getDataFromUrl(from: urlString, result: result)
            } else {
              result(FlutterError(code: "INVALID_ARGUMENT", message: "URL no proporcionada", details: nil))
            }
          } else {
            result(FlutterMethodNotImplemented)
          }
        }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func getDataFromUrl(from url: String, result: @escaping FlutterResult) {
      guard let url = URL(string: url) else {
        result(FlutterError(code: "INVALID_URL", message: "Formato de URL no valido", details: nil))
        return
      }

      let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
          result(FlutterError(code: "NETWORK_ERROR", message: error.localizedDescription, details: nil))
          return
        }

        if let data = data {
           let responseString = String(data: data, encoding: .utf8)
                result(responseString)
           } else {
                result(nil)
           }
      }
      task.resume()
    }
}
