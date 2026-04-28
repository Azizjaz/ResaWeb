<?php
namespace App\Controllers;

use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;

class Accueil extends BaseController
{
    public function afficher()
    {
        // Chargement du modèle
        $model = model(\App\Models\Db_model::class);

        // Récupération uniquement des actualités publiées (act_etat = 'P')
        $data['actualites'] = $model->get_actualites_publiees();

        // Chargement de la vue complète
        return view('templates/haut')
            . view('menu_visiteur')
            . view('affichage_accueil', $data)
            . view('templates/bas');
    }
}
