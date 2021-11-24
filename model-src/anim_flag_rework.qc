$modelname "anim_flag_rework/anim_flag_rework.mdl"

$bodygroup "flag"
{
	studio "anim_flag_rework.smd"
}

$surfaceprop "metal"

$contents "solid"

$illumposition 1.273 31.202 168.895

$opaque

$cdmaterials "models\anim_flag_skins\"

$cbox 0 0 0 0 0 0

$bbox -86.129 -59.747 -0.765 23.703 62.283 343.549

$definebone "group1" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "joint51" "group1" 0 0 0 -89.999641 0 0 0 0 0 0 0 0
$definebone "joint52" "joint51" 140 0 0 0 0 0 0 0 0 0 0 0
$definebone "joint53" "joint52" 149.999878 0 0 89.999641 0 0 0 0 0 0 0 0
$definebone "MAIN" "joint53" 0 0.0699 3.274689 0 0.661193 0 0 0 0 0 0 0
$definebone "joint45" "MAIN" 0 6.8002 19.096405 -1.787055 89.999641 -89.999641 0 0 0 0 0 0
$definebone "joint46" "joint45" 15.328701 0.000031 0 0 4.545847 -179.999855 0 0 0 0 0 0
$definebone "joint47" "joint46" 16.211506 0.000031 0 0 2.758792 0 0 0 0 0 0 0
$definebone "joint48" "joint47" 15.607395 0 0 0 -1.468491 0 0 0 0 0 0 0
$definebone "joint49" "joint48" 15.222301 0 0 0 2.184689 179.999855 0 0 0 0 0 0
$definebone "joint50" "joint49" 15.608696 0.000031 0 89.999641 -89.283441 0 0 0 0 0 0 0
$definebone "joint29" "MAIN" 0 22.511803 6.698303 3.532285 89.999641 89.999641 0 0 0 0 0 0
$definebone "joint30" "joint29" 15.832596 0 0 0 6.430306 -179.999855 0 0 0 0 0 0
$definebone "joint31" "joint30" 15.432106 0.000031 0 0 4.295465 -179.999855 0 0 0 0 0 0
$definebone "joint32" "joint31" 16.002403 -0.000031 0 0 4.490844 -179.999855 0 0 0 0 0 0
$definebone "joint33" "joint32" 14.458015 0 0 89.999641 -86.905667 0 0 0 0 0 0 0
$definebone "joint34" "MAIN" 0 22.316702 -6.372803 -1.332127 89.999641 -89.999641 0 0 0 0 0 0
$definebone "joint35" "joint34" 16.782501 -0.000031 0 0 1.332127 0 0 0 0 0 0 0
$definebone "joint36" "joint35" 15.022202 0 0 0 -2.147446 0 0 0 0 0 0 0
$definebone "joint37" "joint36" 15.618393 0 0 0 3.597602 -179.999855 0 0 0 0 0 0
$definebone "joint38" "joint37" 15.417297 0.000031 0 -89.999641 -88.549482 0 0 0 0 0 0 0
$definebone "joint39" "MAIN" 0 6.1239 -21.980316 0 89.999641 0 0 0 0 0 0 0
$definebone "joint40" "joint39" 15.802499 0 0 3.288778 0 89.999641 0 0 0 0 0 0
$definebone "joint41" "joint40" 17.001101 0 0 0 6.151276 179.999855 0 0 0 0 0 0
$definebone "joint42" "joint41" 15.626904 0 0 0 4.369377 -179.999855 0 0 0 0 0 0
$definebone "joint43" "joint42" 14.832199 -0.000031 0 0 2.887707 -179.999855 0 0 0 0 0 0
$definebone "joint44" "joint43" 16.197395 0 0 89.999641 -88.619382 0 0 0 0 0 0 0

$sectionframes 30 300

$sequence "idle" {
	"anims\idle.smd"
	fps 10
	loop
}

$collisionmodel "anim_flag_rework_phys.smd"
{
	$mass 370
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
	$maxconvexpieces 3
}