#!/bin/sh  
#clean项目  
distDir="/Users/user/Desktop/apps" 
releaseDir="/Users/user/Documents/SVN_DZ0530/DZ/build/Release-iphoneos" 
version="1_0_0" 

cd /Users/user/Documents/SVN_DZ0530/DZ/buildscript/
cd .. 
#回到工程目录
rm -rdf "$releaseDir"
mkdir "$releaseDir"
rm -rdf "$distDir" 
mkdir "$distDir"
pwd
targetName="DZ"
echo "*** clean target DZ ***"
xcodebuild clean -configuration "$targetName"
for line in $(cat ./buildscript/sourceid.txt)
#读取所有渠道号data.dat文件  
do 
ipafilename=`echo $line | cut -f 1 -d ':'` 
#渠道名  
sourceid=`echo $line | cut -f 2 -d ':'`  
#渠道号  
echo "sourceid=$sourceid" 
echo "sourceid=$sourceid" 
echo "ipafilename=$ipafilename" 
echo "$sourceid" > sourceid2.dat  
echo "sourceid.dat: " 
cat sourceid.dat  
rm -rdf "$releaseDir" 
ipapath="${distDir}/${ipafilename}_${version}_${sourceid}.ipa" 
echo "***开始build app文件***"
xcodebuild -target "$targetName"  -arch armv7 -configuration Distribution  -sdk iphoneos build
appfile="${releaseDir}/${targetName}.app" 
if [ $sourceid == "appstore" ]  
then 
cd $releaseDir  
zip -r "${targetName}_${ipafilename}_${version}.zip" "${targetName}.app" 
mv "${targetName}_${ipafilename}.zip" $distDir 2> /dev/null  
cd "$releaseDir"  
else 
echo "***开始打ipa渠道包****" 
/usr/bin/xcrun --sdk iphoneos PackageApplication -v "$appfile" -o "$ipapath"  
fi 
done 
echo $?

