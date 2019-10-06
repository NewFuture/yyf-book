开发调试
===============

YYF提供多种工具在开发和测试的过程中尽快定位问题。开发环境下自动注入的方式方便查看和调试。
同时提供chrome 扩展 YYF-Debugger

* [assert断言错误](assert.md)
* [logger日志记录](logger.md)
* [header调试](header.md)
* [SQL记录和统计](sql.md)
* [YYF-Debugger](http://debugger.newfuture.cc/))


选择调试工具
--------------------

## 保留在代码中(长期存在)
assert和logger可以在代码中长期保留,保证系统稳定性。

断言(assert)仅仅在开发环境下有效，生产环境自动忽略；

日志(logger)是唯一可以在生产环境下高效安全的调试工具；

## 临时调试（类似断点）

Debug调试工具包括header用于临时调试或者输出程序中间的变量值。

### 自动加载
-------
统计工具会在开发环境自动加载.
