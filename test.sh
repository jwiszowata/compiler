for file in ./lattests/good/core0*.lat
do
  resf="${file%.*}.res"
  outf="${file%.*}.output"
  exef="${file%.*}"
  ./latc_x86 $file
  ./$exef > $resf
  diff -s $resf $outf
done

echo "********************************************************************"

for file in ./lattests/bad/bad0*.lat
do
  resf="${file%.*}.res"
  outf="${file%.*}.output"
  exef="${file%.*}"
  ./latc_x86 $file
  diff -s $resf $outf
done
