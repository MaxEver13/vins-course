# <center>ex.1</center>

使用第二章的VIO仿真数据集输入VINS课程代码，并使用evo评估与ground truth的对比效果。

## 准备工作

１．设定仿真数据集的IMU采集频率为100hz，相机的采集频率为10hz。这个跟VINS_Course里面

发布IMU和相机线程的频率保持一致。

２．IMU和相机之间的外参设置为准确的，不需要标定，如下：

![1566976021875](/home/max/.config/Typora/typora-user-images/1566976021875.png)

３．仿真数据集IMU噪声参数设置如下，注意这里设定的是连续时间下噪声标准差：

![1566976472815](/home/max/.config/Typora/typora-user-images/1566976472815.png)

而VINS代码中参数是噪声标准差，但是是离散的，所以IMU的高斯噪声需要再除以$\sqrt{\triangle t}$ （或者乘以$\sqrt {100}$）,随机游走需要再乘以$\sqrt{\triangle t}$ （或者除以$\sqrt {100}$）：

![1567856729269](/home/max/.config/Typora/typora-user-images/1567856729269.png)

４．数据集时长总共20ｓ,因此共有2000帧IMU数据，200帧图像观测数据，每帧图像观测到36个特征点，存为归一化图像坐标，这里需要修改MAX_CNT为36：

![1566978426059](/home/max/.config/Typora/typora-user-images/1566978426059.png)

５．VINS代码里面主要修改了两处，一处是原来读取图片发布图像的线程改成了发布每帧图像的特征点：

![1566978580285](/home/max/.config/Typora/typora-user-images/1566978580285.png)

第二处是trackerData[0].readImage函数：

![1566978882595](/home/max/.config/Typora/typora-user-images/1566978882595.png)

## 测试结果

不含噪声的IMU数据保存在imu_data.txt,含噪声的数据保存在imu_noise_data.txt:

![1566980618210](/home/max/.config/Typora/typora-user-images/1566980618210.png)

１．使用不含噪声的IMU数据进行测试，并使用evo评估，命令如下：

![1566979769925](/home/max/.config/Typora/typora-user-images/1566979769925.png)

输出轨迹与IMU真实轨迹对比：

![1566979862212](/home/max/.config/Typora/typora-user-images/1566979862212.png)

x,y,z各方向对比：

![1566979935431](/home/max/.config/Typora/typora-user-images/1566979935431.png)

rpy_view:

![1566980029613](/home/max/.config/Typora/typora-user-images/1566980029613.png)

２.使用含噪声的数据测试结果：

输出轨迹与IMU真实轨迹对比：

![1566980739009](/home/max/.config/Typora/typora-user-images/1566980739009.png)

x,y,z各方向对比：

![1566980797578](/home/max/.config/Typora/typora-user-images/1566980797578.png)

rpy_view:

![1566980831312](/home/max/.config/Typora/typora-user-images/1566980831312.png)

３．更换一组IMU噪声更大的仿真数据进行测试：

![1567157586125](/home/max/.config/Typora/typora-user-images/1567157586125.png)

VINS配置参数：

![1567856634184](/home/max/.config/Typora/typora-user-images/1567856634184.png)

测试结果：

输出轨迹与IMU真实轨迹对比：

![1567862570168](/home/max/.config/Typora/typora-user-images/1567862570168.png)

x,y,z各方向对比：

![1567862606473](/home/max/.config/Typora/typora-user-images/1567862606473.png)

rpy_view，方框代表不重合的地方：

![1567862671817](/home/max/.config/Typora/typora-user-images/1567862671817.png)

TODO:外参估计不准的问题(主要是旋转部分，小的平移不影响)，噪声参数不准的影响（偏大，偏小），陀螺仪噪声估计参数给的偏小，容易影响定位精度，因为比较更相信陀螺仪的数据。