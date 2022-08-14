## 1. IMU与视觉进行融合之后有何优势？

​		首先相机和IMU都有各自的缺点。相机可以对机器人的位姿进行估计，但是估计的鲁棒性很大程度取决于环境条件，结果对测量噪声比较敏感。比如在弱纹理的环境下难以跟踪，快速运动的过程导致图像模糊，动态场景会无匹配等。IMU会有累计误差和零偏，单纯利用IMU预测会有漂移。

​		但两者融合后，能将各自的优势互补。1.首先通过IMU估计的位姿序列和相机估计的位姿序列对齐，可以估计出机器人轨迹真实的尺度。2.而且通过IMU预积分可以预测下一帧图像的位姿以及上一帧图像中特征点在下一帧图像的位置，提高跟踪算法的匹配速度和应对快速旋转的鲁棒性。3.最后IMU加速度提供的重力估计向量可以将估计的位姿转换到导航的世界坐标系中。

## 2.有哪些常见的视觉+IMU的融合方案？有无工业界的案例？

​		视觉和IMU融合的方案主流是紧耦合的方案，包括基于EKF的滤波方案和基于优化的图优化方案。MSCKF和ROVIO是滤波的紧耦合方案，OKVIS和VINS是优化的紧耦合方案。Google tango 用的是MSCKF方案，算是比较好的应用案例。

## 3.vio新进展？有无将学习方法加入VI slam的例子？

### 3.1 Visual-Inertial Mapping with Non-Linear Factor Recovery

通过重建非线因子图，将回环约束加入到因子图中，进行全局非线性优化。

### 3.2 VIL-VIO： Stereo Visual Inertial LiDAR Simultaneous Localization and Mapping

系统由紧耦合双目vio和LiDAR mapping，以及 LiDAR enhanced visual loop closure.解决穿越隧道失效的问题。

下面是基于学习的方法：

### 3.3 Unsupervised Deep Visual-Inertial Odometry with Online Error Correction for RGB-D Imagery

学会了在没有惯性测量单元（IMU）内在参数或IMU和摄像机之间的外部校准的情况下执行视觉惯性里程计。

### 3.4 Selective Sensor Fusion for Neural Visual-Inertial Odometry.

论文集中在如何学习多传感器融合策略上。提出了一种针对单目VIO的端到端的多传感器选择融合策略。

具体是指提出了两种基于不同掩蔽策略(masking strategies)的融合模态：确定性软融合和随机硬融合，并与先前提出的直接融合baseline进行比较。在测试期间，网络能够选择性地处理可用传感器模态的特征并且产生确定尺度下的轨迹。

### 3.5 VINet : Visual-inertial odometry as a sequence-to-sequence learning problem

利用FlowNet和RNN来做结合，处理VIO的问题。



### reference: 

1.<https://zhuanlan.zhihu.com/p/68627439>

2.<https://www.zhihu.com/question/65068625/answer/541699864>