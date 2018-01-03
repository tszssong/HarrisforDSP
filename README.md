# HarrisforDSP
纯手工C代码实现Harris的

针对TI DSP的，ccs版本5.4，没有专门针对DSP做优化
cmd文件针对tms320c6727,确定的是改成6748也能跑，用Simulation.ccxml可以仿真，打印匹配到的角点
targetConfigs里是可以在硬件上实现的版本，亲测可用
6748的话配DDR2
6727配SDRAM

调试经验：
ccs安装路径最好别有空格和特殊字符，会导致编译无法生成.lib
很多问题可以通过修改堆栈大小解决：properties->build->c6000 linker->basic options

--------------c程序运行结果会和matlab完全一致
