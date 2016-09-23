//
//  MMPictureViewController.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/22.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MMPictureViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/ALAsset.h>
#import "MMPictureAddCell.h"
#import "MMPictureCollectionViewCell.h"

@interface MMPictureViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, MJPhotoBrowserDelegate, ELCImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) UICollectionView *pictureCollectionView;

@property (nonatomic, strong) NSMutableArray *pictureAry;

@end

@implementation MMPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Stars@2x.png"]];
    [self.view addSubview:self.pictureCollectionView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---setter

- (NSMutableArray *)pictureAry
{

    if (!_pictureAry) {
        _pictureAry = [NSMutableArray array];
    }
    return _pictureAry;
}
- (UICollectionView *)pictureCollectionView
{
    if (!_pictureCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(75, 75);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 5; //上下的间距 可以设置0看下效果
        layout.sectionInset = UIEdgeInsetsMake(0.f, 5, 5.f, 5);
        
        //创建 UICollectionView
        _pictureCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 75) collectionViewLayout:layout];
        
        _pictureCollectionView.backgroundColor = [UIColor redColor];
        [_pictureCollectionView registerClass:[MMPictureCollectionViewCell class]forCellWithReuseIdentifier:@"cell"];
        
        [_pictureCollectionView registerClass:[MMPictureAddCell class] forCellWithReuseIdentifier:@"addItemCell"];
        
        _pictureCollectionView.backgroundColor = [UIColor grayColor];
        _pictureCollectionView.delegate = self;
        _pictureCollectionView.dataSource = self;

    }
    return _pictureCollectionView;
}


#pragma mark - collectionView 调用方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pictureAry.count +1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.pictureAry.count) {
        static NSString *addItem = @"addItemCell";
        UICollectionViewCell *addItemCell = [collectionView dequeueReusableCellWithReuseIdentifier:addItem forIndexPath:indexPath];
        
        return addItemCell;
    }else
    {
        static NSString *identify = @"cell";
        MMPictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        
        cell.imageView.image = self.pictureAry[indexPath.row];
        return cell;
    }
}

//用代理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.pictureAry.count) {
        if (self.pictureAry.count > 8) {
            return;
        }
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机选择", @"拍照", nil];
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [sheet showInView:self.view];
    }else
    {
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        for (int i = 0;i< self.pictureAry.count; i ++) {
            UIImage *image = self.pictureAry[i];
            
            MJPhoto *photo = [MJPhoto new];
            photo.image = image;
            MMPictureCollectionViewCell *cell = (MMPictureCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            photo.srcImageView = cell.imageView;
            [photoArray addObject:photo];
        }
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.photoBrowserdelegate = self;
        browser.currentPhotoIndex = indexPath.row;
        browser.photos = photoArray;
        [browser show];
        
    }
}

- (void)deletedPictures:(NSSet *)set
{
    NSMutableArray *cellArray = [NSMutableArray array];
    
    for (NSString *index1 in set) {
        [cellArray addObject:index1];
    }
    
    if (cellArray.count == 0) {
        
    }else if (cellArray.count == 1 && self.pictureAry.count == 1) {
        NSIndexPath *indexPathTwo = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.pictureAry removeObjectAtIndex:indexPathTwo.row];
        [self.pictureCollectionView deleteItemsAtIndexPaths:@[indexPathTwo]];
    }else{
        
        for (int i = 0; i<cellArray.count-1; i++) {
            for (int j = 0; j<cellArray.count-1-i; j++) {
                if ([cellArray[j] intValue]<[cellArray[j+1] intValue]) {
                    NSString *temp = cellArray[j];
                    cellArray[j] = cellArray[j+1];
                    cellArray[j+1] = temp;
                }
            }
        }
        
        for (int b = 0; b<cellArray.count; b++) {
            int idexx = [cellArray[b] intValue]-1;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idexx inSection:0];
            
            [self.pictureAry removeObjectAtIndex:indexPath.row];
            [self.pictureCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
    }
    
    if (self.pictureAry.count <4) {
        self.pictureCollectionView.frame = CGRectMake(0, 100, self.view.frame.size.width, 75);
    }else if (self.pictureAry.count <8)
    {
        self.pictureCollectionView.frame = CGRectMake(0, 100, self.view.frame.size.width, 160);
    }else
    {
        self.pictureCollectionView.frame = CGRectMake(0, 100, self.view.frame.size.width, 240);
    }
}

#pragma mark - 相册、相机调用方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"点击了从手机选择");
        
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        elcPicker.maximumImagesCount = 9 - self.pictureAry.count;
        elcPicker.returnsOriginalImage = YES;
        elcPicker.returnsImage = YES;
        elcPicker.onOrder = NO;
        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
        elcPicker.imagePickerDelegate = self;
        //    elcPicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;//过渡特效
        [self presentViewController:elcPicker animated:YES completion:nil];
        
    }else if (buttonIndex == 1)
    {
        NSLog(@"点击了拍照");
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            
            picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self presentViewController:picker animated:YES completion:nil];
        }else{
            NSLog(@"模拟无效,请真机测试");
        }
    }
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    __weak typeof(self) wself = self;
    
    [self dismissViewControllerAnimated:YES completion:^{
        BOOL hasVideo = NO;
        
        NSMutableArray *images = [NSMutableArray array];
        for (NSDictionary *dict in info) {
            if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
                if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                    UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                    [images addObject:image];
                } else {
                    NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
                }
            } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
                if (!hasVideo) {
                    hasVideo = YES;
                }
            } else {
                NSLog(@"Uknown asset type");
            }
        }
        
        NSMutableArray *indexPathes = [NSMutableArray array];
        for (unsigned long i = wself.pictureAry.count; i < wself.pictureAry.count + images.count; i++) {
            [indexPathes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [wself.pictureAry addObjectsFromArray:images];
        // 调整集合视图的高度
        
        [UIView animateWithDuration:.25 delay:0 options:7 animations:^{
            
            if (wself.pictureAry.count <4) {
                wself.pictureCollectionView.frame = CGRectMake(0, 100, wself.view.frame.size.width, 75);
            }else if (wself.pictureAry.count <8)
            {
                wself.pictureCollectionView.frame = CGRectMake(0, 100, wself.view.frame.size.width, 160);
            }else
            {
                wself.pictureCollectionView.frame = CGRectMake(0, 100, wself.view.frame.size.width, 240);
            }
            
            [wself.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            // 添加新选择的图片
            [wself.pictureCollectionView performBatchUpdates:^{
                [wself.pictureCollectionView insertItemsAtIndexPaths:indexPathes];
            } completion:^(BOOL finished) {
                if (hasVideo) {
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"暂不支持视频发布" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                }
            }];
        }];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    
    [self.pictureAry addObject:image];
    __weak typeof(self) wself = self;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:.25 delay:0 options:7 animations:^{
            if (wself.pictureAry.count <4) {
                wself.pictureCollectionView.frame = CGRectMake(0, 100, wself.view.frame.size.width, 75);
            }else if (wself.pictureAry.count <8)
            {
                wself.pictureCollectionView.frame = CGRectMake(0, 100, wself.view.frame.size.width, 160);
            }else
            {
                wself.pictureCollectionView.frame = CGRectMake(0, 100, wself.view.frame.size.width, 240);
            }
            
            [wself.view layoutIfNeeded];
        } completion:nil];
        
        [self.pictureCollectionView performBatchUpdates:^{
            [wself.pictureCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:wself.pictureAry.count - 1 inSection:0]]];
        } completion:nil];
    }];
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
