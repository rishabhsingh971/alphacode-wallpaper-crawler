download() {
    echo
    echo
    echo "-------------- Fetch '$1' and save at '$2' --------------'"
    curl -L -C - "$1" -o "$2"
}

# download directory path
download_dir_path='downloads'

# make download directory if not exists
mkdir -p "$download_dir_path"

# source html file path
src_file_path="$download_dir_path/src.html"

# download source html
download "https://wall.alphacoders.com/search.php?search=Dark+Knight" "$src_file_path"

# set internal field separator as newline
IFS=$'\n'
set -f
# extract urls from src html file
urls=$(cat "$src_file_path" | sed -rn 's/.*(https:\/\/images[0-9]+\.alphacoders.com\/[0-9]+\/)thumb-[0-9]+-([0-9]+.jpg).*/\1\2/p')

# download each url
echo $urls | while read url; do
    file_path="$download_dir_path/${url##*/}"
    download "$url" "$file_path"
done
