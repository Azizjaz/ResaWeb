<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-7">

            <div class="card p-4 shadow-lg text-center"
                 style="background-color:#0f1724; 
                        border:1px solid #1e2a38;
                        border-radius:12px;">

                <h2 style="color:#0d6efd; font-weight:700; margin-bottom:20px;">
                    ✔ Compte créé avec succès
                </h2>

                <p style="color:#ffffff; font-size:18px;">
                    Bravo ! Formulaire rempli, le compte suivant a été ajouté :
                </p>

                <div style="margin-top:15px; margin-bottom:15px; 
                            padding:10px 20px; 
                            background:#1e293b; 
                            border-radius:8px;
                            display:inline-block;">
                    <span style="color:#0d6efd; font-size:20px; font-weight:600;">
                        <?php echo $le_compte; ?>
                    </span>
                </div>

                <p style="color:#cbd5e1; margin-top:10px; font-size:17px;">
                    <?php echo $le_message; ?>
                    <span style="color:#0d6efd; font-weight:700;">
                        <?php echo $le_total->total; ?>
                    </span>
                </p>

                <a href="<?= base_url('index.php/accueil/afficher') ?>"
                   class="btn mt-3"
                   style="background-color:#1e293b; 
                          color:white; 
                          padding:10px 20px;
                          border-radius:8px;">
                    ⬅ Retour à l’accueil
                </a>

            </div>

        </div>
    </div>
</div>
