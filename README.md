MyOpenSourceCode
================

Mr.Yang

to automaticlly implement copy protocal
- (id)copyWithZone:(NSZone *)zone
{
    BaseModel *model = [[[self class] alloc] init];
    if (model) {
        [self classPropertListNameWithBlock:^(NSString *name) {
            [model setValue:[self valueForKey:name] forKey:name];
        }];
    }
    return model;
}

to automaticlly implement NSCoding protocal

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self classPropertListNameWithBlock:^(NSString *name) {
        [aCoder encodeObject:[self valueForKey:name] forKey:name];
    }];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self classPropertListNameWithBlock:^(NSString *name) {
            [self setValue:[aDecoder decodeObjectForKey:name] forKey:name];
        }];
    }
    return self;
}
