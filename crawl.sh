# source html file path
src_file_path='src.html'

# check if source file exists or not
if [ -f "$src_file_path" ]; then
    echo "$src_file_path exists"
else
    echo "Fetch $src_file_path"
    curl "https://wall.alphacoders.com/search.php?search=Dark+Knight" -o "$src_file_path"
fi

# extract image urls from html and save them in a file
cat "$src_file_path" | sed -rn 's/.*(https:\/\/images[0-9]+\.alphacoders.com\/[0-9]+\/)thumb-[0-9]+-([0-9]+.jpg).*/\1\2/p' >input

# split extracted urls using newline as delimitor
IFS=$'\n'
set -f
urls=($(<input))

# download directory path
download_dir_path='downloads'

# make download directory if not exists
mkdir -p "$download_dir_path"

# download each url
for url in "${urls[@]}"; do
    file_path="$download_dir_path/${url##*/}"
    curl $url -o "$file_path"
done
