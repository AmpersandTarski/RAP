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

    echo "Generating prototype backend from path: $entrypath"
    # Run ampersand compiler to generated new frontend and backend json model files (in generics folder)
    ampersand proto --no-frontend "$entrypath" --proto-dir=/var/www/backend --verbose

    echo "Generating prototype frontend from path: $entrypath"
    ampersand proto --frontend-version Angular --no-backend "$entrypath" --proto-dir=/var/www/frontend/src/app/generated --verbose

    echo "Angular build started (will take up some time)"
    npx ng build

    # Copy output from frontend build
    cp -r /var/www/frontend/dist/prototype-frontend/* /var/www/html
}

set_permissions() {
    echo "Setting permissions"

    chown -R www-data:www-data /var/www/data /var/www/generics
}

deploy(){
    unzip_content
    set_entry
    generate_prototype
    #set_permissions
}