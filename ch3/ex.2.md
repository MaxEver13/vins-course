# <center>ex.2</center>

## 作业说明：

完整推导了离散时间下的误差动力学，结果跟VINS代码中预积分部分，矩阵$V$中除了前四项噪声的系数符号相反，其余全部一致。这里解释下这个负号的成立：

1.由于零均值的高斯噪声，正负不影响。

2.另外从误差的协方差传递方式：
$$
P_{i+1}^{15\times15}=FP_iF^T+VQV^T \tag{1}
$$
以及误差的雅各比：
$$
J_{i+1}^{15\times15}=FJ_i \tag{2}
$$
可以得出噪声传递矩阵的系数正负，不会影响最后结果。

### 1. 连续时间下的误差动力学

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
\dot{b_w}=n_{b_w} \tag{3}
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
\tag{4}
$$

### 2. 离散时间下的误差动力学

这里我们同样使用中值法积分处理离散情形。根据上一节的内容，我们可以知道方向误差的导数连续形式为：
$$
\delta{\dot{\theta}}^{b_k}_t=-[\hat{w}_t-b_{w_t}]_\times\delta{\theta_t}-\delta{b_{w_t}}-n_w \tag{5}
$$
则中值法离散形式为：
$$
\delta{\dot{\theta}_i} = -[\frac{\hat{w}_i+\hat{w}_{i+1}}{2}-b_{w_i}]_\times\delta{\theta}_i-\frac{n_{w_i}+n_{w_{i+1}}}{2}-\delta{b_{w_i}} \tag{6}
$$
由此根据导数定义可得：
$$
\delta{\theta}_{i+1}=[I-[\frac{\hat{w}_i+\hat{w}_{i+1}}{2}-b_{w_i}]_\times\delta{t}]\delta{\theta_i}-\delta{t}\frac{n_{w_i}+n_{w_{i+1}}}{2}-\delta{t}\delta{b_{w_i}} \tag{7}
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

速度误差的导数连续形式为：
$$
\delta{\dot{\beta}}^{b_k}_t=-R^{b_k}_t[\hat{a}_t-b_{a_t}]_\times \delta{\theta_t} -R^{b_k}_t\delta{b}_{a_t}-R^{b_k}_t n_a \tag{8}
$$
则中值法离散形式为：
$$
\delta{\dot{\beta}}_i=-\frac{1}{2}R_i[\hat{a}_i-b_{a_i}]_\times \delta{\theta}_i - \frac{1}{2}R_{i+1}[\hat{a}_{i+1}-b_{a_i}]_\times \delta{\theta}_{i+1}-\frac{1}{2}(R_i+R_{i+1})\delta{b_{a_i}}
$$

$$
-\frac{1}{2}R_in_{a_i}-\frac{1}{2}R_{i+1}n_{a_{i+1}} \tag{9}
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
-\frac{1}{2}R_i \delta{t} n_{a_i}-\frac{1}{2}R_{i+1}\delta{t}n_{a_{i+1}}+v_{21}n_{w_i}+v_{23}n_{w_{i+1}} \tag{10}
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



位置误差导数的连续形式：
$$
\delta{\dot{\alpha}}^{b_k}_t =\delta{\beta}^{b_k}_t \tag{11}
$$
则中值法离散形式为：
$$
\delta{\dot{\alpha}_i}=\frac{1}{2}\delta{\beta}_i + \frac{1}{2}\delta{\beta}_{i+1} \tag{12}
$$
将式（35）代入上式可得：
$$
\delta{\dot{\alpha}_i}=\delta{\beta}_i+\frac{1}{2}f_{21}\delta{\theta}_i-\frac{1}{4}(R_i+R_{i+1})\delta{t}\delta{b_{a_i}}+\frac{1}{2}f_{24}\delta{b_{w_i}}
$$

$$
-\frac{1}{4}R_i \delta{t} n_{a_i}-\frac{1}{4}R_{i+1}\delta{t}n_{a_{i+1}}+\frac{1}{2}v_{21}n_{w_i}+\frac{1}{2}v_{23}n_{w_{i+1}} \tag{13}
$$

根据导数定义：
$$
\delta{\alpha}_{i+1}=\delta{\alpha}_i+\delta{t}\delta{\beta}_i+\frac{1}{2}f_{21}\delta{t}\delta{\theta}_i-\frac{1}{4}(R_i+R_{i+1})\delta{t}^2\delta{b_{a_i}}+\frac{1}{2}f_{24}\delta{t}\delta{b_{w_i}}
$$

$$
-\frac{1}{4}R_i \delta{t}^2 n_{a_i}-\frac{1}{4}R_{i+1}\delta{t}^2 n_{a_{i+1}}+\frac{1}{2}v_{21}\delta{t} n_{w_i}+\frac{1}{2}v_{23}\delta{t} n_{w_{i+1}} \tag{14}
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
+ \left |
\begin{matrix}
v_{00} & v_{01} &v_{02} & v_{03} & 0 & 0 \\
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
$$

