<!DOCTYPE HTML>
<html>
<head>
<script type="text/javascript" src="templates/slideshow.js"></script>
<LINK REL=StyleSheet HREF="<?php echo(S_HOST.S_ROOT.S_TEMPLATEDIR); ?><?php $qi->p('topic'); ?>/horiz_1/style.css" TITLE="Contemporary" TYPE="text/css">
<LINK REL=StyleSheet HREF="<?php echo(S_HOST.S_ROOT.S_TEMPLATEDIR); ?><?php $qi->p('topic'); ?>/text.css" TITLE="Contemporary" TYPE="text/css">
<title>horiz_1</title>
</head>

<body>
	<div id="slide">
		<div id="left">
			<div id="title"><h1 class="bottom" ><?php $pi->p('title'); ?></h1></div>
			<div id="title2"><h1 class="top"><?php $pi->p('title'); ?></h1></div>
			<div id="sub"><h2><?php $pi->p('subtitle'); ?></h2></div>
			<div id="text" class="textone"><?php $pi->p('text_1'); ?></div>
			<div id="text" class="texttwo"><?php $pi->p('text_2'); ?></div>
		</div>
		
		<div id="right">
			<div id ="media"><img src="<?php echo(S_HOST.S_ROOT); ?>media/<?php $pi->p('image_1'); ?>" id="dbIMG" class="<?php list($width, $height, $type, $attr) = getimagesize(S_HOST.S_ROOT.'media/'.$pi->f('image_1')); if($width > $height) { ?>h<?php } else { ?>v<?php } ?>"></div>
		</div>
		
	</div>
</body></html>
