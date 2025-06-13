//
//  HikDownView.swift
//  HikIMSdk
//
//  Created by YONG on 2025/6/13.
//

import Foundation
import WebKit

@objc public class HikDownView: DownView {

    /// 加载完成回调，返回 HTML 内容高度（单位：point）
    @objc public var onDidLoad: ((_ contentHeight: CGFloat) -> Void)?
    @objc public var onOpenURL: ((URL) -> Void)?

    private var delegateForwarder: WKNavigationDelegateForwarder?

    /// 实际初始化方法，先传一个空字符串 markdown
    @objc public init(frame: CGRect, markdown: String) throws {
        try super.init(frame: frame, markdownString: markdown)
        
        let forwarder = WKNavigationDelegateForwarder(
            originalDelegate: self.navigationDelegate,
            onDidLoad: {[weak self]  contentHeight in self?.onDidLoad?(contentHeight)
            },
            onOpenURL: { [weak self] url in self?.onOpenURL?(url) }
        )
        
        self.navigationDelegate = forwarder
        self.delegateForwarder = forwarder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ✅ 加载 Markdown 内容（可供 OC 调用）
    @objc public func updateMarkdown(_ markdown: String) {
        do {
            try super.update(markdownString: markdown)
        } catch {
            print("更新 Markdown 失败：\(error)")
        }
    }
}







// 转发器类：用于拦截并转发 WKNavigationDelegate 事件
class WKNavigationDelegateForwarder: NSObject, WKNavigationDelegate {
    weak var originalDelegate: WKNavigationDelegate?
    @objc public var onDidLoad: ((_ contentHeight: CGFloat) -> Void)?
    var onOpenURL: ((URL) -> Void)?

    init(originalDelegate: WKNavigationDelegate?,
         onDidLoad: ((_ contentHeight: CGFloat) -> Void)?,
         onOpenURL: ((URL) -> Void)?) {
        self.originalDelegate = originalDelegate
        self.onDidLoad = onDidLoad
        self.onOpenURL = onOpenURL
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        originalDelegate?.webView?(webView, didFinish: navigation)
        
        // 获取 HTML 内容高度
        let js = "document.body.scrollHeight;"
        webView.evaluateJavaScript(js) { [weak self] result, error in
            guard error == nil, let height = result as? CGFloat else {
                print("获取内容高度失败：\(error?.localizedDescription ?? "未知错误")")
                self?.onDidLoad?(0)
                return
            }
            self?.onDidLoad?(height)
        }
    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if navigationAction.navigationType == .linkActivated,
           let url = navigationAction.request.url {
            onOpenURL?(url)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
