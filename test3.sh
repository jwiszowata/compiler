make
for file in ./mrjp-tests/good/basic/*.lat
do
	filename=$(basename "$file")
	outfile="./mrjp-tests/good/basic/${filename%.*}.output"
	binfile="./mrjp-tests/good/basic/${filename%.*}"
	resfile="./mrjp-tests/good/basic/${filename%.*}.res"
	./latc_x86 "${file}"
	"${binfile}" > "${resfile}"
	diff -qs "${outfile}" "${resfile}"
done