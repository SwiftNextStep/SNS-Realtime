//
//  ImageHelper.swift
//  SNS-Realtime
//
//  Created by Icaro Lavrador on 25/04/16.
//  Copyright © 2016 Icaro Barreira Lavrador. All rights reserved.
//

import Foundation

class ImageHelper{
    
    static func resizeImage(image: UIImage) -> UIImage{
        
        let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.5, 0.5))
        let scale:CGFloat = 0
        let hasAlpha = false
        
        UIGraphicsBeginImageContextWithOptions(size, hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
}