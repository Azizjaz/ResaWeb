<div class="container mt-5">
  <h2 class="text-center mb-4">Suivi de votre message</h2>

  <?php if (isset($erreur)): ?>
    <div class="alert alert-danger text-center">
      <?= esc($erreur); ?>
    </div>
  <?php else: ?>
    <div class="card shadow p-4">
      <p><strong>Code :</strong> <?= esc($message['msg_code']); ?></p>
      <p><strong>Intitulé :</strong> <?= esc($message['msg_intitule']); ?></p>
      <p><strong>Contenu :</strong> <?= esc($message['msg_contenu']); ?></p>
      <p><strong>Réponse :</strong>
        <?= $message['msg_reponse'] ? esc($message['msg_reponse']) : '<em>Pas encore de réponse</em>'; ?>
      </p>
    </div>
  <?php endif; ?>
</div>
