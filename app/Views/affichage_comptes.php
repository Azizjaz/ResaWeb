<div class="container mt-5">

    <h1 class="text-center mb-4" style="color:#ffffff; font-weight:700;">
        <?php echo $titre; ?>
    </h1>

    <p class="text-center" style="color:#0d6efd; font-size:18px; margin-bottom:30px;">
        Nombre total de comptes :
        <strong><?php echo $nb->total; ?></strong>
    </p>

    <?php if (!empty($logins) && is_array($logins)): ?>

        <div class="card p-4 shadow"
             style="background-color:#0f1724; border:1px solid #1e2a38; border-radius:12px;">

            <h4 style="color:white; margin-bottom:20px;">
                Comptes enregistrés
            </h4>

            <?php foreach ($logins as $pseudos): ?>
                <div style="
                    padding:10px 15px; 
                    margin-bottom:8px;
                    background:#1e293b; 
                    border-radius:8px;
                    color:white;
                    font-size:17px;">
                    • <?php echo $pseudos['cpt_pseudo']; ?>
                </div>
            <?php endforeach; ?>

        </div>

    <?php else: ?>

        <h3 class="text-center" style="color:white;">Aucun compte pour le moment.</h3>

    <?php endif; ?>

</div>
