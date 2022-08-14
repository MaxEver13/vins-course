# <center>VINS on wheels</center>

　　正如我们所知，VINS有４个不可观的自由度，包括全局位置$(x,y,z)$３个自由度，yaw角。但是对于平面机器人的某些特殊运动，会增加额外不可观的自由度。比如尺度等。为了提高VINS对于轮式机器人的性能，通过融合两个额外的信息源：（１）里程计的测量（２）平面运动的约束。

　　轮式里程计提供低频，经常有噪声，只有间歇性可靠的轮子运动测量。另一方面，这些测量包含在匀加速运动下对提高VINS精度有用的尺度信息。

　　根据轮式里程计的数据可以得到局部2D的线性速度和旋转角速度：
$$
v = \frac{r_l w_l + r_r w_r}{2},
w = \frac{r_r w_r - r_l w_l}{a} \tag{1}
$$
这里$w_l,w_r$分别是左右轮的旋转速度，$r_l,r_r$分别是左右轮的半径，$a$表示左右轮的间距(baseline)。

里程计的线速度测量包含绝对尺度信息，因此里程计数据不仅改善了VINS的定位精度，还提供了在机器人匀加速运动导致VINS的尺度不可观时，VINS的尺度信息。为了用一种鲁棒的方式处理含噪声的里程计数据，而不是像式(1)那样用作速度更新，作者提出了将里程计数据积分并将产生的２D的位移估计融合到３D VINS中。

## 1.测量模型推导

假设连续两次里程计读数，运动是平面的。因此在连续两帧里程计之间的转换包含一个绕$ｚ$轴的旋转角度$\phi^{O_{k+1}}_{O_k}$得到的主轴旋转$C^{O_k}_{O_{k+1}}$和$x-y$平面的平移$p^{O_{k+1}}_{O_k}$，这通过积分里程计的线速度和旋转角速度得到。
$$
C^{O_k}_{O_{k+1}} = C_z(\phi^{O_{k+1}}_{O_k}) \tag{2}
$$

$$
\phi_k = \phi^{O_{k+1}}_{O_k} + n_\phi \tag{3}
$$

$$
\pmb{d}_k = \Lambda \pmb{p}^{O_{k+1}}_{O_k} + \pmb{n}_d, \Lambda= [\pmb{e}_1 \ \pmb{e}_2]^T  \tag{4}
$$

这里$[n_\phi \ \pmb{n}_d^T]^T$是一个$3\times1$的零均值高斯噪声向量，$\pmb{e}_1 = [1,0,0]^T$, $\pmb{e}_2=[0,1,0]^T$，　$\Lambda$是一个$2 \times 3$的向量。

　![1571388767154](/home/max/.config/Typora/typora-user-images/1571388767154.png)

如上图所示，连续两帧里程计之间的转换可以推导如下，注意都是从时刻$k$到时刻$k+1$：

旋转部分：
$$
C^{O_k}_{O_{k+1}}=C^O_I C^{I_k}_G (C^{I_{k+1}}_G)^T (C^O_I)^T \tag{5}
$$
平移部分：　$p^{O_{k+1}}_{O_k}$表示从$O_k$指向$O_{k+1}$的向量，根据图１的位姿转换关系，推导如下：
$$
p^{O_{k+1}}_{O_k} = p^I_O + C^O_I p^{O_{k+1}}_{I_k}　\tag{6}
$$
又因为
$$
p^{I_{k＋１}}_{I_k} = p^{O_{k＋１}}_{I_k} + C^{I_k}_{O_{k+1}} p^I_O \tag{7}
$$
所以有
$$
p^{O_{k＋１}}_{I_k} = p^{I_{k＋１}}_{I_k} - C^{I_k}_{O_{k+1}} p^I_O \tag{8}
$$
将式(８)代入式(6)可得：
$$
p^{O_{k+1}}_{O_k} = p^I_O + C^O_I (p^{I_{k＋１}}_{I_k} - C^{I_k}_{O_{k+1}} p^I_O )　\tag{9}
$$
又因为G系的存在，将$p^{I_{k＋１}}_{I_k}$表示到$I_k$上,
$$
p^{I_{k＋１}}_{I_k} = C^{I_k}_G (p^{I_{k+1}}_G - p^{I_k}_G)　\tag{10}
$$
并将$C^{I_k}_{O_{k+1}}$根据旋转关系可得：
$$
C^{I_k}_{O_{k+1}} = C^{I_k}_G (C^{I_{k+1}}_G)^T (C^O_I)^T \tag{11}
$$
因此将式(11)(10)代入式(9)，将$C^{I_k}_G$提出括号，整理可得：
$$
p^{O_{k+1}}_{O_k} = p^I_O + C^O_I C^{I_k}_G (p^{I_{k+1}}_G - p^{I_k}_G - (C^{I_{k+1}}_G)^T (C^O_I)^T p^I_O )　\tag{12}
$$
其中$C^O_I$和$p^I_O$表示从imu到odom的外参。

## 2.雅各比和残差推导

根据上面推导的测量模型，分别对旋转和平移求残差和雅各比：

旋转部分：根据式(2)和式(5)建立误差模型，并在旋转矩阵中利用小角度近似，得到误差方程(四元数残差转成角轴残差,最终转到里程计坐标系上)：
$$
\delta \pmb{\phi }= C^O_I \delta \pmb{\theta}_{I_k}-C^O_I\hat{C}^{I_k}_G (\hat{C}^{I_{k+1}}_G)^T \delta \pmb{\theta}_{I_{k+1}} - n_\phi \pmb{e}_3 \tag{13}
$$
其中有
$$
\left \lfloor \delta \pmb{\phi } \right \rfloor_\times = \mbox{I}_3-C_z(\phi_k) (\hat{C}^{O_k}_{O_{k+1}})^T
$$

$$
\hat{C}^{O_k}_{O_{k+1}} = C^O_I \hat{C}^{I_k}_G (\hat{C}^{I_{k+1}}_G)^T (C^O_I)^T \tag{14}
$$

这里$\hat{C}$表示旋转矩阵的估计，并且$\delta \pmb{\theta}$是对应四元数参数化的误差状态，(参考《后端非线性优化》式(13), 应该是说的扰动，对扰动求导)，$C_z(\phi_k)$表示测量，$\hat{C}^{O_k}_{O_{k+1}}$表示预测(估计)。向量$\delta \pmb{\phi }$的第三项表示测量和估计之间平面旋转的角度误差。在式(15)上左乘$ \pmb{e}_3^T$得到残差，是个标量：
$$
\pmb{r} =  \pmb{e}_3^T \delta \pmb{\phi} \tag{15}
$$
残差对误差状态求雅各比矩阵：
$$
\mbox{H}_{\delta \theta_{I_k}} = \pmb{e}_3^T C^O_I,
\mbox{H}_{\delta \theta_{I_{k+1}}} = -\pmb{e}_3^T C^O_I\hat{C}^{I_k}_G (\hat{C}^{I_{k+1}}_G)^T \tag{16}
$$
平移部分：将式(12)代入式(4)中，得到残差：
$$
\pmb{r} = \pmb{d}_k - \Lambda(\pmb{p}^I_O+C^O_I \pmb{\xi})　\tag{17}
$$
其中
$$
\pmb{\xi} = \hat{C}^{I_k}_G (\hat{p}^{I_{k+1}}_G - \hat{p}^{I_k}_G - (\hat{C}^{I_{k+1}}_G)^T (\hat{C}^O_I)^T p^I_O )
$$
对$p^G_{I_{k+1}}$，　$p^G_{I_k}$求雅各比，跟上式$\hat{p}^{I_{k+1}}_G$，$\hat{p}^{I_k}_G$符号相反：
$$
\mbox{H}_{p_{I_k}} =  －\Lambda C^I_O \hat{C}^{I_k}_G，　\mbox{H}_{p_{I_{k+1}}} = \Lambda C^I_O \hat{C}^{I_k}_G \tag{18}
$$

对$\delta \theta_{I_k}$求雅各比，需要将参考坐标系转到${I_k}$，省略掉不相关的部分：

$$
\mbox{H}_{\delta \theta_{I_k}} = \frac{\partial{r}}{\partial{\delta \theta_{I_k}}}=\lim_{\delta \theta_{I_k} \rightarrow 0} \frac{-\Lambda C^O_I (\hat{C}^G_{I_k} \exp([\delta \theta_{I_k}]_\times))^T (\hat{p}^{I_{k+1}}_G - \hat{p}^{I_k}_G - (\hat{C}^{I_{k+1}}_G)^T (\hat{C}^O_I)^T p^I_O )} {\delta \theta_{I_k}}
$$

$$
=\lim_{\delta \theta_{I_k} \rightarrow 0} \frac{-\Lambda C^O_I (I-[\delta \theta_{I_k}]_\times)\hat{C}^{I_k}_G (\hat{p}^{I_{k+1}}_G - \hat{p}^{I_k}_G - (\hat{C}^{I_{k+1}}_G)^T (\hat{C}^O_I)^T p^I_O )} {\delta \theta_{I_k}}
$$

$$
=\lim_{\delta \theta_{I_k} \rightarrow 0} \frac{-\Lambda C^O_I [\delta \theta_{I_k}]_\times\hat{C}^{I_k}_G (\hat{p}^{I_{k+1}}_G - \hat{p}^{I_k}_G - (\hat{C}^{I_{k+1}}_G)^T (\hat{C}^O_I)^T p^I_O )} {\delta \theta_{I_k}}
$$

$$
=\lim_{\delta \theta_{I_k} \rightarrow 0} \frac{\Lambda C^O_I [\pmb{\xi}]_\times\delta \theta_{I_k}} {\delta \theta_{I_k}}
$$

$$
=\Lambda C^O_I [\pmb{\xi}]_\times \tag{19}
$$

对$\delta \theta_{I_{k+1}}$求雅各比(这里跟论文里面差个负号)，需要将参考坐标系转到${I_{k+1}}$，并省略掉不相关的部分：
$$
\mbox{H}_{\delta \theta_{I_{k+1}}} = \frac{\partial{r}}{\partial{\delta \theta_{I_{k+1}}}}=\lim_{\delta \theta_{I_{k+1}} \rightarrow 0} \frac{-\Lambda C^O_I \hat{C}^{I_k}_G (\hat{p}^{I_{k+1}}_G - \hat{p}^{I_k}_G - (\hat{C}^{I_{k+1}}_G)^T \exp{[\delta \theta_{I_{k+1}}]_\times} (\hat{C}^O_I)^T p^I_O )} {\delta \theta_{I_{k+1}}}
$$

$$
=\lim_{\delta \theta_{I_{k+1}} \rightarrow 0} \frac{-\Lambda C^O_I \hat{C}^{I_k}_G (\hat{p}^{I_{k+1}}_G - \hat{p}^{I_k}_G - \hat{C}^G_{I_{k+1}} (I+[\delta \theta_{I_{k+1}}]_\times) (\hat{C}^O_I)^T p^I_O )} {\delta \theta_{I_{k+1}}}
$$

$$
=\lim_{\delta \theta_{I_{k+1}} \rightarrow 0} \frac{\Lambda C^O_I \hat{C}^{I_k}_G  \hat{C}^G_{I_{k+1}} [\delta \theta_{I_{k+1}}]_\times (\hat{C}^O_I)^T p^I_O} {\delta \theta_{I_{k+1}}}
$$

$$
=\lim_{\delta \theta_{I_{k+1}} \rightarrow 0} \frac{-\Lambda C^O_I \hat{C}^{I_k}_G  \hat{C}^G_{I_{k+1}} [ (\hat{C}^O_I)^T p^I_O]_\times \delta \theta_{I_{k+1}}} {\delta \theta_{I_{k+1}}}
$$

$$
=-\Lambda C^O_I \hat{C}^{I_k}_G  \hat{C}^G_{I_{k+1}} [ (\hat{C}^O_I)^T p^I_O]_\times
$$

$$
=-\Lambda C^O_I \hat{C}^{I_k}_G  (\hat{C}^{I_{k+1}}_G)^T [ (\hat{C}^O_I)^T p^I_O]_\times  \tag{20}
$$

## 3.约束信息融合进VINS

已知具体的运动约束信息，可以提供有助于改善VINS定位精度的额外信息。一个运动流形可以在数学上表示为一个几何约束，$\pmb{g}(\mbox{x})= \pmb{0}$，这里的$\pmb{g}$通常是状态$\mbox{x}$的非线性函数。有两种方式把这种约束信息结合到VINS中去。

### 3.1 确定约束

一个标准的VINS估计器(滤波或者优化的)优化一个代价函数$\mathcal{C}(\mbox{x})$，其来自于传感器的信息(imu,相机，码盘等)，然而运动流形被描述成优化问题的一种确定约束：
$$
\min \ \  \mathcal{C}(\mbox{x}) \
, s.t.\pmb{g}(\mbox{x})= \pmb{0} \tag{21}
$$
对于VINS而言，代价函数利用非线性最小二乘，上式可以通过高斯牛顿法迭代求解。

### 3.2 随机约束

实际上，运动流形从不准确地满足，当机器人在平面行走时，roll和pitch角是随着时间变化的。为了考虑平面的不确定性，需要将运动模型建立成一个随机约束$\pmb{g}(\mbox{x})= \pmb{n}$，这里$\pmb{n}$假设为一个０均值高斯白噪声，其协方差为$\mbox{R}$，并把这个随机约束信息当做另一个代价融合到代价函数中去：
$$
\min \ \mathcal{C}(\mbox{x})+||\pmb{g}(\mbox{x}) || ^2_{\mbox{R}}  \tag{22}
$$
注意上式(22)可以用标准的VINS估计器求解。更多的是，这种随机约束相比确定约束对于排除outliers的错误信息更具有灵活性。特别的，使用马氏距离检测那些最不可能满足平面约束的情况，比如当机器人过坎时，临时删除约束。

### 3.3 对应平面的特殊流形

![1571828549139](/home/max/.config/Typora/typora-user-images/1571828549139.png)

平面坐标系$｛\pi｝$的${x-y}$平面与物理平面重合，并用一个２自由的四元数参数化这个平面，$q^{\pi}_G$，表示平面坐标系和全局坐标系的旋转，$z^G_{\pi}$表示全局坐标系远点到平面的垂直距离。四元数$q^{\pi}_G$的误差状态被定义为一个$2\times1$的向量$\delta \theta_{\pi}$，所以状态误差$\delta q \equiv [\frac{1}{2}\delta \theta_\pi^T \ 0 \ 1]^T$。注意这里的参数化认为在3D平面有３个自由度。如图３所示。

推导如下：

旋转部分用２个自由度约束($2\times 1$的向量)，这里不是位姿中，旋转的表示方式$C^\pi_{O_k}$,仅表示一个旋转约束(roll,pitch角度约束)：
$$
C^{O_k}_\pi = \Lambda C^O_I C^{I_k}_G (C^\pi_G)^T\mbox{e}_3　＝　\mbox{0} \tag{23}
$$
平移部分,垂直距离为０,先以全局坐标系$G$为参考系：
$$
p^{I_k}_G　＝　p^{O_k}_G + C^G_{O_k}p^I_O
$$

$$
＝　p^{O_k}_G +  (C^{I_k}_G)^T (C^O_I)^T p^I_O
$$

所以有得到坐标系$O$在全局坐标系中的平移：
$$
p^{O_k}_G = p^{I_k}_G －(C^{I_k}_G)^T (C^O_I)^T p^I_O
$$
通过旋转将参考坐标系从$G$转换到坐标系$\pi$,然后选取z坐标，得到${O_k}$在平面${\pi}$上的垂直距离：
$$
\mbox{e}_3^T C^\pi_G(p^{I_k}_G －(C^{I_k}_G)^T (C^O_I)^T p^I_O)
$$

所以平面${\pi }$上的垂直距离约束为：
$$
\mbox{e}_3^T C^\pi_G(p^{I_k}_G －(C^{I_k}_G)^T (C^O_I)^T p^I_O) = \mbox{0} \tag{24}
$$

最后将里程计坐标系${O}$在平面运动的几何约束表示为：
$$
\pmb{g}(\mbox{x}) = 
\left [
\begin{matrix}
\Lambda C^O_I C^{I_k}_G (C^{\pi}_G)^T \mbox{e}_3 \\
z^G_\pi+\mbox{e}_3^T C^\pi_G(p^{I_k}_G - (C^{I_k}_G)^T (C^O_I)^T P^I_O)
\end{matrix}
\right ] = \mbox{0}  \tag{25}
$$
其中，垂直方向的约束还加上了平面和全局坐标系的垂直距离。

接下来推导下平面运动模型的雅各比，

旋转部分：

对$\delta \theta_{I_k}$求雅各比，将参考坐标系转到${I_k}$，省略掉不必要的部分:
$$
\mbox{H}_{\delta \theta_{I_k}} = \frac{\partial{r}}{\partial{\delta \theta_{I_k}}}=\lim_{\delta \theta_{I_k} \rightarrow 0} \frac{\Lambda C^O_I (C^G_{I_k} \exp([\delta \theta_{I_k}]_\times))^T (C^{\pi}_G)^T \mbox{e}_3} {\delta \theta_{I_k}}
$$

$$
=\lim_{\delta \theta_{I_k} \rightarrow 0} \frac{\Lambda C^O_I (I- [\delta \theta_{I_k}]_\times )C^{I_k}_G (C^{\pi}_G)^T \mbox{e}_3} {\delta \theta_{I_k}}
$$

$$
=\lim_{\delta \theta_{I_k} \rightarrow 0} \frac{-\Lambda C^O_I [\delta \theta_{I_k}]_\times C^{I_k}_G (C^{\pi}_G)^T \mbox{e}_3} {\delta \theta_{I_k}}
$$

$$
=\lim_{\delta \theta_{I_k} \rightarrow 0} \frac{\Lambda C^O_I [ C^{I_k}_G (C^{\pi}_G)^T \mbox{e}_3 ]_\times  \delta \theta_{I_k}} {\delta \theta_{I_k}}
$$

$$
=\Lambda C^O_I [ C^{I_k}_G (C^{\pi}_G)^T \mbox{e}_3 ]_\times \tag{26}
$$

对$\delta \theta_\pi$求雅各比，将参考坐标系转到${\pi}$，省略掉不必要的部分:
$$
\mbox{H}_{\delta \theta_{\pi}} = \frac{\partial{r}}{\partial{\delta \theta_{I_k}}}=\lim_{\delta \theta_{\pi} \rightarrow 0} \frac{\Lambda C^O_I C^{I_k}_G C^G_{\pi} \exp([\delta \theta_{\pi}]_\times) \mbox{e}_3} {\delta \theta_{\pi}}
$$

$$
=\lim_{\delta \theta_{\pi} \rightarrow 0} \frac{\Lambda C^O_I C^{I_k}_G C^G_{\pi} (I+[\delta \theta_{\pi}]_\times) \mbox{e}_3} {\delta \theta_{\pi}}
$$

$$
=\lim_{\delta \theta_{\pi} \rightarrow 0} \frac{\Lambda C^O_I C^{I_k}_G C^G_{\pi} [\delta \theta_{\pi}]_\times \mbox{e}_3} {\delta \theta_{\pi}}
$$

$$
=\lim_{\delta \theta_{\pi} \rightarrow 0} \frac{-\Lambda C^O_I C^{I_k}_G C^G_{\pi} [\mbox{e}_3]_\times \delta \theta_{\pi} } {\delta \theta_{\pi}}
$$

$$
=\Lambda C^O_I C^{I_k}_G C^G_{\pi} [-\mbox{e}_3]_\times
$$

注意这里有点问题，$\Lambda C^O_I C^{I_k}_G C^G_{\pi} [\mbox{e}_3]_\times$是一个$2 \times 3$的矩阵，但是残差$\Lambda C^O_I C^{I_k}_G (C^{\pi}_G)^T \mbox{e}_3$是$2 \times 1$的向量是２维的，${\pi}$也是一个２自由度的参数，所以$\mbox{H}_{\delta \theta_{\pi}}$应该是一个$2 \times 2$的矩阵。分析下$[-\mbox{e}_3]_\times$:
$$
[\mbox{e}_3]_\times = 
\left [
\begin{matrix}
0 & 1 & 0 \\
-1 & 0 & 0 \\
0 & 0 & 0
\end{matrix}
\right]
$$
取左边两列，得到一个$3 \times 2$的矩阵：
$$
\left [
\begin{matrix}
0 & 1 \\
-1 & 0 \\
0 & 0 
\end{matrix}
\right] = 
[-\mbox{e}_2 \ \mbox{e}_1 ]
$$
因此最终得到一个$2 \times 2$的雅各比矩阵：
$$
\mbox{H}_{\delta \theta_{\pi}}  = \Lambda C^O_I C^{I_k}_G (C^{\pi}_G)^T [-\mbox{e}_2 \ \mbox{e}_1 ] \tag{27}
$$
平移部分：

对$\delta \theta_{I_k} $求雅各比，将参考坐标系转到${I_k}$:
$$
\mbox{H}_{\delta \theta_{I_k}} = \frac{\partial{r}}{\partial{\delta \theta_{I_k}}}=\lim_{\delta \theta_{I_k} \rightarrow 0} \frac{\mbox{e}_3^T C^\pi_G(p^{I_k}_G - C^G_{I_k} \exp([\delta \theta_{I_k}]_\times) (C^O_I)^T P^I_O)}{\delta \theta_{I_k}}
$$

$$
=\lim_{\delta \theta_{I_k} \rightarrow 0} \frac{\mbox{e}_3^T C^\pi_G(p^{I_k}_G - C^G_{I_k} \exp([\delta \theta_{I_k}]_\times) (C^O_I)^T P^I_O)}{\delta \theta_{I_k}}
$$

$$
=\lim_{\delta \theta_{I_k} \rightarrow 0} \frac{\mbox{e}_3^T C^\pi_G(p^{I_k}_G - C^G_{I_k} (I+[\delta \theta_{I_k}]_\times) (C^O_I)^T P^I_O)}{\delta \theta_{I_k}}
$$

$$
=\lim_{\delta \theta_{I_k} \rightarrow 0} \frac{-\mbox{e}_3^T C^\pi_G C^G_{I_k} [\delta \theta_{I_k}]_\times (C^O_I)^T P^I_O}{\delta \theta_{I_k}}
$$

$$
=\lim_{\delta \theta_{I_k} \rightarrow 0} \frac{\mbox{e}_3^T C^\pi_G C^G_{I_k} [(C^O_I)^T P^I_O ]_\times \delta \theta_{I_k}}{\delta \theta_{I_k}}
$$

$$
=\mbox{e}_3^T C^\pi_G C^G_{I_k} [(C^O_I)^T P^I_O ]_\times \tag{28}
$$

对$\delta \theta_\pi $求雅各比，将

对$p^{I_k}_\pi$和$z^G_\pi$求雅各比，这个参考坐标系上面已经转到平面${\pi}$：
$$
\mbox{H}_{p_{I_k}} = \mbox{e}_3^T C^\pi_G, \ \mbox{H}_{z_G}  = 1 \tag{30}
$$


