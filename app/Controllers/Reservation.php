<?php

namespace App\Controllers;

use App\Models\Db_model;

class Reservation extends BaseController
{
    public function seances()
    {
        $session = session();

        // Accès seulement si connecté (admin OU membre)
        if (! $session->has('user')) {
            return redirect()->to(base_url('index.php/compte/connecter'));
        }

        helper('form');

        $model = new Db_model();

        // Date envoyée par le formulaire
        $date = $this->request->getPost('date_reservation');

        // Si 1er affichage ou date vide -> aujourd'hui
        if (empty($date)) {
            $date = date('Y-m-d');
        }

        // Récupération des réservations du jour
        $reservations = $model->get_reservations_by_date($date);

        // Regrouper par ressource (clé = nom de la ressource)
        $reservations_par_ressource = [];
        foreach ($reservations as $res) {
            $nomR = $res['rsc_nom'];
            if (! isset($reservations_par_ressource[$nomR])) {
                $reservations_par_ressource[$nomR] = [];
            }
            $reservations_par_ressource[$nomR][] = $res;
        }

        $data = [
            'date_selectionnee'        => $date,
            'reservations_par_ressource' => $reservations_par_ressource,
        ];

        // Affichage avec le menu admin (comme le reste du back-office)
        echo view('templates/haut2');
        echo view('menu_admin');              // si tu as un menu_membre, tu pourras le gérer plus tard
        echo view('reservation/seances_jour', $data);
        echo view('templates/bas2');
    }
}
