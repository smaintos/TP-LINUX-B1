#!/bin/bash
hostname="$(hostnamectl | grep  hostname | tail -1 | cut -d':' -f2)"
source /etc/os-release
kern="$(uname -r)"
ipa="$(ip a | grep 'inet ' | tail -1 | cut -d' ' -f6)"
ramu="$(free -h | grep Mem | tr -s ' '|cut -d' ' -f4)"
ramt="$(free -h -t | grep Total | tr -s ' '|cut -d' ' -f4)"
disk="$(df -h | grep root | tr -s ' ' | cut -d' ' -f3)"
port="$(sudo ss -ltnpu -4 | tr -s ' ' | cut -d ' ' -f5 | cut -d':' -f2 | tail -1)"
typ="$(sudo ss -ltnpu -4 | tr -s ' ' | cut -d' ' -f1 | tail -1)"
pro="$(sudo ss -ltnpu -4 | tr -s ' ' | cut -d' ' -f7 | tail -1 | cut -d'"' -f2)"

echo "Machine name : ${hostname}"
echo "OS ${PRETTY_NAME} and kernel version is ${kern}"
echo "IP : ${ipa}"
echo "RAM :${ramu} memory available on ${ramt} total memory"
echo "Disk : ${disk} space left"
echo "Top 5 processes by RAM usage :"
echo "$( ps -eo %mem=,cmd= --sort -%mem | head -n5)"
echo "Listening ports :"
echo " - ${port} ${typ} : ${pro}"

cat_filename='super_cat'
curl "https://cataas.com/cat" -o "${cat_filename}" -s

cat_file_output="$(file ${cat_filename})"

if [[ "${cat_file_output}" == *JPEG* ]] ; then
  cat_filetype='jpg'
elif [[ "${cat_file_output}" == *PNG* ]] ; then
  cat_filetype='png'
elif [[ "${cat_file_output}" == *GIF* ]] ; then
  cat_filetype='gif'
fi

mv "${cat_filename}" "${cat_filename}.${cat_filetype}"
echo "Here is your random cat : ./${cat_filename}.${cat_filetype}"
