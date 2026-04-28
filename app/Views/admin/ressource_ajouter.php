<div class="container mt-4" style="max-width:650px">

    <h2 class="mb-4">Ajouter une ressource</h2>

    <?php if (isset($erreurs)): ?>
        <div class="alert alert-danger"><?= $erreurs ?></div>
    <?php endif; ?>

    <form method="post" action="">
        <?= csrf_field() ?>

        <div class="mb-3">
            <label class="form-label">Nom *</label>
            <input type="text" name="nom" class="form-control" value="<?= set_value('nom') ?>">
        </div>

        <div class="row">
            <div class="mb-3 col">
                <label class="form-label">Jauge min *</label>
                <input type="number" name="jauge_min" class="form-control" value="<?= set_value('jauge_min') ?>">
            </div>
            <div class="mb-3 col">
                <label class="form-label">Jauge max *</label>
                <input type="number" name="jauge_max" class="form-control" value="<?= set_value('jauge_max') ?>">
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Image (nom du fichier, optionnel)</label>
            <input type="text" name="image" class="form-control" value="<?= set_value('image') ?>">
        </div>

        <div class="mb-3">
            <label class="form-label">Descriptif</label>
            <textarea name="descriptif" class="form-control"><?= set_value('descriptif') ?></textarea>
        </div>

        <div class="mb-3">
            <label class="form-label">Liste matériel</label>
            <textarea name="materiel" class="form-control"><?= set_value('materiel') ?></textarea>
        </div>

        <button class="btn btn-success">Enregistrer</button>
        <a href="<?= base_url('index.php/admin/ressources'); ?>" class="btn btn-secondary">
            Annuler
        </a>

    </form>

</div>
