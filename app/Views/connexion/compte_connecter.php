<div class="d-flex justify-content-center align-items-center" 
     style="min-height: 80vh; background-color:#111826;">

    <div class="card shadow-lg border-0" style="width: 380px; border-radius: 15px;">
        
        <div class="card-header bg-dark text-white text-center" 
             style="border-top-left-radius: 15px; border-top-right-radius: 15px;">
            <h3 class="mt-2 mb-2">
                <i class="fa-solid fa-right-to-bracket me-2"></i>Connexion
            </h3>
        </div>

        <div class="card-body p-4">

            <?php if (isset($erreur)) : ?>
                <div class="alert alert-danger text-center mb-3">
                    <?= esc($erreur) ?>
                </div>
            <?php endif; ?>

            <form action="<?= base_url('index.php/compte/connecter') ?>" method="post">

                <div class="mb-3">
                    <label class="form-label">Pseudo</label>
                    <input type="text" 
                           class="form-control form-control-lg" 
                           name="pseudo" 
                           required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Mot de passe</label>
                    <input type="password" 
                           class="form-control form-control-lg" 
                           name="mdp" 
                           required>
                </div>

                <button class="btn btn-primary w-100 btn-lg mt-2" type="submit">
                    <i class="fa-solid fa-arrow-right-to-bracket me-1"></i>
                    Se connecter
                </button>

            </form>

        </div>

        <div class="card-footer text-center bg-light small" 
             style="border-bottom-left-radius:15px;border-bottom-right-radius:15px;">
            © <?= date('Y') ?> Padel Club · Tous droits réservés
        </div>

    </div>

</div>
