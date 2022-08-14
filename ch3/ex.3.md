# <center>ex.3</center>

计算LM算法的迭代步长：

已知LM的正则方程为：
$$
(J^{T}J+\mu I)\triangle \mathbf{x}=-J^Tf , \mu \geq 0 \tag{1}
$$
其中，$f$表示残差函数，等式右边表示目标函数$F$的梯度负方向：
$$
(J^{T}J+\mu I)\triangle \mathbf{x}=-F' , \mu \geq 0 \tag{2}
$$


由于$J^TJ$是一个半正定矩阵，因此对$J^TJ$进行特征值分解为：
$$
J^TJ=V \Lambda V^T \tag{3}
$$
且有
$$
V V^T = I \tag{4}
$$


将(3)(4)代入(2)中可得：
$$
(V \Lambda V^T+\mu V V^T)\triangle \mathbf{x}=-F' \tag{5}
$$
将$V$提到括号左边，将$V^T$提到括号右边，
$$
V( \Lambda +\mu I)V^T \triangle \mathbf{x}=-F' \tag{6}
$$
等式两边左乘$V^{T}$可得,
$$
( \Lambda +\mu I)V^T \triangle \mathbf{x}=-V^T F' \tag{7}
$$
化简：
$$
\triangle \mathbf{x}=-V( \Lambda +\mu I)^{-1} V^T F' \tag{8}
$$
写成分块矩阵的形式，其中$F'$是$n\times1$的列向量，$V$是$n*n$的矩阵，$V_i$表示$V$第$i$列的特征向量,
$$
\triangle \mathbf{x}= - \left(\begin{array}{cccc}

  V_1  & V_2 & \cdots &   V_n
  
\end{array}\right)
\left(\begin{array}{cccc}

  （\lambda_1 + \mu)^{-1} \\

    & (\lambda_2 + \mu)^{-1} \\

   &  & \ddots  \\

  & & & (\lambda_n + \mu)^{-1}

\end{array}\right)
\left(\begin{array}{cccc}

  V_1^T \\

  V_2^T \\

  \vdots \\

  V_n^T

\end{array}\right) F' 
 \tag{9}
$$


整理：
$$
\triangle \mathbf{x}= - \left[\begin{array}{cccc}

  （\lambda_1 + \mu)^{-1} V_1  & (\lambda_2 + \mu)^{-1} V_2 & \cdots &  (\lambda_n + \mu)^{-1} V_n
  
\end{array}\right]

\left(\begin{array}{cccc}

  V_1^T \\

  V_2^T \\

  \vdots \\

  V_n^T

\end{array}\right) F' 
 \tag{10}
$$
继续化简：
$$
\triangle \mathbf{x}= - [
  \frac{V_1 V_1^T}{(\lambda_1 + \mu)}  +  \frac{V_2 V_2^T}{(\lambda_2 + \mu)} +  \cdots  + \frac{V_n V_n^T}{(\lambda_n + \mu)}
]
 F' 
 \tag{11}
$$


由于$V_i V_i^T$是$n*n$方阵，所以$F'$左边是$n$个矩阵相加，化简：
$$
\triangle \mathbf{x}=- \sum_{i = 0}^{n} \frac{V_i V_i^T}{(\lambda_i + \mu)} F' \tag{12}
$$
