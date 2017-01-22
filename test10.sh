make
for file in ./mrjp-tests/good/arrays/*.lat
do
    filename=$(basename "$file")
    outfile="./mrjp-tests/good/arrays/${filename%.*}.output"
    binfile="./mrjp-tests/good/arrays/${filename%.*}"
    resfile="./mrjp-tests/good/arrays/${filename%.*}.res"
    ./latc_x86 "${file}"
    "${binfile}" > "${resfile}"
    diff -qs "${outfile}" "${resfile}"
done