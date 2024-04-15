//
//  LMImageEditorConfiguration+Chaining.swift
//  LMImageEditor
//
//  Created by long on 2021/12/22.
//
//  Copyright (c) 2020 Long Zhang <495181165@qq.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

public extension LMImageEditorConfiguration {
    @discardableResult
    func editImageTools(_ tools: [LMImageEditorConfiguration.EditTool]) -> LMImageEditorConfiguration {
        self.tools = tools
        return self
    }
    
    @discardableResult
    func drawColors(_ colors: [UIColor]) -> LMImageEditorConfiguration {
        drawColors = colors
        return self
    }
    
    @discardableResult
    func defaultDrawColor(_ color: UIColor) -> LMImageEditorConfiguration {
        defaultDrawColor = color
        return self
    }
    
    @discardableResult
    func clipRatios(_ ratios: [LMImageClipRatio]) -> LMImageEditorConfiguration {
        clipRatios = ratios
        return self
    }
    
    @discardableResult
    func textStickerTextColors(_ colors: [UIColor]) -> LMImageEditorConfiguration {
        textStickerTextColors = colors
        return self
    }
    
    @discardableResult
    func textStickerDefaultTextColor(_ color: UIColor) -> LMImageEditorConfiguration {
        textStickerDefaultTextColor = color
        return self
    }
    
    @discardableResult
    func textStickerDefaultFont(_ font: UIFont?) -> LMImageEditorConfiguration {
        textStickerDefaultFont = font
        return self
    }
    
    @discardableResult
    func textStickerCanLineBreak(_ enable: Bool) -> LMImageEditorConfiguration {
        textStickerCanLineBreak = enable
        return self
    }
    
    @discardableResult
    func filters(_ filters: [LMFilter]) -> LMImageEditorConfiguration {
        self.filters = filters
        return self
    }
    
    @discardableResult
    func imageStickerContainerView(_ view: (UIView & LMImageStickerContainerDelegate)?) -> LMImageEditorConfiguration {
        imageStickerContainerView = view
        return self
    }

    @discardableResult
    func fontChooserContainerView(_ view: (UIView & LMTextFontChooserDelegate)?) -> LMImageEditorConfiguration {
        fontChooserContainerView = view
        return self
    }
    
    @discardableResult
    func adjustTools(_ tools: [LMImageEditorConfiguration.AdjustTool]) -> LMImageEditorConfiguration {
        adjustTools = tools
        return self
    }
    
    @available(iOS 10.0, *)
    @discardableResult
    func impactFeedbackWhenAdjustSliderValueIsZero(_ value: Bool) -> LMImageEditorConfiguration {
        impactFeedbackWhenAdjustSliderValueIsZero = value
        return self
    }
    
    @available(iOS 10.0, *)
    @discardableResult
    func impactFeedbackStyle(_ style: LMImageEditorConfiguration.FeedbackStyle) -> LMImageEditorConfiguration {
        impactFeedbackStyle = style
        return self
    }
    
    @discardableResult
    func showClipDirectlyIfOnlyHasClipTool(_ value: Bool) -> LMImageEditorConfiguration {
        showClipDirectlyIfOnlyHasClipTool = value
        return self
    }
}
