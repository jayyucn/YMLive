//
//  LCUserEnum.h
//  XCLive
//
//  Created by ztkztk on 14-4-23.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//





/**
 * 修改标记
 */

typedef NS_ENUM(NSInteger,LCEditDetailType){
    LCEditNickname =0,
    LCEditsex =1,
    LCEditBirthday =2,
    LCEditHeight =3,
    LCEditDegree =4,
    LCEditMarriage =5,
    LCEditWage =6,
    LCEditIthink =7,
    LCEditMonologue =8,
    LCEditLocal=9,
    LCEditPhoto=10,
    
    LCRealName=11,
    LCCar=12,
    LCGood=13,
    LCHobbies=14,
    LCHome=15,
    LCHouse=16,
    LCSign=17,
    LCStature=18,
    LCJob=19,
    LCGroupName=20,
  
};



/**
 * 学位类型
 */
typedef NS_ENUM(NSInteger, LCDegreeType) {
    LCDegreePrimary                         = 0,
    LCDegreeJunior                          = 1,
    LCDegreeSenior                          = 2,
    LCDegreeSpecialty                       = 3,
        LCDegreeDaZhuan = 4,
    LCDegreeUndergraduate                   ,//= 4,
    LCDegreeMaster                          ,//= 5,
    LCDegreeDoctor                          ,//= 6,
};

///**
// * 学位名称
// */
//static inline NSString *LCDegreeName(LCDegreeType degreeType) {
//    NSString *degreeName = @"";
//    switch (degreeType) {
//        case LCDegreePrimary: degreeName = @"小学"; break;
//        case LCDegreeJunior: degreeName = @"初中"; break;
//        case LCDegreeSenior : degreeName = @"高中"; break;
//        case LCDegreeSpecialty : degreeName = @"中专"; break;
//            case LCDegreeDaZhuan : degreeName = @"大专"; break;
//        case LCDegreeUndergraduate : degreeName = @"本科"; break;
//        case LCDegreeMaster : degreeName = @"硕士"; break;
//        case LCDegreeDoctor : degreeName = @"博士"; break;
//        default: break;
//    }
//    return degreeName;
//}
//
//static inline LCDegreeType LCDegreeTypeFromString(NSString *string) {
//        NSInteger i = 0;
//        while (i++ <= LCDegreeDoctor) {
//                if ([string isEqualToString:LCDegreeName(i)]) {
//                        return i;
//                }
//        }
//        return LCDegreeSenior;
//}



/**
 * 性别
 */
typedef NS_ENUM(NSInteger, LCSex) {
    LCSexNone=0,
    LCSexMan = 1,
    LCSexWoman = 2,
};

/**
 * 性别title
 */
static inline NSString *LCSexName(LCSex sexType) {
    NSString *sexTitle = @"";
    switch (sexType) {
        case LCSexMan: sexTitle = @"男"; break;
        case LCSexWoman: sexTitle = @"女"; break;
        default: break;
    }
    return sexTitle;
}




extern NSDictionary *getMultiList(NSString *originString, NSArray *listArray);




extern NSArray* iThinkList(void);//我想
extern int selectIThink(void);



extern NSArray* goodList(void);//优点


extern NSArray *hobbiesList(void);//爱好


extern NSArray* jobList(void);//工作

extern int selectJob(void);


extern NSArray* statureList(void);//体型

extern int selectStature(void);

/**
 *  婚姻
 */

typedef NS_ENUM(NSInteger,LCMarriageType){
    LCUnmarried =0,     //未婚
    LCMarried =1,       //已婚
    LCDissociaton=2,    //离异
    LCWidowed=3,        //丧偶
    
};

/**
 * 婚姻title
 */
static inline NSString *LCMarriageName(LCMarriageType marriageType) {
    NSString *marriageTitle = @"";
    switch (marriageType) {
        case LCUnmarried: marriageTitle = @"未婚"; break;
        case LCMarried: marriageTitle = @"已婚"; break;
        case LCDissociaton : marriageTitle = @"离异"; break;
        case LCWidowed : marriageTitle = @"丧偶"; break;
        default: break;
    }
    return marriageTitle;
}


static inline LCMarriageType LCMarriageTypeFromString(NSString *string) {
        return LCUnmarried;
}


