#!/bin/sh

echo "Parameter is $1"

set -e
trace=~/tracing

if [ ! -d "/tracing" ]; then
        echo "start mount"
        mkdir -p /tracing
        mount -t tracefs nodev /tracing
        echo "finish mount"
fi

# clean trace
echo 0 > $trace/tracing_on
echo > $trace/trace

cd $trace

if [ "$1" = "1" ]; then
#---------------------------------------------test 1 module load
# set load module and trace on
    echo "test 1 module load"
    set tracer
    echo function_graph > $trace/current_tracer
    cat $trace/current_tracer
    echo > trace
    echo 'load_module:traceon' > set_ftrace_filter
    echo ':mod:module3' >> set_ftrace_filter 
    cat set_ftrace_filter 
    modprobe module3
    echo 0 > tracing_on
    cat trace
    modprobe -r module3
#---------------------------------------------end of test 1
fi

if [ "$1" = "2" ]; then
#---------------------------------------------test 2 all function
# set load module and trace on
    echo "test 2 all function"
    echo > trace
    sysctl kernel.ftrace_enabled=1  #启用ftrace 
    echo 1 > tracing_on
    usleep 1
    echo 0 > tracing_on
    cat trace
#---------------------------------------------end of test 2
fi

if [ "$1" = "3" ]; then
#---------------------------------------------test 3 irq off
    echo "test 3 irq off"
    echo > trace
    # trace all function or not
    echo 1 > options/function-trace
    echo irqsoff > current_tracer
    echo 1 > tracing_on	
    echo 0 > tracing_max_latency
    echo 0 > tracing_on
    cat trace
#---------------------------------------------end of test 3
fi

if [ "$1" -gt 3 ]; then
    echo "out of boundary"
fi

#chmod +x ftrace*


