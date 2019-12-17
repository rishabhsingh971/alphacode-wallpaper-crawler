download() {
    # check if file already exists
    if [ -f "$2" ]; then
        echo "\n\n-------------- Skip '$1', '$2' already exists --------------'"
    else
        echo "\n\n-------------- Fetch '$1' and save at '$2' --------------'"
    fi
}

# download directory path
download_dir_path='downloads'

# make download directory if not exists
mkdir -p "$download_dir_path"

# source html file path
src_file_path="$download_dir_path/src.html"

# download source html
download "https://wall.alphacoders.com/search.php?search=Dark+Knight" "$src_file_path"

# extract image urls from html and save them in a file
cat "$src_file_path" | sed -rn 's/.*(https:\/\/images[0-9]+\.alphacoders.com\/[0-9]+\/)thumb-[0-9]+-([0-9]+.jpg).*/\1\2/p' >input

# split extracted urls using newline as delimitor
IFS=$'\n'
set -f
urls=($(<input))

# download each url
for url in "${urls[@]}"; do
    file_path="$download_dir_path/${url##*/}"
    download $url "$file_path"
done
