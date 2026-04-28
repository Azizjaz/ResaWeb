<div class="container mt-5" style="max-width:480px; margin:auto;">

    <h2 class="text-center text-info mb-4">Envoyer une demande</h2>

    <form method="post"
          action="<?= base_url('index.php/message/creer') ?>"
          class="p-4 shadow rounded"
          style="background:#0f1724; color:white; border:1px solid #1e2a38;"
          novalidate>

        <?= csrf_field() ?>

        <!-- EMAIL -->
        <label class="form-label">Email</label>
        <input type="email"
               name="email"
               class="form-control mb-2"
               value="<?= old('email') ?>">

        <?php if (isset($validation) && $validation->hasError('email')): ?>
            <p class="text-danger small"><?= $validation->getError('email') ?></p>
        <?php endif; ?>


        <!-- OBJET -->
        <label class="form-label mt-3">Objet</label>
        <input type="text"
               name="objet"
               class="form-control mb-2"
               value="<?= old('objet') ?>">

        <?php if (isset($validation) && $validation->hasError('objet')): ?>
            <p class="text-danger small"><?= $validation->getError('objet') ?></p>
        <?php endif; ?>


        <!-- CONTENU -->
        <label class="form-label mt-3">Contenu</label>
        <textarea name="contenu"
                  class="form-control mb-2"
                  rows="4"><?= old('contenu') ?></textarea>

        <?php if (isset($validation) && $validation->hasError('contenu')): ?>
            <p class="text-danger small"><?= $validation->getError('contenu') ?></p>
        <?php endif; ?>


        <!-- BOUTON -->
        <button class="btn btn-primary w-100 mt-4">Envoyer</button>

    </form>
</div>
