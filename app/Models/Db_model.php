<?php
namespace App\Models;
use CodeIgniter\Model;

class Db_model extends Model
{
    protected $db;

    public function __construct()
    {
        $this->db = db_connect();
    }


    // --- Comptes ---
    public function get_all_compte()
    {
        $resultat = $this->db->query("SELECT cpt_pseudo FROM t_compte_cpt;");
        return $resultat->getResultArray();
    }

    public function get_nb_compte()
    {
        $sql = "SELECT COUNT(*) AS total FROM t_compte_cpt;";
        $result = $this->db->query($sql);
        return $result->getRow();
    }

    // --- Actualités ---
    public function get_actualite($numero)
    {
        $requete = "SELECT * FROM t_actualite_act WHERE act_id = " . $numero . ";";
        $resultat = $this->db->query($requete);
        return $resultat->getRow();
    }

    public function get_all_actualites()
    {
        $sql = "SELECT act_titre, act_contenu, act_date_pub FROM t_actualite_act ORDER BY act_date_pub DESC LIMIT 5;";
        $result = $this->db->query($sql);
        return $result->getResultArray(); // plusieurs lignes
    }

    //  Nouvelle fonction pour la User Story #1
    public function get_actualites_publiees()
    {
        $sql = "SELECT act_titre, act_contenu, act_date_pub, cpt_pseudo
        FROM t_actualite_act, t_compte_cpt
        WHERE t_actualite_act.cpt_id = t_compte_cpt.cpt_id
        AND act_etat = 'P'
        ORDER BY act_date_pub DESC LIMIT 5;";
        $result = $this->db->query($sql);
        return $result->getResultArray();
    }


    public function get_message_by_code($code)
    {
        $sql = "SELECT * FROM t_message_msg WHERE msg_code = ?";
        return $this->db->query($sql, [$code])->getRowArray();
    }



    public function set_compte($saisie)
    {
        // Récupération des données du formulaire
        $login = $saisie['pseudo'];
        $mot_de_passe = $saisie['mdp'];

        // Insérer selon l’ordre officiel : cpt_pseudo, cpt_mdp, cpt_statut
        $sql = "INSERT INTO t_compte_cpt (cpt_pseudo, cpt_mdp, cpt_statut)
                VALUES ('".$login."', '".$mot_de_passe."', 'A')";
        
        return $this->db->query($sql);
    }

    public function set_message_simple($objet, $contenu, $email)
{
    // Appel direct à la procédure SQL
    $this->db->query(
        "CALL ajouter_message(?, ?, ?)",
        [$objet, $contenu, $email]
    );

    // Récupérer l'ID du dernier message inséré automatiquement
    // (dans MariaDB, LAST_INSERT_ID() fonctionne après un CALL)
    $row = $this->db->query("SELECT LAST_INSERT_ID() AS id")->getRow();
    $insert_id = $row->id;

    // Récupérer le code généré par le trigger
    $result = $this->db->query(
        "SELECT msg_code FROM t_message_msg WHERE msg_id = ?",
        [$insert_id]
    )->getRow();

    return $result->msg_code;  // On renvoie le code pour l’afficher dans la vue
}




public function connect_compte($u, $p)
{
    $hash = hash('sha256', $p);

    $sql = "SELECT 
                c.cpt_id,
                c.cpt_pseudo,
                c.cpt_statut,
                p.pfl_role
            FROM t_compte_cpt c
            LEFT JOIN t_profil_pfl p ON c.cpt_id = p.cpt_id
            WHERE c.cpt_pseudo = ?
            AND c.cpt_mdp = ?";

    $result = $this->db->query($sql, [$u, $hash]);
    return ($result->getNumRows() > 0) ? $result->getRow() : null;
}

    



    public function get_reservations_admin($cpt_id)
    {
        $sql = "SELECT rsv_id, rsv_nom, rsv_date, rsv_heure, rsv_lieu
                FROM t_reservation_rsv
                WHERE rsv_date >= CURDATE()
                ORDER BY rsv_date, rsv_heure;";

        $reservations = $this->db->query($sql)->getResultArray();

        // Ajout des participants
        foreach ($reservations as &$r) {
            $r['participants'] = $this->get_participants($r['rsv_id']);
        }

        return $reservations;
    }



    public function get_comptes_profils()
    {
        $sql = "SELECT 
                    cpt_pseudo,
                    cpt_statut,
                    pfl_nom,
                    pfl_prenom,
                    pfl_email,
                    pfl_role
                FROM t_compte_cpt
                LEFT JOIN t_profil_pfl ON t_compte_cpt.cpt_id = t_profil_pfl.cpt_id
                ORDER BY 
                    CASE 
                        WHEN pfl_role = 'A' THEN 1
                        WHEN pfl_role = 'M' THEN 2
                        ELSE 3
                    END,
                    cpt_pseudo ASC;";

        $resultat = $this->db->query($sql);
        return $resultat->getResultArray();
    }



    public function compte_existe($pseudo)
    {
        $sql = "SELECT COUNT(*) AS nb 
                FROM t_compte_cpt 
                WHERE cpt_pseudo = ?;";

        $resultat = $this->db->query($sql, [$pseudo]);
        $row = $resultat->getRow();
        return $row->nb;
    }

    public function inserer_compte_invite($pseudo, $mdp)
    {
        // hash simple
        $hash = hash('sha256', $mdp);

        $sql = "INSERT INTO t_compte_cpt (cpt_pseudo, cpt_mdp, cpt_statut)
                VALUES (?, ?, 'D')";

        return $this->db->query($sql, [$pseudo, $hash]);
    }

    public function get_all_messages()
{
    $sql = "SELECT *
            FROM t_message_msg
            ORDER BY 
                (msg_reponse IS NOT NULL),   
                msg_id DESC";                

    return $this->db->query($sql)->getResultArray();
}



    public function get_message_by_id($id)
    {
        $sql = "SELECT *
                FROM t_message_msg
                WHERE msg_id = ?";

        return $this->db->query($sql, [$id])->getRowArray();
    }


    public function repondre_message($id, $reponse, $cpt_id_admin)
    {
        $sql = "UPDATE t_message_msg
                SET msg_reponse = ?,
                    cpt_id = ?
                WHERE msg_id = ?";

        return $this->db->query($sql, [$reponse, $cpt_id_admin, $id]);
    }



    public function get_profil_admin($cpt_id)
    {
        $sql = "SELECT *
                FROM t_profil_pfl
                WHERE cpt_id = ?";

        return $this->db->query($sql, [$cpt_id])->getRowArray();
    }


    public function get_reservations_membre($cpt_id)
    {
        $sql = "SELECT 
                    rsv_nom,
                    rsv_date,
                    rsv_heure,
                    rsv_lieu,
                    rsc_nom
                FROM t_reservation_rsv, t_participe_prt, t_ressource_rsc
                WHERE t_reservation_rsv.rsc_id = t_ressource_rsc.rsc_id
                AND t_reservation_rsv.rsv_id = t_participe_prt.rsv_id
                AND t_participe_prt.cpt_id = ?
                AND rsv_date >= CURDATE()
                ORDER BY rsv_date ASC, rsv_heure ASC;";

        return $this->db->query($sql, [$cpt_id])->getResultArray();
    }


    public function get_adherents()
    {
        $sql = "SELECT pfl_nom, pfl_prenom, pfl_email, pfl_num
                FROM t_profil_pfl
                WHERE pfl_role = 'M'
                ORDER BY pfl_nom ASC";

        return $this->db->query($sql)->getResultArray();
    }

    public function get_participants($rsv_id)
    {
        $sql = "SELECT pfl_nom, pfl_prenom
                FROM t_participe_prt
                JOIN t_profil_pfl USING(cpt_id)
                WHERE rsv_id = ?;";

        return $this->db->query($sql, [$rsv_id])->getResultArray();
    }

    public function get_all_ressources()
{
    $sql = "SELECT 
                rsc_id,
                rsc_nom,
                rsc_image,
                rsc_jauge_min,
                rsc_jauge_max,
                rsc_descriptif,
                rsc_liste_materiel
            FROM t_ressource_rsc
            ORDER BY rsc_nom ASC;";

    $query = $this->db->query($sql);
    return $query->getResult();
}



    public function count_messages_non_traites()
    {
        $sql = "SELECT nb_messages_non_traites() AS total;";
        return $this->db->query($sql)->getRow()->total;
    }




// 2) Ajouter une nouvelle ressource
public function insert_ressource($nom, $image, $jauge_min, $jauge_max, $descriptif, $materiel)
{
    $sql = "INSERT INTO t_ressource_rsc
            (rsc_nom, rsc_image, rsc_jauge_min, rsc_jauge_max, rsc_descriptif, rsc_liste_materiel)
            VALUES (?, ?, ?, ?, ?, ?)";

    return $this->db->query($sql, [
        $nom,
        $image,
        $jauge_min,
        $jauge_max,
        $descriptif,
        $materiel
    ]);
}


// 3) Supprimer une ressource
public function delete_ressource($id)
{
    // Début de la transaction (sécurité)
    $this->db->transStart();

    // 1. Supprimer les participations liées aux réservations de cette ressource
    // On utilise une sous-requête pour trouver les ID de réservations concernés
    $sql_participation = "DELETE FROM t_participe_prt 
                          WHERE rsv_id IN (
                              SELECT rsv_id FROM t_reservation_rsv WHERE rsc_id = ?
                          )";
    $this->db->query($sql_participation, [$id]);

    // 2. Supprimer les réservations liées à la ressource
    $sql_reservation = "DELETE FROM t_reservation_rsv WHERE rsc_id = ?";
    $this->db->query($sql_reservation, [$id]);

    // 3. Enfin, supprimer la ressource elle-même
    $sql_ressource = "DELETE FROM t_ressource_rsc WHERE rsc_id = ?";
    $this->db->query($sql_ressource, [$id]);

    // Fin de la transaction
    $this->db->transComplete();

    // Retourne TRUE si tout s'est bien passé, FALSE sinon
    return $this->db->transStatus();
}


//   V2.1 - Réservations par date
public function get_reservations_by_date($date)
{
    $sql = "SELECT
                r.rsv_id,
                r.rsv_nom,
                r.rsv_date,
                r.rsv_heure,
                r.rsv_lieu,
                r.rsc_statut,
                s.rsc_nom,
                s.rsc_descriptif,
                s.rsc_liste_materiel,
                COUNT(DISTINCT p.cpt_id) AS nb_participants,
                GROUP_CONCAT(
                    CONCAT(pf.pfl_prenom, ' ', pf.pfl_nom, ' (', p.prt_role, ')')
                    ORDER BY p.prt_role DESC, pf.pfl_nom
                    SEPARATOR ', '
                ) AS liste_participants
            FROM t_reservation_rsv r
            JOIN t_ressource_rsc s ON r.rsc_id = s.rsc_id
            LEFT JOIN t_participe_prt p ON r.rsv_id = p.rsv_id
            LEFT JOIN t_profil_pfl pf ON p.cpt_id = pf.cpt_id
            WHERE r.rsv_date = ?
            GROUP BY
                r.rsv_id, r.rsv_nom, r.rsv_date, r.rsv_heure, r.rsv_lieu, r.rsc_statut,
                s.rsc_nom, s.rsc_descriptif, s.rsc_liste_materiel
            ORDER BY s.rsc_nom, r.rsv_heure;";

    $query = $this->db->query($sql, [$date]);
    return $query->getResultArray();
}




public function connect_invite($pseudo, $mdp)
{
    $hash = hash('sha256', $mdp);

    $sql = "SELECT cpt_id, cpt_pseudo, cpt_statut
            FROM t_compte_cpt
            WHERE cpt_pseudo = ?
            AND cpt_mdp = ?
            AND cpt_statut = 'D'";

    $result = $this->db->query($sql, [$pseudo, $hash]);
    return ($result->getNumRows() > 0) ? $result->getRow() : null;
}



















           





























































}

