make
for file in ./my/array/*.lat
do
    filename=$(basename "$file")
    outfile="./my/array/${filename%.*}.output"
    binfile="./my/array/${filename%.*}"
    resfile="./my/array/${filename%.*}.res"
    ./latc_x86 "${file}"
    "${binfile}" > "${resfile}"
    diff -qs "${outfile}" "${resfile}"
done