# AFNetworking — HTTP以及HTTPS传输，AFSecurityPolic源码分析


## HTTP介绍以及加密和缺点
### HTTP介绍
1. 0.9版本 ： 主要是GET方法；
2. 1.0版本 ： GET外，还有POST，请求头等； 缺点： TCP只能请求一次
3. 1.1版本 ： 出现keep-alive，长连接； 缺点： 客户端可以同时发送多个， 服务端只能依次响应；
4. 2.0版本 ： 多工， header压缩 gzip/cookies/useragent， 自推送，无状态；

### HTTP缺点
1. 不安全，明文传输
2. 没有身份验证
3. 数据不完整无法验证



## HTTPS

### HTTPS介绍
https = http + 加密 + 认证 + 完整保护

### 加密
1. 对称加密
   
2. 非对称加密
   rsa

### 证书
1. CA证书
2. 自签证书


