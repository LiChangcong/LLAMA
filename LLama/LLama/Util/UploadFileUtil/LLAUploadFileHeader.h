//
//  LLAUploadFileHeader.h
//  LLama
//
//  Created by Live on 16/1/9.
//  Copyright © 2016年 heihei. All rights reserved.
//

#ifndef LLAUploadFileHeader_h
#define LLAUploadFileHeader_h

typedef NS_ENUM(NSInteger,LLAUploadFileType) {
    
    LLAUploadFileType_Text = 0,
    
    LLAUploadFileType_Image = 1,
    
    LLAUploadFileType_Video = 2,
    
};

typedef NS_ENUM(NSInteger,LLAUploadFileResponseCode) {
    
    /**
    *    网络错误状态码
    */

    LLAUploadFileResponseCode_NetworkError = -1,
    
    /**
     *    中途取消的状态码
     */
    
    LLAUploadFileResponseCode_RequestCancelled = -2,
    
    /**
     *    错误参数状态码
     */
    
    LLAUploadFileResponseCode_InvalidArgument = -3,
    
    /**
     *    读取文件错误状态码
     */
    
    LLAUploadFileResponseCode_FileError = -4,
    
    /**
     *    错误token状态码
     */
    
    LLAUploadFileResponseCode_InvalidToken = -5,
    
    /**
     *    0 字节文件或数据
     */
    
    LLAUploadFileResponseCode_ZeroDataSize = -6,

    
};

typedef void (^LLAUploadTokenBlock)(NSString *uploadToken,NSString *uploadKey);
typedef void (^LLAUploadProgressBlock)(NSString *uploadKey,float percent);
typedef void (^LLAUploadCompleteBlock)(LLAUploadFileResponseCode responseCode,NSString *uploadToken,NSString *uploadKey,NSDictionary *respDic);

#endif /* LLAUploadFileHeader_h */
