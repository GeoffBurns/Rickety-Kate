
for i in /Users/geoffburns/Documents/projects/PROJECT/robot/cards/Vector-Playing-Cards-master/cards-svg/*.svg; do /Applications/Inkscape.app/Contents/Resources/bin/inkscape $i -w 167 -h  243 --export-png=`echo $i | sed -e 's/svg$/png/'`; done

for i in /Users/geoffburns/Documents/projects/PROJECT/robot/cards/Vector-Playing-Cards-master/cards-svg/*.svg; do /Applications/Inkscape.app/Contents/Resources/bin/inkscape $i -w 334 -h  486 --export-png=`echo $i | sed -e 's/.svg$/@2x.png/'`; done


for i in /Users/geoffburns/Documents/projects/PROJECT/robot/cards/Vector-Playing-Cards-master/button/*.svg; do /Applications/Inkscape.app/Contents/Resources/bin/inkscape $i -w 167 -h  167 --export-png=`echo $i | sed -e 's/svg$/png/'`; done

for i in /Users/geoffburns/Documents/projects/PROJECT/robot/cards/Vector-Playing-Cards-master/button/*.svg; do /Applications/Inkscape.app/Contents/Resources/bin/inkscape $i -w 334 -h  334 --export-png=`echo $i | sed -e 's/.svg$/@x2.png/'`; done

