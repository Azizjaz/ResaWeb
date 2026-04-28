<div class="container mt-5" style="max-width:700px;">

    

    <?php if (isset($erreur)): ?>
        <div class="alert alert-danger text-center mb-4">
            <?= esc($erreur) ?>
        </div>
    <?php endif; ?>

    <?php if (empty($msg)): ?>

        <div class="p-4 shadow rounded text-center"
             style="background:#0f1724; color:white; border:1px solid #1e2a38;">

            <p class="mb-2">Aucun message trouvé pour ce code.</p>

            <?php if (!empty($code)): ?>
                <p class="text-warning"><strong><?= esc($code) ?></strong></p>
            <?php endif; ?>

            <a href="<?= base_url('index.php/message/suivre') ?>" 
               class="btn btn-outline-light mt-3">
                Réessayer
            </a>
        </div>

    <?php else: ?>

        <div class="container mt-5" style="max-width:700px;">

    <h2 class="text-center text-info mb-4">Suivi de votre demande</h2>

    <?php if (isset($erreur)): ?>
        <div class="alert alert-danger text-center mb-4">
            <?= esc($erreur) ?>
        </div>
    <?php endif; ?>

    <?php if (empty($msg)): ?>

        <div class="p-4 shadow rounded text-center"
             style="background:#0f1724; color:white; border:1px solid #1e2a38;">

            <p class="mb-2">Aucun message trouvé pour ce code.</p>

            <?php if (!empty($code)): ?>
                <p class="text-warning"><strong><?= esc($code) ?></strong></p>
            <?php endif; ?>

            <a href="<?= base_url('index.php/message/suivre') ?>" 
               class="btn btn-outline-light mt-3">
                Réessayer
            </a>
        </div>

    <?php else: ?>

        <div class="p-4 shadow rounded"
             style="background:#0f1724; color:white; border:1px solid #1e2a38;">

            <!-- OBJET -->
            <p><strong>Objet :</strong><br><?= esc($msg['msg_intitule']) ?></p>

            <!-- MESSAGE -->
            <p class="mt-3"><strong>Message :</strong><br><?= esc($msg['msg_contenu']) ?></p>

            <!-- ID DE L'ADMIN -->
            <p class="mt-3"><strong>Répondeur (ID Admin) :</strong><br>
                <?php if (!empty($msg['cpt_id'])): ?>
                    <?= esc($msg['cpt_id']) ?>
                <?php else: ?>
                    <em class="text-warning">Admin n'a pas encore répondu</em>
                <?php endif; ?>
            </p>

            <!-- RÉPONSE -->
            <p class="mt-3"><strong>Réponse :</strong><br>
                <?= empty($msg['msg_reponse']) 
                    ? "<em class='text-muted'>Pas encore de réponse…</em>" 
                    : esc($msg['msg_reponse']) ?>
            </p>

            <!-- STATUT — version sans msg_statut -->
            <p class="mt-3"><strong>Statut :</strong><br>
                <?= empty($msg['msg_reponse']) 
                    ? "<span class='text-warning'>En attente</span>" 
                    : "<span class='text-success'>Traité</span>" ?>
            </p>

        </div>

    <?php endif; ?>

</div>


    <?php endif; ?>

</div>
