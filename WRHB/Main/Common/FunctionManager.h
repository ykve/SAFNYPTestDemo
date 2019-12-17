//
//  FunctionManager.h
//  I_am_here
//
//  Created by wc on 13-5-2.
//  Copyright (c) 2013年 wc. All rights reserved.
//应用中需要用到的一些函数

#import <CoreLocation/CoreLocation.h>

@class FLAnimatedImage;

typedef NS_ENUM(NSInteger, FixTypes)
{
    FixTypes_width,
    FixTypes_height,
};//哪个固定


@interface FunctionManager : NSObject<CLLocationManagerDelegate,UIAlertViewDelegate>{
    
}

+(FunctionManager *)sharedInstance;


-(id)getCacheDataByKey:(NSString*)key;

-(void)setCacheDataWithKey:(NSString*)key data:(id)data;
+ (BOOL)isPureInt:(NSString*)string;
+(BOOL)isEmpty:(NSString *)text;
+(CGFloat)getTextWidth:(NSString *)string withFontSize:(UIFont *)font withHeight:(CGFloat)height;

+(BOOL)getDataSuccessed:(NSDictionary *)dic;
+ (CGFloat)getContentHeightWithParagraphStyleLineSpacing:(CGFloat)lineSpacing fontWithString:(NSString*)fontWithString fontOfSize:(CGFloat)fontOfSize boundingRectWithWidth:(CGFloat)width;
+(NSString *)getAppSource;
-(NSString *)getDeviceModel;//机器型号 如iPod4,1,
-(NSString *)getIosVersion;//系统版本号 如4.3.5
-(NSString *)getApplicationVersion;//软件版本
-(NSString *)getApplicationName;//获取应用名
-(NSString *)getApplicationID;//软件ID
-(void)showAlertWithTitle:(NSString *)title andText:(NSString *)text;//弹出无回调的警告框

- (NSInteger)getWeekFromString:(NSString *)dateString;

- (NSString *)stringFromDate:(NSDate *)date;

-(NSDate*)dateFromString:(NSString*)uiDate andFormat:(NSString *)format;


-(UIImage*)imageWithColor:(UIColor*)color;
-(UIImage*)imageWithColor:(UIColor*)color andSize:(CGSize)size;

-(int)heightForLabel:(UILabel *)label;

-(int)heightForStr:(NSString *)string andFont:(UIFont *)font andLineBreakMode:(NSLineBreakMode)mode andWidth:(int)width;

//完整的网络地址
-(NSString *)fullPathWithUrl:(NSString *)url;

- (NSString *)URLEncodedWithString:(NSString *)url;//将有中文的地址转成url编码
- (NSString *)encodedWithString:(NSString *)string;

-(UITableViewCell *)cellForChildView:(UIView *)view;

-(void)fetchVersionInfo;

-(CGSize)getFitSizeWithLabel:(UILabel *)label;
-(CGSize)getFitSizeWithLabel:(UILabel *)label withFixType:(FixTypes)fixType;

//归档`
-(BOOL)archiveWithData:(id)data andFileName:(NSString *)fileName;
-(id)readArchiveWithFileName:(NSString *)fileName;

//跳过icloud备份
-(BOOL)skipIcoundBackupAtURL:(NSString*)filePath;

-(UIViewController *)currentViewController;

-(NSString *)documentCachePath;

- (NSInteger)getAttributedStringHeightWithString:(NSAttributedString *)string width:(NSInteger)width height:(NSInteger)height;

-(UIWindow *)getMainView;

-(CGSize)getFitSizeWithStr:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)maxSize;

-(void)checkVersion:(BOOL)showAlert;

- (void)exitApp;

-(NSArray *)orderBombArray:(NSArray *)bombArray;//给禁抢的雷数排序
-(NSString *)formatBombArrayToString:(NSArray *)bombArray;//将雷数格式化成字符串显示

-(NSDictionary *)appConstants;//一些保存在文件里的常量数据

-(NSString*)getAppIconName;

- (UIImage*)imageWithView:(UIView*) view;

-(UIImage *)grayImage:(UIImage *)oldImage;

-(NSMutableDictionary *)removeNull:(NSDictionary *)dict;


/**
 获取时间戳
 
 @return  时间戳 字符串    // 13位
 */
+ (NSTimeInterval)getNowTime;
/**
 gif图片转换
 
 @param imgStr 图片名称
 @return 转换后的 gif
 */
- (UIImage *)gifImgImageStr:(NSString *)imgStr;

/**
 gif图片转换
 
 @param imgName 图片名称
 @return 转换后的 gif FLAnimatedImage
 */
- (FLAnimatedImage *)gifFLAnimatedImageStr:(NSString *)imgName;

@end
