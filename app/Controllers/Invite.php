<?php
namespace App\Controllers;

use App\Models\Db_model;

class Invite extends BaseController
{
    public function accueil()
    {
        $session = session();

        // Protection : uniquement les invités
        if (! $session->has('user') || $session->get('statut') != 'D') {
            return redirect()->to(base_url('index.php/accueil/afficher'));
        }

        // On récupère les réservations de l’invité
        $model = new Db_model();
        $reservations = $model->get_reservations_membre($session->get('cpt_id'));

        $data = [
            'pseudo'       => $session->get('user'),
            'reservations' => $reservations
        ];

        // CORRECTION ICI : on ajoute $data comme 2ème paramètre
        return view('templates/haut_invite', $data) 
             . view('invite/accueil', $data) 
             . view('templates/bas2');
    }
}
