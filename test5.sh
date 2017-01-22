make
for file in ./moje/test*.lat
do
	filename=$(basename "$file")
	outfile="./moje/${filename%.*}.out"
	binfile="./moje/${filename%.*}"
	resfile="./moje/${filename%.*}.res"
	./latc_x86 "${file}"
	"${binfile}" > "${resfile}"
	diff -qs "${outfile}" "${resfile}"
done