
for i in /Users/geoffburns/Documents/projects/cards/Vector-Playing-Cards-master/cards-svg/*.svg; do /Applications/Inkscape.app/Contents/Resources/bin/inkscape $i -w 167 -h  243 --export-png=`echo $i | sed -e 's/svg$/png/'`; done

for i in /Users/geoffburns/Documents/projects/cards/Vector-Playing-Cards-master/cards-svg/*.svg; do /Applications/Inkscape.app/Contents/Resources/bin/inkscape $i -w 334 -h  486 --export-png=`echo $i | sed -e 's/.svg$/@2x.png/'`; done


for i in /Users/geoffburns/Documents/projects/cards/Vector-Playing-Cards-master/button/*.svg; do /Applications/Inkscape.app/Contents/Resources/bin/inkscape $i -w 167 -h  167 --export-png=`echo $i | sed -e 's/svg$/png/'`; done

for i in /Users/geoffburns/Documents/projects/cards/Vector-Playing-Cards-master/button/*.svg; do /Applications/Inkscape.app/Contents/Resources/bin/inkscape $i -w 334 -h  334 --export-png=`echo $i | sed -e 's/.svg$/@x2.png/'`; done

/Applications/Inkscape.app/Contents/Resources/bin/inkscape /Users/geoffburns/Documents/projects/cards/Vector-Playing-Cards-master/cards-svg/rickety-kate/kate.svg -w 1024 -h  1024 -e /Users/geoffburns/Documents/projects/cards/Vector-Playing-Cards-master/cards-svg/rickety-kate/ituneicon.png

/Applications/Inkscape.app/Contents/Resources/bin/inkscape -w 20 -h  20 -e /Users/geoffburns/Documents/projects/cards/Vector-Playing-Cards-master/cards-svg/rickety-kate/Icon-20.png -f /Users/geoffburns/Documents/projects/cards/Vector-Playing-Cards-master/cards-svg/rickety-kate/kate.svg 


/Applications/Inkscape.app/Contents/Resources/bin/inkscape -w 40 -h  40 -e /Users/geoffburns/Documents/projects/cards/Vector-Playing-Cards-master/cards-svg/rickety-kate/Icon-20@2x.png -f /Users/geoffburns/Documents/projects/cards/Vector-Playing-Cards-master/cards-svg/rickety-kate/kate.svg 

/Applications/Inkscape.app/Contents/Resources/bin/inkscape -w 60 -h  60 -e /Users/geoffburns/Documents/projects/cards/Vector-Playing-Cards-master/cards-svg/rickety-kate/Icon-20@3x.png -f /Users/geoffburns/Documents/projects/cards/Vector-Playing-Cards-master/cards-svg/rickety-kate/kate.svg 



