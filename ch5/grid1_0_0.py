import matplotlib

matplotlib.use('TkAgg')
import matplotlib as mpl
import matplotlib.pyplot as plt
from pylab import *
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FixedLocator, FormatStrFormatter
from matplotlib import pyplot
from matplotlib import colors
import numpy as np
import cv2 as cv


# RGB颜色转换为HSL颜色
def rgb2hsl(rgb):
    rgb_normal = [[[rgb[0] / 255, rgb[1] / 255, rgb[2] / 255]]]
    hls = cv.cvtColor(np.array(rgb_normal, dtype=np.float32), cv.COLOR_RGB2HLS)
    return hls[0][0][0], hls[0][0][2], hls[0][0][1]  # hls to hsl


# HSL颜色转换为RGB颜色
def hsl2rgb(hsl):
    hls = [[[hsl[0], hsl[2], hsl[1]]]]  # hsl to hls
    rgb_normal = cv.cvtColor(np.array(hls, dtype=np.float32), cv.COLOR_HLS2RGB)
    return int(rgb_normal[0][0][0] * 255), int(rgb_normal[0][0][1] * 255), int(rgb_normal[0][0][2] * 255)



# HSL渐变色
def get_multi_colors_by_hsl(begin_color, end_color, color_count):
    if color_count < 2:
        return []

    colors = []
    hsl1 = rgb2hsl(begin_color)
    hsl2 = rgb2hsl(end_color)
    steps = [(hsl2[i] - hsl1[i]) / (color_count - 1) for i in range(3)]
    for color_index in range(color_count):
        hsl = [hsl1[i] + steps[i] * color_index for i in range(3)]
        colors.append(hsl2rgb(hsl))


    #将数值 0-255变为 0-1
    tmp_list_ = []
    for i in range(0, len(colors)):
        color_0_1 = colors[i]
        tmp_list = []
        for j in range(0, 3):
            color_0_1_ = round(color_0_1[j] / 255, 2)
            tmp_list.append(color_0_1_)
        tmp_list_.append(tuple(tmp_list))

    return tmp_list_



#颜色映射以及产生多少种的颜色
color  = get_multi_colors_by_hsl((0,0,0),(255,255,255),100)

# make values from -5 to 5, for this example
zvals = np.array([[100, 1, 43, 45, 1],
                  [87, 0, 0, 32, 76],
                  [0, 100, 44, 14, 90],
                  [45, 15, 34, 76, 54],
                  [100, 32, 0, 32, 1]])

#矩阵块上下相反，需要加上这一行
zvals = flip(zvals, 0)

# make a color map of fixed colors
# cmap = mpl.colors.ListedColormap(['blue','black','red'])
# cmap = mpl.colors.ListedColormap(['cornflowerblue', 'white'])
colormap = color                  #产生出颜色

colormap.sort(reverse=True)

cmap = colors.ListedColormap(colormap)
# bounds=[0,1,2,3,4]
bounds = range(0, len(color)+1)   #产生多少个分段的颜色


# bounds.sort(reverse=True)

# bounds=[0, 3,4, 8]
norm = mpl.colors.BoundaryNorm(bounds, cmap.N)

# tell imshow about color map so that only set colors are used
img = pyplot.imshow(zvals,interpolation='nearest',origin= 'lower',extent= (0,zvals.shape[0],0,zvals.shape[0]),
                    cmap = cmap,norm=norm,)

# make a color bar
pyplot.colorbar(img,cmap=cmap,norm=norm,boundaries=bounds,ticks=[0,len(color)]) #显示图例

tick_params(labeltop=False,labelbottom=False,labelleft=False,labelright=False)  #在什么位置显示刻度线的值
tick_params(top=False,bottom=False,left=False,right=False)                      #在什么位置显示刻度线
pyplot.grid(True,  color='black', linestyle='-', linewidth=2)

pyplot.show()

