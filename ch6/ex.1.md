## <center>ex.1</center>

1.完成Problem::MakeHessian()中信息矩阵$H$的计算：

![1565340433767](/home/max/.config/Typora/typora-user-images/1565340433767.png)

２．完成Problem::SolveLinearSystem()中slam问题的求解，公式推导参考文档《marginalize推导》：

![1565340617079](/home/max/.config/Typora/typora-user-images/1565340617079.png)

输出没有固定前两帧相机位姿的结果：

![1565341171639](/home/max/.config/Typora/typora-user-images/1565341171639.png)

输出固定前两帧相机位姿的结果：

![1565341553914](/home/max/.config/Typora/typora-user-images/1565341553914.png)

可以看到不固定前两帧相机位姿的时候，ＬＭ求解出来的相机位姿会发生一些微小的漂移。固定前两帧相机位姿后，第一个相机的位姿就固定在原点$(0,0,0)$。