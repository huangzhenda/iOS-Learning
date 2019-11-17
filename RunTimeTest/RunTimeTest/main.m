//
//  main.m
//  RunTimeTest
//
//  Created by hwangzhenda on 2019/10/14.
//  Copyright © 2019年 hwangzhenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyClass.h"
#import <objc/runtime.h>

#pragma mark -
void classPrint(Class cls) {
    
    unsigned int outCount = 0;
    
    //类名
    NSLog(@"class name: %s", class_getName(cls));
    NSLog(@"==========================================================");
    
    //父类
    NSLog(@"super class name: %s", class_getName(class_getSuperclass(cls)));
    NSLog(@"==========================================================");
    
    //元类
    NSLog(@"MyClass is %@  a meta-class",(class_isMetaClass(cls) ? @"": @"not"));
    NSLog(@"==========================================================");
    
    Class meta_class = objc_getMetaClass(class_getName(cls));
    NSLog(@"%s's meta-class is %s", class_getName(cls), class_getName(meta_class));
    NSLog(@"==========================================================");
    
    // 变量实例大小
    NSLog(@"instance size: %zu", class_getInstanceSize(cls));
    NSLog(@"==========================================================");
    
    //成员变量
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance variable's name: %s at index %d",ivar_getName(ivar),i);
    }
    free(ivars);
    
    Ivar string = class_getInstanceVariable(cls, "_string");
    if (string != NULL) {
        NSLog(@"instace variable %s", ivar_getName(string));
    }
    NSLog(@"==========================================================");
    
    // 属性操作
    objc_property_t * properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property's name: %s", property_getName(property));
    }
    free(properties);
    objc_property_t array = class_getProperty(cls, "array");
    if (array != NULL) {
        NSLog(@"property %s", property_getName(array));
    }
    NSLog(@"==========================================================");
    
    // 方法操作
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        NSLog(@"method's signature: %s", method_getName(method));
    }
    free(methods);
    
    Method method1 = class_getInstanceMethod(cls, @selector(method1));
    if (method1 != NULL) {
        NSLog(@"method %s", method_getName(method1));
    }
    
    Method classMethod = class_getClassMethod(cls, @selector(classMethod1));
    if (classMethod != NULL) {
        NSLog(@"class method : %s", method_getName(classMethod));
    }
    NSLog(@"MyClass is%@ responsd to selector: method3WithArg1:arg2:", class_respondsToSelector(cls, @selector(method3WithArg1:arg2:)) ? @"" : @" not");
    IMP imp = class_getMethodImplementation(cls, @selector(method1));
    imp();
    
    NSLog(@"==========================================================");
    // 协议
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(cls, &outCount);
    Protocol * protocol;
    for (int i = 0; i < outCount; i++) {
        protocol = protocols[i];
        NSLog(@"protocol name: %s", protocol_getName(protocol));
    }
    NSLog(@"MyClass is%@ responsed to protocol %s", class_conformsToProtocol(cls, protocol) ? @"" : @" not", protocol_getName(protocol));
    NSLog(@"==========================================================");

}

#pragma mark -
void imp_submethod1(id self, SEL _cmd) {
    NSLog(@"run sub method 1");
}


void addClass() {
    
    Class cls = objc_allocateClassPair(MyClass.class, "MySubClass", 0);
    
    class_addMethod(cls, @selector(submethod1), (IMP)imp_submethod1, "v@:");
    class_replaceMethod(cls, @selector(method1), (IMP)imp_submethod1, "v@:");
    class_addIvar(cls, "_ivar1", sizeof(NSString *), log(sizeof(NSString *)), "i");
    objc_property_attribute_t type = {"T", "@\"NSString\""};
    objc_property_attribute_t ownership = { "C", "" };
    objc_property_attribute_t backingivar = { "V", "_ivar1"};
    objc_property_attribute_t attrs[] = {type, ownership, backingivar};
    class_addProperty(cls, "property2", attrs, 3);
    objc_registerClassPair(cls);

    
    id instance = [[cls alloc] init];
    [instance performSelector:@selector(submethod1)];
    [instance performSelector:@selector(method1)];
}


void classList() {
    
    int numClasses = 0;
    Class *classes = NULL;
    
    numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0) {
        classes = malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        NSLog(@"number of classes: %d", numClasses);
        for (int i = 0; i < numClasses; i++) {
            Class cls = classes[i];
            NSLog(@"class name: %s", class_getName(cls));
        }
        free(classes);
    }

}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        
        
//        //打印类信息
//        MyClass *myClass = [[MyClass alloc] init];
//        Class cls = myClass.class;
//        NSLog(@"%p",cls);
        
//        classPrint(cls);
        
//       //动态添加类
//        addClass();
        
//        //获取所有类
//        classList();
    }
    return 0;
}

