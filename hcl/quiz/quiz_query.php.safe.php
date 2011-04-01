<?php 
header('Content-Type: text/xml');
require("vars.php");
require("functions.php");
?>

<?php
	$noID = false;
	if(isset($_GET['ID'])){
		$ID = $_GET['ID'];
	}else if(isset($_POST['ID'])){
		$ID = $_POST['ID'];
	}else{
		$noID = true;
	}

	if(isset($_GET['ord'])){
		$ord = $_GET['ord'];
	}else if(isset($_POST['ord'])){
		$ord = $_POST['ord'];
	}else{
		$ord = 1;
	}

	$qz = new ps_DB;
	$q  = "SELECT * from quiz ";
	//$q .= "where id ='".$ID."'";
	$q .= "WHERE active = 1";
	$qz->query($q);
	$qz->next_record();
	
	$total = $qz->num_rows();
	if($total > 0){
		$p = new ps_DB;
		$q2 = "SELECT * FROM pages WHERE quiz_id = ".$qz->f('id');
		$q2 .= " ORDER BY ord";
		$p->query($q2);
		?>
		<quiz id="<?php $qz->p("id"); ?>">
			<name><?php $qz->p("quiz_name"); ?></name>
		<?php
			while($p->next_record()) { ?>
			<row id="<?php $p->p("ord"); ?>">
				<ord><?php $p->p("ord"); ?></ord>
				<image><?php $p->p("image"); ?></image>
				<text><?php $p->p("text"); ?></text>
				<questions>
					<question><?php $p->p("question_1"); ?></question>
					<question><?php $p->p("question_2"); ?></question>
					<question><?php $p->p("question_3"); ?></question>
					<question><?php $p->p("question_4"); ?></question>
					<question><?php $p->p("question_4"); ?></question>
				</questions>
			</row>
			<?php } ?>
		</quiz>
	<?php } ?>