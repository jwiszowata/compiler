make
for file in ./mrjp-tests/gr5/*.lat
do
    filename=$(basename "$file")
    outfile="./mrjp-tests/gr5/${filename%.*}.out"
    binfile="./mrjp-tests/gr5/${filename%.*}"
    resfile="./mrjp-tests/gr5/${filename%.*}.res"
    ./latc_x86 "${file}"
    "${binfile}" > "${resfile}"
    diff -qs "${outfile}" "${resfile}"
done