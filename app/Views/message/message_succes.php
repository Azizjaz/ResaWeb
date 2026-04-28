<div class="container mt-5 text-center">

    <h2 class="text-success">Merci ! Votre message a été envoyé.</h2>

    <p class="mt-3">Voici votre code de suivi :</p>

    <h3 class="text-primary fw-bold"><?= esc($code) ?></h3>


    <a href="<?= base_url('index.php/message/suivre/' . $code) ?>" 
       class="btn btn-outline-primary mt-4">
        Suivre ma demande
    </a>

</div>
