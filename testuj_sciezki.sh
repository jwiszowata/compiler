#!/bin/bash

ARCHIWUM=latte.tgz

echo "W bieżącym katalogu powinien być ten plik (skrypt) i archiwum ${ARCHIWUM}"
pwd
ls -l

if [ ! -e ${ARCHIWUM} ]; then 
    echo "Brak pliku ${ARCHIWUM} w bieżącym katalogu."
    exit 1
fi

echo " "
echo "Przygotowanie świeżego katalogu"
TEMP=$(mktemp -d Swiezy.XXXXX)
cd $TEMP

echo " "
echo "Przygotowanie udawanego katalogu z testami"
TESTY="Testy Różne"
mkdir "${TESTY}"
TESTBASE="plik testowy"

zrob_test()
{
    cat > "$1/$2.lat" <<EOF
// declaration and initialization in same statement

int main() {
 int x = 7;
 printInt(x);
 return 0 ;

}
EOF

    cat > "$1/$2.output" <<EOF
7
EOF
}

zrob_test "${TESTY}" "${TESTBASE}1"
zrob_test "${TESTY}" "${TESTBASE}2"

(cd "$TESTY"; pwd; ls -l)
echo "Zrobione."


echo " "
echo "Przygotowanie udawanego katalogu studenta"
KATALOG="Imię Nazwisko"
mkdir -v "${KATALOG}"
cp "../${ARCHIWUM}" "${KATALOG}/"
cd "${KATALOG}"
pwd
ls -l
echo "Zrobione."

echo " "
echo "+ Odpakowywanie..."

echo "tar xzvf \"${ARCHIWUM}\""
tar xzvf ${ARCHIWUM} 
echo " "
echo "+ Odpalanie make..."
make #I w rootcie ma mieć działający na students Makefile
echo " "
echo "+ Efekt make:"
pwd
ls -l
cd ..

jest()
{
    if [ -e "$1" ]; then
	echo "Jest plik '$1'! Hurra!"
    else
	echo "Brak pliku '$1' :( "
	exit 1
    fi
}

echo " "
echo "+ Szukamy odpalacza"

if [ -e "${KATALOG}/latc_llvm" ]; then
    ARCH=llvm
elif [ -e "${KATALOG}/latc_x86" ]; then
    ARCH=x86
elif [ -e "${KATALOG}/latc_x86_64" ]; then
    ARCH=x86_64
else
    echo "Nie ma żadnego odpalacza. Czy coś się w ogóle zbudowało?"
    exit 1
fi

echo "Jest odpalacz dla $ARCH !"
echo " "
echo "+ Odpalamy odpalacz!"

echo "  ... ścieżka względna ..."

odpal()
{
    echo "\"$1/latc_${ARCH}\" \"$2/$3.lat\""
    "$1/latc_${ARCH}" "$2/$3.lat"
}

odpal "${KATALOG}" "${TESTY}" "${TESTBASE}1"

sprawdz_pliki()
{
    [ "$3" ] && OPIS3="$3" || OPIS3="bez rozszerzenia"
    [ "$4" ] && OPIS4="$4" || OPIS3="bez rozszerzenia"
    echo "Powinniśmy mieć pliki ${OPIS3} i ${OPIS4}, sprawdzmy"
    ls -l "$1"
    jest "$1/$2$3"
    jest "$1/$2$4"
}

if [ $ARCH == llvm ]; then
    sprawdz_pliki "${TESTY}" "${TESTBASE}1" .ll .bc
else
    sprawdz_pliki "${TESTY}" "${TESTBASE}1" .s ""
fi

echo " "
echo "+ Odpalamy efekt kompilacji"

run_llvm()
{
    echo "lli \"$1/$2.bc\" > \"$1/$2.out\" "
    lli "$1/$2.bc" > "$1/$2.out"
}

run_x86()
{
    echo "\"$1/$2\" > \"$1/$2.out\" "
    "$1/$2" > "$1/$2.out"
}

run_x86_64()
{
    echo "\"$1/$2\" > \"$1/$2.out\" "
    "$1/$2" > "$1/$2.out"
}

run_${ARCH} "${TESTY}" "${TESTBASE}1"

(cd "${TESTY}"; pwd; ls -l)
echo " "
echo "+ Sprawdzamy wyniki"

sprawdz_wynik()
{
    echo "diff \"$1/$2.output\" \"$1/$2.out\""
    if diff "$1/$2.output" "$1/$2.out"; then
        echo "Hurra! Wyjście dla \"$2\" zgodne!"
    else
        echo "Coś nie tak :("
        exit 1
    fi
}

sprawdz_wynik "${TESTY}" "${TESTBASE}1"

absolute()
{
    i="$1"
    if [ -d "$i" ]; then #katalog
        FILENAME=`(cd "$i"; echo $PWD)`
    else #nie katalog
        DIRNAME=`dirname "$i"`
        DIRNAME=`(cd "$DIRNAME"; echo $PWD)`
        BASENAME=`basename "$i"`
        FILENAME=$DIRNAME/$BASENAME
    fi
    echo $FILENAME
}

echo "  ... ścieżka bezwzględna ... "

KATALOG="$(absolute "$KATALOG")"
TESTY="$(absolute "$TESTY")"

odpal "${KATALOG}" "${TESTY}" "${TESTBASE}2"

if [ $ARCH == llvm ]; then
    sprawdz_pliki "${TESTY}" "${TESTBASE}2" .ll .bc
else
    sprawdz_pliki "${TESTY}" "${TESTBASE}2" .s ""
fi

echo " "
echo "+ Odpalamy efekt kompilacji"

run_${ARCH} "${TESTY}" "${TESTBASE}2"

(cd "${TESTY}"; pwd; ls -l)
echo " "
echo "+ Sprawdzamy wyniki"

sprawdz_wynik "${TESTY}" "${TESTBASE}2"

echo " "
echo "Wszystko OK."
echo "Ale tak naprawdę będę sprawdzać wszystkie programy testowe z"
echo "http://www.mimuw.edu.pl/~ben/Zajecia/Mrj2015/Latte/lattests121017.tgz"
echo " "
echo "Teraz można posprzątać poprzez"
echo "  rm -rf $TEMP"
