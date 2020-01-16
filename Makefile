## 说明
##makefile version 0.01, 仅仅是为了更好的在命令行中编译c++用的, testpointer.cpp是测试用的,目前这个对于多文件不适用

.PHONY: all clean
cxx := g++
flag := -Wall 
target := test
objs := testpointer.cpp
all: $(target)
$(target): $(objs)
	$(cxx) $(flag) $^ -o $@
clean:
	-@rm -f $(target)
