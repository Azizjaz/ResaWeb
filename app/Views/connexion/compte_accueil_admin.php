<h2 class="mb-4">Espace Administrateur</h2>
<p class="text-muted">Vue d’ensemble des réservations à venir.</p>

<div class="card shadow mb-4">
    <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
        <span><i class="fas fa-calendar-alt me-2"></i> Réservations à venir</span>
        <span class="badge bg-secondary">
            <?= count($reservations) ?> réservation(s)
        </span>
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
                            <th>Participants</th>
                        </tr>
                    </thead>

                    <tbody>
                    <?php foreach ($reservations as $r) : ?>
                        <tr>
                            <td><?= esc($r['rsv_date']) ?></td>
                            <td><?= esc($r['rsv_heure']) ?></td>
                            <td><?= esc($r['rsv_nom']) ?></td>
                            <td><?= esc($r['rsv_lieu']) ?></td>

                            <td>
                                <?php if (!empty($r['participants'])) : ?>
                                    <?php foreach ($r['participants'] as $p) : ?>
                                        <span class="badge bg-primary me-1">
                                            <?= esc($p['pfl_prenom'].' '.$p['pfl_nom']) ?>
                                        </span>
                                    <?php endforeach; ?>
                                <?php else : ?>
                                    <span class="text-muted">Aucun</span>
                                <?php endif; ?>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                    </tbody>
                </table>
            </div>

        <?php endif; ?>
    </div>
</div>
