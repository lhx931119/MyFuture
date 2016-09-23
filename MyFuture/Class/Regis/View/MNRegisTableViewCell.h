//
//  MNRegisTableViewCell.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/5.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MRegisModel;
@interface MNRegisTableViewCell : UITableViewCell


- (void)creatCellForModel:(MRegisModel *)model indexPath:(NSIndexPath *)indexPath;

@end
