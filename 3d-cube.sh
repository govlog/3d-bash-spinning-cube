#!/bin/bash


# https://fr.wikipedia.org/wiki/Algorithme_de_trac%C3%A9_de_segment_de_Bresenham
function line {
	
	x0=$1;y0=$2;x1=$3;y1=$4
 
  (( x0 > x1 )) && (( dx = x0 - x1, sx = -1 )) || (( dx = x1 - x0 , sx = 1 ))
  (( y0 > y1 )) && (( dy = y0 - y1, sy = -1 )) || (( dy = y1 - y0 , sy = 1 ))
  (( dx > dy )) && (( err = dx )) || (( err = -dy ))
  (( err /= 2 , e2 = 0 ))
 
  while :
  do
    
    echo -en "\033[${y0};${x0}"f#
    (( x0 == x1 && y0 == y1 )) && return
    (( e2 = err ))
	(( e2 > -dx )) && (( err -= dy , x0 += sx ))
    (( e2 < dy  )) && (( err += dx, y0 += sy ))

  done
}

x=()
y=()
z=()

vx=()
vy=()

#((l=25,fs=200,l=l/2))
((l=25,fs=200,l=l/4))


# ouverture d'une pipe nommée vers bc (pour la trigo)
coproc bc -l

tput civis

echo "rx=0" >&${COPROC[1]}

# coordonnes 3D du cube
(( x[1]=-l  ,  y[1]=-l  ,  z[1]=-l  ,
   x[2]=-l  ,  y[2]=l   ,  z[2]=-l  ,
   x[3]=l   ,  y[3]=l   ,  z[3]=-l  ,
   x[4]=l   ,  y[4]=-l  ,  z[4]=-l  ,
   x[5]=-l  ,  y[5]=-l  ,  z[5]=l   ,
   x[6]=-l  ,  y[6]=l   ,  z[6]=l   ,
   x[7]=l   ,  y[7]=l   ,  z[7]=l   ,
   x[8]=l   ,  y[8]=-l  ,  z[8]=l   ))

while clear; do

	echo "rx+=0.1;cc=c(rx);ss=s(rx)" >&${COPROC[1]}
	
	for (( np=1;np<=8;np++ )); do
	
		# rotation des points + calcul des coordonnees
		echo "ynp=cc*${y[np]}-ss*${z[np]};znp=ss*${y[np]}+cc*${z[np]};xt=${x[np]};xnp=cc*xt+ss*znp;znp=-ss*xt+cc*znp;xt=xnp;xnp=cc*xt-ss*ynp;ynp=ss*xt+cc*ynp;80+(xnp*$fs)/(znp+$fs);40+(ynp*$fs)/(znp+$fs)" >&${COPROC[1]}

		mapfile -t -u ${COPROC[0]} -n2 t

		vx[np]=$((${t[0]%.*}-30))
		vy[np]=$((${t[1]%.*}-19))

	done

	line ${vx[1]} ${vy[1]} ${vx[2]} ${vy[2]}
	line ${vx[2]} ${vy[2]} ${vx[3]} ${vy[3]}
	line ${vx[3]} ${vy[3]} ${vx[4]} ${vy[4]}
	line ${vx[4]} ${vy[4]} ${vx[1]} ${vy[1]}
	line ${vx[5]} ${vy[5]} ${vx[6]} ${vy[6]}
	line ${vx[6]} ${vy[6]} ${vx[7]} ${vy[7]}
	line ${vx[7]} ${vy[7]} ${vx[8]} ${vy[8]}
	line ${vx[8]} ${vy[8]} ${vx[5]} ${vy[5]}
	line ${vx[8]} ${vy[8]} ${vx[5]} ${vy[5]}
	line ${vx[1]} ${vy[1]} ${vx[5]} ${vy[5]}
	line ${vx[4]} ${vy[4]} ${vx[8]} ${vy[8]}
	line ${vx[2]} ${vy[2]} ${vx[6]} ${vy[6]}
	line ${vx[3]} ${vy[3]} ${vx[7]} ${vy[7]}

	sleep .03

done
