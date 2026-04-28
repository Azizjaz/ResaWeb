<h1 class="h3 mb-4 text-gray-800">Espace Admin</h1>
                    <h2>Espace d'administration</h2>
                    <br />
                    <h2>Session ouverte ! Bienvenue
                    <?php
                        $session = session();
                        echo $session->get('user');
                    ?>
                    </h2>
<body id="page-top">


    <!-- Page Wrapper -->
    <div id="wrapper">

        <!-- Sidebar -->

        <!-- End Sidebar -->

        <!-- Content Wrapper -->
         <div class="container-fluid">
    <div class="ma-zone-centree mx-auto" style="max-width: 600px;">
        </div>
</div>
        <div id="content-wrapper" class="d-flex flex-column">

            <!-- Main Content -->
            <div id="content">

                <!-- Topbar -->
                <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 shadow">

                    <!-- Sidebar Toggle (Topbar) -->
                    <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
                        <i class="fa fa-bars"></i>
                    </button>
                <!-- End of Topbar -->

                <!-- Page Content -->
                <div class="container-fluid">



                </div>

            </div>
            <!-- End Content -->

        </div>
        <!-- End Content Wrapper -->

    </div>
    <!-- End Page Wrapper -->

</body><?php
$session = session();

// Titre selon le statut du compte
if ($session->get('statut') == 'A') {
    echo "<h2>Espace Administrateur</h2>";
} else {
    echo "<h2>Espace Membre</h2>";
}
?>

<h3>Réservations à venir</h3>

<?php if (empty($reservations)) : ?>

    <p>Aucune réservation à venir.</p>

<?php else : ?>

    <table border="1" cellpadding="5">
        <tr>
            <th>Date</th>
            <th>Heure</th>
            <th>Nom</th>
            <th>Lieu</th>
        </tr>

        <?php foreach ($reservations as $r) : ?>
        <tr>
            <td><?= $r['rsv_date'] ?></td>
            <td><?= $r['rsv_heure'] ?></td>
            <td><?= $r['rsv_nom'] ?></td>
            <td><?= $r['rsv_lieu'] ?></td>
        </tr>
        <?php endforeach; ?>

    </table>

<?php endif; ?>
