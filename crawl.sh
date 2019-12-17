curl "https://wall.alphacoders.com/search.php?search=Dark+Knight" -o 'src.html'
cat src.html | sed -rn 's/.*(https:\/\/images[0-9]+\.alphacoders.com\/[0-9]+\/)thumb-[0-9]+-([0-9]+.jpg).*/\1\2/p' >input
IFS=$'\n'
set -f
foo=($(<input))
mkdir -p downloads
cd downloads
for url in "${foo[@]}"; do
    curl -O $url
done
cd -
