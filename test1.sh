make
for file in ./lattests/good/core*.lat
do
	filename=$(basename "$file")
	outfile="./lattests/good/${filename%.*}.output"
	binfile="./lattests/good/${filename%.*}"
	resfile="./lattests/good/${filename%.*}.res"
	./latc_x86 "${file}"
	"${binfile}" > "${resfile}"
	diff -qs "${outfile}" "${resfile}"
done