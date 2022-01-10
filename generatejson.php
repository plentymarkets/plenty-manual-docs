<?php
$en = Metadata::EN;
$en_output = [];

// make sure u have php installed on your computer. afterwards, run "php generatejson.php" in console

foreach($en as $firstLevel) {

if($firstLevel['position'] == 0) {
continue;
}


$en_output[$firstLevel['urlName']] = [];

foreach($firstLevel as $key1 => $level1){

if($key1 == 'position' || $key1 == 'title' || $key1 == 'urlName') {
$en_output[$firstLevel['urlName']][$key1] = $level1;
}

//if($key1 == 'navAlias' && !empty($level1)){
//$en_output[$firstLevel['urlName']]['title'] = $level1;
//}

if($key1 == 'children' && !empty($level1)){

foreach($level1 as $secondLevel) {

if($secondLevel['position'] == 0) {
continue;
}

$en_output[$firstLevel['urlName']][$key1][$secondLevel['urlName']] = [];

foreach($secondLevel as $key2 => $level2){

if($key2 == 'position' || $key2 == 'title' || $key2 == 'url' || $key2 == 'urlName') {
$en_output[$firstLevel['urlName']][$key1][$secondLevel['urlName']][$key2] = $level2;
}

//if($key2 == 'navAlias' && !empty($level2)){
//$en_output[$firstLevel['urlName']][$key1][$secondLevel['urlName']]['title'] = $level2;
//}

if($key2 == 'children' && !empty($level2)){

foreach($level2 as $thirdLevel) {

if($thirdLevel['position'] == 0) {
continue;
}

$en_output[$firstLevel['urlName']][$key1][$secondLevel['urlName']][$key2][$thirdLevel['urlName']] = [];

foreach($thirdLevel as $key3 => $level3){

if($key3 == 'position' || $key3 == 'title' || $key3 == 'url' || $key3 == 'urlName') {
$en_output[$firstLevel['urlName']][$key1][$secondLevel['urlName']][$key2][$thirdLevel['urlName']][$key3] = $level3;
}

//if($key3 == 'navAlias' && !empty($level3)){
//$en_output[$firstLevel['urlName']][$key1][$secondLevel['urlName']][$key2][$thirdLevel['urlName']]['title'] = $level3;
//}

if($key3 == 'children' && !empty($level3)){

foreach($level3 as $fourthLevel) {

if($fourthLevel['position'] == 0) {
continue;
}

$en_output[$firstLevel['urlName']][$key1][$secondLevel['urlName']][$key2][$thirdLevel['urlName']][$fourthLevel['urlName']] = [];

foreach($fourthLevel as $key4 => $level4){

if($key4 == 'position' || $key4 == 'title' || $key4 == 'url' || $key4 == 'urlName') {
$en_output[$firstLevel['urlName']][$key1][$secondLevel['urlName']][$key2][$thirdLevel['urlName']][$key3][$fourthLevel['urlName']][$key4] = $level4;
}

//if($key4 == 'navAlias' && !empty($level4)){
//$en_output[$firstLevel['urlName']][$key1][$secondLevel['urlName']][$key2][$thirdLevel['urlName']][$key3][$fourthLevel['urlName']]['title'] = $level4;
//}

if($key3 == 'children' && !empty($level3)){

foreach($level4 as $fifthLevel) {

if($fifthLevel['position'] == 0) {
continue;
}

$en_output[$firstLevel['urlName']][$key1][$secondLevel['urlName']][$key2][$thirdLevel['urlName']][$fourthLevel['urlName']][$fifthLevel['urlName']] = [];

foreach($fifthLevel as $key5 => $level5){

if($key5 == 'position' || $key5 == 'title' || $key5 == 'url' || $key5 == 'urlName') {
$en_output[$firstLevel['urlName']][$key1][$secondLevel['urlName']][$key2][$thirdLevel['urlName']][$key3][$fourthLevel['urlName']][$key4][$fifthLevel['urlName']][$key5] = $level5;
}

//if($key5 == 'navAlias' && !empty($level5)){
//$en_output[$firstLevel['urlName']][$key1][$secondLevel['urlName']][$key2][$thirdLevel['urlName']][$key3][$fourthLevel['urlName']][$key4][$fifthLevel['urlName']]['title'] = $level5;
//}
}

}
}

}

}
}

}

}
}



}

}
}
}

}


echo json_encode($en_output);