# KVO学习Tip

## 三部曲
### 添加观察

```	
- (void)addObserver:forKeyPath:options:context
```
* context 
  1. 嵌套少， 性能高
  2. 如果父类要对同一个key进行观察，则可以做一个区分
  3. 如果是空的话， 传NULL

### 重写观察回调方法 

```
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
```

### 删除观察

```
removeObserver:forKeyPath:context: 
```
* Asking to be removed as an observer if not already registered as one results in an NSRangeException. You either call `removeObserver:forKeyPath:context:` exactly once for the corresponding call to `addObserver:forKeyPath:options:context:`, or if that is not feasible in your app, place the `removeObserver:forKeyPath:context:` call inside a `try/catch` block to process the potential exception.
* An observer does not automatically remove itself when deallocated. The observed object continues to send notifications, oblivious to the state of the observer. However, a change notification, like any other message, sent to a released object, triggers a memory access exception. You therefore ensure that observers remove themselves before disappearing from memory.
* The protocol offers no way to ask an object if it is an observer or being observed. Construct your code to avoid release related errors. A typical pattern is to register as an observer during the observer’s initialization (for example in init or viewDidLoad) and unregister during deallocation (usually in dealloc), ensuring properly paired and ordered add and remove messages, and that the observer is unregistered before it is freed from memory.


### 集合观察
1. 要符合KVC
2. mutalbeArrayValueForKey:


##  Manual Change Notification

`+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey`用来控制是否自动通知观察，如果返回`NO`,则要自己触发 `willChangeValueForKey:` 和 `didChangeValueForKey:`。 如果是数组的增删改的话，就需要调用 `willChange:valuesAtIndexes:forKey:` 和 `didChange:valuesAtIndexes:forKey:` ，change的类型是`NSKeyValueChange`,具体值有`NSKeyValueChangeInsertion`、`NSKeyValueChangeRemoval`、`NSKeyValueChangeReplacement`.


## Registering Dependent Keys
### To-One Relationships
* 重写`keyPathsForValuesAffectingValueForKey`或者实现`keyPathsForValuesAffecting<Key>`两个的效果是一样的

```
+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
 
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
 
    if ([key isEqualToString:@"fullName"]) {
        NSArray *affectingKeys = @[@"lastName", @"firstName"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
    }
    return keyPaths;
}


+ (NSSet *)keyPathsForValuesAffectingFullName {
    return [NSSet setWithObjects:@"lastName", @"firstName", nil];
}

```

### To-Many Relationships
* `keyPathsForValuesAffectingValueForKey` 是不支持集合类型的。
* 只能通过设置key观察，再手动进行通知 (原文) You can use key-value observing to register the parent (in this example, Department) as an observer of the relevant attribute of all the children (Employees in this example). You must add and remove the parent as an observer as child objects are added to and removed from the relationship (see Registering for Key-Value Observing). In the observeValueForKeyPath:ofObject:change:context: method you update the dependent value in response to changes, as illustrated in the following code fragment:



## 底层原理探究
1. KVO默认观察Setter方法。
2. Automatic key-value observing is implemented using a technique called isa-swizzling. 做了一个黑魔法， 对对象的isa进行了重新指定。 动态生成了一个子类`NSKVONotifying_<Class>` 。


### 探索子类NSKVONotifying_<Class>
1. 探索method_list , 打印所有的方法
2. 重写setter，class方法
3. 新增_isKVO方法


### 自定义模拟KVO




