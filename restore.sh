if [ -z $1 ]
then
  echo "Please define sourcefile ./restore.sh backupfile.tar"
  exit 1
fi

# extract specific files
tar xvf $1 homeassistant.tar.gz

tar zxvf homeassistant.tar.gz data/home-assistant_v2.db data/media data/www data/custom_components data/.storage

mv -f data/* ~/.homeassistant/

# cleanup
rm homeassistant.tar.gz
rm -rf data
# rm $1
