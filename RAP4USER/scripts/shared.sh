outzip="/out.zip"
outfolder="/out"

read_input(){
    echo "Reading input"

    echo "$1" | base64 -d > $outzip

    main="$2"
}

unzip_content(){
    echo "Unzipping zip: $outzip to folder: $outfolder"

    unzip $outzip -d $outfolder
}

set_entry(){
    echo "Decoding entry name"

    entry=$(echo -n $main | base64 -d)
}

generate_prototype() {
    entrypath="$outfolder/$entry"

    echo "Generating prototype from path: $entrypath"

    ampersand proto "$entrypath" --proto-dir=/var/www --verbose
}

set_permissions() {
    echo "Setting permissions"

    chown -R www-data:www-data /var/www/data /var/www/generics
}

deploy(){
    unzip_content
    set_entry
    generate_prototype
    set_permissions
}