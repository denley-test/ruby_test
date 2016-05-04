Ruby 测试程序集

## test_events
《Ruby元编程》第99页倒数第2段扩展实现
+ 执行：`./test_events_main.rb`
```shell
主程序：  test_events_main.rb
相关文件：test_events.rb
```

## sinatra_main
sinatra 测试程序
+ 执行：`./sinatra_main.rb`
+ 访问网站：`http://localhost:4567`
```shell
主程序：  sinatra_main.rb
相关文件：thirdpart/sinatra
```

## sinatra_auto_boot
将sinatra_main作自启动程序
+ 执行：
```shell
./sinatra_auto_boot_install.rb
sudo service sinatraboot start/stop/restart
```

```shell
主程序：  sinatra_auto_boot.sh
相关文件：sinatra_auto_boot_install.sh(负责安装sinatraboot服务)
```

## active_record_main
active_record 测试程序
+ 执行: `./active_record_main.sh`
```shell
主程序:    active_record_main.sh
相关文件:  active_record_main.rb
          thirdsource/jhgsxx/projectdata/partyserver.db
```
