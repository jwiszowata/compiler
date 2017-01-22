make
for file in ./lattests/bad/bad*.lat
do
	filename=$(basename "$file")
	./latc_x86 "${file}"
done