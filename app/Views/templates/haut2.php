<?php
$session = session();


?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <title>
        <?= ($session->get('statut') === 'A') 
        ? 'Espace Admin' 
        : '<i class="fas fa-user-check me-2"></i>Espace Membre'; ?>
    </title>

    <!-- Bootstrap 5 (CDN) -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
        crossorigin="anonymous"
    >

    <!-- SB Admin / ton thème -->
    <link href="<?= base_url('bootstrap2/css/styles.css'); ?>" rel="stylesheet" />

    <!-- CSS perso -->
    <link rel="stylesheet" href="<?= base_url('V1/ci/public/css/styles.css') ?>">


    <!-- Font Awesome -->
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
</head>

<body class="sb-nav-fixed">

    
    <!--     NAVBAR      -->  

    <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">

        <!-- Titre -->
        <a class="navbar-brand ps-3" href="#">
            <?= ($session->get('statut') === 'A') ? 'Espace Admin' : 'Espace Membre'; ?>
        </a>

        <!-- Bouton sidebar -->
        <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0"
                id="sidebarToggle">
            <i class="fas fa-bars"></i>
        </button>

        <!--  MENU ADMIN + MEMBRE  -->
        <ul class="navbar-nav ms-3">
        <?php if ($session->get('statut') === 'A') : ?>

            <!-- MENU ADMINISTRATEUR -->
            <li class="nav-item">
                <a class="nav-link" href="<?= base_url('index.php/admin/accueil') ?>">
                    Accueil admin
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link" href="<?= base_url('index.php/compte/afficher_profil') ?>">
                    Mon profil
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link" href="<?= base_url('index.php/admin/ajouter_invite') ?>">
                    Ajouter un invité
                </a>
            </li>

            <!-- 🔵 GESTION DES COMPTES → COMPTE-PROFIL -->
            <li class="nav-item">
                <a class="nav-link" href="<?= base_url('index.php/admin/comptes') ?>">
                    Compte-profil
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link" href="<?= base_url('index.php/admin/ressources') ?>">
                    Gestion des ressources
                </a>
            </li>

            <!-- 🔵 MESSAGES VISITEURS → CONTACT -->
            <li class="nav-item">
                <a class="nav-link" href="<?= base_url('index.php/admin/messages') ?>">
                    Contact
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link" href="<?= base_url('index.php/reservation/seances') ?>">
                    Séances réservées
                </a>
            </li>

            <?php else : ?>

            <!-- MENU MEMBRE -->
            <li class="nav-item">
                <a class="nav-link" href="<?= base_url('index.php/compte/accueil_membre') ?>">
                    Accueil membre
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link" href="<?= base_url('index.php/membre/adherents') ?>">
                    Liste adhérents
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link" href="<?= base_url('index.php/compte/afficher_profil') ?>">
                    Mon profil
                </a>
            </li>

        <?php endif; ?>


            <!-- COMMUN (admin + membre) -->
            <li class="nav-item">
                <a class="nav-link" href="<?= base_url('index.php/compte/deconnecter') ?>">
                    Déconnexion
                </a>
            </li>

        </ul>

        <!-- Barre de recherche (optionnelle) -->
        <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3">
            <div class="input-group">
                <input class="form-control" type="text" placeholder="Rechercher..." />
                <button class="btn btn-primary" type="button">
                    <i class="fas fa-search"></i>
                </button>
            </div>
        </form>

        <!-- Icône utilisateur -->
        <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" id="navbarDropdown"
                   role="button" data-bs-toggle="dropdown">
                    <i class="fas fa-user fa-fw"></i>
                </a>

                <ul class="dropdown-menu dropdown-menu-end">
                    <li>
                        <a class="dropdown-item" 
                           href="<?= base_url('index.php/compte/afficher_profil') ?>">
                            Mon profil
                        </a>
                    </li>
                    <li><hr class="dropdown-divider" /></li>
                    <li>
                        <a class="dropdown-item" 
                           href="<?= base_url('index.php/compte/deconnecter') ?>">
                            Déconnexion
                        </a>
                    </li>
                </ul>
            </li>
        </ul>

    </nav>

    <!-- Décaler le contenu sous la navbar -->
    <div style="height: 70px;"></div>
