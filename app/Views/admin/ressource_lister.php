
<?php
// Fonction pour limiter un texte
function limit_text($text, $max = 100) {
    if ($text === null) return '';
    if (strlen($text) <= $max) return $text;
    return substr($text, 0, $max) . '...';
}
?>
<style>
    /* ===== CACHER LE MENU LATERAL UNIQUEMENT SUR CETTE PAGE ===== */
    #layoutSidenav_nav {
        display: none;
    }

    /* Le contenu doit prendre toute la largeur */
    #layoutSidenav #layoutSidenav_content {
        margin-left: 0 !important;
    }

    /* ===== IMAGES DES RESSOURCES (même taille pour toutes) ===== */
    .resource-img {
        width: 100%;
        height: 220px;      /* même hauteur pour toutes */
        object-fit: cover;  /* recadre sans déformer */
        display: block;
    }

    .resource-img-placeholder {
        width: 100%;
        height: 220px;
        background-color: #6c757d; /* gris bootstrap */
    }
</style>


<div class="container mt-5">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary">
            <i class="fa-solid fa-layer-group me-2"></i> Gestion des Ressources
        </h2>

        <a href="<?= base_url('index.php/admin/ressources/ajouter'); ?>" 
           class="btn btn-success shadow-sm">
            <i class="fa-solid fa-plus me-2"></i> Ajouter une ressource
        </a>
    </div>

    <?php if (empty($ressources)): ?>

        <div class="alert alert-info text-center py-4 fs-5 shadow">
            <i class="fa-solid fa-circle-info me-2"></i>
            Aucune ressource réservable pour l'instant !
        </div>

    <?php else: ?>

        <div class="row g-4">

            <?php foreach ($ressources as $r): ?>
                <div class="col-md-4">

                    <div class="card shadow-sm border-0 h-100">

                    <?php if (!empty($r->rsc_image)): ?>
    <img src="<?= base_url('bootstrap/assets/img/padel/' . $r->rsc_image); ?>"
         class="resource-img"
         alt="<?= esc($r->rsc_nom) ?>">
<?php else: ?>
    <div class="resource-img-placeholder"></div>
<?php endif; ?>




                        <div class="card-body">

                            <h5 class="card-title fw-bold"><?= esc($r->rsc_nom) ?></h5>

                            <p class="text-muted small">
                                <?= limit_text(esc($r->rsc_descriptif), 100) ?>
                            </p>

                            <p class="text-primary small mb-2">
                                <i class="fa-solid fa-boxes-stacked me-1"></i>
                                <?= limit_text(esc($r->rsc_liste_materiel), 70) ?>
                            </p>

                            <div class="d-flex justify-content-between mt-3">

                                <a href="#" class="btn btn-outline-primary btn-sm">
                                    <i class="fa-solid fa-eye"></i> Détails
                                </a>

                                <a href="<?= base_url('index.php/admin/ressources/supprimer/'.$r->rsc_id); ?>"
                                   onclick="return confirm('Supprimer cette ressource ?');"
                                   class="btn btn-danger btn-sm">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </div>

                        </div>

                    </div>

                </div>
            <?php endforeach; ?>

        </div>

    <?php endif; ?>

</div>
