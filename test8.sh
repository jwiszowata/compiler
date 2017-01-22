make
for file in ./my/struct/*.lat
do
    filename=$(basename "$file")
    outfile="./my/struct/${filename%.*}.output"
    binfile="./my/struct/${filename%.*}"
    resfile="./my/struct/${filename%.*}.res"
    ./latc_x86 "${file}"
    "${binfile}" > "${resfile}"
    diff -qs "${outfile}" "${resfile}"
done