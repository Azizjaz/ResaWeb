<h2 class="mb-4">Espace Membre</h2>
<p class="text-muted">Voici vos prochaines réservations.</p>

<div class="card shadow mb-4">
    <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
        <span><i class="fas fa-calendar-check me-2"></i> Mes prochaines réservations</span>
        <span class="badge bg-secondary"><?= count($reservations) ?> réservation(s)</span>
    </div>

    <div class="card-body">

        <?php if (empty($reservations)) : ?>

            <p class="text-muted"><em>Aucune réservation à venir.</em></p>

        <?php else : ?>

            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="table-light">
                        <tr>
                            <th>Date</th>
                            <th>Heure</th>
                            <th>Nom</th>
                            <th>Lieu</th>
                        </tr>
                    </thead>

                    <tbody>
                        <?php foreach ($reservations as $r) : ?>
                        <tr>
                            <td><?= esc($r['rsv_date']) ?></td>
                            <td><?= esc($r['rsv_heure']) ?></td>
                            <td><?= esc($r['rsv_nom']) ?></td>
                            <td><?= esc($r['rsv_lieu']) ?></td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>

        <?php endif; ?>

    </div>
</div>
