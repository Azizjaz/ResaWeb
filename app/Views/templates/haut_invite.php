<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>Espace Invité</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <a class="navbar-brand" href="#">Espace Invité</a>
    
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#menuInvite">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="menuInvite">
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <a class="nav-link text-danger" href="<?= base_url('index.php/compte/deconnecter') ?>">
                    Se déconnecter
                </a>
            </li>
        </ul>
    </div>
</nav>

<div class="container">