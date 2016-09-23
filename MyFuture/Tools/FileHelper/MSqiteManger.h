//
//  MSqiteManger.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/3/18.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSqiteManger : NSObject

+ (MSqiteManger *)shareMSqliteManger;

+ (MSqiteManger *)sharedDBManager:(NSString *)dbPath;

///根据表名创建表
- (BOOL)createTableWithName:(NSString *)tableName;

///根据表名检测表是否存在
- (BOOL)getTableCreatedWithName:(NSString *)tableName;

- (NSArray *)executeQuerySQL:(NSString *)sql arguments:(NSArray *)args;

- (BOOL)executeUpdateSQL:(NSString *)sql arguments:(NSArray *)args;

- (void)dropAllTable;

- (BOOL)dropTableWithName:(NSString *)tableName;

- (int)rowCount:(NSString *)tableName where:(NSString *)where;

#pragma mark -- insert delete update search
- (BOOL)insert:(NSString *)tableName
     insertKey:(NSArray *)insertKeys
   insertValue:(NSArray *)insertValues;

- (BOOL)delete:(NSString *)tableName where:(NSString *)where;

- (BOOL)update:(NSString *)tableName
     updateKey:(NSArray *)updateKeys
   updateValue:(NSArray *)updateValues
         where:(NSString *)where;

- (NSArray *)search:(NSString *)tableName
             column:(id)columns
              where:(NSString *)where
            orderBy:(NSString *)order
              limit:(int)count
             offset:(int)offset;



#pragma mark ------
/**
 *  拷贝原来的数据库的表的数据到新的表中
 *  @param tableName      旧的数据库表表名
 *  @param createTableSQL 新的数据库创建SQL
 *
 *  @return 成功/失败 标记
 */
- (BOOL)copyHistoryTable:(NSString *)tableName toNewTable:(NSString *)createTableSQL flag:(BOOL)flag;


/**
 *  检查某个包是否包含某个字段
 *  @param tableName  表名
 *  @param columnName 字段名
 *  @return BOOL    YES--包含 NO--不包含
 */
-(BOOL)checkTable:(NSString *)tableName containsColumn:(NSString *)columnName;
/**
 *  @author _Finder丶Tiwk, 15-05-18 17:05:07
 *  @brief  根据输入的SQL语句从数据库中查找数据
 *  @param    sqlString               sql语句
 *  @param    columnArray     所在查询的字段名
 *  @return  NSArray   查询到的字典数组
 */
- (NSArray *)selectedDataWithSQL:(NSString *)sqlString columnKey:(NSArray *)columnKeyArray;


/**
 *  @author _Finder丶Tiwk, 15-05-18 17:05:07
 *  @brief  在事务里批量执行SQL语句
 *  @param    sqlString               sql语句
 *  @return  BOOL   YES--执行成功   NO--执行失败
 */
- (BOOL)executeBatchSQL:(NSArray *)sqlArray;

@end
