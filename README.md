
# AMY_M0O

AMY_M0O是基于PODES-M0O开发的一款MCU实现，用于演示PODES-M0O的应用及开发过程。<br>
主要目标对象为：个人学习者。尤其是那些具备一定的基础知识，准备涉足SoC设计和应用的人员。比如逻辑设计工程师、在校学生等等。<br>
<br>

## AMY_M0O的设计原则
一个SoC设计，无论多么简单，都要涉及到指令集设计、RTL代码开发、RTL仿真、FPGA硬件系统验证、编译器的开发/使用、嵌入式C程序开发、甚至操作系统的裁剪。正所谓麻雀虽小，五脏俱全。熟悉或者了解上述知识和相关的工具使用，有助于快速上手。
<br>
为了帮助个人学习者尽快上手，AMY/PODES-M0O已经做到了尽量简化。去掉了大量与实际ASIC实现相关的代码；在保留核心的前提下优化结构；尽量使用常见和易得的开发工具；编写精简的开发脚本；甚至提供一个完整的FPGA评估板。
<br>
在如何达到精简易用方面，作者动了不少心思。用剃刀一层一层地刮，直到最后只剩下一堆骨架，再无从下手了。现在你手头的代码已经是数易其稿后的结果。毕竟，SoC芯片开发在IC设计公司一般都经由至少三个不同技术领域的团队协作完成。把这些简化到个人学习者容易接受的程度对我来说确实有一点困难。简单的事情弄复杂一般人都会，复杂的事情弄简单不容易！想到AMY/PODES-M0O是用于学习和研究的，或许简约而不简单就应该是他的本来面目。
<br><br>

## AMY-M0O特性
- 标准的PODES_M0O 32bit MCU Core
- 32bit GPIO
- 2个UART
- 1个IIC
- 1个键盘
- 1个STN
- 1个PWM

应用模式：
- IIC连接外部EEPROM/FLASH存储芯片；
- GPIO扩展应用；
- STN显示功能；
- KEYPAD输入；
- PWM电机驱动控制；
<br><br>

## AMY-M0O功能框图
AMY-M0O的结构如下图，构成一个PODES-M0O处理器内核的最小评估系统。<br>
评估系统工作流程为：内建boot代码接收串口数据，写入内存或者IIC 接口的EEPROM芯片。硬件自动从内存/EEPROM芯片中读取代码，存入片内RAM然后运行。
<br>   
<center>
    <img style="border-radius: 0.3125em;
    box-shadow: 0 2px 4px 0 rgba(34,36,38,.12),0 2px 10px 0 rgba(34,36,38,.08);" 
    src="/images/AMY_diagram.png?raw=true">
    <br>
    <div style="color:orange; border-bottom: 1px solid #d9d9d9;
    display: inline-block;
    color: #999;
    padding: 2px;">AMY-M0O功能框图</div>
</center>
<br>


## AMY-M0O功能扩展
AMY/PODES-M0O的结构设计为功能扩展做了特别优化，用户只需要将自己设计的APB接口模块挂接在系统提供的APB总线上即可。
<br>   
<center>
    <img style="border-radius: 0.3125em;
    box-shadow: 0 2px 4px 0 rgba(34,36,38,.12),0 2px 10px 0 rgba(34,36,38,.08);" 
    src="https://github.com/sunyata000/AMY_MCU/raw/master/images/amy_m0o_expand.png?raw=true">
    <br>
    <div style="color:orange; border-bottom: 1px solid #d9d9d9;
    display: inline-block;
    color: #999;
    padding: 2px;">AMY-M0O功能扩展</div>
</center>
<br>

## 使用方式
具体使用方式，请参考项目中的使用手册：PODES_M0O_Application_User_Manual_V1p0 文档。
<br><br>

## 贡献

1. 直接代码贡献请从 master 创建你的分支。<br>
2. 新的需求或者建议请留言，我会评估并处理。<br>
3. 如果你修改了或者增加了代码，请提供对应的文档。<br>
4. 确保代码风格一致 (尽量参考原始代码风格)。<br>
5. 如果你想直接资助这个项目，请参考[README_AMY](./README_AMY.md)<br>
<br>

## 许可

LGPL

<br> 
