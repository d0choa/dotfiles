#Manage app store apps from the command line
brew install mas

#Apps to install through App Store (they can be searched using “mas search XXX” WARNING: Be careful not spending money on this step)

APPSTOREAPPS=('Ulysses' \
'Byword' \
'Slack' \
'Pocket' \
'Tweetbot' \
'Keynote' \
'Pages' \
'Numbers' \
'Marked' \
'Wunderlist' \
'StuffIt' \
'Scrivener')

for i in ${APPSTOREAPPS[*]}; do
	APPID="$(mas search $i | head -n 1 | cut -d' ' -f 1)"
	mas install ${APPID}
done
