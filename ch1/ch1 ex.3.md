# <center>ch1 ex.3</center>

## 1.

$$
\frac{\partial{(R^{-1}p})}{\partial{R}}=\lim_{\delta{\theta}\rightarrow0}\frac{(R\exp([\delta{\theta}]_\times))^{-1}p-R^{-1}p}{\delta{\theta}}
$$

$$
=\lim_{\delta{\theta}\rightarrow0}\frac{(I-[\delta{\theta}]_\times)R^{-1}p-R^{-1}p}{\delta{\theta}}
$$

$$
=\lim_{\delta{\theta}\rightarrow0}\frac{-[\delta{\theta}]_\times R^{-1}p}{\delta{\theta}}
$$

$$
=\lim_{\delta{\theta}\rightarrow0}\frac{[R^{-1}p]_\times \delta{\theta}}{\delta{\theta}}
$$

$$
=[R^{-1}p]_\times
$$

## 2.

$$
\frac{\partial{\ln(R_1R_2^{-1}})^{\vee}}{\partial{R_2}}=\lim_{\delta{\theta}\rightarrow0}\frac{\ln[R_1(R_2\exp([\delta{\theta}]_\times))^{-1}]^{\vee}-\ln(R_1R_2^{-1})^{\vee}}{\delta{\theta}}
$$

根据$SO(3)$的伴随性质$R^{T}\exp([\delta{\theta}]_\times)R=\exp([R^T\delta\theta]_\times)$： 
$$
=\lim_{\delta{\theta}\rightarrow0}\frac{\ln\{R_1[\exp([R_2\delta{\theta}]_\times)R_2]^{-1}\}^{\vee}-\ln(R_1R_2^{-1})^{\vee}}{\delta{\theta}}
$$

$$
=\lim_{\delta{\theta}\rightarrow0}\frac{\ln[R_1R_2^{-1}(\exp([R_2\delta{\theta}]_\times))^{-1}]^{\vee}-\ln(R_1R_2^{-1})^{\vee}}{\delta{\theta}}
$$

这里扰动求逆等价于绕角轴反向旋转，由此可得：
$$
=\lim_{\delta{\theta}\rightarrow0}\frac{\ln[R_1R_2^{-1}\exp([-R_2\delta{\theta}]_\times)]^{\vee}-\ln(R_1R_2^{-1})^{\vee}}{\delta{\theta}}
$$

再根据$\ln [R(\exp([\delta{\theta}]_\times))]^{\vee}=\ln(R)^{\vee} + J_r^{-1}\delta{\theta}$，可得：
$$
=\lim_{\delta{\theta}\rightarrow0}\frac{\ln[R_1R_2^{-1}\exp([-R_2\delta{\theta}]_\times)]^{\vee}-\ln(R_1R_2^{-1})^{\vee}}{\delta{\theta}}
$$

$$
=\lim_{\delta{\theta}\rightarrow0}\frac{\ln(R_1R_2^{-1})^{\vee} + J_r^{-1}(\ln(R_1R_2^{-1})^{\vee})(-R_2\delta{\theta})-\ln(R_1R_2^{-1})^{\vee}}{\delta{\theta}}
$$

$$
=-J_r^{-1}(\ln(R_1R_2^{-1})^{\vee})R_2
$$

其中$J_r$表示$SO(3)$的右雅各比，见《四元数数学基础》section 4.3.3