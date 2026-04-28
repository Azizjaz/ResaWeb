<div class="container mt-5" style="max-width:480px;">
    

    <form method="post" action="<?= base_url('index.php/message/formSuivre') ?>"
          class="p-4 shadow rounded"
          style="background:#0f1724; color:white; border:1px solid #1e2a38;">

        <label class="form-label">Entrez votre code :</label>
        <input type="text" name="code" class="form-control mb-2">

        <?php if (isset($erreur)): ?>
            <p class="text-danger small"><?= $erreur ?></p>
        <?php endif; ?>

        <button class="btn btn-primary w-100 mt-3">Valider</button>
    </form>
</div>
