<?php

use CodeIgniter\Router\RouteCollection;
use App\Controllers\Accueil;
use App\Controllers\Test;
use App\Controllers\Compte;
use App\Controllers\Actualite;
use App\Controllers\Message;
use App\Controllers\Ressource;
use App\Controllers\Reservation;
use App\Controllers\Invite;

/**
 * @var RouteCollection $routes
 */

// Accueil
$routes->get('/', [Accueil::class, 'afficher']);
$routes->get('accueil/afficher', [Accueil::class, 'afficher']);

// Comptes
$routes->get('compte/lister', [Compte::class, 'lister']);
$routes->get('compte/creer', [Compte::class, 'creer']);
$routes->post('compte/creer', [Compte::class, 'creer']);

// Actualités
$routes->get('actualite/afficher', [Actualite::class, 'afficher']);
$routes->get('actualite/afficher/(:num)', [Actualite::class, 'afficher']);

// Message : créer
$routes->get('message/creer', [Message::class, 'creer']);
$routes->post('message/creer', [Message::class, 'creer']);

// Message : formulaire pour entrer le code
$routes->get('message/formSuivre', [Message::class, 'formSuivre']);
$routes->post('message/formSuivre', [Message::class, 'formSuivre']);

// Message : afficher la demande si code correct
$routes->get('message/suivre', [Message::class, 'suivre']);
$routes->get('message/suivre/(:segment)', [Message::class, 'suivre']);

// MESSAGE — toujours en dernier
$routes->get('message', [Message::class, 'afficher']);

$routes->get('compte/connecter', [Compte::class, 'connecter']);
$routes->post('compte/connecter', [Compte::class, 'connecter']);


$routes->get('compte/deconnecter', [Compte::class, 'deconnecter']);
$routes->get('compte/afficher_profil', [Compte::class, 'afficher_profil']);



// Accueil administrateur
$routes->get('admin/accueil', [\App\Controllers\Compte::class, 'accueil_admin']);

// Gestion comptes
$routes->get('admin/comptes', [\App\Controllers\Compte::class, 'gestion_comptes']);

// Ajout compte invité
$routes->get('admin/ajouter_invite', [Compte::class, 'ajouter_invite']);
$routes->post('admin/ajouter_invite', [Compte::class, 'ajouter_invite']);



$routes->get('admin/messages', 'Message::admin_liste');
$routes->get('admin/message_repondre/(:num)', 'Message::admin_repondre/$1');
$routes->post('admin/message_repondre/(:num)', 'Message::admin_repondre/$1');


$routes->get('compte/accueil_membre', [Compte::class, 'accueil_membre']);

$routes->get('membre/adherents', [Compte::class, 'liste_adherents']);


$routes->get('admin/ressources', [Ressource::class, 'gestion']);
$routes->get('admin/ressources/ajouter', [Ressource::class, 'ajouter']);
$routes->post('admin/ressources/ajouter', [Ressource::class, 'ajouter']);
$routes->get('admin/ressources/supprimer/(:num)', [Ressource::class, 'supprimer']);

$routes->match(['get', 'post'], 'reservation/seances', [Reservation::class, 'seances']);

$routes->get('invite/accueil', [Invite::class, 'accueil']);

