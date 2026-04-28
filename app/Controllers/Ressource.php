<?php

namespace App\Controllers;

use App\Models\Db_model;

class Ressource extends BaseController
{
    private function checkAdmin()
    {
        $session = session();
        if (! $session->has('user') || $session->get('statut') !== 'A') {
            return false;
        }
        return true;
    }

    // ========================
    //   GESTION DES RESSOURCES
    // ========================
    public function gestion()
    {
        if (! $this->checkAdmin()) {
            return redirect()->to(base_url('index.php/accueil/afficher'));
        }

        $model = new Db_model();
        $data['ressources'] = $model->get_all_ressources();

        echo view('templates/haut2');
        echo view('menu_admin');
        echo view('admin/ressource_lister', $data);
        echo view('templates/bas2');
    }


    // ========================
    //        AJOUTER
    // ========================
    public function ajouter()
    {
        // Sécurité : réservé admin
        if (! $this->checkAdmin()) {
            return redirect()->to(base_url('index.php/accueil/afficher'));
        }
    
        helper('form');
        $model = new Db_model();
        $data  = [];   // pour passer un message d’erreur éventuel à la vue
    
        // ---------------------------
        //  CAS POST : bouton "Enregistrer" cliqué
        // ---------------------------
        // On teste simplement si le champ "nom" est présent dans le POST
        if ($this->request->getPost('nom') !== null) {
    
            $nom        = trim($this->request->getPost('nom') ?? '');
            $jmin       = $this->request->getPost('jauge_min');
            $jmax       = $this->request->getPost('jauge_max');
            $image      = trim($this->request->getPost('image') ?? '');
            $descriptif = $this->request->getPost('descriptif');
            $materiel   = $this->request->getPost('materiel');
    
            // Vérif très simple : champs obligatoires
            if ($nom === '' || $jmin === '' || $jmax === '') {
                $data['erreurs'] = "<ul><li>Nom, jauge min et jauge max sont obligatoires.</li></ul>";
            } else {
    
                // si aucun nom d'image → on met une chaîne vide (colonne NOT NULL possible)
                if ($image === '') {
                    $image = 'default.jpg';   // tu peux mettre 'padel1.jpg' si tu veux une image par défaut
                }
    
                // Insertion en base en utilisant TA fonction insert_ressource
                $ok = $model->insert_ressource($nom, $image, $jmin, $jmax, $descriptif, $materiel);
    
                if ($ok) {
                    // Succès → retour à la liste des ressources
                    return redirect()->to(base_url('index.php/admin/ressources'));
                } else {
                    $data['erreurs'] = "<ul><li>Erreur lors de l'enregistrement en base.</li></ul>";
                }
            }
        }
    
        // ---------------------------
        //  CAS GET (ou POST avec erreurs) : on affiche / réaffiche le formulaire
        // ---------------------------
        return view('templates/haut2')
             . view('menu_admin')
             . view('admin/ressource_ajouter', $data)
             . view('templates/bas2');
    }
    
    

    // ========================
    //        SUPPRIMER
    // ========================
    public function supprimer($id)
    {
        if (! $this->checkAdmin()) {
            return redirect()->to(base_url('index.php/accueil/afficher'));
        }

        $model = new Db_model();
        $model->delete_ressource($id);

        return redirect()->to(base_url('index.php/admin/ressources'));
    }
}
