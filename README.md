# ios-pdfviewer-demo
iOS PDF Viewerのサンプルです。(Swift3)

## ページ送りの方向について
UICollectionViewのScrollDirection(Vertical/Horizontal)によって、ページ送りの方向が変わります。

## WebViewを利用した場合

```swift:
    private func loadPDF() {
        
        let url = Bundle.main.url(forResource: "C91-Domain_Driven_Design", withExtension: "pdf")
        let req = URLRequest(url: url!)
        self.webView.loadRequest(req)
    }
```
