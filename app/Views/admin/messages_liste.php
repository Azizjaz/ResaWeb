<?php
// $messages : tableau contenant les messages visiteurs
// $nb_non_traites : nombre de messages sans réponse
?>
<style>
    .page-title-icon {
        width: 42px;
        height: 42px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        background: #0d6efd1a;
        color: #0d6efd;
        margin-right: .6rem;
        font-size: 1.2rem;
    }
</style>

<div class="container my-5">

    <div class="row justify-content-center">
        <div class="col-lg-10">

            <!-- Titre + compteurs -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                
                <div class="d-flex align-items-center">
                    <div class="page-title-icon">
                        <i class="fas fa-envelope-open-text"></i>
                    </div>
                    <div>
                        <h2 class="mb-0">Messages visiteurs</h2>
                        <small class="text-muted">
                            Gestion des demandes reçues via le formulaire de contact
                        </small>
                    </div>
                </div>

                <!-- COMPTEURS -->
                <div class="d-flex align-items-center gap-2">

                    <!-- Badge messages non traités -->
                    <span class="badge bg-danger fs-6">
                        <?= $nb_non_traites ?> non traité<?= $nb_non_traites > 1 ? 's' : '' ?>
                    </span>

                    <!-- Badge nombre total -->
                    <span class="badge bg-primary fs-6">
                        <?= count($messages) ?> message<?= count($messages) > 1 ? 's' : '' ?>
                    </span>
                </div>
            </div>

            <!-- Carte contenant le tableau -->
            <div class="card shadow-sm border-0">

                <div class="card-body p-0">
                    <?php if (empty($messages)) : ?>

                        <div class="p-4 text-center text-muted">
                            <i class="fas fa-inbox fa-2x mb-3"></i>
                            <p class="mb-0">Aucun message pour l’instant.</p>
                        </div>

                    <?php else : ?>

                        <div class="table-responsive">
                            <table class="table table-hover mb-0 align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Objet</th>
                                        <th>Email</th>
                                        <th style="width: 35%;">Contenu</th>
                                        <th>Réponse</th>
                                        <th class="text-center">Action</th>
                                    </tr>
                                </thead>

                                <tbody>
                                <?php foreach ($messages as $m) : ?>
                                    <tr>

                                        <td><strong><?= esc($m['msg_intitule']) ?></strong></td>

                                        <td>
                                            <a href="mailto:<?= esc($m['msg_email']) ?>">
                                                <?= esc($m['msg_email']) ?>
                                            </a>
                                        </td>

                                        <td>
                                            <?= esc(mb_strimwidth($m['msg_contenu'], 0, 80, '…', 'UTF-8')) ?>
                                        </td>

                                        <td>
                                            <?php if (!empty($m['msg_reponse'])) : ?>
                                                <span class="badge bg-success">
                                                    <i class="fas fa-check-circle me-1"></i> Répondu
                                                </span>
                                            <?php else : ?>
                                                <span class="badge bg-danger">
                                                    <i class="fas fa-circle-exclamation me-1"></i> Non répondu
                                                </span>
                                            <?php endif; ?>
                                        </td>

                                        <td class="text-center">

                                            <?php if (empty($m['msg_reponse'])) : ?>

                                                <a href="<?= base_url('index.php/admin/message_repondre/'.$m['msg_id']); ?>"
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="fas fa-reply"></i> Répondre
                                                </a>

                                            <?php else : ?>

                                                <span class="badge bg-secondary">
                                                    <i class="fas fa-check"></i> Déjà répondu
                                                </span>

                                            <?php endif; ?>
                                        </td>

                                    </tr>
                                <?php endforeach; ?>
                                </tbody>

                            </table>
                        </div>

                    <?php endif; ?>
                </div>

                <div class="card-footer text-muted small">
                    Dernière mise à jour : <?= date('d/m/Y à H:i') ?>
                </div>
            </div>

        </div>
    </div>

</div>
