//
//  FutureTable.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/3/18.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#ifndef FutureTable_h
#define FutureTable_h

/**********************表名*******************************/
#define mUserInformationTable @"userInfoTable"    //用户信息表
#define mUserMusicTable   @"userMusicTable"    //用户歌单
#define mUserMovieTable   @"userMovieTable"    //用户影单

#define mUserDNFTable   @"userDNFTable"    //用户DNF游戏单

/**********************表的SQL语句*********************/

//用户信息表
#define mCreatUserInformationTable @"CREATE TABLE IF NOT EXISTS userInfoTable (userCount text, passWord text, date text, memberType text, sex text, expandMemberType text, connectCount text, favort text, years text)"

//用户歌单
#define mCreatUserMusicTable @"CREATE TABLE IF NOT EXISTS userMusicTable(name text, signer text, address text)"

//用户影单
#define mCreatUserMovieTable @"CREATE TABLE IF NOT EXISTS userMovieTable(name text, address text)"


#define mCreatUserDNFTable @"CREATE TABLE IF NOT EXISTS userDNFTable(area text, goodsName text, uerCount text, currentTime text, currentPrice text, icn data, minPrice text, maxPrice text, averagePrice text)"

/**********************用户信息表的字段*********************/
#define mUserInformationTable_userCount                 @"userCount"
#define mUserInformationTable_passWord                  @"passWord"
#define mUserInformationTable_date                      @"date"
#define mUserInformationTable_memberType                @"memberType"
#define mUserInformationTable_expandMemberType          @"expandMemberType"
#define mUserInformationTable_connectCount              @"connectCount"
#define mUserInformationTable_favort                    @"favort"
#define mUserInformationTable_years                     @"years"
#define mUserInformationTable_sex                       @"sex"

/**********************用户歌单表的字段*********************/
#define mUserMusicTable_name                            @"name"
#define mUserMusicTable_signer                          @"signer"
#define mUserMusicTable_address                         @"address"

/**********************用户影单表的字段*********************/
#define mUserMovieTable_name                            @"name"
#define mUserMovieTable_address                         @"address"


/**********************用户DNF表的字段*********************/
#define mUserDNFTable_area                  @"area"
#define mUserDNFTable_goodsName             @"goodsName"
#define mUserDNFTable_currentTime           @"currentTime"
#define mUserDNFTable_currentPrice          @"currentPrice"
#define mUserDNFTable_userCount             @"userCount"
#define mUserDNFTable_icn                   @"icn"
#define mUserDNFTable_minPrice              @"minPrice"
#define mUserDNFTable_maxPrice              @"maxPrice"
#define mUserDNFTable_averagePrice          @"averagePrice"


#endif
