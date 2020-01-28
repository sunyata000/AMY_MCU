## 1	概述

### PODES
**PODES**是**P**rocessor **O**ptmization for **D**eeply **E**mbedded **S**ystem的首字母缩写。包括传统的51指令集架构，SparcV8指令集架构，ARMv6-M指令集架构以及PIC-16指令集架构等一系列MCU Core。<br>
### PODES-M0O
**PODES-M0O** 是兼容于ARMv6-M指令集架构的开源版本。**M0**指代Cortex-M0，**O**指代Open Source。<br>
PODES-M0O是一个经过专门精简优化的MCU CORE，定位于学习和研究。把他应用在一般的FPGA产品中没有问题，用于ASIC实现则需要一些额外的设计修改工作。PODES-M0O可以用于前期可行性评估。<br>
### AMY_M0O 
本项目使用一个工程实例（AMY_M0O）来介绍PODES-M0O的应用及开发过程。主要目标对象为：个人学习者。尤其是那些具备一定的基础知识，准备涉足SoC设计和应用的人员。比如逻辑设计工程师、在校学生等等。<br>
<br>
## 2	关于本项目AMY_M0O
一个SoC设计，无论多么简单，都要涉及到指令集设计、RTL代码开发、RTL仿真、FPGA硬件系统验证、编译器的开发/使用、嵌入式C程序开发、甚至操作系统的裁剪。正所谓麻雀虽小，五脏俱全。熟悉或者了解上述知识和相关的工具使用，有助于快速上手。
<br><br>
为了帮助个人学习者尽快上手，AMY/PODES-M0O已经做到了尽量简化。去掉了大量与实际ASIC实现相关的代码；在保留核心的前提下优化结构；尽量使用常见和易得的开发工具；编写精简的开发脚本；甚至提供一个完整的FPGA评估板。
<br><br>
在如何达到精简易用方面，作者动了不少心思。用剃刀一层一层地刮，直到最后只剩下一堆骨架，再无从下手了。现在你手头的代码已经是数易其稿后的结果。毕竟，SoC芯片开发在IC设计公司一般都经由至少三个不同技术领域的团队协作完成。把这些简化到个人学习者容易接受的程度对我来说确实有一点困难。简单的事情弄复杂一般人都会，复杂的事情弄简单不容易！想到AMY/PODES-M0O是用于学习和研究的，或许简约而不简单就应该是他的本来面目。
<br>

![](https://github.com/sunyata000/AMY_MCU/blob/master/images/AMY_diagram.png?raw=true "AMY block diagram") <br>

AMY for M0O的结构如上图，构成一个PODES-M0O处理器内核的最小评估系统（相当于一个简单MCU芯片）。AMY的外围设备包括32bit GPIO、2个UART、1个IIC、一个键盘、1个STN、1个PWM。应用模式：IIC连接外部EEPROM/FLASH存储芯片；GPIO扩展应用；STN显示功能；KEYPAD输入；PWM电机驱动控制。
<br><br>
评估系统工作流程为：内建boot代码接收串口数据，写入内存或者IIC 接口的EEPROM芯片。硬件自动从内存/EEPROM芯片中读取代码，存入片内RAM然后运行。
<br><br>
本手册只关注PODES-M0O的应用。里面有相当多的地方涉及到PODES-M0O具体功能和结构的实现，都没有展开描述。读者若需要详细了解，可以参考下面的PODES-M0O设计手册：<br>
**PODES-M0O应用用户手册:（本文档）**<br>
*&emsp;PODES-M0O_Application_User_Manual_Vxx.doc*<br>
**PODES-M0O设计实现用户手册：**<br>
*&emsp;PODES-M0O_Implementation_User_Manual_Vxx.doc*<br>
**PODES-M0O评估板用户手册：**<br>
*&emsp;PODES_M0O_Evaluation_Board_User_Manual_Vxx.doc*
<br>
<br>
<br>
## 3	支持和服务

www.mcucore.club 是PODES开源项目的官方维护网站。

立足于保证PODES有用，作者会持续地维护这个项目。所有代码和文档资料的最新版本都可以从下面网站获得：
www.mcucore.club

所有的Issue Report或者优化建议，请投送到：www.mcucore.club 相关的页面，或者：podes.mcu@qq.com 。

<br>
**项目赞助**<br>
小额赞助、购买FPGA开发板、提供开发支持、甚至是一条建议或者评论，都是鼓舞PODES前行的动力。如果您有意赞助，请使用手机支付扫一扫下面的二维码：<br>
         支付宝扫一扫<br>
![](https://github.com/sunyata000/AMY_MCU/blob/master/images/alipay.jpg  "支付宝赞赏") <br>
         微信扫一扫 <br>
![](https://github.com/sunyata000/AMY_MCU/blob/master/images/wechat.jpg  "微信赞赏") <br>

<br><br>
<br> 
