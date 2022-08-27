---
title: linux命令行与shell脚本编程大全
date: 2022-3-12 22:4:2
tags: books
categories: 学习笔记
---

# 快捷键

- Ctrl Shift N 创建新shell会话(N->T:当前窗口)
- Ctrl Shift W 关闭当前会话(W->Q:当前窗口)
- Ctrl +/- 改变窗口显示字号
- Ctrl 0 恢复默认字号
- Ctrl Shift C/V 复制粘贴
- Ctrl Shift F 在当前窗口搜索文本内容(F->G:向后、F->H:向前)
- Alt number 切换当前窗口内的活动标签(Ctrl PageDown/PageUp切换标签，+Shift移动当前标签)


# 基本bash
## 文件与目录

- ls -F # 区分目录和文件
- ls -R # 递归选项
- ls -l # 显示长列表
    - 文件类型：目录d、文件-、字符型文件c、块设备b
    - 文件权限
    - 硬链接数目
    - 属主用户名
    - 属组组名
    - 文件大小
    - 文件上次修改时间（并非是访问时间，若要查看访问时间：--time=atime）
    - 文件名或者目录名
- ls * # 支持过滤功能
- ls -i # 文件或目录的inode编号是唯一标示的数字

## 处理文件

### 创建文件
- touch file # 创建文件命令
- touch -a file # 改变访问时间

### 复制文件
- cp -i source target # 是否覆盖已有文件
- cp命令支持通配符
- cp -R递归复制

### 链接文件
符号链接与硬链接
- ln -s file target # 符号链接
- ln file target # 硬链接会创建单独的虚拟文件，其实是同一个文件
不同存储媒体的文件之间的链接应使用符号链接


### 重命名文件
- `mv old_file new_file` # 重命名或者移动文件，inode编号不变

### 删除文件
- `rm -i file` # 是否确认删除
- `rm -r directory` # 递归删除
- `rm -f file` # 免受提示符的打扰

## 处理目录

### 创建目录
- `mkdir directory` # 创建文件夹
- `mkdir -p directory` # 创建缺失的父目录

### 删除目录
- `rmdir directory` # 删除空目录


- tree # 美观的展示目录、子目录以及文件

## 查看文件内容

### 查看文件类型
- file file # 探测文件

### 查看整个文件
- cat file # 显示文本内容
- cat -n file # 显示行号
- cat -b file # 只给有文本的内容显示行号
- cat -T file # 不显示制表符。^I来替换其中的制表符

- more file # 查看文件
- less file # 功能更强大的查看文件

### 查看部分文件
- tail file # 默认显示最后十行文件
- tail -n 2 file # 显示最后n行文件
- tail -f file # 保持活跃状态，可用于实时检测


- head file # 显示开头内容
- head -5 file # 显示n行开头内容



# 更多bash
## 检测程序
### 探查进程

UNIX 风格的参数：
- ps # 显示当前控制台下属于当前用户的进程
    - pid：进程ID
    - tty：teletypewriter
    - time：已用cpu时间
    - cmd：命令
- ps -ef # 显示所有进程
- ps -l # 长格式输出
    - F:内核分配给进程的系统标记
    - S:进程的状态
        - O 正在运行
        - S 休眠
        - R 可运行，等待运行
        - Z 僵化，进程已结束但父进程已不存在
        - T 停止
    - o # 指定输出格式：-o pid,ppid,ni,cmd...
- PRI # 进程的优先级，数字越大优先级越低
- NI # 谦让度值用来参与决定优先级
- ADDR # 进程的内存地址
- SZ # 加入进程被换出，所需要的交换空间大小
- WCHAN # 进程休眠的内核函数地址

BSD 风格的参数不同之处：
- VSZ # 进程在内存中的大小，单位KB
- RSS # 进程在未换出时占用的物理内存
- STAT # 代表当前进程状态的双字符状态码
    - 第一个字符和UNIX风格的S列相同
    - < 该进程运行在高优先级上
    - N 该进程运行在低优先级上
    - L 该进程有页面锁定在内存中
    - s 该进程是控制进程
    - l 该进程是多线程的
    - + 该进程运行在前台

GUN 长参数

- ps --forest # 显示进程的层级信息，并用ASCII绘制出可爱的图表



### 实时检测进程
- top
    - 第一行显示当前时间、系统的运行时间、登录的用户数、系统的平均负载
        - 平均负载有三个值，最近1分钟、最近5分钟、最近15分钟
        - 系统长时间处于高负载，系统可能会有问题（大于2）
    - 第二行进程概要信息
    - 第三行显示CPU概要信息
    - 系统物理内存状态
    - 系统交换空间内存状态
    - PID 进程的ID
    - USER 进程属主的名字
    - PR 进程的优先级
    - NI 进程的谦让值度
    - VIRT 进程占用的虚拟内存总量
    - RES 进程占用的物理内存总量
    - SHR 进程和其他进程共享的内存总量
    - S 进程的状态
        - D 可中断的休眠状态
        - R 在运行状态
        - S 休眠状态
        - T 跟踪或者停止状态
        - Z 僵化状态
    - %CPU 进程使用的CPU时间比例
    - %MEM 进程使用的内存占可用内存的比例
    - TIME+ 自进程启动到目前为止的CPU时间总量
    - COMMAND 进程所对应的命令行名称，启动的程序名

    - 默认使用%CPU值对进程排序
    - 键入f选择对输出排序的字段
    - 键入d修改轮询间隔
    - 键入q退出top

### 结束进程

linux 进程信号
- 信号 名称 描述
- 1 HUP 挂起
- 2 INT 中断
- 3 QUIT 结束运行
- 9 KILL 无条件终止
- 11 SEGV 段错误
- 15 TERM 尽可能终止
- 17 STOP 无条件停止运行，但不终止
- 18 TSTP 停止或者暂停，但继续在后台运行
- 19 CONT 在STOP或TSTP之后恢复执行


- kill pid # 给列出的全部PID发送TERM信号
- kill -s 信号名称 pid # kill -s HUP 4444

- killall http* # killall 支持通过进程名来结束进程，还支持通配符，上述命令结束了http开头的进程


## 检测磁盘空间

### 挂载存储媒体

- mount # 输出当前系统挂载的设备列表
    - 设备文件名
    - 挂载在虚拟目录的挂载点
    - 文件系统类型
    - 已挂载媒体的访问状态
- mount # P74
- unmount # P75

### 查看磁盘使用情况
- df # 查看已挂载磁盘的使用情况
- df -h # 用户易读方式显示

### 显示特定目录使用情况
- du # 显示特定目录的磁盘使用情况，左边数值为占用的磁盘块数
- du -c # 显示已列出文件总大小
- du -h # 按照用户易读方式输出
- du -s # 显示每个输出参数的统计

## 处理数据文件

### 排序数据

- sort file # 默认语言的排序规则对文本数据行排序
- sort -n file # 将数字识别成数字而不是字符，并按值排序
- sort -M file # 能识别三字符的月份名，相应排序
- sort -k n file # 指定排序的字段，第n列排序
- sort -t str file # 指定分隔符
- sort -f ... # 忽略大小写
- sort -g ... # 支持浮点排序
- sort -b ... # 忽略起始的空白
- sort -m ... # 将两个已排序的文件合并
- sort -o ... # 将排序结果写入指定文件
- sort -r ... # 反向排序

### 搜索数据
- grep -n ... # 显示行号
- grep -c ... # 显示多少行
- grep -e pattern1 -e pattern2 ... # 指定多个模式匹配


### 压缩数据
- gzip file # 压缩指定文件

### 归档数据
- tar -c ... # 创建一个新的归档文件
- tar -x ... # 从已有归档文件提取文件
- tar -f ... # 输出结果到文件或者设备
- tar -p ... # 保留所有问加权限
- tar -v ... # 处理文件时显示文件
- tar -z ... # 将输出重定向给gzip命令来压缩文件
- tar -t ... # 列出已有tar归档文件内容

- tar -cvf test.tar test/ test2/ # 将test和test2目录压缩到压缩文件
- tar -tf test.tar # 列出其内容，但并不提取
- tar -xvf test.tar # 提取内容
- tar -zxvf test.tgz # 提取内容


# 理解bash

## shell类型
`cat /etc/passwd | grep $USER`
`ls -lF /bin/bash`
查看默认类型

## shell的父子关系

- bash # 生成子进程
- ps -f # 查看生成的子进程subshell/child shell
- ps --forest # 展示子进程的嵌套结构

### 进程列表
- (command1; command2) # 进程列表/命令分组将生成一个子进程执行其中的命令，并没有后台执行
- {command1; command2} # 不会生成子进程执行
- echo $BASH_SUBSHELL
    - 0:没有子进程
    - \>0:当前子进程层数
- sleep n # 睡眠n秒

### 子进程
- command & # 将命令后台执行，并未生成子进程
- jobs # 显示后台作业/进程：作业号，状态，命令
- jobs -l # 还可以显示pid
- coproc command # 后台生成一个子进程执行，进程名默认为COPROC
- coproc user_name { command; } # 配置后台子进程名字，注意：花括号与命令之前有空格，且命令要以分号结尾
**注意：子进程成本不低**

## 命令
### 外部命令/文件系统命令

存在于bash shell之外的程序，常位于/bin，/usr/bin，/sbin，/usr/sbin中
- 衍生forking
    - 外部命令执行时会创建一个子进程
    - 可以使用which 和type来找到
### 内建命令

不需要使用子进程来执行

有些命令echo，pwd既有内建命令也有外部命令，`type -a command`查看，which只显示外部命令查看


#### history内建命令

- !! # 换出刚用过的命令来使用 (未必存于历史中)
**bash命令的历史记录是存放在内存中，shell退出时才写入历史文件:~/.bash_history**

- history -a # 强制写入历史文件
- history -n # 强制重新读入历史文件（历史文件只在打开首个终端会话时，才会被读取，使用-a更新后，其他终端并不会更新历史信息，使用-n即可）
- !n # 运行编号为n的历史命令

#### alias别名

- alias -p # 列出当前别名

# linux环境变量

## 环境变量
有两类：局部变量，全局变量

### 全局环境变量
- env
- printenv # 同 env 查看全局变量
- printenv env # 查看个别环境变量env
- echo $env # 让变量作为命令行参数

全局变量可用于进程的所有子进程

### 局部环境变量

- set # 显示局部变量，全局变量，以及用户自定义变量，并按照字母表顺序排序

## 设置用户自定义变量

### 设置局部用户自定义变量

**赋值时变量名等号值之间没有空格，若有空格则会把值视为单独的命令**
**如果要给变量赋一个含有空格的字符串值，必须用单引号来界定字符串的首尾**
**所有的环境变量使用大写字母，如果自己创建的局部变量或者shell脚本，使用小写字母**
**在子shell中不可使用局部环境变量**
**shell脚本自动决定变量的数据类型**
**用户变量长度不得超过20**


### 设置全局环境变量

先创建一个局部环境变量，然后用export使命完成
**修改子进程的全局环境变量不会影响父进程中该变量的值，使用export命令也不行**


## 删除环境变量

- unset env # 删除环境变量env
**子进程删除全局变量，只对子进程有效**


## 默认的shell环境变量

p111

## 设置PATH环境变量

PATH中的目录使用冒号分割
PATH=.:$PATH

## 定位系统环境变量

登录linux启动bashshell时，默认情况下bash会在几个文件中查找命令，这些文件叫做启动文件或环境文件
bash检查的启动文件取决于启动bashshell的方式
启动方式有三种
- 登录时作为默认登录shell
- 作为非登录shell的交互式shell
- 作为运行脚本的非交互式shell

### 登录shell

登录shell会从5个不同的文件中读取命令：
- /etc/profile
- $HOME/.bash_profile
- $HOME/.bashrc
- $HOME/.bash_login
- $HOME/.profile

#### /etc/profile
/etc/profile是系统默认的主启动文件，系统上每个用户登录都会执行这个启动文件

#### $HOME目录下的启动文件
shell会按照下列顺序，运行第一个被找到的文件，余下的则被忽略：
- $HOME/.bash_profile
- $HOME/.bash_login
- $HOME/.profile


$HOME/.bashrc 通常通过其他文件运行

### 交互式shell进程

譬如命令行下运行bash启动进程，就不会访问/etc/profile文件，只会检查$HOME下的.bashrc文件

### 非交互式shell进程

譬如系统执行shell脚本的进程
具体不是很明白p120

### 环境变量持久化

升级发行版之后/etc/profile会被更新，最好是在/etc/profile.d目录下创建一个.sh结尾的文件，把所有新的或者修改过的全局变量放在这个文件中
大多数发行版中，存储个人用户永久性bash shell变量的地方是$HOME/.bashrc，除非BASH_ENV被设置


### 数组变量

给环境变量设置多个值：
test=(test1 test2 test3 test4)

echo ${test[3]} # index从0开始
echo ${test[*]} # 可用通配符显示整个数组
test[1]=2 # 单独改变某个索引的值
unset test[1] # 单独删除某个索引的值，但该索引还在
unset test # 删除整个数组

# linux文件权限

## linux安全性

用户权限是通过创建用户时分配的用户ID通常缩写UID，每个用户都有唯一UID，登陆时使用登录名，登录名是用户用来登陆系统的最长8字符的字符串，同时关联一个对应的密码

### /etc/passwd文件
将用户的登录名匹配到对应的UID

root是管理员，UID是0
linux会为各种功能创建不同的用户账户，并非真正的账户，成为系统账户，是系统上运行各种服务进程访问资源用的特殊账户
linux为系统用户预留了500以下的UID

- 登录用户名
- 用户密码
- 用户账户的UID（数字形式）
- 用户账户的组ID（GID数字形式）
- 用户账户的文本描述（备注字段）
- 用户HOME目录的位置
- 用户的默认shell

密码为x，密码文件/etc/shadow


### /etc/shadow文件

root用户才能访问该文件

- 与/etc/passwd文件中登录名字段对应的登录名
- 加密后的密码
- 自上次修改密码后过去的天数密码
- 多少天后才能更改密码
- 多少天后必须更改密码
- 密码过期前提前多少天提醒用户更改密码
- 密码过期后多少天禁用用户账户
- 用户账户被禁用的日期
- 预留字段给将来使用

### 添加新用户

- useradd -D # 查看默认值
    - GROUP=100 # 添加入GID为100的公共组
    - HOME=/home # 新用户的home位于/home/loginname
    - INACTIVE=-1 # 新用户在密码过期后不会被禁用
    - EXPIRE=   # 新用户账户未被设置过期日期
    - SHELL=/bin/bash # 默认shell
    - SKEL=/etc/skel # 系统将该目录下的内容复制到新用户的HOME目录下（配置文件等）
    - CREATE_MAIL_SPOOL=yes # 系统为该用户在mail目录下创建一个用户接收邮件的文件

- useradd -m username # 创建新用户账户
    - -c comment # 给新用户添加备注
    - -d home_dir # 给主目录指定一个名字
    - -e expire_date # 使用YYYY-MM-DD格式指定一个账户过期时间
    - -f inactive_days # 密码过期多少天后禁用账户，-1标示禁用此功能
    - -g initial_group # 指定GID或者祖名
    - -G group ... # 指定除登录组之外所属一个或其他组
    - -M # 不创建home目录
    - -k # 必须和-m一起使用将/etc/skel目录中的内容复制到用户的home目录
    - -n # 创建一个与用户登录名同名的新组
    - -r # 创建系统用户
    - -p passwd # 指定默认密码
    - -s shell # 指定默认登录shell
    - -u uid # 为账户指定唯一UID

    - -D -b default_home # 更改默认的创建用户home目录的位置
    - -D -e expiration_date # 更改默认的创建用户的过期时间
    - -D -f inactive # 更改默认的创建用户从密码过期到被禁用时间
    - -D -g group # 更改默认的祖名或者GID
    - -D -s shell # 更改默认的登录shell


### 删除用户

- userdel # 只会删除/etc/passwd文件中的信息
    - -r # 会删除用户home目录以及邮件目录

### 修改用户
p130-132
#### usermod
#### passwd&chpasswd
#### chsh&chfn&chage

## linux组
p132
## 文件权限
p135
## 安全性设置
p138
## 共享文件
p140


# 安装软件程序

## 包管理基础
- dpkg
- rmp

## 基于debian的系统

### 用aptitude管理软件包

- aptitude

- dpkg -L package # 列出跟某个特定软件包相关的所有文件列表
- dpkg --search file # 查找特定文件属于哪个软件包（上述操作的反操作，使用时应使用绝对路径）
### aptitude安装软件包

- aptitude search package # 自动在两端加通配符
    - 每个包前面都有一个p/v或者i（i:安装过，其余表示未安装）
- aptitude install package # 安装
### aptitude更新软件包

- aptitude safe-upgrade # 将已安装的所有软件包更新到最新版本（会检查包之间的依赖关系）
    - aptitude full-upgrade
    - aptitude dist-upgrade

### aptitude卸载软件包
- aptitude remove package # 不删除数据和配置文件
- aptitude purge package # 删除数据和配置文件
c：软件已删除，配置文件尚未清除
p：配置文件也已删除

### aptitude仓库

默认软件仓库配置文件/etc/apt/sources.list

deb (or deb-src) address distribution_name package_type_list
deb表明软件包类型
address条目是软件仓库的web地址
distribution_name是这个特定软件仓库的发行版名称
package_type_list表明仓库中有什么类型的包

## 基于RedHat的系统
- yum 在RedHat，Fedora中使用
- urpm 在Mandriva中使用
- zypper 在openSUSE中使用

### 列出已安装包

- yum list installed
urpm与zypper见p172
- yum provides file_name 找出某个文件属于哪个包
yum会查找三个仓库 base updates installed

### 用yum安装软件
- yum install package # 从仓库中安装
- yum localinstall package # 手动下载安装

### 用yum更新软件

- yum list updates # 列出所有已安装包的可用更新
- yum update package # 更新特定包
- yum update # 更新所有包

### 用yum卸载软件

- yum remove package # 删除软件包，保留配置文件和数据文件
- yum erase package # 删除软件包，和它所有文件

### 处理损坏的包依赖关系

- yum clean all
- yum update

若不能解决问题：
- yum deplist package # 显示所有包的库依赖关系以及什么软件可以提供这些库依赖关系

若仍不能解决问题：
- yum update --skip-broken # 虽然救不了损坏的包，但可以更新系统上的其他包

### yum软件仓库

- yum repolist # 正从哪些仓库中获取软件
yum的仓库定义文件位于/etc/yum.repos.d

## 从源码安装

- ./configure
- make
- make install

# 使用编辑器

## vim
vi improves
### vim软件包
- alias vi
- which vim
- ls -l "last result"
- readlink -f "last result" # 查找一系列链接文件的最终目标

如果是/usr/bin/vim.tiny则其只提供少量的vim功能：
- sudo apt-get install vim

### vim基础
- h 左移
- j 下移
- k 上移
- l 后移
- ctrl+f 下翻一页
- ctrl+b 上翻一页
- G 最后一行
- num G 第num行
- gg 第一行

### 编辑数据
- x 删除光标所在数据
- dd 删除光标所在行
- dw 删除光标所在单词
- d$ 删除光标至行尾
- J 用空格拼接下一行
- u 撤销前一操作
- a 在光标后追加数据
- A 在当前行行尾添加数据
- r 用字符替换光标位置数据
- R 用数据替换光标数据直到按下ESC

前面加数字标示重复操作

### 复制与粘贴

vim在删除数据时会将数据放在某个寄存器中使用p取回数据
- y 复制数据yank
与上文中的d用法一样，如：
- yw 复制单词
- y$ 复制到行尾

- v 可视模式，方便复制

### 查找与替换

- /key # 查找
- :s/old/new/ # 替换当前行的old
- :s/old/new/g # 替换当前行所有old
- :n,ms/old/new/g # 替换n到m之间所有old
- :%s/old/new/g # 替换整个文件中的所有old
- :%s/old/new/gc # 替换整个文件中的所有old，但在每次出现时提示

## nano编辑器

nano

p187

## emacs编辑器

emacs
p188

## KDE系编辑器

kwrite

p196

## GNOME编辑器

gedit

p202

# 基本脚本
## 使用多个命令

分号隔开，不超过最大命令行字符数255

## 创建shell脚本文件

## 显示消息

- echo "mesg'test" # 如有引号出现，则使用另一种引号划定起来即可
- echo -e "1\t2" # 打印非可打印字符
- echo -n mesg # 打印信息后不换行

## 使用变量

### 环境变量
echo $USER
echo ${USER}

### 用户变量
详情：设置局部用户自定义变量

### 命令替换

- `command`
- $(command)

**如果命令中有反斜杠，则使用`command`格式时需要对其转意**
**命令替换会创建一个子shell来运行使用./运行命令也会创建子shell，运行命令时不加入路径就不会创建子shell**

## 重定向输入与输出

### 输出重定向

将命令输出发送至文件
- >会覆盖原有文件
- >>会追加数据

### 输入重定向

- <将文件内容重定向到命令
- << 内联输入重定向
    - 必须指定一个文本标记来划分数据的开始和结尾
    - 任何字符串都可作为文本标记
    - 数据的开始和结尾文本必须一致

```
wc << test
testagain
testwillfinish
test
```
上述信息会输出2 2 25(两行，两个单词，25个字符)

## 管道

一个命令的输出作为另一个命令的输入，重定向到另一个命令，叫做管道连接

- rpm -qa | sort | more

## 数学运算

### expr命令

- expr 2 + 4 # 输出6必须有空格
- expr 2 \* 4 # 输出8
todo: expr 命令操作符：P223

### 使用$[]

只能进行整数运算

### 浮点解决方案

#### bc命令基本用法
bash计算器能够识别：
- 数字（整数和浮点数）
- 变量（变量和数组）
- 注释（#或者/**/）
- 表达式
- 编程语言（例如if-then）
- 函数

输入quit退出


浮点运算是由内建变量scale控制，为保留小数点的位数，默认为0，-q命令行选项不显示bash计算器欢迎信息

#### 脚本中使用bc

variable=$(echo "options; expression" | bc)

- echo "234; 23423;sdf;234/2" | bc #输出：234 23423 0 117

## 退出脚本

### 查看退出状态码

- echo $?
    - 0:命令成功结束
    - 1:一般性未知错误
    - 2:不适合的shell命令
    - 126:命令不可执行
    - 127:没找到命令
    - 128:无效的退出参数
    - 128+x:与linux信号x想关的严重错误
    - 130:通过ctrl+c终止的命令
    - 255:正常范围之外的退出状态码

### exit
默认下shell脚本会以最后一个命令的退出状态码退出
exit允许在脚本结束时指定一个退出状态码，最大只能是255，shell会通过模运算来得到这个结果


# 结构化命令

## if-then

```
if command
then
    commands
fi

if command;then
    commands
fi
```
如果command的退出状态码为0，then的部分就会被执行

## if-then-else

```
if command;then
    commands
else
    commands
fi
```

## elif

```
if command;then
    commands
elif command2
then
    commands
...
elif command3
then
    commands
fi
```


## test

```
if test condition
then
    commands
fi
```
如果condition不写则会以非0的退出状态码退出，执行else语句，可以利用此方法判断变量是否有内容：if test $param ...


省略test：
```
if [ condition ]
then
    commands
fi
```

**方括号与condition之间要有空格**
- 数值比较
- 字符串比较
- 文件比较


### 数值比较

- if [ n1 -eq n2 ] # 是否相等
    - -eq # 是否相等
    - -ge # 是否大于等于
    - -gt # 是否大于
    - -le # 是否小于等于
    - -lt # 是否小于
    - -ne # 是否不等于
**只能处理整数**

### 字符串比较

- str1 = str2 # 是否1与2相等
- str1 != str2 # 是否1与2不等
- str1 < str2 # 是否1比2小
- str1 > str2 # 是否1比2大
- -n str # 是否长度非0
- -z str # 是否长度为0

**大于小于号需要转义才能正常使用**
**test时大写字母小于小写字母，而sort排序时相反：test使用ASCII数值，sort使用系统本地化语言设置中定义的排序顺序，对于英语小写出现在大写之前**
**!!!如果比较数值时使用数学运算符，将视为字符串比较，结果可能是错误的!!!**

### 文件比较

- -d file # 是否是目录
- -e file # 是否存在
- -f file # 是否是文件
- -r file # 是否存在并可读
- -s file # 是否存在并非空
- -w file # 是否存在并可写
- -x file # 是否存在并可执行
- -O file # 是否存在并属当前用户所有
- -G file # 是否存在并默认组与当前用户相同
- file1 -nt file2 # file1是否比file2新，并不会判断两个文件是否存在，如不存在返回错误结果
- file1 -ot file2 # file1是否比file2旧，并不会判断两个文件是否存在，如不存在返回错误结果

## 复合条件测试

- if [ condition ] && [ condition2 ]
- if [ condition ] || [ condition2 ]

## if-then高级特性

- 用于数学表达式的双括号
- 用于高级字符串处理功能的双方括号

### 使用双括号

(( expression ))
- val++ # 后增
- val-- # 后减
- ++val # 先增
- --val # 先减
- ! # 逻辑求反
- ~ # 位求反
- ** # 幂运算
- << # 左位移
- >> # 右位移
- & # 位布尔和
- | # 位布尔或
- && # 逻辑和
- || # 逻辑或

其中的大于小于号不需要转义

### 使用双方括号

[[ expression ]]
可使用test命令中标准的字符串比较，还提供了一个test没有的特性：模式匹配
```
if [[ $USER == zhang* ]];then
    echo "hello $USER"
else
    echo "sorry, I don't know you"
fi
```

## case命令

```
case $USER in
rich|zhang)
    echo welcome;;
test)
    echo ditto;;
*)
    echo fail
    echo out!!!!;;
esac
```

# 更多结构化命令

## for

```
l=`ls`
for i in $(cat $file) $l;do
    echo $i
done
```
**循环结束后test一直有效**
**for循环假定以空格分割的，如果有包含空格的数据值，trouble！用引号隔开即可**

### 更改字段分隔符

有一环境变量：内部字段分隔符IFS，默认分隔符：
- 空格
- 制表符
- 换行符

- IFS=$'\n' # 用换行符作为分隔符
- IFS=: # 使用冒号作为分隔符
- IFS=$'\n':;" # 使用换行符、冒号、分号、引号作为分隔符

### 使用通配符读取目录

```
for file in /dir/*
do
    if [ -d "$file" ]
    then
        echo "$file is a directory"
    elif [ -f "$file" ]
    then
        echo "$file is a file"
    fi
done
```

## C语言风格的for

for (( variable assignment ; condition ; iteration process ))

```
for (( a = 1; a < 10; a++));then
    echo $a
done
```
**而且可以使用多个变量，但只能使用一个条件：for((a=1,b=10;a<10;a++,b--))**

## while命令


### 基本格式
```
while test command;do
    commands
done
```

### 使用多个测试命令

```
while test command;test command1;do
    commands
done
```

## until命令

until跟while相反，只有测试命令的退出状态码不为0，才执行循环，一旦为0，循环结束退出

```
until test command;do
    commands
done
```
**也可以有多个测试，但只有最后一个有效，只有在最后一个测试命令成立时才停止**

## 嵌套循环

## 循环控制
### break

- break # 跳出内部循环，自动中止最内层的循环
- break n # 跳出外部循环，n默认为1

### continue

- continue # 中止某次循环中的命令
- continue n # 指定继续哪一级的循环命令

## 处理循环的输出

可以在done命令之后加一个处理命令：

done > output # 会将结果重定向到文件，而不是输出

同样的，也可以将结果管接给另一个命令

## 循环实例

### 创建多个用户账户

```
input=users.csv
while IFS=',' read -r userid namd
do
    useradd -c "$name" -m "$userid"
done < "$input"
```

# 处理用户输入

## 命令行参数

### 读取参数

- bash会将一些位置参数的特殊变量输入到命令行中的所有参数
- 也包含shell所执行的脚本名称
- $0是程序名，$1-$9是第1-9个参数
- ${10}是第十个参数，不止九个的参数必须加花括号

### 读取脚本名

若执行脚本带文件路径，则$0也会带有路径
- name=$(basename $0) # 返回不包含路径的文件名

### 测试参数

- -n $1 # 测试参数是否存在

## 特殊参数变量

### 参数统计

- `$#`
    - 脚本运行时携带的参数个数，不包含$0
- `${!#}`
    - 最后一个命令行参数，支持bash，不支持shell

### 抓取所有数据


- `$*`或者`$@`访问所有提供的参数
    - 区别是`$*`会将所有的参数视为一个整体，`$@`当作同一字符串中的多个独立的单词
    - for循环时，`$*`参数会当成一个整体，`$@`会遍历每一个参数（参数包含空格怎么办）

    - 区别在于：
        - [ -n "$@" ] && echo 1 || echo 2 # 是否参数非空，是非空，退出码为0，输出1
        - [ -n "$*" ] && echo 1 || echo 2 # 是否参数非空，是空的，所以不是非空，退出码不为0，输出2

## 移动变量

- shift n # 使用左移参数，n默认为1，$0是程序名不会被改变，移除的变量将丢弃，不会再找到

## 处理选项

选项是跟在单个破折线之后的单个字母，它能改变命令的行为，以下为三种处理选项的方法：

### 查找选项

#### 处理简单选项

```bash
while [ -n "$1" ];do
    case "$1" in
    -a) commands;;
    -b) commands;;
    -c) commands;;
    *) commands;;
    esac
    shift
done
```

#### 分离参数和选项

双破折线表明选项列表结束，剩下的命令行参数都是参数，case中加一个--)) shift; break;;就可以处理参数了

#### 处理带值的选项

处理完之后加上shift;;就可以了

### 使用getopt处理合并选项

getopt命令是一个处理命令行选项和参数时非常方便的工具

#### 命令的格式

getopt可以接收一系列任意形式的命令行选项和参数，并自动将他们转换成适当的格式，命令格式如下：
- getopt optstring parameters
    - optstring 定义了命令行有效的选项字母，还定义了哪些选项字母需要参数
        - 在optstring列出你要在脚本中用到的每个命令行选项字母，并在需要参数的选项字母后面加一个冒号
    - parameters 是待解析的参数

#### 在脚本中使用getopt

- set -- $(getopt -q optstring "$@")
    - set 的--选项将命令行参数替换成set命令的命令行值
    - 之后就可以正常使用了
与**处理简单选项**功能配合使用
**使用getopt时参数不可有空格，用引号也没用。测试了一下，貌似是可以的**

### 更高级的内建命令getopts

命令格式：
- getopts optstring variable
    - getopts一次只处理命令行上检测到的一个参数，处理完所有参数后会退出返回一个大于0的退出状态码，非常适合用于解析命令行所有参数的循环
    - optstring 有效选项的字母列在其中，如果选项要求有参数值，就加一个冒号，如果要去掉错误信息就在最前面加一个冒号
    - variable getopts会将解析的选项保存在命令行中定义的variable中，跟getopt不一样的是不带开头的单破折线
        - OPTARG 会保存需要跟的参数值
        - OPTING 保存了参数列表中正在处理的参数位置
    - 跟getopt不同的是，getopts拿不到--之后的参数

**demo:**
```
while getopts :ab:c opt;do
    case "$opt" in
    a) commands;;
    b) commands;;
    c) commands;;
    *) commands;;
    esac
done
```

**杀死服务器特定进程demo:**
```bash
#!/bin/bash

service=raptor_latest@172.16.1.71

set -- $(getopt -q xp:h "$@")
branch=master
port=2334
while true; do
    case "$1" in
        -p)
            port="$2"
            shift 2
            ;;
        -h)
            echo "$0 -p port     : the default is 2334"
            exit 0
            ;;
        --)
            [ "$port" = "2334" ] && echo "port was not given, default is the 2334." || echo "port is "$port
            break
            ;;
        *)
            printf "ERROR: did not recognize option '%s', please try -h\\n" "$1"
            exit 1
            ;;
    esac
done

ssh $service "ps -ef | grep '/home/raptor_latest/raptor/py36-venv/bin/python manage.py runserver 0.0.0.0:$port' | grep -v 'grep' | awk '{print \$2}' | xargs -i kill {}"
```

## 选项标准化

常用的linux命令选项：
- -a # 显示所有对象
- -c # 生成一个计数
- -d # 指定一个目录
- -e # 扩展一个对象
- -f # 指定读入数据的文件
- -h # 显示命令的帮助信息
- -i # 忽略文本的大小写
- -l # 产生输出的长格式版本
- -n # 使用非交互式模式（批处理）
- -o # 将所有输出重定向到指定的输出文件
- -q # 以安静模式运行
- -r # 递归的处理目录和文件
- -s # 以安静模式运行
- -v # 生成详细输出
- -x # 排除某个对象
- -y # 对所有问题回答yes

## 获得用户输入

### 基本的读取

- read var # 从标准输入或者令一个文件描述符中接收输入，放入一个变量中
    - -p # 该选项指定提示符
    - 如果变量不够，剩下的数据就全分配给最后一个变量
    - 也可以不指定变量，数据会放入特殊的环境变量REPLY中
    - -t # -t指定一个计数器，read命令等待的秒数，计时器过期后，read命令会返回一个非0退出状态码，可结合if-then使用
    - -n3 # 统计输入的字符数达到预期的字符数（3）就自动退出，将输入数据给变量，不用回车结束，也可回车提前结束
    - -s # 隐藏方式读取（实际上数据会被显示只是read会将文本颜色设成跟背景色一致）如待用户输入密码时

### 从文件中读取

```
cat file | while read line;do
    echo $line
done
```
或者使用输入重定向，见下章第三节


# 呈现数据

## 输入与输出
两种显示脚本输出的方法：
- 在显示器屏幕上输出
- 将输出重定向到文件中

### 标准文件描述符

linux系统将每个对象当作文件处理，也包括输入输出过程。
linux用文件描述符（file descriptor）来标识每个文件对象，其是一个非负整数，可以唯一标识会话中打开的文件。
每个进程最多可以有九个文件描述符，处于特殊目的，bash保留了前三个文件描述符（0、1、2）：
- 0 # STDIN 标准输入
- 1 # STDOUT 标准输出
- 2 # STDERR 标准错误

#### STDIN
对于终端来说标准输入是键盘
- cat # 可接收标准输入
- cat < file # 可使用STDIN重定向符号强制cat命令接收另一个非STDIN文件的输入

#### STDOUT
对于终端来说标准输出是终端显示器，shell所有输出都会定向到标准输出中。
可以用输出重定向来改变，也可以使用数据追加。

#### STDERR
shell对于错误消息的处理和普通输出是分开的，通过STDERR文件描述符来处理错误消息。
**默认情况下，STDERR文件描述符和STDOUT文件描述符会指向相同的地方，但不会随着STDOUT的重定向发生改变。**

### 重定向错误

将文件描述符紧紧放在重定向符号前即可：`ls ./ ./wrongdir 1> stdout 2> stderr`。
也可以放在一个文件中（bash赋予错误信息更高的优先级）：`ls ./ ./wrongdir &> stdboth`。

## 脚本中重定向输出

- 临时重定向行输出
- 永久重定向脚本中的所有命令

### 临时重定向

在脚本中生成错误信息`echo "error message" >&2`

### 永久重定向

如果脚本中有大量数据需要重定向，可以用exec命令告诉shell在脚本执行期间重定向某个特定文件描述符

`exec 1 > file`会启动一个新shell并将STDOUT文件描述符重定向到文件，之后脚本中所有发给STDOUT的所有输出都被重定向到该文件
`exec 1 >> file`会启动一个新shell并将STDOUT文件描述符重定向到文件，之后脚本中所有发给STDOUT的所有输出都被追加到该文件

## 输入重定向

`exec 0 < file`可用于读文件：
```
exec 0 < file
while read line;do
    echo $line
done
```

## 创建自己重定向

可自由使用3~8的文件描述符，使用方法同上

### 创建输出文件描述符
```
exec 3 > file
echo user define message >&3
```
```
exec 3 >> file
echo user define message >&3
```

### 重定向文件描述符

用于恢复文件描述符，当作指针理解

```
exec 3>&1 # 备份之前的文件描述符
exec 1>fileout # 输出重定向

echo output in file
echo ditto

exec 1>&3 # 恢复文件描述符
echo back to normal
```

### 创建输入文件描述符

```
exec 6<&0
exec 0<testfile
count=1
while read line;do
    echo "line : $line"
done
exec 0<&6
```

### 创建读写文件描述符

任何读写都是从文件指针上次的位置开始，要足够小心才能避免出错
```
exec 3<>testfile
read line <&3
echo "line:$line"
echo "test line" >&3
```
若testfile中有：
first line
second line
thrid line
执行之后会变成
first line
test line
e
thrid line

### 关闭文件描述符

`exec 3>&-` # 关闭之后将不能在脚本中再次使用

## 列出打开的文件描述符

- lsof # 显示当前linux系统上打开的每个文件的有关信息，包括后台运行的所有进程以及登录到系统的任何用户。
    - 所以会向非系统管理员用户提供linux系统的信息，故，许多linux系统隐藏了该命令，这时需要全路径来引用`/usr/sbin/lsof`
    - lsof -a -p $$ -d 0,1,2
        - -a # 表示对其他两个选项的结果执行布尔and运算
        - $$ # 显示当前进程的pid
        - -p # 指定进程pid
        - d # 指定要显示的文件描述符编号

lsof的默认输出：
- COMMAND # 正在运行的命令名的前9个字符
- PID # 进程pid
- USER # 进程属主的登录名
- FD # 文件描述符号以及访问类型
    - r # 读
    - w # 写
    - u # 读写
- TYPE # 文件的类型
    - CHR # 字符型
    - BLK # 块型
    - DIR # 目录
    - REG # 常规文件
- DEVICE # 设备的设备号，主设备号和从设备号
- SIZE # 如果有的话，表示文件的大小
- NODE # 本地文件的节点号
- NAME # 文件名

## 阻止命令输出

将内容重定向到叫null的特殊文件，标准位置为`/dev/null`，重定向到此位置的任何数据都会被丢掉

常用于清除日志文件：`cat /dev/null > logfile`

## 创建临时文件

/tmp目录来存放不需要永久保留的文件，大多数linux系统启动时自动删除tmp目录的所有文件，任何用户都有权限使用
- mktemp # 可以在/tmp目录中创建一个唯一的临时文件，且不用默认的umask值，会将文件的读写权限分配给文件属主，并设置为文件的属主，但其他人没法访问他

### 创建本地临时文件

- mktemp name.XXXXXX # 在本地目录创建一个临时文件，模板名后加六个XXXXXX
    - -t # 强制mktemp命令在系统的临时目录来创建该文件，此时会返回全路径
    - -d # 创建临时目录

## 记录消息

将输出同时发送到显示器和日志文件

- tee # 相当于管道的T形接口，指定STDOUT之外的文件名：`date | tee filename`
    - -a # tee使用时默认覆盖输出文件内容，使用-a追加文件

## 实例

```
outfile=my.sql
IFS=','
while read pname lname fname address city state zip;do
    cat >> $file << EOF
    INSERT INTO members (pname,lname,fname,address,city,state,zip) VALUES
('$pname','$lname','$fname','$address','$city','$state','$zip')
EOF
done < $1
```
上述脚本读取csv文件，创建INSERT语句将数据插入数据库
cat将标准输入数据标准输出，追加到文件，配合<<输入重定向使用

# 控制脚本

## 处理信号
linux利用信号进行通讯，从而控制脚本操作

### 复习linux进程信号
- 信号 名称 描述
- 1 SIGHUP 挂起
- 2 SIGINT 中断
- 3 SIGQUIT 结束运行
- 9 SIGKILL 无条件终止
- 11 SIGSEGV 段错误
- 15 SIGTERM 尽可能终止
- 17 SIGSTOP 无条件停止运行，但不终止
- 18 SIGTSTP 停止或者暂停，但继续在后台运行
- 19 SIGCONT 在STOP或TSTP之后恢复执行

默认情况下bash会忽略收到的3、15，支持交互式shell，会处理1,2信号
- bash收到了1信号，比如要离开一个交互式shell，它就会退出
    - 退出前，将1信号传给所有的由该shell启动的进程，包括正在运行的shell
- bash收到2信号，可以中断shell，linux内核会停止为shell分配cpu处理时间
    - 这种情况发生时，会将2信号传给所有由它启动的进程

shell会将信号传给shell脚本程序处理，而默认行为是忽略这些信号，而不利于脚本的运行，需要加入识别信号的代码，并执行命令来处理信号

### 生成信号

#### 中断进程

- ctrl+c 生成中断信号

#### 暂停进程

- ctrl+z 生成18信号

### 捕获信号

- trap "echo test" SIGINT
- trap 'echo 欢迎下次再来' EXIT

### 修改或者移除捕获

- 修改捕获只需要在原有的代码之后重写即可，重写之前修改无效，重写后修改生效
- trap -- EXIT # 删除之前的`trap 'echo something' EXIT`，单破折号也行

## 以后台模式运行脚本

### 后台运行脚本

在脚本后加&即可，但仍会使用终端显示器来显示STDOUT和STDERR

**终端会话退出，后台进程也退出，如果想后台程序在登出控制台后继续运行，请看下集**

## 在非控制台下运行脚本

- nohup command & # nohup命令运行了另一个命令来阻断所有发送给该进程的SIGHUP信号，会在退出终端时阻止进程退出
    - nohup会解除终端和进程的关联，终端stdout和stderr也不再和进程联系在一起为了保存该命令的输出，重定向到一个nohup.out中

## 作业控制

重启发送SIGCONT信号

启动，停止，终止以及恢复作业统称为作业控制

### 查看作业

- jobs # 查看shell当前正在处理的作业
    - jobs -l # 查看pid以及作业号
    - jobs -n # 只列出上次shell发出通知后改变了的作业
    - jobs -p # 只列出作业的pid
    - jobs -r # 只列出运行中的作业
    - jobs -s # 只列出已停止的作业

jobs中的加号与减号：
- 带加号的会被当做默认作业，在使用作业控制命令时，如果未在命令行中指定任何作业号，该作业就是操作对象
- 带减号的成为下一个默认作业
- 不管有多少在运行的作业，任何时候都只有一个带加号和一个带减号的作业

### 重启停止的作业号

- bg n # n是作业号，方括号内的数字

## 调整谦让度

内核负责将cpu时间分配给系统上运行的每个进程。调度优先级是内核分配给进程的cpu时间（相对于其他进程）。在linux中由shell启动的所有进程的调度优先级默认都是相同的

调度优先级是个整数值，从-20（最高优先级）到+19（最低优先级），bash默认情况下以优先级0来启动所有进程 # 便于记忆：好人难做哈哈

### nice命令

- nice -n 10 ./bash.sh > bash.out & # -n指定命令使用更低的优先级，使用10优先级
    - -n 若使用其用于提高命令的优先级，命令作业运行了，但提高优先级的操作失败了
    - -n 可省略，示例修改之后的结果：`nice -10 ./bash.sh > bash.out &`

### renice命令

- renice -n 10 -p pid # 可以改变已运行命令的优先级
    - 只能对属于你的进程执行renice
    - 只能通过renice降低进程的优先级
    - root用户可以通过renice来任意调整进程的优先级

## 定时运行作业

linux提供了多个在预选时间运行脚本的方法：at命令和cron表

### at命令来计划执行作业

at命令允许指定linux系统何时运行脚本。at命令会将作业提交到队列中，指定shell何时运行该作业。at的守护进程atd会以后台模式运行，检查作业队列来运行作业。大多数linux在启动时运行此守护进程。

atd守护进程会检查系统上的一个特殊目录（通常/var/spool/at）来获取at命令提交的作业。默认atd会每60秒检查一下这个目录。有作业时atd守护进程会检查作业设置运行的时间，如果时间跟当前时间匹配，atd守护进程就会运行此作业。

#### at命令格式

- at [ -f filename ] time
    - -f # 默认情况下at会将stdin的输入放入队列中，可以用f参数指定用于读取命令脚本文件
    - time # 指定了linux系统何时运行该作业。能识别多种不同的时间格式
        - 标准的小时分钟格式：11:11
        - AM/PM指示符：11:11 PM
        - 特定可命名时间，such as：now，noon，midnight，teatime（4 PM）
        - 标准日期格式：MMDDYY，MM/DD/YY，DD.MM.YY
        - 文本日期：Jul 4,Dec 5
        - 指定时间增量
            - 当前时间+25min
            - 明天10:15 PM
            - 10:15+7天

- 针对不同的优先级，存在26种不同的作业队列，作业队列通常用字母代指。
- 作业队列的字母排序越高，作业优先级越低（更高的nice值）。
- 默认情况下at的作业会提交到a作业队列，如果想以更高的优先级运行作业，可以使用-q参数指定不同的队列字母

#### 获取作业的输出

- 作业在linux上运行时，linux系统会将提交该作业的用户的电子邮件地址作为stdout和stderr。任何输出都会通过邮件系统发送给该用户。
- at命令利用sendmail应用程序来发邮件，如果没有安装sendmail将不会有任何输出可以获得，在使用at时，最好在脚本中对stderr和stdout重定向。
- 如果不想使用邮件或者重定向，最好加上-M选项屏蔽作业产生的输出信息

#### 列出等待的作业

- atq # 可以查看系统中有哪些作业在等待，显示作业号，系统运行作业日期时间以及所在作业队列

#### 删除作业

- atrm n # n为作业号，只能删除自己提交的

### 安排需要定期指定的脚本

#### cron时间表

格式如下：

min hour dayofmonth month dayofweek command

每个月最后一天执行:
```bash
00 12 * * * if [`date +%d -d tomorrow` = 01 ]; then ; command
```

- 列出已有的时间表
    - `crontab -l`
- 浏览cron目录
    - `ls /etc/cron.*ly`
    - 如果脚本需要每天运行一次，将脚本复制到daily目录即可
        - 注意，脚本是使用run-parts命令执行的，run-parts会查找文件夹下所有可执行文件，并执行
        - 所以脚本权限必须是可执行的，还有一点需要注意的是不能以`.sh`为后缀，否则也不执行
        - `run-parts --test /etc/cron.daily`可用于测试，测试结果貌似有点问题
- anacron程序
    - cron程序的唯一问题是它假定Linux系统是7×24小时运行的。除非将Linux当成服务器环境来运行，否则假设未必成立
    - 即该运行的时候，处于关机状态，作业将不会再执行。再开机也不会再运行。
    - anacron在错过作业后会尽快运行该作业
    - 一般用于常规日志维护的脚本。
    - anacron只会处理cron目录的程序
    - 用时间戳来决定作业是否在正确的计划间隔内运行了。时间戳文件位于`/var/spool/anacron`
    - anacron程序使用自己的时间表来检查作业目录:`cat /etc/anacrontab`
    - anacron时间表格式: period delay identifier command
        - period 定义多久运行一次，以天为单位
        - delay 系统启动后需要等待多久后再开始运行错过的脚本
        - command 包含了run-parts程序和一个cron脚本目录名
            - run-parts程序负责运行目录中传给它的任何脚本
        - identifier 是一种特别的非空字符串，如 `cron-weekly` 用于唯一标示日志消息和错误邮件中的作业
    - **anacron不会运行位于/etc/cron.hourly的脚本，因为anacron程序不会处理执行时间需求小于一天的脚本**



# 创建函数

## 基本的脚本函数

### 创建函数


使用关键字`function`创建函数：

```bash
function name {
    commands
}
```

或者空括号声明函数：

```bash
name() {
    commands
}
```


### 使用函数

- 使用函数名调用函数
- 要在使用前定义函数
- 函数名必须唯一，否则会被新定义的函数覆盖，而不会有任何错误消息提示

## 返回值

bash shell 会把函数当做一个小型脚本，运行结束时会返回一个退出状态码，有三种不同的方法来生成函数退出状态码。

### 默认退出状态码

默认情况下，函数的退出状态码是函数最后一条命令返回的退出状态码。可以使用`$?`来确定函数的退出状态码。

### 使用return命令

return 命令注意事项
- 函数一结束就要取出返回值，否则会被其他命令的返回值覆盖
- 退出状态码必须在0~255之间，否则都会产生一个错误值。

### 使用函数输出

`echo`命令输出结果，使用`$()`取值

`read`命令的提示信息不会作为STDOUT输出的一部分内容，会忽略其中内容

## 在函数中使用变量

函数使用特殊环境变量作为自己的参数值，所以例如如下内容可在函数中使用：`$#` 参数个数 ,`$1`, ...

### 在函数中处理变量

#### 全局变量

默认情况下，在脚本中定义的任何变量都是全局变量。

#### 局部变量

函数内部在声明变量前面加上`local`关键字就可以声明成局部变量，不会影响全局变量中同名内容。

## 数组变量和函数

第六章中讲过数组变量，觉得使用起来会有点麻烦，并没有使用过。

但是直接将数组作为参数传给函数会有问题，函数只会读取第一个值

### 向函数传递数组参数

必须将数组变量的值分解成单个的值，再传参。

### 从函数返回数组

函数使用`echo`语句按顺序输出单个数组值，然后脚本再将他们重新放进一个新的数组变量中。

## 函数递归

函数支持递归调用

## 创建库

与环境变量一样，shell函数仅在定义它的shell会话内有效。

函数库的关键在于`source`命令，该命令会在当前shell上下文中执行命令，而不是创建一个新的shell。

`source`命令有一个快捷的别名，称作`点操作符`：`. ./file`

## 在命令行上使用函数

### 在命令行上创建函数

如果你给函数起了一个与内建命令或另一个命令相同的名字，函数将会覆盖原来的命令。

### 在.bashrc中定义函数

#### 直接定义函数

直接在文件中追加函数即可

#### 读取函数文件

使用`source`命令或者点操作符将库文件中的函数添加到你的`.bashrc`脚本中


# 图形化桌面环境中的脚本编程

## 创建文本菜单

### 创建菜单布局

`clear`命令用当前终端会话的terminfo数据来清理出现在屏幕上的文本。

`echo -e "1.\tcontent"`             -e 选项打印非可打印字符
`echo -en "\t\tenter option:"`      -n 选项去除回车
`read -n 1 option`                  -n 限制只读取一个字符

### 创建菜单函数

shell菜单选项作为一组独立的函数实现起来更为容易，能够创建出简洁，准确，容易理解的case命令。

通常我们会为还没有实现的函数先创建一个桩函数。桩函数是一个空函数，或者只有一个`echo`语句，说明最终这里需要什么内容。demo:

```bash
function diskspace {
    clear
    echo "This is what it is"
}

function menu {
    clear
    echo -e "\t\t\tTest Menu\n"
    echo -e "\t1. xxxxxxx"
    echo -e "\t2. xxxxxxx"
    echo -e "\t3. xxxxxxx"
    echo -e "\t4. xxxxxxx"
    echo -en "\t\tEnter option: "
    read -n 1 option
}
```

### 添加菜单逻辑

典型菜单中`case`的用法：

```bash
menu
case $option in
0)
    break ;;
1)
    diskspace ;;
2)
    whoseon ;;
3)
    memusage ;;
*)
    clear
    echo "Sorry wrong selection" ;;
esac
```

### 整合shell脚本菜单

你可能发现，大部分代码在用于建立菜单布局和获取用户输入了

可以使用`select`命令创建，然后获取输入的答案并自动处理

```bash
select option in "content1" "content2" "conten3"
do
    case $option in
    "content1")
        break ;;
    "content2")
        commands ;;
    "content3")
        commands ;;
    *)
        clear
        echo "Sorry, wrong option." ;;
    esac
done
```

# 图形化脚本编程

P376~P400

## 制作窗口

# sed&gawk

## 文本处理

### sed编辑器

流编辑器，会在编辑器处理数据之前基于预先提供的一组规则来编辑数据流。

- 一次从输入中读取一行数据
- 根据所提供的编辑器命令匹配数据
- 按照命令修改流中的数据
- 将新的数据输出到STDOUT

sed命令格式：`sed options script file`

- `-e script`在处理输入时，将script中指定的命令添加到已有的命令中
- `-f file`在处理输入时，将file中指定的命令添加到已有的命令中
- `-n`不产生命令输出，使用print命令来完成输出

#### 在命令行定义编辑器命令

`echo "test sed for demo" | sed "s/test/Test/"` 该sed编辑器使用了s命令

#### 在命令行使用多个编辑器命令

可以使用`-e`执行多个命令:`echo "test sdfl sdf " | sed -e "s/s/st/g; s/test/AAAA/"` 或者`echo "test sdfl sdf " | sed -e "s/s/st/g" -e "s/test/AAAA/"` 命令有先后顺序

#### 从文件中读取编辑器命令

可以使用`-f`指定命令文件:`sed -f script.sed data.txt`

### gawk程序

gawk是awk程序的GUN版本。

- 定义变量来保存数据
- 使用算术和字符串操作符来处理数据
- 使用结构化编程概念来为数据处理增加处理逻辑
- 通过提取数据文件中的数据元素，将其重新排列或格式化，生成格式化报告

gawk命令格式：`gawk potions program file`

- `-F` 指定行中划分数据字段的字段分隔符
- `-f` 从指定的文件中读取程序
- `-v` 定义gawk程序中的一个变量及其默认值
- `-mf` 指定要处理的数据文件中的最大字段数
- `-mr` 指定数据文件中的最大数据行数
- `-W` 指定gawk的兼容模式或警告等级

#### 从命令行中读取程序脚本

gawk使用花括号定义程序脚本：`gawk '{print "Hello World."}'`

#### 使用数据字段变量

gawk的主要特性之一就是其处理文本文件中数据的能力。它会自动给一行中的每个数据元素分配一个变量。

- `$0` 代表整个文本行
- `$n` 代表文本行中的第n个数据字段

默认的字段分隔符是任意的空白字符（空格或者制表符）

#### 在程序脚本中使用多个命令

在命令之间添加分号即可

#### 从文件中读取程序

使用`-f`选项即可，程序文件一行为一个命令，不需要分号。

#### 在处理数据前运行脚本

gawk在读取数据前执行`BEGIN`关键字后指定的程序脚本，然后用第二段脚本处理文本数据：`echo "content content" | gawk 'BEGIN {print "title"} {print $0} '`

#### 在处理数据后运行脚本

相应的有`END`关键字指定的程序脚本在处理本文数据结束后执行：`echo -e "test test\ncontent content" | gawk 'BEGIN {print "title"} END {print $1} {print $0}'`

## sed编辑器基础

### 更多的替换选项

#### 替换标记

`s/pattern/replacement/flags`

- 数字，表明新文本将替换第几处模式匹配的地方
- g，表明新文本将会替换所有匹配的文本
- p，表明原先行的内容要打印出来
    - 通常会与`sed`的`-n`选项一起使用
        - `-n`选项将禁止sed编辑器输出，但p替换标记会输出修改过的行。配合使用的效果就是只输出被替换命令修改过的行。
        - `echo -e "test line\nanother test line" | sed -n 's/another/this is another/p'`
- w file，将替换的结果写到文件中

可同时使用多个标记

#### 替换字符

有时候字符中可能包含`/`符号，这时需要转义符，这样会影响可读性。此时可以使用别的符号作为字符串分隔符：`echo "te/st" | sed 's!/!//!g'`。而不用使用复杂的：`echo "te/st" | sed 's/\//\/\//g'`

### 使用地址

如果想将命令作用于特定行或某些行，则必须使用行寻址。

格式：`[address]command`或者将特定地址的多个命令分组：`address { command1 command2 command3}`

- 以数字形式表示行区间
- 用文本模式来过滤出行

#### 数字方式的行寻址

```bash
sed '2s/dog/cat/g' data.txt  # 作用于第二行
sed '2,3s/dog/cat/g' data.txt  # 作用于第二行到第三行
sed '2,$s/dog/cat/g' data.txt  # 作用于第二行到之后的所有行
```

#### 使用文本模式过滤器

格式：`/pattern/command`

允许使用正则表达式，demo:`sed -n '/roo./s/bash/csh/p' /etc/passwd`，for compare:`cat /etc/passwd | grep "roo."`

#### 命令组合

使用`address { command1 command2 command3}`格式即可

经测试该格式下貌似只能使用数字方式寻址：`sed -n '1{s/bash/csh/p;s/bin/test/p}' /etc/passwd`


### 删除行

sed 'd' file.suffix
sed d file.suffix

#### 行寻址删除
sed '4d' file
sed '2,4d' file
sed '3,$d' file

#### 模式匹配删除
sed '/pattern 1/d' file

sed ‘/pattern1/,/pattern2/d' file #从模式1所在行删除至模式2所在行，多次，若模式2不存在，删除到底

**源文件不会变**

### 插入和附加文本

insert:i # 前插
append:a # 后加

$sed '3i\
insert line1\
insert line2' file

### 修改行

change:c # 将某行内容修改为指定内容（可为多行）

若行寻址为范围，则将范围内所有行修改为指定内容
$sed '3,5c\
changed line' file

$sed ‘3c\
changed line1\
changed line2' file

支持匹配修改行
$sed '/pattern/c\
changed line' file


### 转换命令

transform:y # 字符映射

sed 'y/123/456' file


### 打印

p:打印文本行
=:打印行号
l:列出行

-n:禁止输出其他行

sed -n '/pattern/p' file
sed -n '2,10p' file

$sed -n '/3/{
p
s/line/test/p
}' file
# 查找带3的行先打印，再打印替换内容


$sed -n '/pattern/{
=
p
}' file
# 查找内容，打印行号和内容

l:打印数据流中的文本和不可打印的ASCII字符，制表符->‘\t' 换行符->'$', 控制铃声->'\a'等


### 处理文件

w

sed ‘1,4w test.txt' file # 可以配合-n不打印出来
sed '/pattern/w test.txt' file

r

sed '3r test.txt' file # 读file读到第三行时将test.txt读入
sed '/pattern/r test.txt' file
sed '$r test.txt' file # 在数据流末尾读入

$sed '/List/{
r input.txt
d
}' file

# 将file中占位符List处读入文件input，再删除，实现字符到文件的替换
