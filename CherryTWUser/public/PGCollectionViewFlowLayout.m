//
//  PGCollectionViewFlowLayout.m
//  CherryTWUser
//
//  Created by guo on 2024/12/4.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGCollectionViewFlowLayout.h"

@implementation PGCollectionViewFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray * attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    CGFloat rightX = self.itemLeft;
    CGFloat itemY = 0;
    CGFloat collectViewW = self.collectViewWidth > 0 ? self.collectViewWidth : ScreenWidth;
    
    if (attributes.count > 0) {
        UICollectionViewLayoutAttributes *firstAttributes = attributes[0];
        CGRect frame = firstAttributes.frame;
        frame.origin.x = self.itemLeft;
        firstAttributes.frame = frame;
        
       rightX += getSize(self.dataArray.firstObject, self.itemHeight, self.fontNum).width+self.addWidth;
    }
    //第一个frame不用更改 从第二个循环到最后一个
    for (NSInteger i = 1 ; i < attributes.count ; i++ ) {
        // 当前的attribute
        UICollectionViewLayoutAttributes * currentLayoutAttributes = attributes[i];
        CGFloat currentCellWidth = getSize(self.dataArray[i], self.itemHeight, self.fontNum).width+self.addWidth;
        
        if (rightX+self.cellSpace+currentCellWidth<collectViewW -self.itemLeft) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = rightX + self.cellSpace;
            frame.origin.y = itemY;
            currentLayoutAttributes.frame = frame;
            rightX += getSize(self.dataArray[i], self.itemHeight, self.fontNum).width+self.addWidth+self.cellSpace;
        }else{
            itemY += self.itemHeight+self.cellSpaceY;
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = self.itemLeft;
            frame.origin.y = itemY;
            currentLayoutAttributes.frame = frame;
            rightX = self.itemLeft+currentCellWidth;
        }
    }
    return attributes;
}

@end
