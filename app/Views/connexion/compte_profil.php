<?php $session = session(); ?>

<style>
    .profil-icon {
        width: 70px;
        height: 70px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        background: #0d6efd1a;
        color: #0d6efd;
        font-size: 2rem;
    }
</style>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-6 col-md-8">

            <!-- Titre espace -->
            <div class="text-center mb-4">
                <div class="profil-icon mb-3">
                    <i class="fas fa-user-circle"></i>
                </div>

                <h2 class="mb-1">
                    <?= ($session->get('statut') == 'A') 
                        ? 'Espace Administrateur' 
                        : 'Espace Membre' ?>
                </h2>

                <p class="text-muted mb-0">Mon profil</p>
            </div>

            <!-- Carte profil -->
            <div class="card shadow-sm border-0">
                <div class="card-body">

                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h5 class="mb-0">
                                <?= esc($profil['pfl_prenom'].' '.$profil['pfl_nom']) ?>
                            </h5>
                            <small class="text-muted">Pseudo : <?= esc($session->get('user')) ?></small>
                        </div>

                        <span class="badge bg-primary">
                            <?= ($session->get('statut') == 'A') ? 'Admin' : 'Membre' ?>
                        </span>
                    </div>

                    <hr>

                    <dl class="row mb-0">
                        <dt class="col-sm-4">Email</dt>
                        <dd class="col-sm-8"><?= esc($profil['pfl_email']) ?></dd>

                        <dt class="col-sm-4">Numéro</dt>
                        <dd class="col-sm-8"><?= esc($profil['pfl_num']) ?></dd>

                        <dt class="col-sm-4">Adresse</dt>
                        <dd class="col-sm-8"><?= esc($profil['pfl_adresse']) ?></dd>

                        <dt class="col-sm-4">Date de naissance</dt>
                        <dd class="col-sm-8">
                            <?= esc(date('d/m/Y', strtotime($profil['pfl_date_naissance']))) ?>
                        </dd>
                    </dl>

                </div>
            </div>

        </div>
    </div>
</div>
