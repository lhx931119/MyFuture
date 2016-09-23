//
//  MSqiteManger.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/3/18.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MSqiteManger.h"
#import "FileManger.h"

@interface MSqiteManger ()

@property (nonatomic, weak) FMDatabase *mDb;
@property (nonatomic, strong) FMDatabaseQueue *baseQueue;
@property (nonatomic, strong) NSRecursiveLock *threadLock;
@property (nonatomic, copy) NSString  *dbPath;

@end

@implementation MSqiteManger

+ (MSqiteManger *)sharedDBManager:(NSString *)dbPath
{
    static MSqiteManger *manger;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manger = [[MSqiteManger alloc] initWithDBPath:dbPath];
    });
    return manger;
}


+ (MSqiteManger *)shareMSqliteManger
{
    static MSqiteManger *manger;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSString *dbPath = [FileManger getFilePathForDocuments:@"userInfo.db"];
        manger = [[MSqiteManger alloc] initWithDBPath:dbPath];
    });
     return manger;
}


- (instancetype)initWithDBPath:(NSString*)dbPath
{
    self = [super init];
    if (self) {
        if(self.baseQueue && [self.dbPath isEqualToString:dbPath])
        {
            return self;//already exist
        }
        
        self.threadLock = [[NSRecursiveLock alloc] init];
        //create db dir
        NSString* dirPath = [dbPath stringByDeletingLastPathComponent];
        BOOL isDir = NO;
        BOOL isCreated = [[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir];
        if ( isCreated == NO || isDir == NO )
        {
            NSError* error = nil;
            BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
            if(success == NO)
            {
                NSLog(@"create dir error: %@",error.debugDescription);
            }
        }
        
        self.dbPath = dbPath;
        [self.baseQueue close];
        //create db within FMDatabaseQueue
        self.baseQueue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
#ifdef DEBUG
        //print error log when in debug mode
        [_baseQueue inDatabase:^(FMDatabase *db) {
            db.logsErrors = YES;
        }];
#endif
    }
    
    return self;
}


- (BOOL)createTableWithName:(NSString *)tableName
{
    if (tableName == nil)
    {
        return NO;
    }
    
    if ([self getTableCreatedWithName:tableName])
    {
        return YES;//already created,return yes
    }
    
    NSString *createTableSQL = nil;
    if ([tableName isEqualToString:mUserInformationTable]) {
        createTableSQL = mCreatUserInformationTable;
    }else if ([tableName isEqualToString:mUserMusicTable]){
        createTableSQL = mCreatUserMusicTable;
    }else if ([tableName isEqualToString:mUserMovieTable]){
        createTableSQL = mCreatUserMovieTable;
    }else {
        NSLog(@"表名输入有误,无法创建此表");
        return NO;
    }
    BOOL isCreated  = [self executeUpdateSQL:createTableSQL arguments:nil];

    return isCreated;
}

- (BOOL)getTableCreatedWithName:(NSString *)tableName
{
    NSArray *tableNameArray = [self search:@"sqlite_master"
                                    column:@"name"
                                     where:@"type ='table'"
                                   orderBy:nil
                                     limit:0
                                    offset:0];
    
    for (NSDictionary *tableItemDic in tableNameArray) {
        NSString *localTableName = tableItemDic[@"name"];
        if ([localTableName.lowercaseString isEqualToString:tableName.lowercaseString]) {
            return YES; // 表存在
        }
    }
    
    return NO; // 表不存在
}

- (NSArray *)executeQuerySQL:(NSString *)sql arguments:(NSArray *)args
{
    __block NSMutableArray *results = [NSMutableArray array];
    [self.baseQueue inDatabase:^(FMDatabase *db){
        FMResultSet *resultSet = nil;
        if(args.count>0)
            resultSet = [db executeQuery:sql  withArgumentsInArray:args];
        else
            resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            [results addObject:[resultSet resultDictionary]];
        }
        [resultSet close];
    }];
    
    return results;
}


- (BOOL)executeUpdateSQL:(NSString *)sql arguments:(NSArray *)args
{
    __block BOOL execute = NO;
    
    [self.baseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if(args.count>0)
            execute = [db executeUpdate:sql withArgumentsInArray:args];
        else
            execute = [db executeUpdate:sql];
    }];
    
    return execute;

}

- (void)dropAllTable
{

    [self executeDB:^(FMDatabase *db) {
        FMResultSet* set = [db executeQuery:@"SELECT name FROM sqlite_master WHERE type='table'"];
        NSMutableArray* dropTables = [NSMutableArray arrayWithCapacity:0];
        while ([set next]) {
            [dropTables addObject:[set stringForColumnIndex:0]];
        }
        [set close];
        
        for (NSString* tableName in dropTables) {
            //table sqlite_sequence may not be dropped
            if (![tableName isEqualToString:@"sqlite_sequence"]) {
                NSString* dropTable = [NSString stringWithFormat:@"DROP table %@",tableName];
                [db executeUpdate:dropTable];
                
            }
        }
    }];
}

- (BOOL)dropTableWithName:(NSString *)tableName
{
    if (tableName == nil) {
        return NO;
    }
    
    NSString* dropTable = [NSString stringWithFormat:@"DROP table %@",tableName];
    BOOL isDrop = [self executeUpdateSQL:dropTable arguments:nil];
    
    return isDrop;

}

- (int)rowCount:(NSString *)tableName
          where:(NSString *)where
{
    NSMutableString* rowCountSql = [NSMutableString stringWithFormat:@"SELECT COUNT(rowid) FROM %@",tableName];
    if ([FileManger checkStringIsEmpty:where] == NO) {
        [rowCountSql appendFormat:@" WHERE %@",where];
    }
    __block int result = 0;
    [self executeDB:^(FMDatabase *db) {
        FMResultSet* set = nil;
        set = [db executeQuery:rowCountSql];
        
        if([set columnCount]>0 && [set next])
        {
            result = [set intForColumnIndex:0];
        }
        [set close];
    }];
    return result;
}

#pragma mark ---search
///查询
- (NSArray *)search:(NSString *)tableName
             column:(id)columns
              where:(NSString *)where
            orderBy:(NSString *)order
              limit:(int)count
             offset:(int)offset
{
    
    NSString* columnsString = nil;
    NSUInteger columnCount = 0;
    if([columns isKindOfClass:[NSArray class]] && [columns count]>0){
        
        columnsString = [columns componentsJoinedByString:@","];
        columnsString = [NSString stringWithFormat:@"%@",columnsString];
        columnCount = ((NSArray *)columns).count;
        
    }else if([FileManger checkStringIsEmpty:columns] == NO){
        
        columnsString = columns;
        NSArray* array = [columns componentsSeparatedByString:@","];
        
        columnCount = array.count;
        
        if(columnCount>1)
        {
            columnsString = [NSString stringWithFormat:@"%@",columnsString];
        }
    }
    
    if(columnCount==0){
        columnsString = @"*";
    }
    
    NSMutableString *searchSql = [NSMutableString stringWithFormat:@"SELECT %@ FROM %@",columnsString,tableName];
    
    
    if ([FileManger checkStringIsEmpty:where] == NO) {
        [searchSql appendFormat:@" WHERE %@",where];
    }
    
    if ([FileManger checkStringIsEmpty:order] == NO) {
        [searchSql appendFormat:@" ORDER BY %@",order];
    }
    
    if(count>0)
    {
        [searchSql appendFormat:@" LIMIT %d OFFSET %d",count,offset];
    }
    else if(offset > 0)
    {
        [searchSql appendFormat:@" LIMIT %d OFFSET %d",INT_MAX,offset];
    }
    
    return [self executeQuerySQL:searchSql arguments:nil];
}

#pragma mark --privte
- (void)executeDB:(void (^)(FMDatabase *db))block
{
    [_threadLock lock];
    if(self.mDb != nil)
    {
        block(self.mDb);
    }
    else
    {
        if(_baseQueue == nil)
        {
            _baseQueue = [[FMDatabaseQueue alloc]initWithPath:_dbPath];
        }
        [_baseQueue inDatabase:^(FMDatabase *db) {
            self.mDb = db;
            block(db);
            self.mDb = nil;
        }];
    }
    [_threadLock unlock];
}

#pragma mark -- insert 
- (BOOL)insert:(NSString *)tableName insertKey:(NSArray *)insertKeys insertValue:(NSArray *)insertValues
{
    if (insertKeys.count == 0 || insertValues.count == 0 || insertKeys.count != insertValues.count)
    {
        return NO;
    }
    
    NSMutableString *keys = [NSMutableString string];
    NSMutableString *valuesString = [NSMutableString string];
    for (int i = 0; i < insertKeys.count; i++) {
        if (i > 0) {
            [keys appendString:@","];
            [valuesString appendString:@","];
        }
        [keys appendString:insertKeys[i]];
        [valuesString appendString:@"?"];
    }
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@)",tableName,keys,valuesString];
    
    BOOL isSuccessed = [self executeUpdateSQL:sql arguments:insertValues];
    
    return isSuccessed;

}

#pragma mark -- delete
- (BOOL)delete:(NSString *)tableName where:(NSString *)where
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@",tableName];
    if ([FileManger checkStringIsEmpty:where] == NO) {
        [sql appendFormat:@" WHERE %@",where];
    }
    
    BOOL isSuccessed = [self executeUpdateSQL:sql arguments:nil];
    
    return  isSuccessed;
}

#pragma mark ---update
- (BOOL)update:(NSString *)tableName
     updateKey:(NSArray *)updateKeys
   updateValue:(NSArray *)updateValues
         where:(NSString *)where
{
    if (updateKeys.count == 0 || updateValues.count == 0 || updateValues.count!=updateValues.count) {
        return NO;
    }
    
    NSMutableString *updateKeyString = [NSMutableString string];
    for (int i = 0; i < updateKeys.count; i++)
    {
        if (i>0) {
            [updateKeyString appendString:@","];
        }
        [updateKeyString appendFormat:@"%@=?",updateKeys[i]];
    }
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET %@",tableName,updateKeyString];
    
    if ([FileManger checkStringIsEmpty:where] == NO) {
        [sql appendFormat:@" WHERE %@",where];
    }
    
    BOOL isSuccessed = [self executeUpdateSQL:sql arguments:updateValues];
    
    return isSuccessed;
}

/**
 *  拷贝原来的数据库的表的数据到新的表中
 *  @param tableName      旧的数据库表表名
 *  @param createTableSQL 新的数据库创建SQL
 *
 *  @return 成功/失败 标记
 */
- (BOOL)copyHistoryTable:(NSString *)tableName toNewTable:(NSString *)createTableSQL flag:(BOOL)flag{
    
    BOOL transcationTag = NO;
    
    //1.判断原来的表是否存在,如果不存在,直接创建新表
    if (![self getTableCreatedWithName:tableName]) {
        transcationTag = [self executeBatchSQL:@[createTableSQL]];
    }
    //2.如果存在,则将原来的表重命名,创建新表,并将原来的表数据插入到新表中
    else{
        if (flag) {
            return NO;
        }else{
            
            NSString *tmpTableName = [NSString stringWithFormat:@"%@_Bak", tableName];
            NSString *copyTableSql = [NSString stringWithFormat:@"alter table %@ rename to %@", tableName, tmpTableName];
            transcationTag = [self executeBatchSQL:@[copyTableSql,createTableSQL]];
            
            //2.1如果修改表名成功并且创建新表成功,刚从原来的表中拷贝数据到新表
            if (transcationTag) {
                NSString *searchSql = [NSString stringWithFormat:@"select * from %@", tmpTableName];
                NSArray *data = [self executeQuerySQL:searchSql arguments:nil];
                
                for (NSDictionary *dict in data){
                    NSArray *keys = [dict allKeys];
                    NSArray *values = [dict allValues];
                    
                    [self insert:tableName insertKey:keys insertValue:values];
                }
            }else{
                NSAssert(1==2, @"XSqliteManager------>系统异常,拷贝数据库异常");
            }
            
        }
    }
    return transcationTag;
}


/**
 *  检查某个包是否包含某个字段
 *  @param tableName  表名
 *  @param columnName 字段名
 *  @return BOOL    YES--包含 NO--不包含
 */
- (BOOL)checkTable:(NSString *)tableName containsColumn:(NSString *)columnName{
    __block BOOL transcationTag = NO;
    
    NSString *sqlString = [NSString stringWithFormat:@"select count(*) from sqlite_master where type=\'table\' and name=\'%@\' and sql like \'%%%@%%\'",tableName,columnName];
    [self executeDB:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sqlString];
        while ([resultSet next]) {
            NSUInteger count = [resultSet intForColumnIndex:0];
            if (count>0) {
                transcationTag = YES;
            }else{
                transcationTag = NO;
            }
        }
        [resultSet close];
    }];
    return transcationTag;
}


/**
 *  @author _Finder丶Tiwk, 15-05-18 17:05:07
 *  @brief  根据输入的SQL语句从数据库中查找数据
 *  @param    sqlString       sql语句
 *  @param    columnArray     所在查询的字段名
 *  @return  NSArray   查询到的字典数组
 */
-(NSArray *)selectedDataWithSQL:(NSString *)sqlString columnKey:(NSArray *)columnKeyArray{
    __block NSMutableArray *resultArray =[NSMutableArray array];
    [self executeDB:^(FMDatabase *db) {
        FMResultSet* resultSet = [db executeQuery:sqlString];
        while ([resultSet next]) {
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
            for (NSUInteger index=0; index<columnKeyArray.count; index++) {
                NSString *columnKey = columnKeyArray[index];
                
                NSString *column = [resultSet stringForColumn:columnKey];
                
                if (column) {
                    [resultDic setValue:column forKey:columnKey];
                }else{
                    [resultDic setValue:[NSNull null] forKey:columnKey];//continue;
                }
            }
            [resultArray addObject:resultDic];
        }
        [resultSet close];
    }];
    return resultArray;
}

/**
 *  @author _Finder丶Tiwk, 15-05-18 17:05:07
 *  @brief  在事务里批量执行SQL语句
 *  @return  BOOL   YES--执行成功   NO--执行失败
 */
-(BOOL)executeBatchSQL:(NSArray *)sqlArray{
    __block BOOL resultTag = YES;
    [self.baseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSString *sqlString in sqlArray) {
            BOOL isSuccess  = [db executeUpdate:sqlString];
            if (!isSuccess) {
                resultTag = NO;
                *rollback = YES;
                return;
            }
        }
    }];
    return resultTag;
}

@end
