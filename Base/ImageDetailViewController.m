//
//  ImageDetailViewController.m
//  NewWfunNews
//
//  Created by AnarL on 16/3/21.
//  Copyright © 2016年 AnarL. All rights reserved.
//

#import "ImageDetailViewController.h"

@interface ImageDetailViewController ()<UIScrollViewDelegate>
{
    UIScrollView * _scrollView;
    UIImageView * _imageView;
}

@end

@implementation ImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.delegate = self;
    
    CGSize imageSize = self.image.size;
    CGFloat imageViewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageViewH = imageViewW * imageSize.height / imageSize.width;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageViewW, imageViewH)];
    _imageView.center = self.view.center;
    
    _imageView.userInteractionEnabled = YES;
    _imageView.multipleTouchEnabled = YES;
    _imageView.image = self.image;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [_imageView addGestureRecognizer:tap];
    _scrollView.contentSize = imageSize;
    
    [_scrollView addSubview:_imageView];
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.minimumZoomScale = 0.3;
    
    [self.view addSubview:_scrollView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    //NSLog(@"缩放结束.");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
