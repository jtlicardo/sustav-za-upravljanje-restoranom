<?php
        echo "<section style='overflow-y:scroll; height:160px;'>
        <table>
        <tbody>";
        $sql_jt = "SELECT osoba.ime, osoba.prezime, zanimanje.naziv FROM djelatnik
		JOIN osoba 
		ON djelatnik.id_osoba=osoba.id
		JOIN zanimanje
		ON djelatnik.id_zanimanje=zanimanje.id
		JOIN djelatnik_smjena
		ON djelatnik_smjena.id_djelatnik = djelatnik.id_osoba
        JOIN smjena
        ON djelatnik_smjena.id_smjena = smjena.id
        WHERE '$vrijeme' >= smjena.pocetak_radnog_vremena AND
        '$vrijeme' <= smjena.kraj_radnog_vremena AND
        djelatnik_smjena.datum = subdate('$_SESSION[s_datumsmjena]', $dan);";
        $smjene = mysqli_query($con,$sql_jt);
        while ($smjena = mysqli_fetch_assoc($smjene)){
        echo "<tr>
                <td>".$smjena['ime']."<br>".$smjena['prezime']."</td>
                <td>".$smjena['naziv']."</td></tr>";
        }
        echo "
        </tbody>
        </table>
        </section>";
?>