<div class="container-fluid px-4">

    <!-- En-tête -->
    <div class="d-flex justify-content-between align-items-center mt-4 mb-4">
        <div>
            <h1 class="h3 mb-1">Gestion des comptes / profils</h1>
            <p class="text-muted mb-0">
                Visualisez et administrez les comptes administrateurs et membres.
            </p>
        </div>

        <a href="<?= base_url('index.php/admin/ajouter_invite') ?>" class="btn btn-primary">
            <i class="fa-solid fa-user-plus me-1"></i> Ajouter un compte invité
        </a>
    </div>

    <?php if (isset($message)) : ?>
        <div class="alert alert-success">
            <?= esc($message) ?>
        </div>
    <?php endif; ?>

    <div class="card border-0 shadow-sm rounded-3">
        <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
            <span><i class="fa-solid fa-users me-2"></i>Liste des comptes</span>
            <?php if (!empty($comptes)) : ?>
                <span class="badge bg-light text-dark">
                    <?= count($comptes) ?> compte(s)
                </span>
            <?php endif; ?>
        </div>

        <div class="card-body p-0">

            <?php if (empty($comptes)) : ?>

                <p class="p-3 text-muted mb-0">
                    Aucun compte trouvé.
                </p>

            <?php else : ?>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Pseudo</th>
                                <th>Statut compte</th>
                                <th>Nom</th>
                                <th>Prénom</th>
                                <th>Email</th>
                                <th>Rôle</th>
                            </tr>
                        </thead>
                        <tbody>
                        <?php foreach ($comptes as $c): ?>
                            <tr>
                                <td><?= esc($c['cpt_pseudo']) ?></td>
                                <td><?= esc($c['cpt_statut']) ?></td>
                                <td><?= esc($c['pfl_nom']) ?></td>
                                <td><?= esc($c['pfl_prenom']) ?></td>
                                <td><?= esc($c['pfl_email']) ?></td>
                                <td>
                                    <?php
                                        // adapte le nom du tableau : $c, $compte, $a...
                                        $role = $c['pfl_role'] ?? null;

                                        if ($role === 'A') {
                                            echo 'Admin';
                                        } elseif ($role === 'M') {
                                            echo 'Membre';
                                        } else {
                                            echo 'Invité';   // pas de profil → invité
                                        }
                                    ?>
                                </td>

                            </tr>
                        <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>

            <?php endif; ?>

        </div>
    </div>

</div>
