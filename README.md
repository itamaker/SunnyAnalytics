# SunnyAnalytics-alpha beta v0.0.1

###本工程用于APP用户行为埋点

####1.初始化统计模块：

通过`SAAnalytics`
类初始化

	/**
 	*  初始化数据统计
 	*
 	*  @param baseUrl      埋点上传URL
 	*  @param reportPolicy 发送策略
 	*  @param channelId    渠道ID
 	*/
	+(void)initSAAnalytics:(NSString *)baseUrl  reportPolicy:(SAReportPolicy)reportPolicy channelId:(NSString *) channelId;


####2.事件监听方法
#####［1］按钮点按事件

	/**
 	*  按钮事件统计
 	*
 	*  @param operateType 名称
 	*  @param objId       ID
 	*  @param optParams   参数
 	*/
	+(void)doEvent:(NSString*)operateType objectId:(NSString*)objId params:(NSString*)optParams;


#### [2] 页面停留时长

#pragma mark - 在UIViewController---viewWillAppear----方法中加入如下方法

	/**
 	*  UIViewController 创建时调用
 	*
 	*  @param page UIViewController名称
 	*/
	+(void)beginPage:(NSString*)page;


#pragma mark - 在UIViewController---viewWillDisappear----方法中加入如下方法

	/**
 	*  UIViewController 销毁时调用
 	*
 	*  @param page UIViewController名称
 	*/
	+(void)endPage:(NSString*)page;


###欢迎大家 issue


