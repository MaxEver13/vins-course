# <center>imu噪声参数标定</center>

## 1.T265记录２hours的静态IMU数据

1.1 先将t265跑起来，具体参数看rs_t265.launch,里面设置了时间戳同步enable_sync，imu统一发布unite_imu_method：

roslaunch realsense2_camera rs_t265.launch

这里使用rostopic list 查看发布的imu消息名称，这里叫做/camera/imu:

![1570677140466](/home/max/.config/Typora/typora-user-images/1570677140466.png)

1.2  将imu保持静止，记录imu消息:

rosbag record /camera/imu

按实际时间录制2019-06-12-11-38-21.bag，我重命名为imu_2019-06-12-11-38-21.bag。

## 2.使用kalibr_allan标定

参考<https://github.com/MaxEver13/kalibr_allan>

2.1 将rosbag转换为mat格式：

进入rosbag路径：cd /home/max/calibration/realsense_T265/bag

运行命令：

![1570677989862](/home/max/.config/Typora/typora-user-images/1570677989862.png)

得到mat文件：

![1570678029026](/home/max/.config/Typora/typora-user-images/1570678029026.png)

2.2 利用matlab标定

进入/home/max/kalibr_allan/matlab路径下，

![1570678918223](/home/max/.config/Typora/typora-user-images/1570678918223.png)

然后会看到左侧出现了脚本：

![1570678954593](/home/max/.config/Typora/typora-user-images/1570678954593.png)

修改脚本中关于rosbag的信息：

![1570678735792](/home/max/.config/Typora/typora-user-images/1570678735792.png)

运行脚本SCRIPT_allan_matparallel.m：

![1570679050377](/home/max/.config/Typora/typora-user-images/1570679050377.png)

请耐心等候，成功后自动保存结果：

![1570679497948](/home/max/.config/Typora/typora-user-images/1570679497948.png)



修改脚本SCRIPT_process_results.m中上次运行结果的信息：

![1570679715268](/home/max/.config/Typora/typora-user-images/1570679715268.png)

运行脚本SCRIPT_process_results.m：

![1570679809479](/home/max/.config/Typora/typora-user-images/1570679809479.png)