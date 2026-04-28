<?php helper('form'); ?>

<style>
    body {
        background: #f5f7fa;
        font-family: "Segoe UI", Roboto, sans-serif;
    }

    .reply-container {
        max-width: 950px;
        margin: 40px auto;
        padding: 35px 45px;
        background: #ffffff;
        border-radius: 18px;
        box-shadow: 0 6px 25px rgba(0,0,0,0.08);
    }

    .reply-title {
        font-size: 28px;
        font-weight: 700;
        color: #0a1a2a;
        margin-bottom: 25px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .reply-title i {
        font-size: 22px;
        color: #0a1a2a;
    }

    .reply-label {
        font-weight: 600;
        color: #0a1a2a;
        margin-top: 15px;
        display: block;
    }

    .reply-value {
        color: #333;
        margin-bottom: 12px;
        display: block;
    }

    .reply-textarea {
        width: 100%;
        border: 1px solid #cfd6dd;
        border-radius: 10px;
        padding: 12px 14px;
        resize: vertical;
        min-height: 150px;
        font-size: 15px;
    }

    .reply-btn {
        margin-top: 20px;
        background: #0a1a2a;
        color: #fff;
        padding: 12px 26px;
        border-radius: 10px;
        border: none;
        font-size: 15px;
        cursor: pointer;
        transition: 0.3s ease;
    }

    .reply-btn:hover {
        background: #102840;
    }

    .error-message {
        color: #cc0000;
        font-weight: 600;
        padding: 10px 0;
    }
</style>

<div class="reply-container">

    <h2 class="reply-title">
        <i class="fa-solid fa-reply"></i>
        Répondre à la demande
    </h2>

    <span class="reply-label">Objet :</span>
    <span class="reply-value"><?= esc($message['msg_intitule']) ?></span>

    <span class="reply-label">Email :</span>
    <span class="reply-value"><?= esc($message['msg_email']) ?></span>

    <span class="reply-label">Contenu :</span>
    <span class="reply-value"><?= esc($message['msg_contenu']) ?></span>

    <hr style="margin:25px 0;">

    <?php if (isset($erreur)) : ?>
        <p class="error-message"><?= esc($erreur) ?></p>
    <?php endif; ?>

    <?= form_open('admin/message_repondre/' . $message['msg_id']) ?>

        <label class="reply-label">Votre réponse :</label>
        <textarea name="reponse" class="reply-textarea"><?= old('reponse') ?></textarea>

        <button type="submit" class="reply-btn">
            Envoyer la réponse
        </button>

    </form>
</div>
