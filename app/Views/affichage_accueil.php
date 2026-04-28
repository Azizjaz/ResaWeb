<section id="hero" class="hero section">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

  <div class="container" data-aos="fade-up" data-aos-delay="100">
    <div class="row gy-4 align-items-center">

      <div class="col-lg-8 order-2 order-lg-1">
        <div class="hero-content text-center">

          <?php if (isset($_GET['erreur']) && $_GET['erreur'] == "vide"): ?>
            <div class="alert alert-danger text-center mt-3">
                Veuillez entrer un code.
            </div>
          <?php endif; ?>

          <h1 data-aos="fade-up" data-aos-delay="200">
            Bienvenue dans l’univers du <span class="highlight">Padel</span> 🎾🔥
          </h1>

          <h2 data-aos="fade-up" data-aos-delay="300">
            Prêt(e) à jouer, progresser & t’éclater ?
            <span class="typed" data-typed-items="Débute, Progresse, Domine, Deviens un Pro"></span>
          </h2>

          <p data-aos="fade-up" data-aos-delay="400">
            Rejoins notre club et découvre des terrains modernes, du fun, des matchs entre amis, des tournois,
            du coaching, et tout ce qu’il faut pour kiffer le padel ! 💪
          </p>

          <div class="hero-actions" data-aos="fade-up" data-aos-delay="500">
            <a href="<?= base_url(); ?>index.php/reserver" class="btn btn-primary">Réserver un terrain</a>
            <a href="<?= base_url(); ?>index.php/coaching" class="btn btn-outline">Trouver un coach</a>
          </div>

          <div class="container-fluid my-5">
            <div class="card shadow-lg border-0">

              <div class="card-header text-white text-center py-3"
                style="background: linear-gradient(90deg, #4b6cb7 0%, #182848 100%);">
                <h3 class="mb-0">Actualités</h3>
              </div>

              <div class="card-body p-4">

                <?php if (! empty($actualites) && is_array($actualites)): ?>

                  <div class="table-responsive mt-4">
                    <table class="table table-hover table-bordered align-middle" style="width: 100%; font-size: 1rem;">
                      <thead class="table-dark text-center">
                        <tr>
                          <th style="width: 25%;">Intitulé</th>
                          <th style="width: 45%;">Texte</th>
                          <th style="width: 15%;">Date</th>
                          <th style="width: 15%;">Auteur</th>
                        </tr>
                      </thead>

                      <tbody>
                        <?php foreach ($actualites as $act): ?>
                          <tr>
                            <td class="fw-bold text-primary"><?= esc($act['act_titre']); ?></td>
                            <td><?= esc($act['act_contenu']); ?></td>
                            <td class="text-center text-light"><?= esc($act['act_date_pub']); ?></td>
                            <td class="text-center text-light"><?= esc($act['cpt_pseudo']); ?></td>
                          </tr>
                        <?php endforeach; ?>
                      </tbody>

                    </table>
                  </div>

                <?php else: ?>

                  <div class="alert alert-info text-center mt-4" style="font-size:1.2rem;">
                    Aucune actualité disponible pour le moment.
                  </div>

                <?php endif; ?>

              </div>
            </div>
          </div>

          <div class="social-links" data-aos="fade-up" data-aos-delay="600">
            <a href="#"><i class="bi bi-instagram"></i></a>
            <a href="#"><i class="bi bi-tiktok"></i></a>
            <a href="#"><i class="bi bi-youtube"></i></a>
          </div>

        </div>
      </div>

      <div class="col-lg-4 order-1 order-lg-2" id="contact">
        <div class="hero-image" data-aos="zoom-in" data-aos-delay="300">
          <div class="image-wrapper">
            <img src="<?= base_url(); ?>bootstrap/assets/img/profile/padel-player.webp"
                 alt="Padel Player"
                 class="img-fluid rounded shadow">
          </div>
        </div>
      </div>

    </div>
  </div>
</section>
