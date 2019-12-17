# check arguments
if [ -z "$1" ]; then
    echo "Please provide search string"
    return 1
fi

# search string
search_string=$1

# function to download files using curl with resume support
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

current_page=1
page_url="https://wall.alphacoders.com/search.php?search=$search_string&page=$current_page"

# set internal field separator as newline
old_ifs="$IFS"
IFS=$'\n'

while [ ! -z "$page_url" ]; do
    # current page html file path
    src_file_path="$download_dir_path/$search_string.$current_page.html"
    # download current page html
    download "$page_url" "$src_file_path"
    # extract urls from src html file
    urls=$(cat "$src_file_path" | sed -rn 's/.*(https:\/\/images[0-9]+\.alphacoders.com\/[0-9]+\/)thumb-[0-9]+-([0-9]+.jpg).*/\1\2/p')

    # download each url
    echo $urls | while read url; do
        file_path="$download_dir_path/${url##*/}"
        download "$url" "$file_path"
    done
    current_page=$((current_page + 1))
    page_url=$(cat "$src_file_path" | sed -rn 's/.*link rel="next" href="(.*&)amp;(page=[0-9]+)".*/\1\2/p')
done

# reset internal field separator
IFS="$old_ifs"
