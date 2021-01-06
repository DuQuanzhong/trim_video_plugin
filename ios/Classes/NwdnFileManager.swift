//
//  FileManager.swift
//  trim_video_plugin
//
//  Created by Quanzhong Du  on 2021/1/6.
//

import UIKit

class NwdnFileManager: NSObject {
    /// 判断文件是否存在
    static func isExist(atPath filePath : String) -> Bool {
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    /// 创建文件目录
    static func creatDir(atPath dirPath : String) -> Bool {
        
        if isExist(atPath: dirPath) {
            return false
        }
        
        do {
            try FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    /// 删除文件 或者目录
    static func delete(atPath filePath : String) -> Bool {
        guard isExist(atPath: filePath) else {
            return false
        }
        do {
            try FileManager.default.removeItem(atPath: filePath)
            return true
        } catch  {
            print(error)
            return false
        }
    }
}
