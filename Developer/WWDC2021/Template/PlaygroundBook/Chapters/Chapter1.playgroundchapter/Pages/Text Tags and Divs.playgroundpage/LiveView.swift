import SwiftUI
import WebKit
import PlaygroundSupport

public struct ContentView: View {
    public init() {}
    @State var html = """
<div class="biography">
    
    <h1>Don</h1>

    <!-- add the rest from the stickies here -->

</div>
"""
    @State var css = """
.biography {
    background: cyan;
    border-radius: 5px;
    color: black;
    height: auto;
    padding: 20 20 20 20;
    box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.15), 0 6px 20px 0 rgba(0, 0, 0, 0.14);
}
"""
    
    @State var stickies = """
Name: Don
Country of Birth: Singapore
Interesting facts: My first contact with Apple product was a 5th generation iPod that belonged to my Father. We've owned iPhones since the iPhone 3G and being a computing science student, I use a powerful MacBook Pro with the newest M1 as the power allows for me to work swiftly (pun intended). The MacBook coupled with tools like Xcode allows me to power through my iOS development journey.
"""
    @State var dragAmount: CGPoint?
    
    @State var stickyColor: UIColor = UIColor(red: 0.99, green: 0.96, blue: 0.65, alpha: 1.00)
    @State var editorColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.00)
    
    public var body: some View {
        GeometryReader { gp in
            ZStack {
                
                VStack {
                    WebView(html: $html, css: $css)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    HStack {
                        TextView(text: $html, color: $editorColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        TextView(text: $css, color: $editorColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                }.padding()
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(Color(red: 251 / 255, green: 235 / 255, blue: 97 / 255))
                        .frame(width: 300, height: 250)
                    
                    TextView(text: $stickies, color: $stickyColor)
                        .frame(width: 300, height: 235)
                        .background(Color(red: 252 / 255, green: 244 / 255, blue: 167 / 255))
                }
                .background(Color.white
                    .shadow(radius: 10, x: 0, y: 0)
                  )
                .animation(.none)
                .position(self.dragAmount ?? CGPoint(x: gp.size.width / 1.5, y: gp.size.height / 3))
                .highPriorityGesture(
                    DragGesture()
                        .onChanged { self.dragAmount = $0.location})
            }.frame(maxWidth: gp.size.width, maxHeight: gp.size.height)
        }
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
    <body>
    \(html)
    </body>
    </html>
    <style>
    \(css)
    html {
            font-family: Arial, Helvetica, sans-serif;
    }
    </style>
    """, baseURL: nil)
    }
}

struct TextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var color: UIColor
    
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
        myTextView.backgroundColor = color
        
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
