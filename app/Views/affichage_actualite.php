<h1><?php echo $titre;?></h1><br />
<?php
if (isset($news)){
echo $news->act_id;
echo(" -- ");
echo $news->act_titre;
}
else {
echo ("Pas d'actualité !");
}
?>