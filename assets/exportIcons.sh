# for inkscape CLI reference, see https://inkscape.org/en/doc/inkscape-man.html

inName=$1
dir=$(pwd)
outDir=$2/Assets.xcassets/AppIcon.appiconset
inkscape=/Applications/Inkscape.app/Contents/Resources/bin/inkscape

if [ -e $outdir ]
then

cd $outDir
outDir=$(pwd)
cd dir

save() {
	echo "saving icon size $1"
	$inkscape -z $dir/$inName -C -w $1 -h $1 -e $outDir/Icon-App-$1.png
}

echo "exporting images..."

save 29
save 40
save 58
save 80
save 76
save 87
save 120
save 152
save 167
save 180

echo "saving contents..."

cat > $outDir/Contents.json <<- EOM

{
"images" : [
{
"idiom" : "iphone",
"size" : "29x29",
"filename" : "Icon-App-58.png",
"scale" : "2x"
},
{
"idiom" : "iphone",
"size" : "29x29",
"filename" : "Icon-App-87.png",
"scale" : "3x"
},
{
"idiom" : "iphone",
"size" : "40x40",
"filename" : "Icon-App-80.png",
"scale" : "2x"
},
{
"idiom" : "iphone",
"size" : "40x40",
"filename" : "Icon-App-120.png",
"scale" : "3x"
},
{
"idiom" : "iphone",
"size" : "60x60",
"filename" : "Icon-App-120.png",
"scale" : "2x"
},
{
"idiom" : "iphone",
"size" : "60x60",
"filename" : "Icon-App-180.png",
"scale" : "3x"
},
{
"idiom" : "ipad",
"size" : "29x29",
"filename" : "Icon-App-29.png",
"scale" : "1x"
},
{
"idiom" : "ipad",
"size" : "29x29",
"filename" : "Icon-App-58.png",
"scale" : "2x"
},
{
"idiom" : "ipad",
"size" : "40x40",
"filename" : "Icon-App-40.png",
"scale" : "1x"
},
{
"idiom" : "ipad",
"size" : "40x40",
"filename" : "Icon-App-80.png",
"scale" : "2x"
},
{
"idiom" : "ipad",
"size" : "76x76",
"filename" : "Icon-App-76.png",
"scale" : "1x"
},
{
"idiom" : "ipad",
"size" : "76x76",
"filename" : "Icon-App-152.png",
"scale" : "2x"
},
{
"idiom" : "ipad",
"size" : "83.5x83.5",
"filename" : "Icon-App-167.png",
"scale" : "2x"
}
],
"info" : {
"version" : 1,
"author" : "xcode"
}
}

EOM

echo "all done"

else

echo "out location does not exist"

fi

