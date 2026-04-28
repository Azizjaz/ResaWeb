<?php

namespace App\Controllers;

use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;

class Compte extends BaseController
{
    protected $model;

    public function __construct()
    {
        helper('form');
        $this->model = model(Db_model::class);
    }

    /**
     * Création simple d'un compte (non utilisé dans sprint admin)
     */
    public function lister()
    {
        $data['titre']  = "Liste de tous les comptes";
        $data['logins'] = $this->model->get_all_compte();
        $data['nb']     = $this->model->get_nb_compte();

        return view('templates/haut', $data)
            . view('affichage_comptes')
            . view('templates/bas');
    }

    public function creer()
    {
        if ($this->request->getMethod() == "POST")
        {
            if (! $this->validate([
                'pseudo' => 'required|max_length[255]|min_length[2]',
                'mdp'    => 'required|max_length[255]|min_length[8]'
            ]))
            {
                return view('templates/haut', ['titre' => 'Créer un compte'])
                    . view('compte/compte_creer')
                    . view('templates/bas');
            }

            $recuperation = $this->validator->getValidated();
            $this->model->set_compte($recuperation);

            $data['le_compte']  = $recuperation['pseudo'];
            $data['le_message'] = "Nouveau nombre de comptes : ";
            $data['le_total']   = $this->model->get_nb_compte();

            return view('templates/haut', $data)
                . view('compte/compte_succes', $data)
                . view('templates/bas');
        }

        return view('templates/haut', ['titre' => 'Créer un compte'])
            . view('compte/compte_creer')
            . view('templates/bas');
    }



    public function connecter()
    {
        if ($this->request->getMethod() == "POST")
        {
            if (! $this->validate([
                'pseudo' => 'required',
                'mdp'    => 'required'
            ])) {
                return view('templates/haut', ['titre' => 'Se connecter'])
                    . view('connexion/compte_connecter')
                    . view('templates/bas');
            }

            $username = $this->request->getVar('pseudo');
            $password = $this->request->getVar('mdp');

            // Vérification dans la base (admin OU membre)
            $compte = $this->model->connect_compte($username, $password);



            if ($compte !== null) {
                $session = session();
                $session->set('user', $compte->cpt_pseudo);
                $session->set('statut', $compte->pfl_role);
                $session->set('cpt_id', $compte->cpt_id);

                if ($compte->pfl_role == 'A') {
                    return redirect()->to(base_url('index.php/admin/accueil'));
                }
                if ($compte->pfl_role == 'M') {
                    return redirect()->to(base_url('index.php/compte/accueil_membre'));
                }
            }

            // Tentative connexion invité
            $invite = $this->model->connect_invite($username, $password);

            if ($invite !== null) {
                $session = session();
                $session->set('user', $invite->cpt_pseudo);
                $session->set('statut', 'D');
                $session->set('cpt_id', $invite->cpt_id);

                return redirect()->to(base_url('index.php/invite/accueil'));
            }

            // Sinon erreur
            $data['erreur'] = 'Identifiants erronés !';
            return view('connexion/compte_connecter', $data);





            // Si identifiants incorrects :
            return view('templates/haut', ['titre' => 'Se connecter'])
                . view('connexion/compte_connecter', ['erreur' => "Identifiants erronés ou inexistants !"])
                . view('templates/bas');
        }

        return view('templates/haut', ['titre' => 'Se connecter'])
            . view('connexion/compte_connecter')
            . view('templates/bas');
    }


    public function accueil_admin()
    {
        $session = session();

        // PROTECTION ADMIN
        if (! $session->has('user') || $session->get('statut') != 'A')
        {
            return redirect()->to(base_url('index.php/accueil/afficher'));
        }

        $cpt_id = $session->get('cpt_id');

        // Réservations
        $data['reservations'] = $this->model->get_reservations_admin($cpt_id);

        return view('templates/haut2')
            . view('connexion/compte_accueil_admin', $data)
            . view('templates/bas2');
    }



    public function gestion_comptes()
    {
        $session = session();

        if (! $session->has('user') || $session->get('statut') != 'A')
        {
            return redirect()->to(base_url('index.php/accueil/afficher'));
        }

        $data['comptes'] = $this->model->get_comptes_profils();

        return view('templates/haut2')
            . view('admin/comptes_liste', $data)
            . view('templates/bas2');
    }


    public function ajouter_invite()
    {
        $session = session();

        if (! $session->has('user') || $session->get('statut') != 'A')
        {
            return redirect()->to(base_url('index.php/accueil/afficher'));
        }

        if ($this->request->getMethod() == "POST")
        {
            if (! $this->validate([
                'pseudo' => 'required|min_length[2]|max_length[255]',
                'mdp'    => 'required|min_length[8]|max_length[255]'
            ]))
            {
                return view('templates/haut2')
                    . view('admin/ajouter_invite', ['validation' => $this->validator])
                    . view('templates/bas2');
            }

            $pseudo = $this->request->getPost('pseudo');
            $mdp    = $this->request->getPost('mdp');

            // Vérification doublon
            $existe = $this->model->compte_existe($pseudo);

            if ($existe > 0)
            {
                return view('templates/haut2')
                    . view('admin/ajouter_invite', ['erreur' => "Ce compte existe déjà !"])
                    . view('templates/bas2');
            }

            // Création compte invité
            $this->model->inserer_compte_invite($pseudo, $mdp);

            // Rafraîchir la liste
            $data['comptes'] = $this->model->get_comptes_profils();
            $data['message'] = "Compte invité créé avec succès.";

            return view('templates/haut2')
                . view('admin/comptes_liste', $data)
                . view('templates/bas2');
        }

        return view('templates/haut2')
            . view('admin/ajouter_invite')
            . view('templates/bas2');
    }



    public function afficher_profil()
    {
        $session = session();

        // Si pas connecté : retour connexion
        if (! $session->has('user')) {
            return view('templates/haut', ['titre' => 'Se connecter'])
                . view('connexion/compte_connecter')
                . view('templates/bas');
        }

        $cpt_id = $session->get('cpt_id');

        $data['profil'] = $this->model->get_profil_admin($cpt_id);

        // ADMIN
        if ($session->get('statut') == 'A') {
            return view('templates/haut2')

                . view('connexion/compte_profil', $data)
                . view('templates/bas2');
        }

        // MEMBRE
        return view('templates/haut2')
            . view('connexion/compte_profil', $data)
            . view('templates/bas2');
    }


    

    public function deconnecter()
    {
        $session = session();
        $session->destroy();

        return view('templates/haut', ['titre' => 'Se connecter'])
            . view('connexion/compte_connecter')
            . view('templates/bas');
    }
    public function accueil_membre()
    {
        $session = session();

        // Protection membre
        if (! $session->has('user') || $session->get('statut') != 'M') {
            return redirect()->to(base_url('index.php/accueil/afficher'));
        }

        $cpt_id = $session->get('cpt_id');

        // récupérer les réservations du membre
        $data['reservations'] = $this->model->get_reservations_membre($cpt_id);

        return view('templates/haut2')
            . view('connexion/compte_accueil_membre', $data)
            . view('templates/bas2');
    }

        public function liste_adherents()
    {   
        $session = session();

        if (! $session->has('user') || $session->get('statut') != 'M') {
            return redirect()->to(base_url('index.php/accueil/afficher'));
        }

        $data['adherents'] = $this->model->get_adherents();

        return view('templates/haut2')
            . view('membre/adherents_liste', $data)
            . view('templates/bas2');
    }






}
