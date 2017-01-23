make
for file in ./lattests/extensions/objects1/*.lat
do
    filename=$(basename "$file")
    outfile="./lattests/extensions/objects1/${filename%.*}.output"
    binfile="./lattests/extensions/objects1/${filename%.*}"
    resfile="./lattests/extensions/objects1/${filename%.*}.res"
    ./latc_x86 "${file}"
    "${binfile}" > "${resfile}"
    diff -qs "${outfile}" "${resfile}"
done