#!/bin/bash
echo '############ Lock #############'
lockfile='lockfile'
if [ ! -f ${lockfile} ];then
  echo 'Create new lock file now......'
  echo "touch ${lockfile}"
  eval "touch ${lockfile}"
  echo $$ > ${lockfile}
else
  echo "Locked by other mission! Please check ${lockfile} and remove it!"
  echo -n 'Press any key to continue: '
  read -n 1
  exit 1;
fi

echo ''
echo '############ Prepare #############'
getSrcDir='c/'
if [ ! -d ${getSrcDir} ];then
  echo 'Old backup directory not exist. Continue.'
else
  echo 'Old backup directory exist! Remove it now!'
  echo "rm -rf ${getSrcDir} && rm *.tar.gz"
  eval "rm -rf ${getSrcDir} && rm *.tar.gz"
fi

echo ''
echo '############ Start #############'
echo '#Note: The file filelist.txt must use Unix(LF)'
gitSrcDir='/c/xxx/'
echo 'New Mission start now......'
while read -r line || [[ -n ${line} ]]
do
    getSrc="cp -ipr --parents ${gitSrcDir}${line} ./"
    echo ${getSrc}
    eval ${getSrc}
done < filelist.txt

if [ ! -d ${getSrcDir} ];then
  echo 'New backup directory not exist. Error occurred!'
else
  echo 'New backup directory exist. Compress it now......'
  archiveTime=$(date "+%Y%m%d%H%M%S")
  # tar cvzf mydata.tar.gz mydata/
  echo "tar cvzf ${archiveTime}.tar.gz ${getSrcDir}"
  eval "tar cvzf ${archiveTime}.tar.gz ${getSrcDir}"
fi

echo ''
echo '############ Unlock #############'
if [ -f ${lockfile} ];then
  echo 'Release new lock file now......'
  echo "rm ${lockfile}"
  eval "rm ${lockfile}"
fi

echo ''
echo '############ End #############'
echo -n 'Press any key to continue: '
read -n 1

exit 0;