# Runtime 学习Tip

## 资源
[Objective-C Runtime Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008048-CH1-SW1)

[objc4源码下载](https://opensource.apple.com/source/objc4/)

[南峰子Runtime系列](http://southpeak.github.io/categories/objectivec/)


## Objective-C是一门动态语言
会在运行时，发送和转发消息！！！！


## 类与对象

### Class , 对象 ，元类
 
```
struct objc_class {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;

#if !__OBJC2__
    Class _Nullable super_class                              OBJC2_UNAVAILABLE;
    const char * _Nonnull name                               OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
    struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
    struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
#endif

} OBJC2_UNAVAILABLE;

```

```
typedef struct objc_class *Class;
```

```
/// Represents an instance of a class.
struct objc_object {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
};
```

```
typedef struct objc_object *id;

```

* Class本身也是对象，我们称之为类对象
* 在main方法执行之前，从 dyld到runtime这期间，会创建类对象以及元类对象。 类对象和元类对象是唯一的，不会被重复创建；

#### isa
* 对象的isa指向的是类对象
* 类对象的isa指向的就是元类对象
* 元类的isa指向的根元类
* 根元类的isa指向自己

#### superclass
* 根类对象的superclass指向nil
* 根元类对象的superclass指向根类对象


### object_getClass 与 Objc_getClass的区别

* object_getClass 参数是一个id类型， 他返回的是这个id的isa指针所指向的Class， 如果传参是Class, 则返回该Class的metaClass；
* objc_getClass参数是类名的字符串， 返回的就是这个类的对象；

```
objc-class.mm

Class object_getClass(id obj)
{
    if (obj) return obj->getIsa();
    else return Nil;
}
```

```
obc-runtime.mm

Class objc_getClass(const char *aClassName)
{
    if (!aClassName) return Nil;

    // NO unconnected, YES class handler
    return look_up_class(aClassName, NO, YES);
}

```


## 成员变量与属性

### 类型编码

```
float a[] = {1.0, 2.0, 3.0};
NSLog(@"array encoding type: %s", @encode(typeof(a)));
```

```
char *buf1 = @encode(int **);
char *buf2 = @encode(struct key);
char *buf3 = @encode(Rectangle);
```

* 任何可以作为sizeof()操作参数的类型都可以用于@encode()。
* 注：Objective-C不支持long double类型。@encode(long double)返回d，与double是一样的。
* 在Objective-C Runtime Programming Guide中的[Type Encoding](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1)一节中，列出了Objective-C中所有的类型编码。


## 方法
### SEL与IMP的区别
SEL可以理解为ID, IMP可以理解为函数指针， 指向了最终的实现。SEL 与 IMP 的关系非常类似于 HashTable 中 key 与 value 的关系。OC 中不支持函数重载的原因就是因为一个类的方法列表中不能存在两个相同的 SEL 。但是多个方法却可以在不同的类中有一个相同的 SEL，不同类的实例对象执行相同的 SEL 时，会在各自的方法列表中去根据 SEL 去寻找自己对应的IMP。这使得OC可以支持函数重写。

### 消息传递机制
1. 查看经典的isa以及superclass关系图。如果是实例方法的话， 则按照类对象找， 如果是类方法，则按元类对象找。
2. 如果都找不到进入到消息转发机制。

#### 消息转发 TODO
1. 动态方法解析
* 所属类的类方法`+resolveInstanceMethod:`、`+resolveClassMethod:`

```
void functionForMethod1(id self, SEL _cmd) {
   NSLog(@"%@, %p", self, _cmd);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selectorString = NSStringFromSelector(sel);
    if ([selectorString isEqualToString:@"method1"]) {
        class_addMethod(self.class, @selector(method1), (IMP)functionForMethod1, "@:");
    }
    return [super resolveInstanceMethod:sel];
}
```

2. 备用接收者

```
- (id)forwardingTargetForSelector:(SEL)aSelector
```

3. 完整转发


```
- (void)forwardInvocation:(NSInvocation *)anInvocation
```


## 拾遗
### [self class] 与 [super class]

self是隐藏参数， 而super是一个'编译标识符'，编译器在调用super执行方法的时候，会去生成一个`objc_super`结构体。

```
struct objc_super {
    /// Specifies an instance of a class.
    __unsafe_unretained _Nonnull id receiver;

    /// Specifies the particular superclass of the instance to message. 
#if !defined(__cplusplus)  &&  !__OBJC2__
    /* For compatibility with old objc-runtime.h header */
    __unsafe_unretained _Nonnull Class class;
#else
    __unsafe_unretained _Nonnull Class super_class;
#endif
    /* super_class is the first class to search */
};
```
objc_super结构体，包含`receiver`与`super_class`, `receiver`就是`self`， `super_class`指向父类。[self class]其实是调用`objc_msgSend(self,@selector(class))`, 而[super class]调用的是`objc_msgSendSuper(struct objc_super *super, SEL op, ... )`,他是先去查找superclass的方法，然后`receiver`来执行这个方法；也就是说[super class]最后面是`objc_msgSend(objc_super->receiver, @selector(class))`,而objc_super的receiver是self,所以等价`objc_msgSend(self, @selector(class))`;
`class;`方法是定义在NSObject上的，所以`@selector(class)`的是一样的。


