for i in *.png; do convert $i -color-matrix \
  " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
    0.0 0.0 0.0 0.0, 0.0, 1.0 \
    0.0 0.0 0.0 0.0, 0.0, 1.0 \
    -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
    0.0 0.0 0.0 0.0, 1.0,  0.0 \
    0.0 0.0 0.0 0.0, 0.0,  1.0" `echo $i | sed -e 's/.png$/_.png/'`; done



cd "/Users/geoffburns/Documents/projects/PROJECT/xcode/Rickety Kate/Rickety Kate/cards_stars.atlas"
for i in *R.png; do convert $i -color-matrix \
                      " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                        0.0 0.0 0.0 0.0, 0.0, 1.0 \
                        0.0 0.0 0.0 0.0, 0.0, 1.0 \
                        -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
                        -0.35 -0.35 -0.35 0.0, 1.0,  0.0 \
                        0.0 0.0 0.0 0.0, 0.0,  1.0" `echo ../cards_stars_white.atlas/$i | sed -e 's/.png$/_.png/'`; done

for i in *R@2x.png; do convert $i -color-matrix \
                               " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
                                -0.35 -0.35 -0.35 0.0, 1.0,  0.0 \
                                 0.0 0.0 0.0 0.0, 0.0,  1.0" `echo ../cards_stars_white.atlas/$i | sed -e 's/@2x.png$/_@2x.png/'`; done


for i in *J.png; do convert $i -color-matrix \
   " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
     0.0 0.0 0.0 0.0, 0.0, 1.0 \
     0.0 0.0 0.0 0.0, 0.0, 1.0 \
     -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
     -0.35 -0.35 -0.35 0.0, 1.0,  0.0 \
     0.0 0.0 0.0 0.0, 0.0,  1.0" `echo $i | sed -e 's/.png$/_.png/'`; done

for i in *J@2x.png; do convert $i -color-matrix \
          " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
             0.0 0.0 0.0 0.0, 0.0, 1.0 \
             0.0 0.0 0.0 0.0, 0.0, 1.0 \
           -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
             -0.35 -0.35 -0.35 0.0, 1.0,  0.0 \
             0.0 0.0 0.0 0.0, 0.0,  1.0" `echo $i | sed -e 's/@2x.png$/_@2x.png/'`; done

cd "/Users/geoffburns/Documents/projects/PROJECT/xcode/Rickety Kate/Rickety Kate/cards_tarot.atlas"
for i in *T.png; do convert $i -color-matrix \
   " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
    0.0 0.0 0.0 0.0, 0.0, 1.0 \
     0.0 0.0 0.0 0.0, 0.0, 1.0 \
   -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
     -0.35 -0.35 -0.35 0.0, 1.0,  0.0 \
     0.0 0.0 0.0 0.0, 0.0,  1.0" `echo ../cards_tarot_white.atlas/$i | sed -e 's/.png$/_.png/'`; done

for i in *T@2x.png; do convert $i -color-matrix \
                                >               " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                >                 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                >                 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                >               -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
                                >                 -0.35 -0.35 -0.35 0.0, 1.0,  0.0 \
                                >                 0.0 0.0 0.0 0.0, 0.0,  1.0" `echo ../cards_tarot_white.atlas/$i | sed -e 's/@2x.png$/_@2x.png/'`; done


cd "/Users/geoffburns/Documents/projects/PROJECT/xcode/Rickety Kate/Rickety Kate/cards_clubs.atlas"
for i in *C.png; do convert $i -color-matrix \
                   " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                     0.0 0.0 0.0 0.0, 0.0, 1.0 \
                     0.0 0.0 0.0 0.0, 0.0, 1.0 \
                    -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
                     -0.35 -0.35 -0.35 0.0, 1.0,  0.0 \
                     0.0 0.0 0.0 0.0, 0.0,  1.0" `echo ../cards_clubs_white.atlas/$i | sed -e 's/.png$/_.png/'`; done
for i in *C@2x.png; do convert $i -color-matrix \
                                                    " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                                      0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                                      0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                                     -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
                                                      -0.35 -0.35 -0.35 0.0, 1.0,  0.0 \
                                                      0.0 0.0 0.0 0.0, 0.0,  1.0" `echo ../cards_clubs_white.atlas/$i | sed -e 's/@2x.png$/_@2x.png/'`; done

cd "/Users/geoffburns/Documents/projects/PROJECT/xcode/Rickety Kate/Rickety Kate/cards_anchors.atlas"
for i in *A.png; do convert $i -color-matrix \
                   " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                     0.0 0.0 0.0 0.0, 0.0, 1.0 \
                     0.0 0.0 0.0 0.0, 0.0, 1.0 \
                     -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
                     -0.35 -0.35 -0.35 0.0, 1.0,  0.0 \
                     0.0 0.0 0.0 0.0, 0.0,  1.0" `echo ../cards_anchors_white.atlas/$i | sed -e 's/.png$/_.png/'`; done


or i in *A@2x.png; do convert $i -color-matrix \
                               " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                 -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
                                 -0.35 -0.35 -0.35 0.0, 1.0,  0.0 \
                                 0.0 0.0 0.0 0.0, 0.0,  1.0" `echo ../cards_anchors_white.atlas/$i | sed -e 's/@2x.png$/_@2x.png/'`; done


cd "/Users/geoffburns/Documents/projects/PROJECT/xcode/Rickety Kate/Rickety Kate/cards_diamonds.atlas"
for i in *D.png; do convert $i -color-matrix \
                   " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                     0.0 0.0 0.0 0.0, 0.0, 1.0 \
                     0.0 0.0 0.0 0.0, 0.0, 1.0 \
                     -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
                     -0.35 -0.35 -0.35 0.0, 1.0,  0.0 \
                     0.0 0.0 0.0 0.0, 0.0,  1.0" `echo ../cards_diamonds_white.atlas/$i | sed -e 's/.png$/_.png/'`; done


for i in *D@2x.png; do convert $i -color-matrix \
                               " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                               -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
                                 -0.35 -0.35 -0.35 0.0, 1.0,  0.0 \
                                 0.0 0.0 0.0 0.0, 0.0,  1.0" `echo ../cards_diamonds_white.atlas/$i | sed -e 's/@2x.png$/_@2x.png/'`; done


cd "/Users/geoffburns/Documents/projects/PROJECT/xcode/Rickety Kate/Rickety Kate/cards_hearts.atlas"
for i in *H.png; do convert $i -color-matrix \
                   " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                     0.0 0.0 0.0 0.0, 0.0, 1.0 \
                     0.0 0.0 0.0 0.0, 0.0, 1.0 \
                   -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
                     -0.35 -0.35 -0.35 0.0, 1.0,  0.0 \
                     0.0 0.0 0.0 0.0, 0.0,  1.0" `echo ../cards_hearts_white.atlas/$i | sed -e 's/.png$/_.png/'`; done


for i in *H@2x.png; do convert $i -color-matrix \
                               " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                              -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
                                 -0.35 -0.35 -0.35 0.0, 1.0,  0.0 \
                                 0.0 0.0 0.0 0.0, 0.0,  1.0" `echo ../cards_hearts_white.atlas/$i | sed -e 's/@2x.png$/_@2x.png/'`; done
cd "/Users/geoffburns/Documents/projects/PROJECT/xcode/Rickety Kate/Rickety Kate/cards_spades.atlas"
for i in *S.png; do convert $i -color-matrix \
                   " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                     0.0 0.0 0.0 0.0, 0.0, 1.0 \
                     0.0 0.0 0.0 0.0, 0.0, 1.0 \
                   -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
                     -0.35 -0.35 -0.35 0.0, 1.0,  0.0 \
                     0.0 0.0 0.0 0.0, 0.0,  1.0" `echo ../cards_spades_white.atlas/$i | sed -e 's/.png$/_.png/'`; done

for i in *S@2x.png; do convert $i -color-matrix \
                                                              " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                                                0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                                                0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                                              -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
                                                                -0.35 -0.35 -0.35 0.0, 1.0,  0.0 \
                                                                0.0 0.0 0.0 0.0, 0.0,  1.0" `echo ../cards_spades_white.atlas/$i | sed -e 's/@2x.png$/_@2x.png/'`; done


cd "/Users/geoffburns/Documents/projects/PROJECT/xcode/Rickety Kate/Rickety Kate/cards_suns.atlas"
for i in *U.png; do convert $i -color-matrix \
                   " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                     0.0 0.0 0.0 0.0, 0.0, 1.0 \
                     0.0 0.0 0.0 0.0, 0.0, 1.0 \
                    -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
                     -0.35 -0.35 -0.35 0.0, 1.0,  0.0 \
                     0.0 0.0 0.0 0.0, 0.0,  1.0" `echo ../cards_suns_white.atlas/$i | sed -e 's/.png$/_.png/'`; done
for i in *U@2x.png; do convert $i -color-matrix \
                               " 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                 0.0 0.0 0.0 0.0, 0.0, 1.0 \
                                -0.35 -0.35 -0.35 1.0, 0.0,  0.0 \
                                 -0.35 -0.35 -0.35 0.0, 1.0,  0.0 \
                                 0.0 0.0 0.0 0.0, 0.0,  1.0" `echo ../cards_suns_white.atlas/$i | sed -e 's/@2x.png$/_@2x.png/'`; done
