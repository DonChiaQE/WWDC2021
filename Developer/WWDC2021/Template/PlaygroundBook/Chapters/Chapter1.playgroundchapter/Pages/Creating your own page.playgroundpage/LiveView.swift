import UIKit
import SwiftUI
import BookCore
import PlaygroundSupport
import WebKit

public struct ContentView: View {
    public init() {}
    @State var html = """
<div class="title">
  <!-- put your name here -->
</div>

<div class="details">
  <!-- use some paragraph tags and add some details about yourself! -->
</div>

<div class="biography">
  <!-- go wild with your own biography -->
</div>
"""
    @State var css = """
.title {
  width: 100%;
  background: none;
  border-radius: none;
  text-decoration: none;
  color: black;
  padding: none;
  text-align: left;
}

.details {
  width: 100%;
  background: none;
  border-radius: none;
  text-decoration: none;
  color: black;
  padding: none;
  text-align: left;
}

.biography {
  width: 100%;
  background: none;
  border-radius: none;
  text-decoration: none;
  color: black;
  padding: none;
  text-align: left;
}
"""
    
    public var body: some View {
        VStack {
            WebView(html: $html, css: $css)
                .cornerRadius(10)
                .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            HStack {
                TextView(text: $html)
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                TextView(text: $css)
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
            }
        }.padding()
    }
}

public struct WebView: UIViewRepresentable {
    @Binding var html: String
    @Binding var css: String
    
    public func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString("""
    <html>
    \(html)
    </html>
    <style>
    \(css)
    html { font-family: Arial, Helvetica, sans-serif; }
    </style>
    """, baseURL: nil)
    }
}

struct TextView: UIViewRepresentable {
    @Binding var text: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {

        let myTextView = UITextView()
        myTextView.delegate = context.coordinator

        myTextView.font = UIFont(name: "Courier", size: 15)
        myTextView.isScrollEnabled = true
        myTextView.isEditable = true
        myTextView.isUserInteractionEnabled = true
        myTextView.autocapitalizationType = .none
        myTextView.keyboardType = .asciiCapable
        myTextView.isSelectable = true
        myTextView.contentInsetAdjustmentBehavior = .never

        return myTextView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    class Coordinator : NSObject, UITextViewDelegate {

        var parent: TextView

        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            print("text now: \(String(describing: textView.text!))")
            self.parent.text = textView.text
        }
    }
}

PlaygroundPage.current.setLiveView(ContentView())
