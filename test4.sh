make
for file in ./mrjp-tests/bad/semantic/*.lat
do
	filename=$(basename "$file")
	./latc_x86 "${file}"
done