# ios-pdfviewer-demo
iOS PDF Viewerのサンプルです。(Swift3)

<img width="260" alt="2017-03-14 13 10 21" src="https://cloud.githubusercontent.com/assets/9479568/23885667/13980032-08b8-11e7-8f08-6a2c4b410d40.png">

## ページ送りの方向について
UICollectionViewのScrollDirection(Vertical/Horizontal)によって、ページ送りの方向が変わります。

## [参考]WebViewを利用した場合

```swift:
    private func loadPDF() {
        
        let url = Bundle.main.url(forResource: "apple", withExtension: "pdf")
        let req = URLRequest(url: url!)
        self.webView.loadRequest(req)
    }
```
