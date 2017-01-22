make
for file in ./lattests/extensions/struct/*.lat
do
	filename=$(basename "$file")
	outfile="./lattests/extensions/struct/${filename%.*}.output"
	binfile="./lattests/extensions/struct/${filename%.*}"
	resfile="./lattests/extensions/struct/${filename%.*}.res"
	./latc_x86 "${file}"
	"${binfile}" > "${resfile}"
	diff -qs "${outfile}" "${resfile}"
done