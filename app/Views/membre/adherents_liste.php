<h2 class="mb-4">Liste des adhérents</h2>

<div class="card shadow mb-4">
    <div class="card-header bg-dark text-white">
        <i class="fas fa-users me-2"></i> Adhérents du club
    </div>

    <div class="card-body">

        <?php if (empty($adherents)) : ?>

            <p class="text-muted"><em>Aucun adhérent pour le moment.</em></p>

        <?php else : ?>

            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="table-light">
                        <tr>
                            <th>Nom</th>
                            <th>Prénom</th>
                            <th>Email</th>
                            <th>Téléphone</th>
                        </tr>
                    </thead>

                    <tbody>
                        <?php foreach ($adherents as $a) : ?>
                        <tr>
                            <td><?= esc($a['pfl_nom']) ?></td>
                            <td><?= esc($a['pfl_prenom']) ?></td>
                            <td><?= esc($a['pfl_email']) ?></td>
                            <td><?= esc($a['pfl_num']) ?></td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>

        <?php endif; ?>

    </div>
</div>
