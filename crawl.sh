#!/bin/bash
# check arguments
if [ -z "$1" ]; then
    echo "Please provide search string"
    return 1
fi

# search string
search_string=$1

# download directory path
download_dir_path='downloads'

# make download directory if not exists
mkdir -p "$download_dir_path"

download_page() {
    # page number
    page_number=$1
    # page url
    page_url="https://wall.alphacoders.com/search.php?search=$search_string&page=$page_number"
    # page html file path
    src_file_path="$download_dir_path/$search_string.$page_number.html"
    # download page html
    echo
    echo "============ Fetch page-$page_number from '$page_url' and save at '$src_file_path' ============'"
    curl "$page_url" -o "$src_file_path"
    # extract urls from src html file
    urls=$(cat "$src_file_path" | sed -rn 's/.*<img.*data-src="(.*\/)thumb-[0-9]+-([0-9]+.jpg)".*/\1\2/p')

    # download each url
    for url in $urls; do
        file_path="$download_dir_path/${url##*/}"
        # download image file with resume support
        echo
        echo "---------- Download image of page $page_number from '$url' and save at '$file_path' ----------'"
        curl -L -C - "$url" -o "$file_path"
    done
}

start_page_number=1
src_file_path=''
download_page "$start_page_number"
last_page_number=$(cat "$src_file_path" | sed -rn 's/.*<a title="Last Page \(([0-9]+)\).*/\1/p')

for ((i = $start_page_number + 1; i < $last_page_number; ++i)); do
    download_page "$i"
done
