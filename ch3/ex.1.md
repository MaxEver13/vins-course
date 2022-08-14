# <center>ex.1</center>

1.使用LM算法估计曲线$y=\exp(ax^2+bx+c)$的参数,绘制出阻尼因子的变化曲线，当噪声参数为1.0时，估计的参数误差较大，此处将噪声参数设为0.1，曲线上升阶段是最速下降法，后半段是高斯牛顿法：

![1563891233637](/home/max/.config/Typora/typora-user-images/1563891233637.png)

2.使用LM算法估计曲线$y=ax^2+bx+c$的参数,绘制出阻尼因子的变化曲线，发现噪声方差太大时，估计的参数误差较大，设定噪声方差为0.1。

​		2.1重新计算了残差和雅各比：

![1563890010031](/home/max/.config/Typora/typora-user-images/1563890010031.png)

​		2.2 阻尼因子变化曲线只迭代了3次便收敛，但是有一定的误差，可以跟下面另外一种阻尼更新方式对比：

![1563891715907](/home/max/.config/Typora/typora-user-images/1563891715907.png)

![1563891624875](/home/max/.config/Typora/typora-user-images/1563891624875.png)

3.示例代码中采用阻尼因子更新策略是方式3，我这里采用方式2作为阻尼因子的更新策略来估计曲线$y=ax^2+bx+c$的参数，参考文章The Levenberg-Marquardt algorithm for nonlinear least squares curve-fitting problems：

![1563890490757](/home/max/.config/Typora/typora-user-images/1563890490757.png)

​	实现的关键代码如下：

​		3.1 计算缩放因子和更新状态

![1563890257807](/home/max/.config/Typora/typora-user-images/1563890257807.png)

![1563890343402](/home/max/.config/Typora/typora-user-images/1563890343402.png)

​	3.2 使用上述方式2更新阻尼因子：

![1563890393835](/home/max/.config/Typora/typora-user-images/1563890393835.png)

​	3.3 运行结果和阻尼因子变化曲线，迭代了12次收敛，有一定的误差：

![1563889280618](/home/max/.config/Typora/typora-user-images/1563889280618.png)

![1563889347860](/home/max/.config/Typora/typora-user-images/1563889347860.png)