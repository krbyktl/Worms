//Most of these lines can be copied from the macro recorder 
//(Plugins -> Macros -> Record)
//which tracks actions within the FIJI software
//use this to write commands obtain exact numbers for selections



imageTitle=getTitle();
run("Duplicate...", " ");
close(imageTitle);
if (roiManager("count")>=1)
		roiManager("delete");
imageTitle=getTitle();
run("16-bit");
//adjust the lighting of the image (a good amount of contrast is needed for analysis)
setMinAndMax(100, 255);
//subtract the background of the image to distinguish worms
run("Subtract Background...", "rolling=5");
//threshold the image to create a mask (threshold type may be replaced)
setAutoThreshold("Default dark");
run("Convert to Mask");
run("Fill Holes");
run("Watershed");
//select an area of interest (this may be any shape or size)
makeOval(554, 234, 435, 522);
//area filter 
run("Analyze Particles...", "size=0.00002-0.002 show=Masks display add");
right = 0;
for (i = 0; i < roiManager("count"); i++) {
	a = getResult("Area", i);
	n = a/0.0001;
	right = parseInt(n) + right;
}
name = "[Worm Count]";
f=name;
  if (isOpen("Worm Count"))
     print(f, "\\Clear");
  else
     run("New... ", "name="+name+" type=Table");
print(f,imageTitle);
print(f,"Right");
print(f,right);
if (roiManager("count")>=1)
		roiManager("delete");
selectWindow(imageTitle);
//imageMask=getTitle();
//setAutoThreshold("MaxEntropy");
//makeRectangle(510, 44, 518, 938);
makeOval(58, 210, 442, 574);
run("Analyze Particles...", "size=0.00002-0.002 show=Masks display add");
left = 0;
for (i = 0; i < roiManager("count"); i++) {
	a = getResult("Area", i);
	n = a/0.0001;
	left = parseInt(n) + left;
}
print(f,"Left");
print(f,left);
selectWindow("Worm Count");

macro "Close All Windows" { 
    while (nImages>0) { 
         selectImage(nImages); 
         close(); 
      } 
  } 