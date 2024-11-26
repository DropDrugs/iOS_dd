// Copyright © 2024 RT4. All rights reserved

import UIKit
import QuickLook

class PDFPreviewController: QLPreviewController, QLPreviewControllerDataSource {
    var pdfURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 로컬 PDF 파일 경로 설정
        if let url = Bundle.main.url(forResource: "Privacy", withExtension: "pdf") {
            self.pdfURL = url
        }

        self.dataSource = self
    }

    // QLPreviewControllerDataSource
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return pdfURL! as QLPreviewItem
    }
}

