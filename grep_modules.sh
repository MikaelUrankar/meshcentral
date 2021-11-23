#!/bin/sh
required_modules=$(grep "var modules =" meshcentral.js)
for i in $(echo $required_modules | sed -e "s#var modules = \['##" -e "s#',##g" -e "s#'##g" -e "s#];##g")
do
	echo $i
done

modules=$(grep "modules.push('" meshcentral.js)
for i in $modules
do
	module=$(echo $i | grep modules.push | sed -e "s#modules.push('##" -e "s#');##g")
	if [ ! -z $module ]; then
		echo $module
	fi
done
