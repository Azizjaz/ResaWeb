<div class="container mt-4">

    <h2 class="mb-4">Réservations</h2>

    <!-- Formulaire choix de la date -->
    <form method="post" class="mb-4 d-flex align-items-center gap-3">
        <div>
            <label for="date_reservation" class="form-label mb-0">Sélectionner une date :</label>
            <input type="date"
                   id="date_reservation"
                   name="date_reservation"
                   class="form-control"
                   value="<?= esc($date_selectionnee) ?>">
        </div>

        <div class="mt-4">
            <button class="btn btn-primary mt-2">
                Voir les réservations
            </button>
        </div>
    </form>

    <?php if (empty($reservations_par_ressource)) : ?>

        <div class="alert alert-info">
            Aucune réservation pour l'instant !
        </div>

    <?php else : ?>

        <?php foreach ($reservations_par_ressource as $nomRessource => $liste) : ?>

            <div class="card mb-4 shadow-sm">
                <div class="card-header bg-primary text-white">
                    <strong><?= esc($nomRessource) ?></strong>
                </div>

                <div class="card-body">

                    <?php foreach ($liste as $r) : ?>
                        <div class="mb-3 pb-3 border-bottom">

                            <p class="mb-1">
                                <strong>Horaire :</strong>
                                <?= substr($r['rsv_heure'], 0, 5) ?>
                            </p>

                            <p class="mb-1">
                                <strong>Lieu :</strong>
                                <?= esc($r['rsv_lieu']) ?>
                            </p>

                            <p class="mb-1">
                                <strong>Statut :</strong>
                                <?= esc($r['rsc_statut']) ?>
                            </p>

                            <p class="mb-1">
                                <strong>Matériel :</strong>
                                <?= esc($r['rsc_liste_materiel']) ?>
                            </p>

                            <p class="mb-1">
                                <strong>Description :</strong>
                                <?= esc($r['rsc_descriptif']) ?>
                            </p>

                            <p class="mb-0">
                                <strong>Participants :</strong>
                                <?php if (!empty($r['liste_participants'])) : ?>
                                    <?= esc($r['liste_participants']) ?>
                                <?php else : ?>
                                    <em>Aucun participant inscrit.</em>
                                <?php endif; ?>
                            </p>

                        </div>
                    <?php endforeach; ?>

                </div>
            </div>

        <?php endforeach; ?>

    <?php endif; ?>

</div>
