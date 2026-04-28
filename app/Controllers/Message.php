<?php
namespace App\Controllers;

use App\Models\Db_model;

class Message extends BaseController
{
    public function afficher($code = null)
    {
        $model = new Db_model();

        if ($code === null) {
            return redirect()->to('https://obiwan.univ-brest.fr/~e22307806/index.php/accueil/afficher');
        }

        $data['message'] = $model->get_message_by_code($code);

        if (empty($data['message'])) {
            $data['erreur'] = "Aucun message trouvé pour le code : " . esc($code);
        }

        
        echo view('templates/haut');
        echo view('menu_visiteur');
        echo view('affichage_message', $data);
        echo view('templates/bas');
    }

    public function creer()
{
    helper('form');
    $model = model(Db_model::class);

    if ($this->request->getMethod() == "POST")
    {
        if (! $this->validate(
            [
                'email'   => 'required|valid_email|max_length[255]',
                'objet'   => 'required|max_length[255]',
                'contenu' => 'required|max_length[1000]'
            ],
            [
                'email' => [
                    'required'    => 'Veuillez entrer votre adresse e-mail.',
                    'valid_email' => 'Veuillez saisir une adresse e-mail valide.',
                    'max_length'  => 'L’adresse e-mail dépasse la longueur maximale autorisée.'
                ],

                'objet' => [
                    'required'    => 'Veuillez entrer un objet.',
                    'max_length'  => 'L’objet ne doit pas dépasser 255 caractères.'
                ],

                'contenu' => [
                    'required'    => 'Veuillez entrer un contenu.',
                    'max_length'  => 'Le message ne doit pas dépasser 1000 caractères.'
                ]
            ]
        ))
        {
            return view('menu_visiteur')
                . view('templates/haut', ['titre' => 'Envoyer une demande'])
                . view('message/message_creer', [
                    'validation' => $this->validator  
                ])
                . view('templates/bas');
        }

        $data = $this->validator->getValidated();
        $code = $model->set_message_simple(
            $data['objet'],
            $data['contenu'],
            $data['email']
        );
        

        return view('menu_visiteur') 
            . view('templates/haut')
            . view('message/message_succes', ['code' => $code])
            . view('templates/bas');
    }

    
    return view('menu_visiteur')
        . view('templates/haut', ['titre' => 'Envoyer une demande'])
        . view('message/message_creer')
        . view('templates/bas');
}






    public function suivre($code = null)
{
    $model = model(Db_model::class);

    // 1) Si aucun code retour accueil avec erreur
    if ($code == null) {
        return view('menu_visiteur')
            . view('templates/haut')
            . view('affichage_accueil')
            . view('templates/bas');
    }

    // 2) Si la longueur n’est pas de 20 rester sur le formulaire
        if (strlen($code) != 20) {

            $data['erreur'] = "Veuillez entrer un code valide de 20 caractères.";

            return view('menu_visiteur')
                . view('templates/haut')
                . view('affichage_message', $data)
                . view('templates/bas');
        }


    // 3) Vérifier si le message existe
    $msg = $model->get_message_by_code($code);

    // 4) Si aucun message afficher la page message_suivre avec erreur
    if ($msg == null) {
        return view('menu_visiteur')
            . view('templates/haut')
            . view('message/message_suivre', ['msg' => null, 'code' => $code])
            . view('templates/bas');
    }

    // 5) Sinon afficher le message
    return view('menu_visiteur')
        . view('templates/haut')
        . view('message/message_suivre', ['msg' => $msg, 'code' => $code])
        . view('templates/bas');
}



    public function formSuivre()
{
    if ($this->request->getMethod() == "POST") {

        $code = trim($this->request->getPost('code'));

        if ($code === "" || $code === null) {
            return redirect()->to(base_url('index.php/accueil/afficher?erreur=vide'));
        }

        if (strlen($code) != 20) {
            return view('menu_visiteur')
                . view('templates/haut')
                . view('message/message_suivre_form', ['erreur' => "Le code doit contenir 20 caractères."])
                . view('templates/bas');
        }

        return redirect()->to(base_url('index.php/message/suivre/' . $code));
    }
    return view('menu_visiteur')
        . view('templates/haut')
        . view('message/message_suivre_form')
        . view('templates/bas');
}


public function admin_liste()
{
    $session = session();

    // Protection admin
    if (! $session->has('user') || $session->get('statut') != 'A') {
        return redirect()->to(base_url('index.php/accueil/afficher'));
    }

    $model = new Db_model();

    //  On récupère tous les messages
    $data['messages'] = $model->get_all_messages();

    //  On récupère le nombre de messages non traités
    $data['nb_non_traites'] = $model->count_messages_non_traites();

    return view('templates/haut2')
        . view('admin/messages_liste', $data)
        . view('templates/bas2');
}



public function admin_repondre($id)
{
    $session = session();

    if (! $session->has('user') || $session->get('statut') != 'A') {
        return redirect()->to(base_url('index.php/accueil/afficher'));
    }

    $model = new Db_model();

    // GET : affichage du formulaire
    if ($this->request->getMethod() == 'GET') {

        $data['message'] = $model->get_message_by_id($id);

        return view('templates/haut2')
            . view('admin/message_repondre', $data)
            . view('templates/bas2');
    }

    // POST : validation du formulaire
    $reponse = $this->request->getPost('reponse');

    if ($reponse == null || trim($reponse) == "") {
        $data['erreur'] = "Veuillez remplir le formulaire !";
        $data['message'] = $model->get_message_by_id($id);

        return view('templates/haut2')
            . view('admin/message_repondre', $data)
            . view('templates/bas2');
    }

    // mise à jour
    $model->repondre_message($id, $reponse, $session->get('cpt_id'));

    // retour liste
    return redirect()->to(base_url('index.php/admin/messages'));
}







  


}

