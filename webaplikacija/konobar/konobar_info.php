<?php
    include_once 'konobar_konekcija.php';
    if (isset($_POST['sp_konobar'])) {
        $osobniidkonobar=mysqli_real_escape_string($con, $_POST['id_konobar']);
        $upit_provjera="SELECT id FROM djelatnik WHERE id='$osobniidkonobar' AND id_zanimanje='2' AND zaposlen='D';";
        $rezultat = mysqli_query($con, $upit_provjera);
        if (!mysqli_num_rows($rezultat)) {
        echo "Dogodila se greška. Molimo pokušajte kasnije."; 
		} else {
        //postavljanje sesijske varijable za prikaz
        $_SESSION['idkonobar']=mysqli_fetch_assoc($rezultat)['id'];
        header("Location: konobar_sucelje.php");
		}
    } else {
        echo "Dogodila se greška. Molimo pokušajte kasnije.";
    }
    ?>