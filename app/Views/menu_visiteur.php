<!-- NAVBAR STYLE DIRECTEMENT DANS LE FICHIER -->
<style>
    nav {
        background: linear-gradient(90deg, #4b6cb7 0%, #182848 100%);
        padding: 14px 0;
    }

    .navbar-container {
        width: 90%;
        margin: 0 auto;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    /* Logo */
    .logo {
        color: white;
        font-size: 1.8rem;
        font-weight: bold;
        text-decoration: none;
    }

    /* Liens */
    .nav-links {
        display: flex;
        gap: 35px;
        list-style: none;
        margin: 0;
        padding: 0;
    }

    .nav-links a {
        color: white;
        text-decoration: none;
        font-size: 1.2rem;
        font-weight: 500;
        padding: 6px 12px;
        border-radius: 6px;
        transition: 0.2s ease-in-out;
    }

    .nav-links a:hover {
        background: rgba(255, 255, 255, 0.15);
    }

    /* Lien actif */
    .active-link {
        background: rgba(255,255,255,0.25);
        border-radius: 6px;
    }

</style>

<!-- NAVBAR HTML -->
<nav>
    <div class="navbar-container">

        <!-- Logo -->
        <a href="<?= base_url('/') ?>" class="logo">ResaWeb</a>

        <!-- Liens -->
        <ul class="nav-links">

            <li>
              <a href="<?= base_url('/') ?>">Accueil</a>
            </li>

            <li>
                <a href="<?= base_url('index.php/message/formSuivre') ?>">
                    Suivre une demande
                </a>
            </li>

            <li>
                <a href="<?= base_url('index.php/message/creer') ?>">
                    Faire une demande
                </a>
            </li>

            <li>
                <a href="<?= base_url('index.php/compte/connecter') ?>">
                    Se connecter
                </a>
            </li>

        </ul>

    </div>
</nav>
