make
for file in ./lattests/extensions/arrays1/array00*.lat
do
	filename=$(basename "$file")
	outfile="./lattests/extensions/arrays1/${filename%.*}.output"
	binfile="./lattests/extensions/arrays1/${filename%.*}"
	resfile="./lattests/extensions/arrays1/${filename%.*}.res"
	./latc_x86 "${file}"
	"${binfile}" > "${resfile}"
	diff -qs "${outfile}" "${resfile}"
done