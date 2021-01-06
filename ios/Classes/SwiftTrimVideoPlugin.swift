import Flutter
import UIKit
import AVFoundation

public class SwiftTrimVideoPlugin: NSObject, FlutterPlugin {
    
    var eventChanelSink: FlutterEventSink?
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftTrimVideoPlugin()
        
        // flutter 调用 原生
        let channel = FlutterMethodChannel(name: "com.nwdn.plugins/trim/video/method/channel", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
        
//        // 原生调用flutter  回传
//        let eventChannel = FlutterEventChannel.init(name: "com.nwdn.plugins/trim/video/event/channel", binaryMessenger: registrar.messenger())
//        eventChannel.setStreamHandler(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        //  获取缩略图 并回传给flutter
        if (call.method == "videoThumbnails") {
            let par = call.arguments as! Dictionary<String, Any>
            let videoPath = par["videoPath"] as! String;
            let count = par["count"] as! Int;
            getVideoThumbnail(videoPath, count) { (success, splitimgs, duration) in
                if (success) {
                    let resultDict:[String:Any] = ["thumbnails" : splitimgs, "duration" : duration]
                    result(resultDict)
                }
            }
        }
        
        //  截取视频
        if (call.method == "trimVideo") {
            let par = call.arguments as! Dictionary<String, Any>
            let startTime = par["startTime"] as! Double
            let duration = par["duration"] as! Double
            let videoPath = par["videoPath"] as! String;
    
            trimVideo(videoPath, startTime: startTime, duration: duration) { (exportsession) in
                if (AVAssetExportSession.Status.failed == exportsession?.status) {
                    debugPrint(exportsession?.error ?? "未知错误")
                } else if (AVAssetExportSession.Status.completed == exportsession?.status) {
                    if let url = exportsession?.outputURL {
                        result(url.path)
                    }
                }
            }
        }
    }
    
    
    
    // MARK: 获取视频的缩略图数组
    func getVideoThumbnail(_ path: String?, _ count: Int, splitCompleteBlock: @escaping (_ success: Bool, _ splitimgs: [Data], _ duration: Double) -> Void) {
        let asset = AVAsset(url: URL(fileURLWithPath: path ?? ""))
        var arrayImages: [Data] = []
        //  视频的长度
        let videoDuration = Double(asset.duration.value) / Double(asset.duration.timescale);
        asset.loadValuesAsynchronously(forKeys: ["duration"], completionHandler: {
            let generator = AVAssetImageGenerator(asset: asset)
            // generator.maximumSize = CGSize(width: 480,height: 136);//如果是CGSizeMake(480,136)，则获取到的图片是{240, 136}。与实际大小成比例
            generator.appliesPreferredTrackTransform = true
            // 这个属性保证我们获取的图片的方向是正确的。比如有的视频需要旋转手机方向才是视频的正确方向。
            // 因为有误差，所以需要设置以下两个属性。如果不设置误差有点大，设置了之后相差非常非常的小*
            generator.requestedTimeToleranceAfter = .zero
            generator.requestedTimeToleranceBefore = .zero
            let seconds = CMTimeGetSeconds(asset.duration)
            
            // let count: Int = Int(seconds/1);
            
            var array: [NSValue] = []
            for i in 0..<count {
                let time = CMTimeMakeWithSeconds(Float64(Double(i) * (seconds / Double(count))), preferredTimescale: asset.duration.timescale) //想要获取图片的时间位置
                array.append(NSValue(time: time))
            }
            var i = 0
            
            generator.generateCGImagesAsynchronously(forTimes: array, completionHandler: { requestedTime, imageRef, actualTime, result, error in
                i += 1
                if result == .succeeded {
                    var image: UIImage? = nil
                    if let imageRef = imageRef {
                        image = UIImage(cgImage: imageRef)
                    }
                    if let image = image {
                        if let data = image.pngData() {
                            arrayImages.append(data)
                        }
                    }
                } else {
                    print("获取图片失败！！！")
                }
                if i == count {
                    DispatchQueue.main.async(execute: {
                        splitCompleteBlock(true, arrayImages, videoDuration)
                    })
                }
            })
        })
    }
    
    
    // MARK: 截取视频
    func trimVideo(_ videoPath: String, startTime: Double, duration: Double, completionHandler: @escaping (_ exportsession: AVAssetExportSession?) -> Void) {
        
        let asset = AVURLAsset(url: URL(fileURLWithPath: videoPath), options: nil)
        
        let kNwdnAsset = "nwdn_asset/"
        let tmpNwdn = NSTemporaryDirectory() + kNwdnAsset
        let _ = NwdnFileManager.delete(atPath: tmpNwdn)
        let _ = NwdnFileManager.creatDir(atPath: tmpNwdn)
        let path = tmpNwdn + "outFile" + ".mp4"
        
        let startCMTime = CMTime(seconds: startTime, preferredTimescale: 1)
        let durationCMTime = CMTime(seconds: duration, preferredTimescale: 1)
        
        let fileUrl = URL(fileURLWithPath: path)

        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough)
        
        exportSession?.outputURL = fileUrl
        
        exportSession?.shouldOptimizeForNetworkUse = true
        
        exportSession?.outputFileType = .mp4
        
        let range = CMTimeRangeMake(start: startCMTime, duration: durationCMTime)
        
        exportSession?.timeRange = range
        
        exportSession?.exportAsynchronously(completionHandler: {
            DispatchQueue.main.async(execute: {
                completionHandler(exportSession)
            })
        })
    }
    
}


//extension SwiftTrimVideoPlugin: FlutterStreamHandler {
//    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
//        eventChanelSink = events
//        return nil
//    }
//    
//    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
//        return nil
//    }
//    
//    
//}
