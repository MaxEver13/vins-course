# <center>IMU预积分及误差状态动力学</center>

On-Manifold预积分指的是通过将选定关键帧之间的IMU测量积分为单个相对运动约束,避免在优化问题中出现太多的IMU优化变量。如下图所示：

![1560850701430](/home/max/.config/Typora/typora-user-images/1560850701430.png)

## 1 预备知识

### 1.1 IMU测量

真实的加速度$a_t$和真实的角速度$w_t$(世界坐标系)从IMU的含噪声和重力的测量数据$a_m$和$w_m$获取（机体坐标系，一般跟IMU坐标系相同）：
$$
a_m = {R^W_B}^T(a^W_t+g^W)+b_{a_t}+n_a  \tag{1}
$$

$$
w_m = w^W_t + b_{w_t} + n_w \tag{2}
$$

这里加上重力向量$g^w=[0,0,g]^T$，是一个矢量运算。因此真实的测量为：
$$
a^W_t = R^W_B(\hat{a}_t-b_{a_t}-n_a)-g^W \tag{3}
$$

$$
w^W_t = \hat{w}_t-b_{w_t}-n_w \tag{4}
$$

这里，$\hat{a}_t$,$\hat{w}_t$是IMU坐标系下的读数。我们假设IMU加速度和陀螺仪的测量加性噪声是高斯的:
$$
n_a \sim \mathcal{N}(0, \sigma^2_a), n_w \sim \mathcal{N}(0, \sigma^2_w) \tag{5}
$$
加速度和陀螺仪的偏差用随机游走模型表示，其导数是高斯的:
$$
n_{b_a} \sim \mathcal{N}(0,\sigma^2_{b_a}), n_{b_w} \sim \mathcal{N}(0, \sigma^2_{b_w})  \tag{6}
$$

$$
\dot{b_{a_t}} = n_{b_a},	\dot{b_{w_t}}= n_{b_w} \tag{7}
$$

### 1.2 PVQ的连续形式

给定两帧图像$b_k$和$b_{k+1}$，其位置，速度，方向状态量可以通过在世界坐标系中对时间间隔$[k,k+1]$内的IMU测量积分得到（这里是连续形式）：
$$
p^W_{b_{k+1}}=p^W_{b_k}+v^W_{b_k}\triangle{t_k}+\iint_{t\in[t_k,t_{k+1}]}(R^W_B(\hat{a}_t-b_{a_t}-n_a)-g^W)dt^2
$$

$$
v^W_{b_{k+1}}=v^W_{b_k}+\int_{t\in[t_k,t_{k+1}]}(R^W_B(\hat{a}_t-b_{a_t}-n_a)-g^W)dt
$$

$$
q^W_{b_{k+1}}=q^W_{b_k}\otimes\int_{t\in[t_k,t_{k+1}]}\frac{1}{2}\Omega(\hat{w}_t-b_{w_t}-n_w)q^{b_k}_tdt \tag{8}
$$

这里
$$
\Omega(w) = \left|
			\begin{matrix}
			-[w]_\times & w \\
            -w^T & 0
			\end{matrix}
			\right | , 
[w]_\times = \left |
\begin{matrix}
			0 & -w_x & w_y \\
			w_z & 0 & -w_x \\
			-w_y & w_x & 0
\end{matrix}
\right | \tag{9}
$$

### 1.3 PVQ的中值法离散形式

这里先回顾下两种最基本的数值积分方法：欧拉法和中值法。欧拉法假设在时间间隔内状态变量的导数$f(.)$是常数，因此：
$$
x_{n+1} = x_n +\triangle{t}f(t_n,x_n) \tag{10}
$$
中值法假设状态变量在时间间隔内的导数是区间中点处的导数，并进行一次迭代计算状态变量在中点处的值：
$$
x_{n+1}=x_n+\triangle{t}f(t_n+\frac{1}{2}\triangle{t},\frac{1}{2}\triangle{tf(t_n,x_n)}) \tag{11}
$$
这个中值法可以通过下面两步解释。首先，用欧拉法积分到中点处，
$$
k_1=f(t_n,x_n) \tag{12}
$$

$$
x(t_n+\frac{1}{2}\triangle{t})=x_n+\frac{1}{2}\triangle{t}k_1 \tag{13}
$$

然后再求在中点处的导数$k_2$:
$$
k_2 = f(t_n+\frac{1}{2}\triangle{t},x(t_n+\frac{1}{2}\triangle{t})) \tag{14}
$$
因此得到:
$$
x_{n+1}=x_n+\triangle{t}k_2 \tag{15}
$$
下面正式给出两个相邻时刻中值积分形式：
$$
p^W_{b_{k+1}}=p^W_{b_k}+v^W_{b_k}\triangle{t}+\frac{1}{2}\bar{a}_m\triangle{t}^2
$$

$$
v^W_{b_{k+1}}=v^W_{b_k}+\bar{a}_m\triangle{t}
$$

$$
q^W_{b_{k+1}}=q^W_{b_k}\otimes{\left|
			\begin{matrix}
			1\\
            \frac{1}{2}\bar{w}_m\triangle{t}
			\end{matrix}
			\right |}   \tag{16}
$$

其中，
$$
\bar{a}_m=\frac{1}{2}[R_k(a_k-b_{a_k})-g^W+R_{k+1}(a_{k+1}-b_{a_k}-g^W)]
$$

$$
\bar{w}_m=\frac{1}{2}(w_k+w_{k+1})-b_{w_k} \tag{17}
$$

注意：这里均没有考虑IMU加速度和陀螺仪的噪声。

### 1.4 误差状态动力学

我们希望在一个惯性系统中通过积分含零偏和噪声的IMU测量数据写出误差状态方程。但是这个积分过程会随着时间增长而发生漂移。为了避免这种漂移，通常我们会融合一些绝对位置信息，比如GPS或者vision。那么我们为啥要写出误差状态动力学呢？

1.方向的误差状态是最小的，可以避免过度参数化相关的问题，以及由此带来的相关协方差矩阵奇异性的风险。

2.误差状态系统总是在远点附近运行，因此远离可能的参数奇点，框架锁或类似问题，从而保证线性化有效性在任何时候都有效。

3.误差状态量通常是很小的量，这意味着高阶项可以忽略。这使得雅各比的计算会比较容易和快速。

### 2 IMU预积分

从上面的积分项，可以看出IMU状态更新需要第K帧世界坐标系下的旋转，位置和速度。当在优化过程中，这些状态变量会随着优化迭代进行发生变化，此时就需要重新积分两帧之间的IMU测量。为了避免重复积分，这里采用预积分的思想：即将参考坐标系从世界坐标系转换到局部坐标系,在式子（8）左右两边同时左乘 $R^{b_k}_W$:
$$
R^{b_k}_Wp^W_{b_{k+1}}=R^{b_k}_W(p^W_{b_k}+v^W_{b_k}\triangle{t_k}-\frac{1}{2}g^W\triangle{t_k}^2)+\alpha^{b_k}_{b_{k+1}}
$$

$$
R^{b_k}_Wv^W_{b_{k+1}}=R^{b_k}_W(v^W_{b_k}-g^W\triangle{t_k})+\beta^{b_k}_{b_{k+1}}
$$

$$
q^{b_k}_W\otimes{q^W_{b_{k+1}}}=\gamma^{b_k}_{b_{k+1}} \tag{18}
$$

其中，
$$
\alpha^{b_k}_{b_{k+1}}=\iint_{t\in[t_k,t_{K+1}]}R^{b_k}_t(\hat{a}_t-b_{a_t}-n_a)dt^2
$$

$$
\beta^{b_k}_{b_{k+1}}=\int_{t\in[t_k,t_{K+1}]}R^{b_k}_t(\hat{a}_t-b_{a_t}-n_a)dt
$$

$$
\gamma^{b_k}_{b_{k+1}}=\int_{t\in[t_k,t_{k+1}]}\frac{1}{2}\Omega(\hat{w}_t-b_{w_t}-n_w)\gamma^{b_k}_tdt \tag{19}
$$

由此可以看到把$b_k$当做参考坐标系后，积分项可以单独通过IMU的测量得到。当IMU测量的bias估计改变时，如果改变很小，通过积分项关于偏差的一阶近似来调整$\alpha^{b_k}_{b_{k+1}}$,$\beta^{b_k}_{b_{k+1}}$,$\gamma^{b_k}_{b_{k+1}}$。由于bias也是需要优化的变量，如果变化太大，则需要重新积分。这里假设预积分的变化量与bias是线性关系：
$$
\alpha^{b_k}_{b_{k+1}}\approx \hat{\alpha}^{b_k}_{b_{k+1}}+J^{\alpha}_{b_a}\delta{b_a}+J^{\alpha}_{b_w}\delta{b_w}
$$

$$
\beta^{b_k}_{b_{k+1}}\approx \hat{\beta}^{b_k}_{b_{k+1}}+J^{\beta}_{b_a}\delta{b_a}+J^{\beta}_{b_w}\delta{b_w}
$$

$$
\gamma^{b_k}_{b_{k+1}}=\hat{\gamma}^{b_k}_{b_{k+1}}\otimes \left |
\begin{matrix}
1 \\
\frac{1}{2}J^{\gamma}_{b_w}\delta{b_w}
\end{matrix}
\right | \tag{20}
$$

在一开始，$\alpha^{b_k}_{b_k}$,$\beta^{b_k}_{b_k}$是0，$\gamma^{b_k}_{b_k}$是单位四元数。注意加性噪声$n_w$,$n_a$是未知的，实现中当做0处理。IMU预积分的欧拉法更新步骤如下：
$$
\hat{\alpha}^{b_k}_{i+1}=\hat{\alpha}^{b_k}_i+\hat{\beta}^{b_k}_i\delta{t}+\frac{1}{2}R(\hat{\gamma}^{b_k}_i)(\hat{\alpha_i}-b_{a_i})\delta{t}^2
$$

$$
\hat{\beta}^{b_k}_{i+1}=\hat{\beta}^{b_k}_i+R(\hat{\gamma}^{b_k}_i)(\hat{\alpha_i}-b_{a_i})\delta{t}
$$

$$
\hat{\gamma}^{b_k}_{i+1}=\hat{\gamma}^{b_k}_i\otimes \hat{\gamma}^{i}_{i+1} =\hat{\gamma}^{b_k}_i\otimes 
\left |
\begin{matrix}
1 \\
\frac{1}{2}(\hat{w}_i-b_{w_i})\delta{t}
\end{matrix}
\right |  \tag{21}
$$

$i$是对应时间间隔$[t_k, t_{k+1}]$的离散时刻，$\delta{t}$是两个IMU测量$i$和$i+1$的时间间隔。

然后给出IMU预积分的中值法更新步骤：
$$
\hat{\alpha}^{b_k}_{i+1}=\hat{\alpha}^{b_k}_i+\hat{\beta}^{b_k}_i\delta{t}+\frac{1}{2}\overline{\hat{\alpha}}\delta{t}^2
$$

$$
\hat{\beta}^{b_k}_{i+1}=\hat{\beta}^{b_k}_i+\overline{\hat{\beta}}\delta{t}
$$

$$
\hat{\gamma}^{b_k}_{i+1}=\hat{\gamma}^{b_k}_i\otimes \hat{\gamma}^{i}_{i+1} =\hat{\gamma}^{b_k}_i\otimes 
\left |
\begin{matrix}
1 \\
\frac{1}{2}\overline{\hat{w}}\delta{t}
\end{matrix}
\right |  \tag{21}
$$

其中，
$$
\overline{\hat{\alpha}}=\frac{1}{2}[q_i(\hat{\alpha}_i-b_{a_i})+q_{i+1}(\hat{\alpha}_{i+1}-b_{\alpha{_i}})]
$$

$$
\overline{\hat{w}}=\frac{1}{2}(\hat{w}_i+\hat{w}_{i+1})-b_{w_i}  \tag{22}
$$

### 2.1 连续时间下的误差动力学

为简化起见，忽略了所有高阶项和重力的变化。参考《四元数数学基础》5.3节。
$$
\dot{\delta{p}}=\delta{v}
$$

$$
\dot{\delta{v}}=-R[\hat{a}_t-b_a]_\times\delta{\theta}-R\delta{b_a}-Rn_a
$$

$$
\dot{\delta{\theta}}=-[\hat{w}_t-b_w]_\times\delta{\theta}-\delta{b_w}-w_n
$$

$$
\dot{b_a}=n_{b_a}
$$

$$
\dot{b_w}=n_{b_w} \tag{23}
$$

这里$\delta{p}$,$\delta{v}$,$\delta{\theta}$对应IMU预积分中的$\delta{\alpha}$,$\delta{\beta}$,$\delta{\gamma}$分别对应位置，速度，方向的变化量。其中方向的变化量用$\delta{\theta}$来表示。可以写出：

$$
\left |
\begin{matrix}
\delta{\dot{\alpha}}^{b_k}_t\\
\delta{\dot{\beta}}^{b_k}_t\\
\delta{\dot{\theta}}^{b_k}_t\\
\delta{\dot{b}}_{a_t}\\
\delta{\dot{b}}_{w_t}
\end{matrix}
\right | =
\left |
\begin{matrix}
0 & I & 0 & 0 & 0 \\
0 & 0 & -R^{b_k}_t[\hat{a}_t-b_{a_t}]_\times & -R^{b_k}_t & 0\\
0 & 0 & -[\hat{w}_t-b_{w_t}]_\times & 0 & -I \\
0 & 0 & 0 & 0 & 0 \\
0 & 0 & 0 & 0 & 0
\end{matrix}
\right |
\left |
\begin{matrix}
\delta{\alpha}^{b_k}_t\\
\delta{\beta}^{b_k}_t\\
\delta{\theta}^{b_k}_t\\
\delta{b}_{a_t}\\
\delta{b}_{w_t}
\end{matrix}
\right |
$$

$$
+
\left |
\begin{matrix}
0 & 0 & 0 & 0  \\
-R^{b_k}_t & 0 & 0 & 0\\
0 & -I & 0 & 0 \\
0 & 0 & I & 0 \\
0 & 0 & 0 & I
\end{matrix}
\right |
\left |
\begin{matrix}
n_a \\
n_w\\
n_{b_a}\\
n_{b_w}
\end{matrix}
\right | = F_t\delta{z^{b_k}_t}+G_tn_t
\tag{24}
$$

### 2.2 连续时间下误差的协方差及雅各比

上式（24）可以简化为：
$$
\delta{\dot{z}}^{b_k}_t =F_t\delta{z^{b_k}_t}+G_tn_t \tag{25}
$$
根据导数的定义：
$$
\delta{\dot{z}}^{b_k}_t = \lim_{\delta{t}\to 0}\frac{\delta{z^{b_k}_{t+\delta{t}}}-\delta{z^{b_k}_t}}{\delta{t}}
$$

$$
\delta{z^{b_k}_{t+\delta{t}}}=\delta{z^{b_k}_t}+\delta{\dot{z}}^{b_k}_t\delta{t}=(I+F_t\delta{t})\delta{z^{b_k}_t}+({G_t\delta{t}})n_t=F\delta{z^{b_k}_t}+Vn_t \tag{26}
$$

这里$F=I+F_t\delta{t}$,$V=G_t\delta{t}$。值得一提的是上式给出了对非线性系统的线性化过程，这意味着下一时刻IMU状态的误差与当前时刻IMU状态的误差成线性关系，我们可以根据当前时刻预测下一时刻状态的均值和协方差。上式给出的是误差均值的预测，下面给出误差的协方差预测：
$$
P^{b_k}_{t+\delta{t}}=(I+F_t\delta{t})P^{b_k}_t(I+F_t\delta{t})^T+(G_t\delta{t})Q(G_t\delta{t})^T \tag{27}
$$
上式给出了误差协方差的迭代公式，初始值$P^{b_k}_{b_k}=0$。其中$Q$表示噪声项的对角协方差矩阵，参考《四元数数学基础》5.4.3节内容：
$$
Q^{12\times12}=
\left |
\begin{matrix}
\sigma^2_a & 0 & 0 & 0 \\
0 & \sigma^2_w & 0 & 0 \\
0 & 0 & \sigma^2_{b_a} & 0 \\
0 & 0 & 0 & \sigma^2_{b_w}
\end{matrix}
\right | \tag{28}
$$
与此同时，IMU状态误差$\delta{z^{b_k}_{b_{k+1}}}$的一阶雅各比$J_{b_{k+1}}$也可以利用式（26）类似的方式迭代：
$$
J_{t+\delta{t}}=(I+F_t\delta{t})J_t  \tag{29}
$$
式（20）中IMU状态误差关于bias的线性化过程中的雅各比$J^\alpha _{b_a}$是$J_{b_{k+1}}$的一个子块，对应$\frac{\delta{\alpha^{b_k}_{b_{k+1}}}}{\delta{b_{a_k}}}$。其余的雅各比子块也是类似的意义。

### 2.3 离散时间下的误差动力学

这里我们同样使用中值法积分处理离散情形。根据上一节的内容，我们可以知道:

#### 2.3.1 方向误差的导数连续形式为：

$$
\delta{\dot{\theta}}^{b_k}_t=-[\hat{w}_t-b_{w_t}]_\times\delta{\theta_t}-\delta{b_{w_t}}-n_w \tag{30}
$$
则中值法离散形式为：
$$
\delta{\dot{\theta}_i} = -[\frac{\hat{w}_i+\hat{w}_{i+1}}{2}-b_{w_i}]_\times\delta{\theta}_i-\frac{n_{w_i}+n_{w_{i+1}}}{2}-\delta{b_{w_i}} \tag{31}
$$
由此根据导数定义可得：
$$
\delta{\theta}_{i+1}=[I-[\frac{\hat{w}_i+\hat{w}_{i+1}}{2}-b_{w_i}]_\times\delta{t}]\delta{\theta_i}-\delta{t}\frac{n_{w_i}+n_{w_{i+1}}}{2}-\delta{t}\delta{b_{w_i}} \tag{32}
$$
令：
$$
f_{11}=I-[\frac{\hat{w}_i+\hat{w}_{i+1}}{2}-b_{w_i}]_\times\delta{t}
$$

$$
v_{11}=v_{13}=-\frac{\delta{t}}{2}
$$

$$
f_{14}=-\delta{t}
$$

#### 2.3.2 速度误差的导数连续形式为：

$$
\delta{\dot{\beta}}^{b_k}_t=-R^{b_k}_t[\hat{a}_t-b_{a_t}]_\times \delta{\theta_t} -R^{b_k}_t\delta{b}_{a_t}-R^{b_k}_t n_a \tag{33}
$$
则中值法离散形式为：
$$
\delta{\dot{\beta}}_i=-\frac{1}{2}R_i[\hat{a}_i-b_{a_i}]_\times \delta{\theta}_i - \frac{1}{2}R_{i+1}[\hat{a}_{i+1}-b_{a_i}]_\times \delta{\theta}_{i+1}-\frac{1}{2}(R_i+R_{i+1})\delta{b_{a_i}}
$$

$$
-\frac{1}{2}R_in_{a_i}-\frac{1}{2}R_{i+1}n_{a_{i+1}} \tag{34}
$$

将式（32）代入上式可得：
$$
\delta{\dot{\beta}}_i=-\frac{1}{2}R_i[\hat{a}_i-b_{a_i}]_\times \delta{\theta}_i-\frac{1}{2}R_{i+1}[\hat{a}_{i+1}-b_{a_i}]_\times
$$

$$
\{[I-[\frac{\hat{w}_i+\hat{w}_{i+1}}{2}-b_{w_i}]_\times\delta{t}]\delta{\theta_i}-\frac{n_{w_i}+n_{w_{i+1}}}{2}\delta{t}-\delta{b_{w_i}}\delta{t} \}
$$

$$
-\frac{1}{2}(R_i+R_{i+1})\delta{b_{a_i}} -\frac{1}{2}R_in_{a_i}-\frac{1}{2}R_{i+1}n_{a_{i+1}}
$$

继续整理：
$$
\delta{\dot{\beta}}_i= \{-\frac{1}{2}R_i[\hat{a}_i-b_{a_i}]_\times -\frac{1}{2}R_{i+1}[\hat{a}_{i+1}-b_{a_i}]_\times [I-[\frac{\hat{w}_i+\hat{w}_{i+1}}{2}-b_{w_i}]_\times\delta{t}] \}\delta{\theta}
$$

$$
+\frac{1}{4}R_{i+1}[\hat{a}_{i+1}-b_{a_i}]_\times (n_{w_i}+n_{w_{i+1}})\delta{t}+\frac{1}{2}R_{i+1}[\hat{a}_{i+1}-b_{a_i}]_\times \delta{b_{w_i}}\delta{t}
$$

$$
-\frac{1}{2}(R_i+R_{i+1})\delta{b_{a_i}} -\frac{1}{2}R_in_{a_i}-\frac{1}{2}R_{i+1}n_{a_{i+1}}
$$

根据导数定义可得：
$$
\delta{\beta}_{i+1}=\delta{\beta}_i+f_{21}\delta{\theta}_i-\frac{1}{2}(R_i+R_{i+1})\delta{t}\delta{b_{a_i}}+f_{24}\delta{b_{w_i}}
$$

$$
-\frac{1}{2}R_i \delta{t} n_{a_i}-\frac{1}{2}R_{i+1}\delta{t}n_{a_{i+1}}+v_{21}n_{w_i}+v_{23}n_{w_{i+1}} \tag{35}
$$

令：
$$
f_{21}=-\frac{1}{2}R_i[\hat{a}_i-b_{a_i}]_\times\delta{t} -\frac{1}{2}R_{i+1}[\hat{a}_{i+1}-b_{a_i}]_\times [I-[\frac{\hat{w}_i+\hat{w}_{i+1}}{2}-b_{w_i}]_\times\delta{t}]\delta{t}
$$

$$
f_{22}=I
$$

$$
f_{23}=-\frac{1}{2}(R_i+R_{i+1})\delta{t}
$$

$$
f_{24}=\frac{1}{2}R_{i+1}[\hat{a}_{i+1}-b_{a_i}]_\times \delta{t}^2
$$

$$
v_{20}=-\frac{1}{2}R_i \delta{t}
$$

$$
v_{21}=v_{23}=\frac{1}{4}R_{i+1}[\hat{a}_{i+1}-b_{a_i}]_\times \delta{t}^2
$$

$$
v_{22}=-\frac{1}{2}R_{i+1}\delta{t}
$$



#### 2.3.3 位置误差导数的连续形式：

$$
\delta{\dot{\alpha}}^{b_k}_t =\delta{\beta}^{b_k}_t \tag{36}
$$
则中值法离散形式为：
$$
\delta{\dot{\alpha}_i}=\frac{1}{2}\delta{\beta}_i + \frac{1}{2}\delta{\beta}_{i+1} \tag{37}
$$
将式（35）代入上式可得：
$$
\delta{\dot{\alpha}_i}=\delta{\beta}_i+\frac{1}{2}f_{21}\delta{\theta}_i-\frac{1}{4}(R_i+R_{i+1})\delta{t}\delta{b_{a_i}}+\frac{1}{2}f_{24}\delta{b_{w_i}}
$$

$$
-\frac{1}{4}R_i \delta{t} n_{a_i}-\frac{1}{4}R_{i+1}\delta{t}n_{a_{i+1}}+\frac{1}{2}v_{21}n_{w_i}+\frac{1}{2}v_{23}n_{w_{i+1}} \tag{38}
$$

根据导数定义：
$$
\delta{\alpha}_{i+1}=\delta{\alpha}_i+\delta{t}\delta{\beta}_i+\frac{1}{2}f_{21}\delta{t}\delta{\theta}_i-\frac{1}{4}(R_i+R_{i+1})\delta{t}^2\delta{b_{a_i}}+\frac{1}{2}f_{24}\delta{t}\delta{b_{w_i}}
$$

$$
-\frac{1}{4}R_i \delta{t}^2 n_{a_i}-\frac{1}{4}R_{i+1}\delta{t}^2 n_{a_{i+1}}+\frac{1}{2}v_{21}\delta{t} n_{w_i}+\frac{1}{2}v_{23}\delta{t} n_{w_{i+1}} \tag{39}
$$

令：
$$
v_{00}=-\frac{1}{4}R_i\delta{t}^2
$$

$$
v_{01}=v_{03}=\frac{\delta{t}}{2}v_{21}
$$

$$
v_{02}=-\frac{1}{4}R_{i+1}\delta{t}^2
$$

$$
f_{00}=I
$$

$$
f_{01}=\frac{\delta{t}}{2}f_{21}
$$

$$
f_{02}=\delta{t}
$$

$$
f_{03}=-\frac{1}{4}(R_i+R_{i+1})\delta{t}^2
$$

$$
f_{04}=\frac{\delta{t}}{2}f_{24}
$$

根据式（7）可得：
$$
\delta{b}_{a_{k+1}}=\delta{b}_{a_k}+\delta{t}n_{b_a}
$$

$$
\delta{b}_{w_{k+1}}=\delta{b}_{w_k}+\delta{t}n_{b_w}
$$

令：
$$
f_{33}=f_{44}=I
$$

$$
v_{34}=v_{45}=\delta{t}
$$

由上可以写出离散时间下的误差动力学,这里交换了$\beta$,$\theta$：
$$
\left |
\begin{matrix}
\delta{\alpha}_{i+1}\\
\delta{\theta}_{i+1}\\
\delta{\beta}_{i+1}\\
\delta{b}_{a_{i+1}}\\
\delta{b}_{w_{i+1}}
\end{matrix}
\right | =
\left |
\begin{matrix}
f_{00} & f_{01} &f_{02} & f_{03} & f_{04} \\
0 & f_{11} & 0 & 0 & f_{14}\\
0 & f_{21} & f_{22} & f_{23} & f_{24} \\
0 & 0 & 0 & f_{33} & 0 \\
0 & 0 & 0 & 0 & f_{44}
\end{matrix}
\right |
\left |
\begin{matrix}
\delta{\alpha}_i\\
\delta{\theta}_i\\
\delta{\beta}_i\\
\delta{b}_{a_i}\\
\delta{b}_{w_i}
\end{matrix}
\right |
$$

$$
+
\left |
\begin{matrix}
v_{00} & v_{01} & v_{02} & v_{03} & 0 & 0  \\
0 & v_{11} & 0 & v_{13} & 0 & 0 \\
v_{20} & v_{21} & v_{22} & v_{23} & 0 & 0 \\
0 & 0 & 0 & 0 & v_{34} & 0 \\
0 & 0 & 0 & 0 & 0 & v_{45}
\end{matrix}
\right |
\left |
\begin{matrix}
n_{a_i} \\
n_{w_i} \\
n_{a_{i+1}} \\
n_{w_{i+1}} \\
n_{b_a} \\
n_{b_w}
\end{matrix}
\right | 
\tag{40}
$$

### 2.4 离散时间下误差的协方差及雅各比

将式（40）简写为：
$$
\delta{z_{i+1}}^{15\times1}=F^{15\times15}\delta{z_i}^{15\times1}+V^{15\times18}n_i^{18\times1} \tag{41}
$$
则雅各比的迭代公式为：
$$
J_{i+1}^{15\times15}=FJ_i \tag{42}
$$
协方差的预测为：
$$
P_{i+1}^{15\times15}=FP_iF^T+VQV^T \tag{43}
$$
其中初始值$P_i=0$。$Q$为表示噪声项的对角协方差矩阵：
$$
Q^{18 \times 18}=
\left |
\begin{matrix}
\sigma_a^2 & 0 & 0 & 0 & 0 & 0 \\
0 & \sigma_w^2 & 0 & 0 & 0 & 0 \\
0 & 0 & \sigma_a^2 & 0 & 0 & 0  \\
0 & 0 & 0 & \sigma_w^2 & 0  & 0 \\
0 & 0 & 0 & 0 & \sigma_{b_a}^2 & 0 \\
0 & 0 & 0 & 0 & 0 & \sigma_{b_w}^2
\end{matrix}
\right | \tag{44}
$$
