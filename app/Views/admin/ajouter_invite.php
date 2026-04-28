<div class="container-fluid px-4">

    <!-- En-tête -->
    <div class="d-flex justify-content-between align-items-center mt-4 mb-4">
        <div>
            <h1 class="h3 mb-1">Ajouter un compte invité</h1>
            <p class="text-muted mb-0">
                Créez rapidement un compte invité avec un accès limité.
            </p>
        </div>

        <a href="<?= base_url('index.php/admin/comptes') ?>" class="btn btn-outline-secondary">
            <i class="fa-solid fa-users me-1"></i> Gestion des comptes
        </a>
    </div>

    <!-- Messages d'erreur -->
    <?php if (isset($validation)) : ?>
        <div class="alert alert-danger">
            <?= $validation->listErrors() ?>
        </div>
    <?php elseif (isset($erreur)) : ?>
        <div class="alert alert-warning">
            <?= esc($erreur) ?>
        </div>
    <?php endif; ?>

    <!-- Card formulaire -->
    <div class="card border-0 shadow-sm rounded-3" style="max-width: 600px;">
        <div class="card-header bg-dark text-white">
            <i class="fa-solid fa-user-plus me-2"></i> Nouveau compte invité
        </div>

        <div class="card-body">

            <form method="post" action="<?= base_url('index.php/admin/ajouter_invite') ?>">

                <div class="mb-3">
                    <label for="pseudo" class="form-label">Pseudo</label>
                    <input
                        type="text"
                        name="pseudo"
                        id="pseudo"
                        class="form-control"
                        value="<?= set_value('pseudo') ?>"
                        placeholder="ex : invité.padel"
                        required
                    >
                </div>

                <div class="mb-3">
                    <label for="mdp" class="form-label">Mot de passe</label>
                    <input
                        type="password"
                        name="mdp"
                        id="mdp"
                        class="form-control"
                        placeholder="Au moins 8 caractères"
                        required
                    >
                </div>

                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary">
                        <i class="fa-solid fa-check me-1"></i> Créer le compte
                    </button>
                </div>

            </form>

        </div>

        <div class="card-footer text-muted small">
            Les invités disposent d’un accès restreint à la plateforme.
        </div>
    </div>

</div>
