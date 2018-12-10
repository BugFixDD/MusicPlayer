//
//  String+HandleLyric.swift
//  QQMusic
//
//  Created by 树清吴 on 2018/5/1.
//  Copyright © 2018年 BF. All rights reserved.
//

import Foundation

// 处理歌词
extension String {
    /// 切割lrc字符串，转换成字典timeKey: TimeInterval, textKey: String
    ///
    /// - Parameters:
    ///   - timeKey: 时间的key名字
    ///   - textKey: 每句歌词的key名字
    func handleLyric(timeKey: String, textKey: String) -> [[String: Any]]? {
        let arr = components(separatedBy: "\n")
        
        let pattern = "\\[[0-9]{2}:[0-9]{2}.[0-9]{2}\\]"
        guard let regular = try? NSRegularExpression(pattern: pattern, options: []) else {
            print("没能切割歌词, pattern不正确")
            return nil
        }
        
        var textArr = [[String: Any]]()
        for str in arr {
            let results = regular.matches(in: str, range: NSRange(location: 0, length: str.count))

            for result in results {
                let text = (str as NSString).substring(from: (results.last?.range.location ?? 0) + (results.last?.range.length ?? 0))
                
                let timeStr = (str as NSString).substring(with: result.range)
                
                let format = "[mm:ss.SS]"
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = format
                
                let time = dateFormat.date(from: timeStr)
                let zeroDate = dateFormat.date(from: "[00:00.00]") ?? Date()
                
                let timeInterval = time?.timeIntervalSince(zeroDate) ?? 0
                textArr += [[timeKey: timeInterval, textKey: text]]
            }
        }
        
        return textArr
    }
}
