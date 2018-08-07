//Most of these lines can be copied from the macro recorder 
//(Plugins -> Macros -> Record)
//which tracks actions within the FIJI software
//use this to copy in commands to obtain exact numbers for selections

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
//3 area filters to account for singles, doubles, and triples
run("Analyze Particles...", "size=0.00004-0.0002 show=Masks display add");
single_r = roiManager("count");
if (roiManager("count")>=1)
	roiManager("delete");
selectWindow(imageTitle);
run("Select None");
makeOval(554, 234, 435, 522);
run("Analyze Particles...", "size=0.0002-0.0003 show=Masks display add");
double_r = 2*roiManager("count");
if (roiManager("count")>=1)
	roiManager("delete");
selectWindow(imageTitle);
run("Select None");
makeOval(554, 234, 435, 522);
run("Analyze Particles...", "size=0.0003-0.0005 show=Masks display add");
triple_r = 3*roiManager("count");
if (roiManager("count")>=1)
	roiManager("delete");
//create a table named Worm Count that resets with every image you are analyzing
name = "[Worm Count]";
f=name;
  if (isOpen("Worm Count"))
     print(f, "\\Clear");
  else
     run("New... ", "name="+name+" type=Table");
//print title of image and count
print(f,imageTitle);
print(f,"Right");
right=single_r+double_r+triple_r;
print(f,right);
if (roiManager("count")>=1)
		roiManager("delete");
//repeat this triple filter with the left side of the plate
selectWindow(imageTitle);
makeOval(58, 210, 442, 574);
run("Analyze Particles...", "size=0.00004-0.0002 show=Masks display add");
single_l = roiManager("count");
if (roiManager("count")>=1)
	roiManager("delete");
selectWindow(imageTitle);
run("Select None");
makeOval(58, 210, 442, 574);
run("Analyze Particles...", "size=0.0002-0.0003 show=Masks display add");
double_l = 2*roiManager("count");
if (roiManager("count")>=1)
	roiManager("delete");
selectWindow(imageTitle);
run("Select None");
makeOval(58, 210, 442, 574);
run("Analyze Particles...", "size=0.0003-0.0005 show=Masks display add");
triple_l = 3*roiManager("count");
if (roiManager("count")>=1)
	roiManager("delete");
print(f,"Left");
left=single_l+double_l+triple_l;
print(f,left);
selectWindow("Worm Count");

//closes all your windows to ease clutter
//take this portion out if you are testing the script and want to evaluate each individual ste
macro "Close All Windows" { 
    while (nImages>0) { 
         selectImage(nImages); 
         close(); 
      } 
  } 