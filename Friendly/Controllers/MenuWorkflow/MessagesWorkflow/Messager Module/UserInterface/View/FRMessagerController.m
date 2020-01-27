//
//  FRMessagerInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 16.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRMessagerController.h"
#import "FRMessagerDataSource.h"
#import "FRMessagerSectionHeader.h"
#import "FRMessagesGroupRoomCell.h"
#import "FRMessagesPrivateRoomCell.h"

@interface FRMessagerController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) UITableView* tableView;
//@property (nonatomic, strong) NSArray* chats;
@property (nonatomic, strong) NSFetchedResultsController* frc;
@property (nonatomic, weak) FRMessagerDataSource* dataSource;

@end

@implementation FRMessagerController

- (NSInteger)currentRoomsCount {
    return [self.frc.fetchedObjects count];
}

- (void)updateWithTableView:(UITableView *)tableView
{
 
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRMessagesGroupRoomCell class] forCellReuseIdentifier:@"FRMessagesGroupRoomCell"];
    [self.tableView registerClass:[FRMessagesPrivateRoomCell class] forCellReuseIdentifier:@"FRMessagesPrivateRoomCell"];
    
}

- (void)updateChats:(NSArray*)chats {
//    self.chats = chats;
//    [self.tableView reloadData];
}

- (NSFetchedResultsController*)frc {
    if (!_frc){
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isGroupChat == %@ OR lastMessage.length > 0", @(YES)];
        
        _frc = [FRBaseRoom MR_fetchAllSortedBy:@"lastActivityAt"
                                     ascending:false
                                 withPredicate:predicate
                                       groupBy:nil
                                      delegate:self
                                     inContext:[NSManagedObjectContext MR_defaultContext]];
        
        
        }

    return _frc;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

- (void)updateForSearch:(NSString *)searchString {
    
    if (searchString.length > 0) {
        
        [self.frc.fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"roomTitle CONTAINS[c] %@", searchString]];
    } else {
        [self.frc.fetchRequest setPredicate:nil];
    }
    
    [self.frc performFetch:nil];
    
    [self.tableView reloadData];
    
}
#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerReuseIdentifier = @"FRMessagerSectionHeader";
    
    FRMessagerSectionHeader* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerReuseIdentifier];
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.frc.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self cellForModel:[self.frc objectAtIndexPath:indexPath]];
}

- (UITableViewCell*)cellForModel:(id)model {
    
    if ([model isKindOfClass:[FRGroupRoom class]]) {
        FRMessagesGroupRoomCellViewModel* room = [FRMessagesGroupRoomCellViewModel initWithModel:(FRGroupRoom*)model];
        room.delegate = (id<FRMessagesGroupRoomCellViewModelDelegate>)self.dataSource;
        FRMessagesGroupRoomCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"FRMessagesGroupRoomCell"];
        [cell updateWithModel:room];
        return cell;
    }
    
    if ([model isKindOfClass:[FRPrivateRoom class]]) {
        
        FRMessagesPrivateRoomCellViewModel* room = [FRMessagesPrivateRoomCellViewModel initWithModel:(FRPrivateRoom*)model];
        room.delegate = (id<FRMessagesGroupRoomCellViewModelDelegate>)self.dataSource;
        FRMessagesPrivateRoomCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"FRMessagesPrivateRoomCell"];
        [cell updateWithModel:room];
        return  cell;
    }
    
    NSAssert(false, @"wrong cell model");
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id item = [self.frc objectAtIndexPath:indexPath];
    
    if ([item isKindOfClass:[FRGroupRoom class]])
    {
        return 100;
    }
    
    return 70;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)updateDataSource:(FRMessagerDataSource *)dataSource
{
    self.dataSource = dataSource;
}

@end
