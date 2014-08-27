cd ..
for line in  $(cat ./buildscript/sourceid.dat)
do
twopara=`echo $line | cut -d ':'  -f 2  `;
onepara=`echo $line | cut -d ':' -f 1`;
echo "twopara=$twopara"
echo oneparaa = $onepara
done
