//  Copyright (c) 2020 Shortcut AS
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software
//  and associated documentation files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
//  BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

class StaticViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .gray

    let closeBarButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                         target: self, action: #selector(dismissMe))
    navigationItem.rightBarButtonItem = closeBarButton

    let closeButton = UIButton(type: .custom)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    closeButton.setTitle("Dismiss", for: .normal)
    closeButton.addTarget(self, action: #selector(dismissMe), for: .touchUpInside)
    view.addSubview(closeButton)

    NSLayoutConstraint.activate([
        closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        closeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }

  @objc func dismissMe() {
    dismiss(animated: true)
  }
}
