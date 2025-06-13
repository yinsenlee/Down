//
//  HikMarkdown.swift
//  HikIMSdk
//
//  Created by YONG on 2025/6/12.
//

import Foundation
import UIKit

@objc public class HikDown: NSObject {

    /// 公开的 Markdown 属性，供 OC 设置
    @objc public var markdown: String = ""

    public override init() {
        super.init()
    }

    /// 渲染当前 markdown 属性，返回 HTML 字符串
    /// 失败时通过 error 输出 NSError
    @objc public func renderHTML(error: NSErrorPointer) -> String? {
        let down = Down(markdownString: markdown)
        do {
            return try down.toHTML()
        } catch let renderError as NSError {
            error?.pointee = renderError
            return nil
        }
    }
}
