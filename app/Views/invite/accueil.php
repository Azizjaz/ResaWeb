<div class="container mt-5">

    <h2 class="text-center text-primary">
        Bienvenue dans votre espace invité, <?= esc($pseudo) ?> !
    </h2>

    <p class="text-center text-muted mb-4">
        Voici vos réservations à venir.
    </p>

    <div class="card shadow-sm p-4">

        <?php if (empty($reservations)) : ?>

            <div class="alert alert-info text-center">
                Aucune réservation pour le moment.
            </div>

        <?php else : ?>

            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Nom séance</th>
                        <th>Date</th>
                        <th>Heure</th>
                        <th>Lieu</th>
                        <th>Ressource</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($reservations as $r) : ?>
                        <tr>
                            <td><?= esc($r['rsv_nom']) ?></td>
                            <td><?= esc($r['rsv_date']) ?></td>
                            <td><?= esc($r['rsv_heure']) ?></td>
                            <td><?= esc($r['rsv_lieu']) ?></td>
                            <td><?= esc($r['rsc_nom']) ?></td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>

        <?php endif; ?>

    </div>

</div>
