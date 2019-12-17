src_file_path='src.html'
if [ -f "$src_file_path" ]; then
    echo "$src_file_path exists"
else
    echo "Fetch $src_file_path"
    curl "https://wall.alphacoders.com/search.php?search=Dark+Knight" -o "$src_file_path"
fi
cat "$src_file_path" | sed -rn 's/.*(https:\/\/images[0-9]+\.alphacoders.com\/[0-9]+\/)thumb-[0-9]+-([0-9]+.jpg).*/\1\2/p' >input
IFS=$'\n'
set -f
foo=($(<input))
mkdir -p downloads
cd downloads
for url in "${foo[@]}"; do
    curl -O $url
done
cd -
