# <center>marginalize推导</center>

已知优化问题的信息矩阵(hessian矩阵)为：
$$
\left [
\begin{matrix}
\Lambda_{pp} & \Lambda_{pm} \\
\Lambda_{mp} & \Lambda_{mm}
\end{matrix}
\right ]
$$
优化问题：
$$
\left [
\begin{matrix}
\Lambda_{pp} & \Lambda_{pm} \\
\Lambda_{mp} & \Lambda_{mm}
\end{matrix}
\right ] 
\left[
\begin{matrix}
\delta X_{pp} \\
\delta X_{mm}
\end{matrix}
\right ] = 
\left [
\begin{matrix}
b_{pp} \\
b_{mm}
\end{matrix}
\right] \tag{1}
$$
现在要marg掉$X_{mm}$，相应的需要对信息矩阵进行操作：
$$
\left[
\begin{matrix}
0 & I \\
I & -\Lambda_{pm} \Lambda_{mm}^{-1}
\end{matrix}
\right]
\left [
\begin{matrix}
\Lambda_{pp} & \Lambda_{pm} \\
\Lambda_{mp} & \Lambda_{mm}
\end{matrix}
\right ] 
\left[
\begin{matrix}
\delta X_{pp} \\
\delta X_{mm}
\end{matrix}
\right ] = 
\left[
\begin{matrix}
0 & I \\
I & -\Lambda_{pm} \Lambda_{mm}^{-1}
\end{matrix}
\right]
\left [
\begin{matrix}
b_{pp} \\
b_{mm}
\end{matrix}
\right] \tag{2}
$$

$$
\left [
\begin{matrix}
\Lambda_{mp} & \Lambda_{mm} \\
\Lambda_{pp}-\Lambda_{pm} \Lambda_{mm}^{-1} \Lambda_{mp} & 0
\end{matrix}
\right ] 
\left[
\begin{matrix}
\delta X_{pp} \\
\delta X_{mm}
\end{matrix}
\right ] = 
\left [
\begin{matrix}
b_{mm} \\
b_{pp}-\Lambda_{pm} \Lambda_{mm}^{-1} b_{mm}
\end{matrix}
\right] 
$$

$$
\left[
\begin{matrix}
\Lambda_{mp} \delta X_{pp} + \Lambda_{mm} \delta X_{mm} \\
(\Lambda_{pp}-\Lambda_{pm} \Lambda_{mm}^{-1} \Lambda_{mp})\delta X_{pp} 
\end{matrix}
\right ] = 
\left [
\begin{matrix}
b_{mm} \\
b_{pp}-\Lambda_{pm} \Lambda_{mm}^{-1} b_{mm}
\end{matrix}
\right] \tag{3}
$$

因此可得：
$$
\Lambda_{mp} \delta X_{pp} + \Lambda_{mm} \delta X_{mm}  =  b_{mm} \tag{4}
$$

$$
(\Lambda_{pp}-\Lambda_{pm} \Lambda_{mm}^{-1} \Lambda_{mp})\delta X_{pp} = b_{pp}-\Lambda_{pm} \Lambda_{mm}^{-1} b_{mm} \tag{5}
$$

由于$\Lambda_{mm}$表示路标点之间的信息矩阵块，是一个对角阵，因此$\Lambda_{mm}^{-1}$易求得。通过式（５）可得舒尔补形式，并求出$\delta X_{pp}$.将$\delta X_{pp}$代入式(4)可求得$\delta X_{mm}$:
$$
\delta X_{mm} = \Lambda_{mm}^{-1} (b_{mm}-\Lambda_{mp} \delta X_{pp}) \tag{6}
$$
