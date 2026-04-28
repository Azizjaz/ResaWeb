<div id="layoutSidenav">
    <div id="layoutSidenav_nav">
        <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">

            <div class="sb-sidenav-menu">
                <div class="nav">

                    <div class="sb-sidenav-menu-heading">Administration</div>

                    <a class="nav-link" href="<?= base_url('index.php/admin/accueil') ?>">
                        <div class="sb-nav-link-icon"><i class="fas fa-home"></i></div>
                        Accueil admin
                    </a>

                    <a class="nav-link" href="<?= base_url('index.php/compte/afficher_profil') ?>">
                        <div class="sb-nav-link-icon"><i class="fas fa-user"></i></div>
                        Mon profil
                    </a>

                    <a class="nav-link" href="<?= base_url('index.php/admin/ajouter_invite') ?>">
                        <div class="sb-nav-link-icon"><i class="fas fa-user-plus"></i></div>
                        Ajouter un invité
                    </a>

                    <a class="nav-link" href="<?= base_url('index.php/admin/comptes') ?>">
                        <div class="sb-nav-link-icon"><i class="fas fa-users-cog"></i></div>
                        Gestion des comptes
                    </a>

                    <a class="nav-link" href="<?= base_url('index.php/admin/ressources') ?>">
                        <div class="sb-nav-link-icon"><i class="fas fa-layer-group"></i></div>
                        Gestion des ressources
                    </a>

                    <a class="nav-link" href="<?= base_url('index.php/admin/messages') ?>">
                        <div class="sb-nav-link-icon"><i class="fas fa-envelope"></i></div>
                        Messages visiteurs
                    </a>
                    <a class="nav-link" href="<?= base_url('index.php/reservation/seances') ?>">
                        <div class="sb-nav-link-icon"><i class="fas fa-calendar-alt"></i></div>
                        Séances réservées
                    </a>


                </div>
            </div>

        </nav>
    </div>

    <div id="layoutSidenav_content">
        <main class="container py-4">
