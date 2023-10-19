#!/bin/sh

set -ex
tracing=~/tracing

if [ ! -d "/tracing" ]; then
        echo "start mount"
        mkdir -p /tracing
        mount -t tracefs nodev /tracing
        echo "finish mount"
fi

# clean trace
echo 0 > $trace/tracing_on
echo > $trace/trace
# set tracer
echo function_graph > $trace/current_tracer
cat $trace/current_tracer
#echo 'load_module:traceon' > $trace/set_ftrace_filter 
#echo load_module > $trace/set_ftrace_filter 

#-- test module load
cat $trace/set_ftrace_filter
# set load module and trace on
echo 'load_module:traceon' > $trace/set_ftrace_filter
echo ':mod:module3' >> $trace/set_ftrace_filter 
cat $trace/set_ftrace_filter 


#echo $$ >> $trace/set_ftrace_pid
#echo module1 > $trace/set_event
#echo load_module > sys/kernel/debug/tracing/set_graph_function 
#echo 1 > sys/kernel/debug/tracing/tracing_on
#modprobe module3
#echo my_function >> set_ftrace_filter
echo 0 > $trace/tracing_on
cat $trace/trace

