//
//  ViewController.m
//  实时判断用户的输入内容
//
//  Created by 王奥东 on 16/7/13.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+judgeOfReachability.h"


#define W   [UIScreen mainScreen].bounds.size.width
#define H   [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UITextFieldDelegate>

//保存页面内所有的textField
@property(nonatomic,strong)NSMutableArray <UITextField *> *array;
//下一步按钮
@property(nonatomic,strong)UIButton *nextBtn;
//用户的真实姓名输入正确与否的判断
@property(nonatomic,assign)BOOL isUserName;
//用户的身份证号输入正确与否的判断
@property(nonatomic,assign)BOOL isUserID;


@end

@implementation ViewController


//array懒加载
-(NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];

    
    //设置信息输入框
    UIView *nameView = [self createImport:@"真实姓名" AndPoint:CGPointMake(0, 66) AndPlaceholder:@"您的真实姓名"];
    
    UIView *userID = [self createImport:@"身份证号" AndPoint:CGPointMake(0, CGRectGetMaxY(nameView.frame)) AndPlaceholder:@"18位身份证号"];
  
    [self.view addSubview:nameView];
    [self.view addSubview:userID];
    
    
    //下一步按钮
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(userID.frame)+50, 330, 44)];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[self createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[self createImageWithColor:[UIColor redColor]] forState:UIControlStateSelected];
    
    nextBtn.font = [UIFont systemFontOfSize:18];
    
    [nextBtn addTarget:self action:@selector(clickNext:) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn = nextBtn;
    [self.view addSubview:nextBtn];
    
    //给当前页面存在的textField添加tag值
    for (int i = 0; i < self.array.count; i++) {
        self.array[i].tag = i;
    }
    
}


#warning --- 重点在这！ ------
#pragma mark texrField的代理方法
//通过textField的代理方法判断姓名与身份证号码输入是否正确
//正在编辑的时候
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    //如果string.length为nil代表输入的是撤销
    if (!string.length) {
        
        NSRange ranges;
        if (textField.text.length > 0) {
            ranges= NSMakeRange(0, textField.text.length - 1);
        }else{
            ranges = NSMakeRange(0, 0);
        }
        NSString *subString = [textField.text substringWithRange:ranges];
        
        [self judgeNextbtnAndTextField:textField String:subString];
        
    }
    //否则就是输入了字符
    else {
        NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
        
        [self judgeNextbtnAndTextField:textField String:str];
    }
    
    
    
    return YES;
}

#warning --- 重点还有这！ ---
#pragma mark 判断下一步按钮能否点击
-(void)judgeNextbtnAndTextField:(UITextField *)textField String:(NSString *)string{
    
    
    
    
    //通过正则表达式判断输入是否符合要求
    if (textField.tag==0 ) {
        
        if ([NSObject checkUserName:string]) {
            self.isUserName = YES;
        }
        
        else{
            self.isUserName = NO;
        }
        
        
    }
    else if(textField.tag==1){
        
        if ([NSObject checkUserIdCard:string]) {
            self.isUserID = YES;
        }
        
        else{
            self.isUserID = NO;
        }
        
    }
    
    
    
    //如果姓名、身份证号输入正确则可以点击下一步
    if (self.isUserID && self.isUserName) {
        
        self.nextBtn.selected = YES;
        
    }else{
        
        self.nextBtn.selected = NO;
    }
    
}


#pragma mark - 下一步按钮的点击事件
-(void)clickNext:(UIButton *)sender{

    
    if (self.isUserID && self.isUserName) {
        
        NSLog(@"用户的信息输入都正确~");

    }
    
    
}



#pragma mark 真实姓名、身份证号信息输入设置
-(UIView *) createImport:(NSString *)text AndPoint:(CGPoint)point AndPlaceholder:(NSString *)placeholder{
    
    //信息输入框的View界面
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    
    //添加下分割线
    [self createBotLine:view];
    
    //信息输入框中的文本信息
    UILabel *label;
    if (text) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 120, 44)];
        label.text = text;
        label.textColor = [UIColor blackColor];
        [label setFont:[UIFont systemFontOfSize:15]];
        [view addSubview:label];
    }
    else{
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    
    
    //信息输入框中的textField
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(label.frame.size.width+10, 0, W-label.frame.size.width-5, 44)];
    textField.placeholder = placeholder;
    
    [textField setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:textField];
    [self.array addObject:textField];
    textField.delegate = self;
    
    //重新设置view的frame
    view.frame = CGRectMake(point.x, point.y, W, CGRectGetMaxY(textField.frame));
    
    return view;
}

#pragma mark - 生成一个下分割线
-(UIView *)createBotLine:(UIView *)baskView{
    
    //信息输入框的下分割线
    UIView *botLine = [[UIView alloc]initWithFrame:CGRectMake(5, baskView.frame.size.height-1, W-10, 1)];
    botLine.backgroundColor = [UIColor grayColor];
    
    [baskView addSubview:botLine];
    return baskView;
}

#pragma mark - 通过颜色生成图片
-(UIImage*)createImageWithColor:(UIColor*)color{
    
    CGRect rect=CGRectMake(0.0f,0.0f,30,30);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage * theImage=UIGraphicsGetImageFromCurrentImageContext();UIGraphicsEndImageContext();
    
    return theImage;
    
}

@end
