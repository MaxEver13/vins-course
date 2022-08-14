# <center>ex.1</center>

当矩阵$D \in R^{2n \times 4}$满秩时，寻找：
$$
\min \limits_{y} ||Dy||^2, st ||y||=1　\tag{1}
$$
的最小二乘解。上式等价于：
$$
\min \limits_{y} (Dy)^T (Dy)=\min \limits_{y} y^TD^TDy, st ||y||=1 \tag{2}
$$
对$D^TD$进行SVD分解，假设$D$的SVD分解为:
$$
D = \sum_i \sigma_i \textbf{u}_i \textbf{v}_i^T \tag{3}
$$
则
$$
D^TD =(\sum_i \sigma_i \textbf{v}_i \textbf{u}_i^T)(\sum_j \sigma_j \textbf{u}_j \textbf{v}_j^T)= \sum_{i,j} \sigma_i \sigma_j \textbf{ｖ}_i (\textbf{u}_i^T \textbf{u}_j) \textbf{v}_j^T \tag{4}
$$
又$\textbf{u}_i^T \textbf{u}_j$当$i\neq j$时都等于０，因此继续化简：
$$
D^TD =\sum_i \sigma_i^2\textbf{v}_i \textbf{v}_i^T \tag{5}
$$
但是由于$D^TD$是对称阵，SVD后的$\textbf{U}$阵与$\textbf{V}$阵相同，所以有$\textbf{u}_i = \textbf{v}_i$,即有：
$$
D^TD =\sum_i \sigma_i^2\textbf{u}_i \textbf{u}_i^T   \tag{6}
$$
其中:
$$
\sigma_1^2 \geq \dots \geq \sigma_4^2,
\textbf{u}_l^T \textbf{u}_m =  \begin{cases} 
0 &  l\neq m \\
1 & otherwise
\end{cases}
$$



假设$y=\textbf{u}_4+\textbf{v}, \textbf{v} \perp \textbf{u}_4$,将式(2)代入式(1)中：
$$
y^T (\sum_{j=1}^{4} \sigma_j^2 \textbf{u}_j \textbf{u}_j^T) y = \sum_{j=1}^{4} y^T\sigma_j^2 \textbf{u}_j \textbf{u}_j^T y = \sum_{j=1}^{4} \sigma_j^2(\textbf{u}_j^T y)^2 \tag{7}
$$
当$j=4$时有：
$$
\sigma_4^2[\textbf{u}_4^T(\textbf{u}_4+\textbf{v})]^2=\sigma_4^2(\textbf{u}_4^T\textbf{u}_4+ \textbf{u}_4^T \textbf{v})=\sigma_4^2 \tag{8}
$$
因此将式(4)重写为：
$$
\sum_{j=1}^{4} \sigma_j^2(\textbf{u}_j^T y)^2 = \sigma_4^2 + \sum_{j=1}^{3} \sigma_j^2(\textbf{u}_j^T y)^2=\sigma_4^2 + \sum_{j=1}^{3} \sigma_j^2[\textbf{u}_j^T (\textbf{u}_4+\textbf{v})]^2 \tag{9}
$$
由于$\textbf{u}_j^T \textbf{u}_4=0, j=1\dots3$,可继续将式(6)继续化简：
$$
\sum_{j=1}^{4} \sigma_j^2(\textbf{u}_j^T y)^2 =\sigma_4^2 + \sum_{j=1}^{3} \sigma_j^2(\textbf{u}_j^T \textbf{v})^2 \geq \sigma_4^2 \tag{10}
$$
由上式可知，当$\textbf{v}=0, y = \textbf{u}_4$时，式(４)有最小值。



