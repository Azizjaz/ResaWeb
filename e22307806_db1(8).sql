-- phpMyAdmin SQL Dump
-- version 5.2.1deb1+deb12u1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : jeu. 04 déc. 2025 à 19:05
-- Version du serveur : 10.11.11-MariaDB-0+deb12u1-log
-- Version de PHP : 8.2.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `e22307806_db1`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`e22307806sql`@`%` PROCEDURE `ajouter_message` (IN `p_intitule` VARCHAR(255), IN `p_contenu` TEXT, IN `p_email` VARCHAR(255))   BEGIN
    INSERT INTO t_message_msg
    (msg_intitule, msg_contenu, msg_email, msg_reponse, msg_date_question)
    VALUES (p_intitule, p_contenu, p_email, NULL, CURDATE());
END$$

CREATE DEFINER=`e22307806sql`@`%` PROCEDURE `gestion_document` (IN `reu_id2` INT)   proc_doc: BEGIN
    DECLARE nb_par INT;
    DECLARE intitule VARCHAR(500);
    DECLARE reu_theme_var VARCHAR(255);
    DECLARE document_exists INT;

    SET nb_par = Nbpersonnes(reu_id2);

    IF nb_par = -1 THEN
        LEAVE proc_doc;
    END IF;

    SELECT reu_theme INTO reu_theme_var 
    FROM t_reunion_reu 
    WHERE reu_id = reu_id2;

    SET intitule = CONCAT('CR ', reu_theme_var, ' - ', nb_par, ' participants');

    SELECT COUNT(*) INTO document_exists 
    FROM t_document_dcm 
    WHERE reu_id = reu_id2;

    IF document_exists = 0 THEN
        INSERT INTO t_document_dcm (doc_titre, doc_url_fichier, reu_id)
        VALUES (intitule, 'CR en attente', reu_id2);
    ELSE
        UPDATE t_document_dcm
        SET doc_titre = intitule
        WHERE reu_id = reu_id2;
    END IF;
END proc_doc$$

--
-- Fonctions
--
CREATE DEFINER=`e22307806sql`@`%` FUNCTION `Liste_adresse` (`reu_id` INT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE liste TEXT;

    SELECT GROUP_CONCAT(
                DISTINCT t_profil_pfl.pfl_email         
                ORDER BY t_profil_pfl.pfl_email ASC     
                SEPARATOR ', '                        
            )
    INTO liste
    FROM t_inscription_ins
    JOIN t_profil_pfl ON t_inscription_ins.cpt_id = t_profil_pfl.cpt_id
    WHERE t_inscription_ins.reu_id = reu_id;

    RETURN liste;
END$$

CREATE DEFINER=`e22307806sql`@`%` FUNCTION `Nbpersonnes` (`reu` INT) RETURNS INT(11)  BEGIN
    DECLARE nb INT;
    DECLARE reunion_exists INT;

    SELECT COUNT(*) INTO reunion_exists FROM t_reunion_reu WHERE reu_id = reu;

    IF reunion_exists = 0 THEN
        RETURN -1;
    END IF;

    SELECT COUNT(*) INTO nb FROM t_inscription_ins WHERE reu_id = reu;

    RETURN nb;
END$$

CREATE DEFINER=`e22307806sql`@`%` FUNCTION `nb_messages_non_traites` () RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE nb INT;

    SELECT COUNT(*)
    INTO nb
    FROM t_message_msg
    WHERE msg_reponse IS NULL;

    RETURN nb;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_actualite_act`
--

CREATE TABLE `t_actualite_act` (
  `act_id` int(11) NOT NULL,
  `act_titre` varchar(45) NOT NULL,
  `act_contenu` varchar(250) NOT NULL,
  `act_date_pub` date NOT NULL,
  `act_etat` char(1) NOT NULL,
  `cpt_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_actualite_act`
--

INSERT INTO `t_actualite_act` (`act_id`, `act_titre`, `act_contenu`, `act_date_pub`, `act_etat`, `cpt_id`) VALUES
(1, 'Ouverture des terrains de Padel', 'Les 3 nouveaux terrains de Padel sont désormais ouverts à la réservation en ligne ! Venez vite découvrir ce sport en plein essor.', '2025-09-25', 'P', 1),
(2, 'Maintenance du système', 'Une maintenance est prévue dans la nuit du 10 au 11 octobre. Les réservations seront indisponibles de minuit à 6h du matin.', '2025-09-30', 'P', 2),
(3, 'Nouveaux tarifs 2026', 'Les nouveaux tarifs pour l\'année 2026 sont consultables dans la section \"Infos\". N\'hésitez pas à les consulter.', '2025-10-01', 'P', 1),
(4, 'Alerte Météo', 'Les terrains extérieurs seront fermés ce week-end en raison de fortes pluies annoncées. Les réservations concernées seront remboursées.', '2025-10-02', 'P', 5),
(5, 'Compétition inter-clubs', 'Le terrain principal est réservé du 15 au 17 novembre pour le grand tournoi inter-clubs annuel. Les autres terrains restent accessibles.', '2025-10-05', 'P', 10),
(6, 'Mise à jour de l\'application', 'La nouvelle version de l\'application est disponible avec une gestion simplifiée de l\'annulation des réservations.', '2025-10-10', 'P', 3);

-- --------------------------------------------------------

--
-- Structure de la table `t_adresse_adr`
--

CREATE TABLE `t_adresse_adr` (
  `adr_ville` varchar(150) NOT NULL,
  `adr_code_postal` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_adresse_adr`
--

INSERT INTO `t_adresse_adr` (`adr_ville`, `adr_code_postal`) VALUES
('Nice', 6000),
('Marseille', 13008),
('Dijon', 21000),
('Brest', 29200),
('Toulouse', 31000),
('Bordeaux', 33000),
('Montpellier', 34000),
('Rennes', 35000),
('Grenoble', 38000),
('Saint-Étienne', 42000),
('Nantes', 44000),
('Angers', 49000),
('Reims', 51100),
('Lille', 59000),
('Clermont-Ferrand', 63000),
('Strasbourg', 67000),
('Lyon', 69002),
('Paris', 75001),
('Le Havre', 76600),
('Toulon', 83000);

-- --------------------------------------------------------

--
-- Structure de la table `t_association_asc`
--

CREATE TABLE `t_association_asc` (
  `rsc_id` int(11) NOT NULL,
  `ind_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `t_compte_cpt`
--

CREATE TABLE `t_compte_cpt` (
  `cpt_id` int(11) NOT NULL,
  `cpt_pseudo` varchar(255) DEFAULT NULL,
  `cpt_mdp` varchar(255) DEFAULT NULL,
  `cpt_statut` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=big5 COLLATE=big5_chinese_ci;

--
-- Déchargement des données de la table `t_compte_cpt`
--

INSERT INTO `t_compte_cpt` (`cpt_id`, `cpt_pseudo`, `cpt_mdp`, `cpt_statut`) VALUES
(1, 'principal', 'be04b80973d1db6dda571f3e6c043f41054007cd8699ec7147251ca5ade3dbdc', 'A'),
(2, 'leila.petit', 'c055a839dc5183673a0873137bf762976e50eaec22b10674daf8cdfa7d43f782', 'A'),
(3, 'david.durand', 'c29876024118844d786b943da3379862a2070da8eda20a8788eb694e16891c38', 'A'),
(4, 'claire.leroy', 'a61f16ec09acd330f5467632c8bedd175e0546289cf0daf8e47c25b7c2073003', 'A'),
(5, 'paul.moreau', '1e2020335c214af12cf756c9db7c2e3bf6cda3120044d76992440306a42ced61', 'A'),
(6, 'chloe.simon', '7f502c3498b8c2d130c9a405a468d601b3a5c7f8e9d0a1b2c3d4e5f6a7b8c9d0', 'A'),
(7, 'theo.fournier', 'c055a839dc5183673a0873137bf762976e50eaec22b10674daf8cdfa7d43f782', 'A'),
(8, 'eva.roux', '9a8b7c6d5e4f3a2b1c0d9e8f7a6b5c4d3e2f1a0b9c8d7e6f5a4b3c2d1e0f9a8b', 'A'),
(9, 'thomas.fournier', '1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d', 'A'),
(10, 'marie.dubois', '2b1a0d9c8b7a6f5e4d3c2b1a0f9e8d7c6b5a4f3e2d1c0b9a8f7e6d5c4b3a2f1e', 'A'),
(11, 'jerome.masson', '3d4c5b6a7e8f9d0c1b2a3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a', 'A'),
(12, 'amelie.ribot', '5f6e7d8c9b0a1c2b3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c', 'A'),
(13, 'lucas.dumas', '8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b', 'A'),
(14, 'chloe.giraud', 'c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2', 'A'),
(15, 'maxime.legrand', 'f0e1d2c3b4a5f6e7d8c9b0a1c2b3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1', 'A'),
(16, 'celine.bernard', '1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f', 'A'),
(17, 'julien.ricard', '4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c', 'A'),
(18, 'laura.blanc', '7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e', 'A'),
(19, 'nicolas.girard', 'a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1', 'A'),
(20, 'adeline.morel', 'd3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4', 'A'),
(21, 'mathieu.fournel', '1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a', 'A'),
(22, 'virginie.lemaire', '4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e', 'A'),
(23, 'alexandre.perez', '7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b', 'A'),
(24, 'elodie.michel', 'a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5', 'A'),
(25, 'remi.andre', 'd1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2', 'A'),
(26, 'marine.henry', '1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b', 'A'),
(27, 'antoine.dufour', '4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a', 'A'),
(28, 'aurelie.fournier', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(29, 'gregory.garcia', 'a2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3', 'A'),
(30, 'anais.dubois', 'd5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6', 'A'),
(31, 'vincent.leclerc', '1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c', 'A'),
(32, 'camille.rousseau', '4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b', 'A'),
(33, 'fabien.prevost', '7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f', 'A'),
(34, 'juliette.lambert', 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2', 'A'),
(35, 'loic.robin', 'd4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5', 'A'),
(36, 'alice.moreau', '1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d', 'A'),
(37, 'damien.roy', '4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f', 'A'),
(38, 'emma.vincent', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(39, 'felix.blanchard', 'a3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4', 'A'),
(40, 'noemie.charpentier', 'd6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7', 'A'),
(41, 'nicolas.bernard', '1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b', 'A'),
(42, 'lea.gautier', '4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a', 'A'),
(43, 'etienne.leconte', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(44, 'manon.olivier', 'a2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3', 'A'),
(45, 'baptiste.duval', 'd5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6', 'A'),
(46, 'charlotte.bonnet', '1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c', 'A'),
(47, 'gabin.meyer', '4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b', 'A'),
(48, 'lucie.faure', '7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f', 'A'),
(49, 'quentin.rousseau', 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2', 'A'),
(50, 'ines.lefevre', 'd4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5', 'A'),
(51, 'theo.marchand', '1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d', 'A'),
(52, 'zoe.perrin', '4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f', 'A'),
(53, 'enzo.richard', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(54, 'margaux.simon', 'a3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4', 'A'),
(55, 'leo.thomas', 'd6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7', 'A'),
(56, 'lou.dubois', '1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b', 'A'),
(57, 'hugo.guerin', '4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a', 'A'),
(58, 'jeanne.riviere', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(59, 'felicie.robert', 'a2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3', 'A'),
(60, 'victor.roger', 'd5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6', 'A'),
(61, 'camille.dumas', '1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c', 'A'),
(62, 'louis.fournier', '4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b', 'A'),
(63, 'sarah.durand', '7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f', 'A'),
(64, 'arthur.dubois', 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2', 'A'),
(65, 'emilie.martin', 'd4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5', 'A'),
(66, 'gabriel.petit', '1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d', 'A'),
(67, 'clara.leroy', '4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f', 'A'),
(68, 'mattis.moreau', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(69, 'margot.roux', 'a3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4', 'A'),
(70, 'raphael.thomas', 'd6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7', 'A'),
(71, 'elias.bernard', '1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b', 'A'),
(72, 'oceane.legrand', '4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a', 'A'),
(73, 'enzo.giraud', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(74, 'lisa.lefevre', 'a2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3', 'A'),
(75, 'aymeric.marchand', 'd5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6', 'A'),
(76, 'ninon.perrin', '1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c', 'A'),
(77, 'sacha.richard', '4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b', 'A'),
(78, 'amel.simon', '7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f', 'A'),
(79, 'corentin.thomas', 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2', 'A'),
(80, 'maelys.martin', 'd4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5', 'A'),
(81, 'adrien.petit', '1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d', 'A'),
(82, 'julia.leroy', '4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f', 'A'),
(83, 'florian.moreau', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(84, 'louise.roux', 'a3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4', 'A'),
(85, 'arnaud.fournier', 'd6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7', 'A'),
(86, 'elena.dubois', '1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b', 'A'),
(87, 'hugo.masson', '4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a', 'A'),
(88, 'ines.ribot', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(89, 'jules.dumas', 'a2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3', 'A'),
(90, 'leonie.giraud', 'd5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6', 'A'),
(91, 'maxence.legrand', '1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c', 'A'),
(92, 'maya.bernard', '4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b', 'A'),
(93, 'noah.ricard', '7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f', 'A'),
(94, 'lilou.blanc', 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2', 'A'),
(95, 'adam.girard', 'd4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5', 'A'),
(96, 'solene.morel', '1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d', 'A'),
(97, 'samuel.fournel', '4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f', 'A'),
(98, 'lila.lemaire', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(99, 'raphael.perez', 'a3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4', 'A'),
(100, 'lena.michel', 'd6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7', 'A'),
(101, 'enzo.andre', '1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b', 'A'),
(102, 'anna.henry', '4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a', 'A'),
(103, 'leo.dufour', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(104, 'chloe.fournier', 'a2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3', 'A'),
(105, 'paul.garcia', 'd5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6', 'A'),
(106, 'sarah.dubois', '1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c', 'A'),
(107, 'noah.leclerc', '4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b', 'A'),
(108, 'lea.rousseau', '7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f', 'A'),
(109, 'adam.prevost', 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2', 'A'),
(110, 'manon.lambert', 'd4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5', 'A'),
(111, 'gabin.robin', '1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d', 'A'),
(112, 'emmie.moreau', '4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f', 'A'),
(113, 'louis.roy', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(114, 'julie.vincent', 'a3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4', 'A'),
(115, 'axel.blanchard', 'd6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7', 'A'),
(116, 'elisa.charpentier', '1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b', 'A'),
(117, 'hugo.bernard', '4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a', 'A'),
(118, 'jade.gautier', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(119, 'theo.leconte', 'a2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3', 'A'),
(120, 'lina.olivier', 'd5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6', 'A'),
(121, 'leo.duval', '1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c', 'A'),
(122, 'inaya.bonnet', '4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b', 'A'),
(123, 'gabin.meyer2', '7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f', 'A'),
(124, 'chloe.faure', 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2', 'A'),
(125, 'quentin.rousseau2', 'd4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5', 'A'),
(126, 'ines.lefevre2', '1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d', 'A'),
(127, 'theo.marchand2', '4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f', 'A'),
(128, 'zoe.perrin2', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(129, 'enzo.richard2', 'a3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4', 'A'),
(130, 'margaux.simon2', 'd6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7', 'A'),
(131, 'leo.thomas2', '1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b', 'A'),
(132, 'lou.dubois2', '4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a', 'A'),
(133, 'hugo.guerin8', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(134, 'jeanne.riviere2', 'a2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3', 'A'),
(135, 'felicie.robert2', 'd5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6', 'A'),
(136, 'victor.roger2', '1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c', 'A'),
(137, 'camille.dumas2', '4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b', 'A'),
(138, 'louis.fournier7', '7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f', 'A'),
(139, 'sarah.durand7', 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2', 'A'),
(140, 'arthur.dubois7', 'd4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5', 'A'),
(141, 'emilie.martin7', '1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d', 'A'),
(142, 'gabriel.petit7', '4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f', 'A'),
(143, 'clara.leroy7', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(144, 'mattis.moreau7', 'a3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4', 'A'),
(145, 'margot.roux7', 'd6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7', 'A'),
(146, 'raphael.thomas7', '1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b', 'A'),
(147, 'elias.bernard7', '4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a', 'A'),
(148, 'oceane.legrand7', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(149, 'enzo.giraud7', 'a2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3', 'A'),
(150, 'lisa.lefevre7', 'd5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6', 'A'),
(151, 'aymeric.marchand7', '1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c', 'A'),
(152, 'ninon.perrin7', '4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b', 'A'),
(153, 'sacha.richard7', '7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f', 'A'),
(154, 'amel.simon7', 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2', 'A'),
(155, 'corentin.thomas7', 'd4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5', 'A'),
(156, 'maelys.martin7', '1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d', 'A'),
(157, 'adrien.petit7', '4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f', 'A'),
(158, 'julia.leroy7', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(159, 'florian.moreau7', 'a3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4', 'A'),
(160, 'louise.roux7', 'd6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7', 'A'),
(161, 'arnaud.fournier7', '1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b', 'A'),
(162, 'elena.dubois7', '4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a', 'A'),
(163, 'hugo.masson7', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(164, 'ines.ribot7', 'a2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3', 'A'),
(165, 'jules.dumas7', 'd5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6', 'A'),
(166, 'leonie.giraud7', '1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c', 'A'),
(167, 'maxence.legrand7', '4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b', 'A'),
(168, 'maya.bernard7', '7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f', 'A'),
(169, 'noah.ricard7', 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2', 'A'),
(170, 'lilou.blanc7', 'd4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5', 'A'),
(171, 'adam.girard7', '1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d', 'A'),
(172, 'solene.morel7', '4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f', 'A'),
(173, 'samuel.fournel7', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(174, 'lila.lemaire7', 'a3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4', 'A'),
(175, 'raphael.perez7', 'd6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7', 'A'),
(176, 'lena.michel7', '1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b', 'A'),
(177, 'enzo.andre7', '4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a', 'A'),
(178, 'anna.henry7', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(179, 'leo.dufour7', 'a2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3', 'A'),
(180, 'chloe.fournier7', 'd5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6', 'A'),
(181, 'paul.garcia7', '1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c', 'A'),
(182, 'sarah.dubois7', '4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b', 'A'),
(183, 'noah.leclerc7', '7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f', 'A'),
(184, 'lea.rousseau7', 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2', 'A'),
(185, 'adam.prevost7', 'd4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5', 'A'),
(186, 'manon.lambert7', '1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d', 'A'),
(187, 'gabin.robin7', '4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f', 'A'),
(188, 'emmie.moreau7', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(189, 'louis.roy7', 'a3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4', 'A'),
(190, 'julie.vincent7', 'd6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7', 'A'),
(191, 'axel.blanchard7', '1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b', 'A'),
(192, 'elisa.charpentier7', '4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a', 'A'),
(193, 'hugo.bernard7', '7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c', 'A'),
(194, 'jade.gautier7', 'a2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3', 'A'),
(195, 'theo.leconte7', 'd5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6', 'A'),
(196, 'lina.olivier7', '1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c', 'A'),
(197, 'leo.duval7', '4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b', 'A'),
(198, 'inaya.bonnet7', '7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f', 'A'),
(199, 'gabin.meyer37', 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2', 'A'),
(200, 'chloe.faure2', 'd4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5', 'A'),
(201, 'invite1', '3f95205bfbebd136a9ce192e4df6b13e', 'D'),
(202, 'invite2', '93dba506286d41f8663e074140a5e559', 'D'),
(203, 'invite3', 'aa52fbfc842ebc6b7bc105979c14cbcd', 'D'),
(204, 'invite4', 'c5a33a0fa2123cf530a7599ed803fc4f', 'D'),
(205, 'invite5', 'ccd7e081a7b2f18f12f8967d6e164fa5', 'D'),
(206, 'invite6', '7233ec85013a04ed5feb2528b8154f34', 'D'),
(207, 'invite7', 'b0538bb25615408a6bed67cc6639ab20', 'D'),
(208, 'invite8', 'cc2cf34dea0908403eb449cecaab7e87', 'D'),
(209, 'invite9', '266bb050f09ff47ebd6f4e146cc83a23', 'D'),
(210, 'invite10', '5ab0d2d5ff59da7c942b17841773fa19', 'D'),
(240, 'l\'acrobate', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 'D'),
(241, 'joseph', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 'D'),
(243, 'invite1234', '0a77601af850be620aa12239488315cc7f0f527d6f4c1618b48880de41cffc92', 'D'),
(244, 'invite123', 'b090678710c4eb4fbde5d249b75ad587ce197ea2e76142c3dfdf19a0c3f9a374', 'D'),
(245, 'in4', '8eea67e8a7c04496b478db3bed6e0b459133ca9354143f2b495107c6e0f2b8e3', 'D'),
(246, 'invite444', 'd4d67e20bc8344e2aa0e8d2609b8f19536028c93fd642e6878c47480b49cdf84', 'D');

-- --------------------------------------------------------

--
-- Structure de la table `t_document_dcm`
--

CREATE TABLE `t_document_dcm` (
  `doc_id` int(11) NOT NULL,
  `doc_titre` varchar(100) NOT NULL,
  `doc_url_fichier` varchar(300) NOT NULL,
  `reu_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_document_dcm`
--

INSERT INTO `t_document_dcm` (`doc_id`, `doc_titre`, `doc_url_fichier`, `reu_id`) VALUES
(2, 'CR Formation nouvelle plateforme de réservation - 1 participants', '/docs/guide_v2_formation.pdf', 2),
(3, 'CR Réunion CoDir: Planification événements Noël - 1 participants', '/docs/oj_codir_nov.pdf', 3),
(4, ' JPO : Découverte des nouveaux équipements   CR mis en ligne dans cette date 2025-10-23', 'mise_a_jour_cr.pdf', 4),
(5, 'CR Cours d\'essai de Yoga Sportif et flexibilité - 1 participants', '/docs/exercices_yoga.pdf', 5);

--
-- Déclencheurs `t_document_dcm`
--
DELIMITER $$
CREATE TRIGGER `trigger_cr` BEFORE UPDATE ON `t_document_dcm` FOR EACH ROW BEGIN
    IF NEW.doc_url_fichier LIKE '%.pdf' THEN
        SET NEW.doc_titre = CONCAT(NEW.doc_titre, '  CR mis en ligne dans cette date ', CURDATE());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_indisponibilite_ind`
--

CREATE TABLE `t_indisponibilite_ind` (
  `ind_id` int(11) NOT NULL,
  `ind_etat` char(1) NOT NULL,
  `ind_date_debut` date NOT NULL,
  `ind_duree` varchar(45) NOT NULL,
  `motif_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_indisponibilite_ind`
--

INSERT INTO `t_indisponibilite_ind` (`ind_id`, `ind_etat`, `ind_date_debut`, `ind_duree`, `motif_id`) VALUES
(1, 'A', '2025-10-15', '3 jours', 1),
(2, 'A', '2025-11-20', '1 semaine', 2),
(3, 'A', '2025-12-05', '1 jour', 3),
(4, 'A', '2026-01-10', '4 heures', 4),
(5, 'A', '2026-02-14', '2 jours', 1),
(6, 'A', '2026-03-01', '6 heures', 3);

-- --------------------------------------------------------

--
-- Structure de la table `t_inscription_ins`
--

CREATE TABLE `t_inscription_ins` (
  `cpt_id` int(11) NOT NULL,
  `ins_date` date NOT NULL,
  `reu_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=big5 COLLATE=big5_chinese_ci;

--
-- Déchargement des données de la table `t_inscription_ins`
--

INSERT INTO `t_inscription_ins` (`cpt_id`, `ins_date`, `reu_id`) VALUES
(2, '2025-10-20', 5),
(10, '2025-10-20', 2),
(20, '2025-11-25', 4);

--
-- Déclencheurs `t_inscription_ins`
--
DELIMITER $$
CREATE TRIGGER `trigger_mise_a_jour` AFTER INSERT ON `t_inscription_ins` FOR EACH ROW BEGIN
    CALL gestion_document(NEW.reu_id);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_message_msg`
--

CREATE TABLE `t_message_msg` (
  `msg_id` int(11) NOT NULL,
  `msg_intitule` varchar(255) NOT NULL,
  `msg_contenu` text NOT NULL,
  `msg_email` varchar(255) NOT NULL,
  `msg_reponse` text DEFAULT NULL,
  `msg_code` varchar(50) NOT NULL,
  `cpt_id` int(11) DEFAULT NULL,
  `msg_date_question` date NOT NULL DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_message_msg`
--

INSERT INTO `t_message_msg` (`msg_id`, `msg_intitule`, `msg_contenu`, `msg_email`, `msg_reponse`, `msg_code`, `cpt_id`, `msg_date_question`) VALUES
(1, 'Problème de connexion', 'Je ne peux plus accéder à mon compte.', 'qvdk@gmail.com', 'Le probléme de serveur est résolu', 'ab12cd34ef56gh78ij90', 4, '2025-11-28'),
(2, 'Demande de remboursement', 'J’ai annulé une réservation.', 'marie@gmail.com', 'Votre demande est en cours.', 'ff99aa112233bb445566', 6, '2025-11-28'),
(3, 'Suggestion', 'Ajout de créneaux matinaux ?', 'jules@gmail.com', 'aaaa', '0011aabbccddeeff2233', 1, '2025-11-28'),
(4, 'Tournoi', 'Quand aura lieu le prochain tournoi ?', 'alice@gmail.com', NULL, '778899aabbccddeeff00', NULL, '2025-11-28'),
(5, 'Coach', 'Comment réserver un coach ?', 'julien@gmail.com', 'Un coach prendra contact.', 'aa11bb22cc33dd44ee55', 5, '2025-11-28'),
(6, 'Horaires', 'Êtes-vous ouverts le dimanche ?', 'alex@hmail.com', NULL, 'cd45ef67ab89cd12ef34', NULL, '2025-11-28'),
(7, 'frre', 'vezve', 'kjgou@gmail.com', NULL, '2654ecb9e0321d1be449', NULL, '2025-11-28'),
(13, 'rth', 'ryh', 'erh@gmail.com', NULL, 'ca200fbec10031a4a008', NULL, '2025-11-28'),
(14, 'dwgh', 'dghsd', 'sdth@gmail.com', NULL, '465b21df0eaf27e290c2', NULL, '2025-11-28'),
(15, 'l\'objet', 'zaeg', 'fr@gmail.com', 'cccc', 'b41dd3af8121d5395030', 1, '2025-11-28'),
(16, 'l\'objet', 'zaeg', 'fr@gmail.com', 'bbbb', 'b393e9b37672ad23c01f', 1, '2025-11-28'),
(17, 'a', 'a', 'rgn@gmail.com', NULL, '5f0d2dcd77e1cdab5bab', NULL, '2025-11-28'),
(18, 'l\'association', 'adresse ', 'vm@tutu.fr', NULL, '94241fb566620c0b5ccc', 1, '2025-11-28'),
(19, 'R 3 p', 'fjdjhjkdhkldlks', 'llegoff5@gmail.com', NULL, '6bbceb7b813fafeb2b29', 1, '2025-11-28'),
(20, 'l\'offre ', 'pour tester le trig', 'gnhds@gmail.com', NULL, '55BD32F258BC1FE7BAFE', NULL, '2025-12-02'),
(21, 'test proc et trig', 'le test final\'//', 'zjv@gmail.com', NULL, 'C1997D15D9E87D796FAE', NULL, '2025-12-02'),
(22, 'l\'addis', 'l\'act de naisadbhdjd', 'thhqq@g.c', 'l\'act est chere', '59246311C8BECDC2B1D8', 1, '2025-12-02'),
(23, 'l\'adhésion', 'C\'est cher ?', 'test@gmail.com', 'c\'est pas cher ', '7B13B321ACC61E35C73C', 1, '2025-12-03');

--
-- Déclencheurs `t_message_msg`
--
DELIMITER $$
CREATE TRIGGER `trig_code_message` BEFORE INSERT ON `t_message_msg` FOR EACH ROW BEGIN
    SET NEW.msg_code = UPPER(SUBSTRING(MD5(RAND()), 1, 20));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_motif_mot`
--

CREATE TABLE `t_motif_mot` (
  `motif_id` int(11) NOT NULL,
  `motif_intitule` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_motif_mot`
--

INSERT INTO `t_motif_mot` (`motif_id`, `motif_intitule`) VALUES
(1, 'Maintenance terrain'),
(2, 'Tournoi annuel'),
(3, 'Météo défavorable'),
(4, 'Événement exceptionnel'),
(5, 'Annulation personnelle'),
(6, 'Blessure');

-- --------------------------------------------------------

--
-- Structure de la table `t_participe_prt`
--

CREATE TABLE `t_participe_prt` (
  `cpt_id` int(11) NOT NULL,
  `prt_date_inscription` date NOT NULL,
  `rsv_id` int(11) NOT NULL,
  `prt_role` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_participe_prt`
--

INSERT INTO `t_participe_prt` (`cpt_id`, `prt_date_inscription`, `rsv_id`, `prt_role`) VALUES
(2, '2025-10-23', 6, 'P'),
(7, '2025-10-20', 4, 'P'),
(7, '2025-12-17', 5, 'P'),
(10, '2025-10-19', 2, 'I');

-- --------------------------------------------------------

--
-- Structure de la table `t_profil_pfl`
--

CREATE TABLE `t_profil_pfl` (
  `pfl_nom` varchar(80) NOT NULL,
  `pfl_prenom` varchar(80) NOT NULL,
  `pfl_email` varchar(200) NOT NULL,
  `pfl_num` varchar(12) NOT NULL,
  `pfl_role` char(1) NOT NULL,
  `pfl_date_naissance` date NOT NULL,
  `pfl_adresse` varchar(250) NOT NULL,
  `cpt_id` int(11) NOT NULL,
  `adr_code_postal` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_profil_pfl`
--

INSERT INTO `t_profil_pfl` (`pfl_nom`, `pfl_prenom`, `pfl_email`, `pfl_num`, `pfl_role`, `pfl_date_naissance`, `pfl_adresse`, `cpt_id`, `adr_code_postal`) VALUES
('Admin', 'Principal', 'admin@application.fr', '0000000000', 'A', '1970-01-01', '29 Rue Buffon', 1, 29200),
('Petit', 'Leila', 'leila.petit@asso-domaine.fr', '0601010101', 'A', '1995-07-25', '1 Rue de la Fontaine', 2, 75001),
('Durand', 'David', 'david.durand@asso-domaine.fr', '0602020202', 'A', '1988-04-10', '2 Avenue des Champs', 3, 69002),
('Leroy', 'Claire', 'claire.leroy@asso-domaine.fr', '0603030303', 'A', '2000-01-05', '3 Place du Marché', 4, 13008),
('Moreau', 'Paul', 'paul.moreau@asso-domaine.fr', '0604040404', 'A', '1975-09-30', '4 Boulevard Saint-Michel', 5, 31000),
('Simon', 'Chloé', 'chloe.simon@asso-domaine.fr', '0605050505', 'M', '1998-03-22', '5 Rue Gambetta', 6, 75001),
('Fournier', 'Théo', 'theo.fournier@asso-domaine.fr', '0606060606', 'M', '1993-12-18', '6 Allée des Roses', 7, 69002),
('Garcia', 'Léa', 'lea.garcia@asso-domaine.fr', '0607070707', 'M', '1980-06-07', '7 Rue de la Victoire', 8, 13008),
('Robert', 'Axel', 'axel.robert@asso-domaine.fr', '0608080808', 'M', '1996-11-03', '8 Quai de Saône', 9, 31000),
('Dubois', 'Manon', 'manon.dubois@asso-domaine.fr', '0609090909', 'M', '1983-02-14', '9 Rue de Rivoli', 10, 75001),
('Thomas', 'Hugo', 'hugo.thomas@asso-domaine.fr', '0610101010', 'M', '1990-10-28', '10 Place Bellecour', 11, 69002),
('Perrin', 'Camille', 'camille.perrin@asso-domaine.fr', '0611111111', 'M', '1979-04-01', '11 Avenue du Prado', 12, 13008),
('Sanchez', 'Julien', 'julien.sanchez@asso-domaine.fr', '0612121212', 'M', '1997-08-16', '12 Rue des Oliviers', 13, 31000),
('Roux', 'Eva', 'eva.roux@asso-domaine.fr', '0613131313', 'M', '1982-01-25', '13 Boulevard Voltaire', 14, 75001),
('Michel', 'Maxime', 'maxime.michel@asso-domaine.fr', '0614141414', 'M', '1994-07-09', '14 Rue de la République', 15, 69002),
('Richard', 'Clément', 'clement.richard@asso-domaine.fr', '0615151515', 'M', '1989-11-21', '15 Rue Paradis', 16, 13008),
('Garnier', 'Alice', 'alice.garnier@asso-domaine.fr', '0616161616', 'M', '2001-05-04', '16 Avenue des Ternes', 17, 31000),
('Faure', 'Romain', 'romain.faure@asso-domaine.fr', '0617171717', 'M', '1976-08-12', '17 Rue de Rennes', 18, 75001),
('Lemoine', 'Juliette', 'juliette.lemoine@asso-domaine.fr', '0618181818', 'M', '1991-03-06', '18 Quai des Célestins', 19, 69002),
('Roger', 'Gabriel', 'gabriel.roger@asso-domaine.fr', '0619191919', 'M', '1984-09-19', '19 Avenue de Toulon', 20, 13008),
('Leroux', 'Inès', 'ines.leroux@asso-domaine.fr', '0620202020', 'M', '1999-12-01', '20 Place du Capitole', 21, 31000),
('Chevalier', 'Valentin', 'valentin.chevalier@asso-domaine.fr', '0621212121', 'M', '1981-05-10', '21 Rue du Four', 22, 75001),
('Masson', 'Aurélie', 'aurelie.masson@asso-domaine.fr', '0622222222', 'M', '1995-01-27', '22 Rue Grignan', 23, 69002),
('Weber', 'Émilien', 'emilien.weber@asso-domaine.fr', '0623232323', 'M', '1987-10-15', '23 Avenue de Saint-Just', 24, 13008),
('Legrand', 'Lila', 'lila.legrand@asso-domaine.fr', '0624242424', 'M', '2002-04-08', '24 Rue d’Alsace', 25, 31000),
('Marchand', 'Adrien', 'adrien.marchand@asso-domaine.fr', '0625252525', 'M', '1977-11-29', '25 Boulevard Malesherbes', 26, 75001),
('Meyer', 'Lou', 'lou.meyer@asso-domaine.fr', '0626262626', 'M', '1992-06-13', '26 Rue du Lycée', 27, 69002),
('Henry', 'Antoine', 'antoine.henry@asso-domaine.fr', '0627272727', 'M', '1985-03-02', '27 Place Castellane', 28, 13008),
('Dupuis', 'Noémie', 'noemie.dupuis@asso-domaine.fr', '0628282828', 'M', '1998-09-24', '28 Rue des Martyrs', 29, 31000),
('Lacroix', 'Enzo', 'enzo.lacroix@asso-domaine.fr', '0629292929', 'M', '1980-12-05', '29 Avenue d’Italie', 30, 75001),
('Navarro', 'Elise', 'elise.navarro@asso-domaine.fr', '0630303030', 'M', '1996-02-17', '30 Rue du Mont-Cenis', 31, 69002),
('Poirier', 'Gabin', 'gabin.poirier@asso-domaine.fr', '0631313131', 'M', '1983-07-28', '31 Boulevard de la Corderie', 32, 13008),
('Martinez', 'Sofia', 'sofia.martinez@asso-domaine.fr', '0632323232', 'M', '2000-11-10', '32 Rue des Jacobins', 33, 31000),
('Morel', 'Tristan', 'tristan.morel@asso-domaine.fr', '0633333333', 'M', '1978-04-04', '33 Rue de Maubeuge', 34, 75001),
('Rousseau', 'Jade', 'jade.rousseau@asso-domaine.fr', '0634343434', 'M', '1993-09-08', '34 Rue de Sèze', 35, 69002),
('Vincent', 'Kylian', 'kylian.vincent@asso-domaine.fr', '0635353535', 'M', '1986-01-20', '35 Avenue Foch', 36, 13008),
('Nguyen', 'Léo', 'leo.nguyen@asso-domaine.fr', '0636363636', 'M', '2001-07-03', '36 Rue d’Austerlitz', 37, 31000),
('Blanchet', 'Stella', 'stella.blanchet@asso-domaine.fr', '0637373737', 'M', '1975-10-11', '37 Boulevard Saint-Germain', 38, 75001),
('Renard', 'Tom', 'tom.renard@asso-domaine.fr', '0638383838', 'M', '1990-05-26', '38 Rue de Créqui', 39, 69002),
('Dumas', 'Zoé', 'zoe.dumas@asso-domaine.fr', '0639393939', 'M', '1984-12-09', '39 Rue de Rome', 40, 13008),
('Dufresne', 'Hugo', 'hugo.dufresne@asso-domaine.fr', '0640404040', 'M', '1999-03-07', '40 Place Wilson', 41, 31000),
('Brunet', 'Lilou', 'lilou.brunet@asso-domaine.fr', '0641414141', 'M', '1981-06-20', '41 Rue de Tolbiac', 42, 75001),
('Remy', 'Arthur', 'arthur.remy@asso-domaine.fr', '0642424242', 'M', '1995-11-01', '42 Avenue Jean Jaurès', 43, 69002),
('Gros', 'Éloïse', 'eloise.gros@asso-domaine.fr', '0643434343', 'M', '1987-08-14', '43 Rue Longue des Capucins', 44, 13008),
('Guillot', 'Nathan', 'nathan.guillot@asso-domaine.fr', '0644444444', 'M', '2002-02-28', '44 Rue du Taur', 45, 31000),
('Da Cunha', 'Tiago', 'tiago.da.cunha@asso-domaine.fr', '0645454545', 'M', '1977-09-17', '45 Rue de Turenne', 46, 75001),
('Leclerc', 'Margaux', 'margaux.leclerc@asso-domaine.fr', '0646464646', 'M', '1992-04-29', '46 Rue Mercière', 47, 69002),
('Caron', 'Noah', 'noah.caron@asso-domaine.fr', '0647474747', 'M', '1985-10-06', '47 Boulevard National', 48, 13008),
('Fernandez', 'Lina', 'lina.fernandez@asso-domaine.fr', '0648484848', 'M', '1998-05-19', '48 Rue d’Assas', 49, 31000),
('Girard', 'Kenza', 'kenza.girard@asso-domaine.fr', '0649494949', 'M', '1980-08-31', '49 Rue de la Chaussée d’Antin', 50, 75001),
('Dubois', 'Claire', 'claire.dubois@asso-domaine.fr', '0623456780', 'M', '1987-05-12', '3 Rue du Pont', 51, 75001),
('Bertrand', 'Lucas', 'lucas.bertrand@asso-domaine.fr', '0724567891', 'M', '1991-02-20', '5 Avenue Victor Hugo', 52, 69002),
('Gautier', 'Emma', 'emma.gautier@asso-domaine.fr', '0635678902', 'M', '1989-07-15', '12 Rue Saint-Michel', 53, 13008),
('Martins', 'Antoine', 'antoine.martins@asso-domaine.fr', '0736789013', 'M', '1992-03-27', '8 Rue Lafayette', 54, 31000),
('Fabre', 'Sophie', 'sophie.fabre@asso-domaine.fr', '0647890124', 'M', '1986-11-09', '15 Rue de Provence', 55, 75001),
('Colin', 'David', 'david.colin@asso-domaine.fr', '0748901235', 'M', '1990-06-18', '2 Rue des Lilas', 56, 69002),
('Roussel', 'Marine', 'marine.roussel@asso-domaine.fr', '0659012346', 'M', '1984-12-23', '20 Rue de la Paix', 57, 13008),
('Baron', 'Lucas', 'lucas.baron@asso-domaine.fr', '0750123457', 'M', '1995-04-14', '7 Boulevard Haussmann', 58, 31000),
('Mahe', 'Julie', 'julie.mahe@asso-domaine.fr', '0661234568', 'M', '1988-08-11', '9 Rue Saint-Denis', 59, 75001),
('Noir', 'Antoine', 'antoine.noir@asso-domaine.fr', '0762345679', 'M', '1993-01-03', '3 Rue du Faubourg', 60, 69002),
('Perret', 'Emma', 'emma.perret@asso-domaine.fr', '0673456780', 'M', '1987-05-07', '12 Rue Victor Hugo', 61, 13008),
('Marin', 'Lucas', 'lucas.marin@asso-domaine.fr', '0774567891', 'M', '1991-09-25', '5 Rue Montmartre', 62, 31000),
('Dumont', 'Clara', 'clara.dumont@asso-domaine.fr', '0605678902', 'M', '1989-03-12', '8 Avenue de la Gare', 63, 75001),
('Germain', 'Paul', 'paul.germain@asso-domaine.fr', '0716789013', 'M', '1992-12-05', '15 Rue Saint-Honoré', 64, 69002),
('Lemoine', 'Sophie', 'sophie.lemoine@asso-domaine.fr', '0627890124', 'M', '1985-08-19', '2 Rue du Parc', 65, 13008),
('Renard', 'Mathieu', 'mathieu.renard@asso-domaine.fr', '0728901235', 'M', '1994-07-07', '9 Rue des Rosiers', 66, 31000),
('Blanchard', 'Emma', 'emma.blanchard@asso-domaine.fr', '0639012346', 'M', '1986-11-20', '12 Rue de l’Église', 67, 75001),
('Carpentier', 'Lucas', 'lucas.carpentier@asso-domaine.fr', '0730123457', 'M', '1990-05-28', '7 Rue des Tilleuls', 68, 69002),
('Moulin', 'Claire', 'claire.moulin@asso-domaine.fr', '0641234568', 'M', '1988-02-13', '20 Rue du Temple', 69, 13008),
('Delaunay', 'Paul', 'paul.delaunay@asso-domaine.fr', '0742345679', 'M', '1993-06-09', '3 Rue de Rivoli', 70, 31000),
('Chapel', 'Emma', 'emma.chapel@asso-domaine.fr', '0653456780', 'M', '1987-09-17', '15 Rue Saint-Pierre', 71, 75001),
('Richer', 'Lucas', 'lucas.richer@asso-domaine.fr', '0754567891', 'M', '1991-12-02', '5 Rue du Bac', 72, 69002),
('Bazin', 'Julie', 'julie.bazin@asso-domaine.fr', '0665678902', 'M', '1989-04-21', '8 Rue Saint-Michel', 73, 13008),
('Monet', 'Paul', 'paul.monet@asso-domaine.fr', '0766789013', 'M', '1992-10-11', '12 Rue Lafayette', 74, 31000),
('Chevalier', 'Emma', 'emma.chevalier@asso-domaine.fr', '0677890124', 'M', '1986-06-30', '2 Rue de Provence', 75, 75001),
('Picard', 'Lucas', 'lucas.picard@asso-domaine.fr', '0778901235', 'M', '1994-03-18', '9 Rue des Fleurs', 76, 69002),
('Legros', 'Claire', 'claire.legros@asso-domaine.fr', '0609012346', 'M', '1985-12-12', '15 Avenue de la Gare', 77, 13008),
('Barre', 'Paul', 'paul.barre@asso-domaine.fr', '0710123457', 'M', '1990-08-22', '7 Rue Montmartre', 78, 31000),
('Oudin', 'Emma', 'emma.oudin@asso-domaine.fr', '0621234568', 'M', '1987-01-29', '12 Rue Saint-Honoré', 79, 75001),
('Viguier', 'Lucas', 'lucas.viguier@asso-domaine.fr', '0722345679', 'M', '1991-07-13', '3 Rue du Parc', 80, 69002),
('Chauvet', 'Julie', 'julie.chauvet@asso-domaine.fr', '0633456780', 'M', '1989-05-04', '20 Rue des Rosiers', 81, 13008),
('Bertin', 'Paul', 'paul.bertin@asso-domaine.fr', '0734567891', 'M', '1992-02-27', '15 Rue de l’Église', 82, 31000),
('Rivière', 'Emma', 'emma.riviere@asso-domaine.fr', '0645678902', 'M', '1986-09-09', '5 Rue des Tilleuls', 83, 75001),
('Joubert', 'Lucas', 'lucas.joubert@asso-domaine.fr', '0746789013', 'M', '1994-11-11', '8 Rue du Temple', 84, 69002),
('Hamel', 'Claire', 'claire.hamel@asso-domaine.fr', '0657890124', 'M', '1988-01-16', '12 Rue de Rivoli', 85, 13008),
('Pichon', 'Paul', 'paul.pichon@asso-domaine.fr', '0758901235', 'M', '1990-05-22', '2 Rue Saint-Pierre', 86, 31000),
('Lejeune', 'Emma', 'emma.lejeune@asso-domaine.fr', '0669012346', 'M', '1985-03-08', '9 Rue du Bac', 87, 75001),
('Benoît', 'Lucas', 'lucas.benoit@asso-domaine.fr', '0760123457', 'M', '1991-09-29', '15 Rue Saint-Michel', 88, 69002),
('Giraud', 'Claire', 'claire.giraud@asso-domaine.fr', '0671234568', 'M', '1987-12-05', '7 Rue Lafayette', 89, 13008),
('Boivin', 'Paul', 'paul.boivin@asso-domaine.fr', '0772345679', 'M', '1993-06-23', '12 Rue de Provence', 90, 31000),
('Vasseur', 'Emma', 'emma.vasseur@asso-domaine.fr', '0606789012', 'M', '1986-10-19', '3 Rue des Fleurs', 91, 75001),
('Roux', 'Lucas', 'lucas.roux@asso-domaine.fr', '0717890123', 'M', '1994-01-30', '20 Avenue de la Gare', 92, 69002),
('Blanc', 'Claire', 'claire.blanc@asso-domaine.fr', '0628901234', 'M', '1989-03-21', '5 Rue Montmartre', 93, 13008),
('Lecomte', 'Paul', 'paul.lecomte@asso-domaine.fr', '0729012345', 'M', '1992-07-15', '12 Rue Saint-Honoré', 94, 31000),
('Dufour', 'Emma', 'emma.dufour@asso-domaine.fr', '0630123456', 'M', '1987-11-28', '7 Rue du Parc', 95, 75001),
('Morel', 'Lucas', 'lucas.morel@asso-domaine.fr', '0731234567', 'M', '1991-04-10', '15 Rue des Rosiers', 96, 69002),
('Peltier', 'Claire', 'claire.peltier@asso-domaine.fr', '0642345678', 'M', '1988-08-03', '9 Rue de l’Église', 97, 13008),
('Normand', 'Paul', 'paul.normand@asso-domaine.fr', '0743456789', 'M', '1993-12-19', '8 Rue des Tilleuls', 98, 31000),
('Lamy', 'Emma', 'emma.lamy@asso-domaine.fr', '0654567890', 'M', '1986-06-01', '12 Rue du Temple', 99, 75001),
('Guillaume', 'Lucas', 'lucas.guillaume@asso-domaine.fr', '0755678901', 'M', '1994-02-14', '2 Rue de Rivoli', 100, 69002),
('Lacombe', 'Raphaël', 'raphael.lacombe@asso-domaine.fr', '0650505050', 'M', '1996-04-12', '50 Quai Saint-Antoine', 101, 69002),
('Pons', 'Chloé', 'chloe.pons@asso-domaine.fr', '0651515151', 'M', '1983-11-23', '51 Avenue Pasteur', 102, 13008),
('Rousselot', 'Théo', 'theo.rousselot@asso-domaine.fr', '0652525252', 'M', '2000-09-05', '52 Rue Vélane', 103, 31000),
('Leblanc', 'Maël', 'mael.leblanc@asso-domaine.fr', '0653535353', 'M', '1978-02-16', '53 Rue de la Convention', 104, 75001),
('Barbier', 'Léa', 'lea.barbier@asso-domaine.fr', '0654545454', 'M', '1993-07-30', '54 Rue des Capucins', 105, 69002),
('Bouvier', 'Louis', 'louis.bouvier@asso-domaine.fr', '0655555555', 'M', '1986-05-03', '55 Boulevard de la Libération', 106, 13008),
('Martel', 'Anna', 'anna.martel@asso-domaine.fr', '0656565656', 'M', '2001-10-25', '56 Rue Sainte-Ursule', 107, 31000),
('Sauvage', 'Jules', 'jules.sauvage@asso-domaine.fr', '0657575757', 'M', '1975-12-08', '57 Avenue Mozart', 108, 75001),
('Prevost', 'Elsa', 'elsa.prevost@asso-domaine.fr', '0658585858', 'M', '1990-11-17', '58 Rue de la Charité', 109, 69002),
('Peltier', 'Victor', 'victor.peltier@asso-domaine.fr', '0659595959', 'M', '1984-06-29', '59 Rue Thiers', 110, 13008),
('Guyot', 'Ambre', 'ambre.guyot@asso-domaine.fr', '0660606060', 'M', '1999-01-09', '60 Rue Cujas', 111, 31000),
('Colin', 'Yanis', 'yanis.colin@asso-domaine.fr', '0661616161', 'M', '1981-03-24', '61 Rue Cardinet', 112, 75001),
('Bourgeois', 'Naomi', 'naomi.bourgeois@asso-domaine.fr', '0662626262', 'M', '1995-08-07', '62 Avenue Berthelot', 113, 69002),
('Boyer', 'Gaspard', 'gaspard.boyer@asso-domaine.fr', '0663636363', 'M', '1987-04-19', '63 Rue Sainte-Anne', 114, 13008),
('Fischer', 'Nina', 'nina.fischer@asso-domaine.fr', '0664646464', 'M', '2002-10-01', '64 Rue des Pénitents', 115, 31000),
('Moulin', 'Rémi', 'remi.moulin@asso-domaine.fr', '0665656565', 'M', '1977-07-13', '65 Boulevard Ornano', 116, 75001),
('Briand', 'Sonia', 'sonia.briand@asso-domaine.fr', '0666666666', 'M', '1992-12-25', '66 Rue du Bât d’Argent', 117, 69002),
('Vidal', 'Arthur', 'arthur.vidal@asso-domaine.fr', '0667676767', 'M', '1985-05-18', '67 Avenue de la Rose', 118, 13008),
('Berthelot', 'Maëlys', 'maelys.berthelot@asso-domaine.fr', '0668686868', 'M', '1998-10-30', '68 Rue des Trois Journées', 119, 31000),
('Klein', 'Youssef', 'youssef.klein@asso-domaine.fr', '0669696969', 'M', '1980-01-21', '69 Rue de Flandre', 120, 75001),
('Perez', 'Clémence', 'clemence.perez@asso-domaine.fr', '0670707070', 'M', '1996-08-04', '70 Rue des Farges', 121, 69002),
('Lefevre', 'Esteban', 'esteban.lefevre@asso-domaine.fr', '0671717171', 'M', '1983-04-15', '71 Rue de Rome', 122, 13008),
('Huet', 'Flora', 'flora.huet@asso-domaine.fr', '0672727272', 'M', '2000-12-27', '72 Place Saint-Georges', 123, 31000),
('Joly', 'Yanis', 'yanis.joly@asso-domaine.fr', '0673737373', 'M', '1978-07-09', '73 Rue des Pyrénées', 124, 75001),
('Bailly', 'Célia', 'celia.bailly@asso-domaine.fr', '0674747474', 'M', '1993-01-23', '74 Rue de la Barre', 125, 69002),
('Voisin', 'Adam', 'adam.voisin@asso-domaine.fr', '0675757575', 'M', '1986-10-05', '75 Avenue de Mazargues', 126, 13008),
('Diot', 'Alice', 'alice.diot@asso-domaine.fr', '0676767676', 'M', '2001-04-17', '76 Rue du Rempart Saint-Étienne', 127, 31000),
('Bourdon', 'Hugo', 'hugo.bourdon@asso-domaine.fr', '0677777777', 'M', '1975-06-29', '77 Rue de Sèvres', 128, 75001),
('Gomez', 'Maeva', 'maeva.gomez@asso-domaine.fr', '0678787878', 'M', '1990-11-03', '78 Rue Duguesclin', 129, 69002),
('Barre', 'Théo', 'theo.barre@asso-domaine.fr', '0679797979', 'M', '1984-03-16', '79 Avenue de la Soude', 130, 13008),
('Leboeuf', 'Julia', 'julia.leboeuf@asso-domaine.fr', '0680808080', 'M', '1999-08-28', '80 Rue des Filatiers', 131, 31000),
('Allard', 'Clément', 'clement.allard@asso-domaine.fr', '0681818181', 'M', '1981-01-09', '81 Rue Vignon', 132, 75001),
('Delmas', 'Noémie', 'noemie.delmas@asso-domaine.fr', '0682828282', 'M', '1995-07-22', '82 Place des Terreaux', 133, 69002),
('Guérin', 'Ethan', 'ethan.guerin@asso-domaine.fr', '0683838383', 'M', '1987-02-04', '83 Rue Saint-Ferréol', 134, 13008),
('Picard', 'Louisa', 'louisa.picard@asso-domaine.fr', '0684848484', 'M', '2002-12-16', '84 Rue de Metz', 135, 31000),
('Michaud', 'Oscar', 'oscar.michaud@asso-domaine.fr', '0685858585', 'M', '1977-05-09', '85 Rue de Passy', 136, 75001),
('Ponsart', 'Lina', 'lina.ponsart@asso-domaine.fr', '0686868686', 'M', '1992-10-21', '86 Rue de la Tête d’Or', 137, 69002),
('Remy', 'Gabin', 'gabin.remy@asso-domaine.fr', '0687878787', 'M', '1985-04-03', '87 Avenue du 24 Avril', 138, 13008),
('Rouxel', 'Jade', 'jade.rouxel@asso-domaine.fr', '0688888888', 'M', '1998-11-15', '88 Rue Pargaminières', 139, 31000),
('Sanchez', 'Mathis', 'mathis.sanchez@asso-domaine.fr', '0689898989', 'M', '1980-03-26', '89 Rue du Faubourg Saint-Antoine', 140, 75001),
('Valentin', 'Chloé', 'chloe.valentin@asso-domaine.fr', '0690909090', 'M', '1996-10-08', '90 Boulevard des Belges', 141, 69002),
('Tissot', 'Axel', 'axel.tissot@asso-domaine.fr', '0691919191', 'M', '1983-05-20', '91 Avenue de Lattre de Tassigny', 142, 13008),
('Vernier', 'Léa', 'lea.vernier@asso-domaine.fr', '0692929292', 'M', '2000-08-02', '92 Rue Saint-Rome', 143, 31000),
('Bresson', 'Paul', 'paul.bresson@asso-domaine.fr', '0693939393', 'M', '1978-10-14', '93 Rue de Vaugirard', 144, 75001),
('Carré', 'Manon', 'manon.carre@asso-domaine.fr', '0694949494', 'M', '1993-03-28', '94 Rue de Gerland', 145, 69002),
('Charrier', 'Émilie', 'emilie.charrier@asso-domaine.fr', '0695959595', 'M', '1986-12-10', '95 Rue du Commandant Rolland', 146, 13008),
('Duval', 'Louis', 'louis.duval@asso-domaine.fr', '0696969696', 'M', '2001-02-23', '96 Rue d’Embarthe', 147, 31000),
('Fontaine', 'Zoé', 'zoe.fontaine@asso-domaine.fr', '0697979797', 'M', '1975-05-06', '97 Rue de Beaune', 148, 75001),
('Leroy', 'Sacha', 'sacha.leroy@asso-domaine.fr', '0698989898', 'M', '1990-12-18', '98 Rue du Garet', 149, 69002),
('Martin', 'Hugo', 'hugo.martin@asso-domaine.fr', '0699999999', 'M', '1984-07-31', '99 Avenue de Corinthe', 150, 13008),
('Bernard', 'Paul', 'paul.bernard2@asso-domaine.fr', '0700000000', 'M', '1978-11-01', '100 Rue des Lilas', 151, 31000),
('Masson', 'Marine', 'marine.masson@asso-domaine.fr', '0701010101', 'M', '1981-09-02', '101 Rue de Grenelle', 152, 75001),
('Moreau', 'Alex', 'alex.moreau@asso-domaine.fr', '0702020202', 'M', '1995-03-15', '102 Rue des Dames', 153, 69002),
('Perrin', 'Lola', 'lola.perrin@asso-domaine.fr', '0703030303', 'M', '1987-12-27', '103 Boulevard Bompard', 154, 13008),
('Richard', 'Tom', 'tom.richard@asso-domaine.fr', '0704040404', 'M', '2002-06-20', '104 Rue de la Pomme', 155, 31000),
('Robert', 'Axel', 'axel.robert2@asso-domaine.fr', '0705050505', 'M', '1977-03-14', '105 Avenue Montaigne', 156, 75001),
('Simon', 'Clara', 'clara.simon2@asso-domaine.fr', '0706060606', 'M', '1992-09-26', '106 Rue de Sèze', 157, 69002),
('Thomas', 'Nathan', 'nathan.thomas@asso-domaine.fr', '0707070707', 'M', '1985-06-08', '107 Rue d’Endoume', 158, 13008),
('Vincent', 'Elise', 'elise.vincent@asso-domaine.fr', '0708080808', 'M', '1998-12-01', '108 Rue des Lois', 159, 31000),
('Weber', 'Kylian', 'kylian.weber@asso-domaine.fr', '0709090909', 'M', '1980-04-13', '109 Rue Cadet', 160, 75001),
('Bernard', 'Lucas', 'lucas.bernard2@asso-domaine.fr', '0710101010', 'M', '1996-11-25', '110 Rue Boileau', 161, 69002),
('Fournier', 'Inès', 'ines.fournier2@asso-domaine.fr', '0711111111', 'M', '1983-08-07', '111 Rue du Repos', 162, 13008),
('Garcia', 'Paul', 'paul.garcia2@asso-domaine.fr', '0712121212', 'M', '2000-01-19', '112 Avenue Jean Jaurès', 163, 31000),
('Garnier', 'Léo', 'leo.garnier2@asso-domaine.fr', '0713131313', 'M', '1978-06-30', '113 Rue de Dunkerque', 164, 75001),
('Henry', 'Juliette', 'juliette.henry2@asso-domaine.fr', '0714141414', 'M', '1993-11-12', '114 Rue de la Thibaudière', 165, 69002),
('Lacroix', 'Hugo', 'hugo.lacroix2@asso-domaine.fr', '0715151515', 'M', '1986-03-25', '115 Boulevard de Pont-de-Vivaux', 166, 13008),
('Lemoine', 'Anna', 'anna.lemoine2@asso-domaine.fr', '0716161616', 'M', '2001-09-06', '116 Rue des Sept Troubadours', 167, 31000),
('Leroux', 'Manon', 'manon.leroux2@asso-domaine.fr', '0717171717', 'M', '1975-12-18', '117 Avenue de la République', 168, 75001),
('Marchand', 'Adrien', 'adrien.marchand2@asso-domaine.fr', '0718181818', 'M', '1990-07-02', '118 Rue de la Martinière', 169, 69002),
('Martinez', 'Clément', 'clement.martinez2@asso-domaine.fr', '0719191919', 'M', '1984-01-14', '119 Rue Sainte', 170, 13008),
('Michel', 'Lila', 'lila.michel2@asso-domaine.fr', '0720202020', 'M', '1999-05-27', '120 Rue des Arts', 171, 31000),
('Nguyen', 'Tom', 'tom.nguyen2@asso-domaine.fr', '0721212121', 'M', '1981-08-08', '121 Rue de Charenton', 172, 75001),
('Oudin', 'Lucas', 'lucas.oudin2@asso-domaine.fr', '0722222222', 'M', '1995-02-20', '122 Rue Saint-Georges', 173, 69002),
('Perez', 'Emma', 'emma.perez2@asso-domaine.fr', '0723232323', 'M', '1987-07-04', '123 Avenue de Toulon', 174, 13008),
('Petit', 'Eva', 'eva.petit2@asso-domaine.fr', '0724242424', 'M', '2002-11-15', '124 Rue Croix-Baragnon', 175, 31000),
('Poirier', 'Gabin', 'gabin.poirier2@asso-domaine.fr', '0725252525', 'M', '1977-10-27', '125 Boulevard Vincent Auriol', 176, 75001),
('Richard', 'Zoé', 'zoe.richard2@asso-domaine.fr', '0726262626', 'M', '1992-05-09', '126 Place Guichard', 177, 69002),
('Roux', 'Nathan', 'nathan.roux2@asso-domaine.fr', '0727272727', 'M', '1985-11-21', '127 Rue de la Palud', 178, 13008),
('Sanchez', 'Hugo', 'hugo.sanchez2@asso-domaine.fr', '0728282828', 'M', '1998-04-03', '128 Rue des Couteliers', 179, 31000),
('Simon', 'Manon', 'manon.simon2@asso-domaine.fr', '0729292929', 'M', '1980-10-15', '129 Rue Daguerre', 180, 75001),
('Thomas', 'Axel', 'axel.thomas2@asso-domaine.fr', '0730303030', 'M', '1996-06-27', '130 Rue du Dauphiné', 181, 69002),
('Vincent', 'Juliette', 'juliette.vincent2@asso-domaine.fr', '0731313131', 'M', '1983-01-09', '131 Boulevard de Sainte-Marguerite', 182, 13008),
('Weber', 'Léo', 'leo.weber2@asso-domaine.fr', '0732323232', 'M', '2000-07-22', '132 Rue du Pharaon', 183, 31000),
('Allard', 'Paul', 'paul.allard2@asso-domaine.fr', '0733333333', 'M', '1978-12-04', '133 Rue de Javel', 184, 75001),
('Bailly', 'Laura', 'laura.bailly2@asso-domaine.fr', '0734343434', 'M', '1993-05-18', '134 Rue de la Roquette', 185, 69002),
('Barbier', 'Maxime', 'maxime.barbier2@asso-domaine.fr', '0735353535', 'M', '1986-07-30', '135 Avenue de Mazargues', 186, 13008),
('Baron', 'Nina', 'nina.baron2@asso-domaine.fr', '0736363636', 'M', '2001-01-11', '136 Rue Montardy', 187, 31000),
('Berthelot', 'Hugo', 'hugo.berthelot2@asso-domaine.fr', '0737373737', 'M', '1975-03-24', '137 Boulevard Murat', 188, 75001),
('Bertrand', 'Chloé', 'chloe.bertrand2@asso-domaine.fr', '0738383838', 'M', '1990-09-05', '138 Rue du Plat', 189, 69002),
('Blanchet', 'Romain', 'romain.blanchet2@asso-domaine.fr', '0739393939', 'M', '1984-04-17', '139 Rue de Tilsit', 190, 13008),
('Boivin', 'Elise', 'elise.boivin2@asso-domaine.fr', '0740404040', 'M', '1999-10-30', '140 Rue de la Fonderie', 191, 31000),
('Bouvier', 'Louis', 'louis.bouvier2@asso-domaine.fr', '0741414141', 'M', '1981-02-10', '141 Rue de Tocqueville', 192, 75001),
('Boyer', 'Eva', 'eva.boyer2@asso-domaine.fr', '0742424242', 'M', '1995-09-23', '142 Rue de la Goutte d’Or', 193, 69002),
('Briand', 'Jules', 'jules.briand2@asso-domaine.fr', '0743434343', 'M', '1987-11-05', '143 Rue du Puits Neuf', 194, 13008),
('Brunet', 'Sonia', 'sonia.brunet2@asso-domaine.fr', '0744444444', 'M', '2002-05-18', '144 Rue Peyrolières', 195, 31000),
('Caron', 'Axel', 'axel.caron2@asso-domaine.fr', '0745454545', 'M', '1977-12-30', '145 Rue de l’Évangile', 196, 75001),
('Carpentier', 'Léa', 'lea.carpentier2@asso-domaine.fr', '0746464646', 'M', '1992-06-12', '146 Rue des Écoles', 197, 69002),
('Charrier', 'Victor', 'victor.charrier2@asso-domaine.fr', '0747474747', 'M', '1985-01-24', '147 Avenue du Général de Gaulle', 198, 13008),
('Chauvet', 'Ambre', 'ambre.chauvet2@asso-domaine.fr', '0748484848', 'M', '1998-07-07', '148 Rue du Pont Saint-Pierre', 199, 31000),
('Chevalier', 'Maël', 'mael.chevalier2@asso-domaine.fr', '0749494949', 'M', '1980-11-19', '149 Boulevard Serrurier', 200, 75001);

-- --------------------------------------------------------

--
-- Structure de la table `t_reservation_rsv`
--

CREATE TABLE `t_reservation_rsv` (
  `rsv_id` int(11) NOT NULL,
  `rsv_nom` varchar(80) NOT NULL,
  `rsv_date` date NOT NULL,
  `rsv_heure` time NOT NULL,
  `rsv_lieu` varchar(200) NOT NULL,
  `rsc_statut` char(1) NOT NULL,
  `rsc_id` int(11) NOT NULL,
  `rsc_bilan` varchar(600) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_reservation_rsv`
--

INSERT INTO `t_reservation_rsv` (`rsv_id`, `rsv_nom`, `rsv_date`, `rsv_heure`, `rsv_lieu`, `rsc_statut`, `rsc_id`, `rsc_bilan`) VALUES
(2, 'Entraînement Padel Avancé', '2025-12-15', '20:00:00', 'Terrain Padel N°2', 'C', 108, 'L\'éclairage était parfait, mais les ballons étaient sous-gonflés.'),
(3, 'Test Nouveau Matériel Padel', '2024-12-15', '14:00:00', 'Terrain Padel N°3', 'C', 109, 'Les nouveaux ballons sont excellents. Bien vérifier le stock avant la prochaine réservation.'),
(4, 'Tournoi Interne Padel', '2025-12-17', '17:00:00', 'Terrain Padel N°1', 'A', 110, 'Annulé pour cause de pluie. Aucune utilisation du court.'),
(5, 'Cours Collectif Débutants - Padel', '2025-12-17', '07:00:00', 'Terrain Padel N°2', 'C', 111, 'L\'eau était un peu fraîche, mais le couloir était bien réservé.'),
(6, 'Location Matériel Padel', '2025-12-01', '18:00:00', 'Terrain Padel N°3', 'C', 112, 'Matériel en bon état, tout est rentré sans dommage.');

-- --------------------------------------------------------

--
-- Structure de la table `t_ressource_rsc`
--

CREATE TABLE `t_ressource_rsc` (
  `rsc_id` int(11) NOT NULL,
  `rsc_nom` varchar(45) NOT NULL,
  `rsc_image` varchar(200) NOT NULL,
  `rsc_jauge_min` int(11) NOT NULL,
  `rsc_jauge_max` int(11) NOT NULL,
  `rsc_descriptif` varchar(200) NOT NULL,
  `rsc_liste_materiel` varchar(600) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_ressource_rsc`
--

INSERT INTO `t_ressource_rsc` (`rsc_id`, `rsc_nom`, `rsc_image`, `rsc_jauge_min`, `rsc_jauge_max`, `rsc_descriptif`, `rsc_liste_materiel`) VALUES
(108, 'Terrain de Padel 2', 'tpadel2.webp', 1, 4, 'Terrain couvert, parfait pour jouer par tous les temps.', 'Filet, éclairage, surface synthétique'),
(109, 'Terrain d’entraînement Padel', 'tpadel3.webp', 1, 2, 'Terrain réservé aux cours individuels et échauffements.', 'Cônes, filets, raquettes de démonstration'),
(110, 'Raquette de Padel', 'padel2.jpg', 1, 10, 'Raquettes de prêt disponibles pour les membres du club.', 'Raquette de padel standard'),
(111, 'Balles de Padel (x3)', '3balles.webp', 1, 15, 'Lot de 3 balles homologuées pour les compétitions.', '3 balles neuves par lot'),
(112, 'Vestiaires du Club', 'vestiaire.jpg', 1, 6, 'Vestiaires modernes équipés de douches et casiers sécurisés.', 'Casiers, bancs, douches, sèche-cheveux'),
(120, 'Maillots', 'shirt.jpg', 6, 12, 'Maillot des différentes équipes de paddle ', 'Maillots floqués'),
(125, 'terrain444', 'default.jpg', 1, 4, 'c\'est un grand terrain ', '');

--
-- Déclencheurs `t_ressource_rsc`
--
DELIMITER $$
CREATE TRIGGER `trig_verif_jauge` BEFORE INSERT ON `t_ressource_rsc` FOR EACH ROW BEGIN
    
    IF NEW.rsc_jauge_min > NEW.rsc_jauge_max THEN
        
        SET @tmp = NEW.rsc_jauge_min;
        
        SET NEW.rsc_jauge_min = NEW.rsc_jauge_max;
        SET NEW.rsc_jauge_max = @tmp;
        
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_reunion_reu`
--

CREATE TABLE `t_reunion_reu` (
  `reu_id` int(11) NOT NULL,
  `reu_salle` varchar(100) NOT NULL,
  `reu_date` date NOT NULL,
  `reu_heure` time NOT NULL,
  `reu_duree` varchar(45) NOT NULL,
  `reu_theme` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_reunion_reu`
--

INSERT INTO `t_reunion_reu` (`reu_id`, `reu_salle`, `reu_date`, `reu_heure`, `reu_duree`, `reu_theme`) VALUES
(2, 'Salle de Conférence B', '2025-10-25', '10:30:00', '01:30:00', 'Présentation plateforme Padel'),
(3, 'Bureau de Direction', '2025-11-05', '18:00:00', '01:00:00', 'Organisation Tournoi Winter Cup'),
(4, 'Gymnase Principal', '2025-12-01', '09:00:00', '08:00:00', 'Analyse nouveaux équipements Padel'),
(5, 'Salle de Yoga/Détente', '2025-10-28', '08:00:00', '00:45:00', 'Formation bénévoles Padel'),
(6, 'Club-house (Bar)', '2025-12-10', '19:30:00', '01:15:00', 'Bilan annuel Padel');

--
-- Déclencheurs `t_reunion_reu`
--
DELIMITER $$
CREATE TRIGGER `trigger_supprime_reuinion` BEFORE DELETE ON `t_reunion_reu` FOR EACH ROW BEGIN
    DELETE FROM t_inscription_ins WHERE reu_id = OLD.reu_id;
    DELETE FROM t_document_dcm WHERE reu_id = OLD.reu_id;
END
$$
DELIMITER ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `t_actualite_act`
--
ALTER TABLE `t_actualite_act`
  ADD PRIMARY KEY (`act_id`),
  ADD KEY `fk_t_actualite_act_t_compte_cpt1_idx` (`cpt_id`);

--
-- Index pour la table `t_adresse_adr`
--
ALTER TABLE `t_adresse_adr`
  ADD PRIMARY KEY (`adr_code_postal`);

--
-- Index pour la table `t_association_asc`
--
ALTER TABLE `t_association_asc`
  ADD PRIMARY KEY (`rsc_id`,`ind_id`),
  ADD KEY `fk_ind_assoc` (`ind_id`);

--
-- Index pour la table `t_compte_cpt`
--
ALTER TABLE `t_compte_cpt`
  ADD PRIMARY KEY (`cpt_id`),
  ADD UNIQUE KEY `cpt_pseudo_UNIQUE` (`cpt_pseudo`);

--
-- Index pour la table `t_document_dcm`
--
ALTER TABLE `t_document_dcm`
  ADD PRIMARY KEY (`doc_id`),
  ADD KEY `fk_t_document_dcm_t_reunion_reu1_idx` (`reu_id`);

--
-- Index pour la table `t_indisponibilite_ind`
--
ALTER TABLE `t_indisponibilite_ind`
  ADD PRIMARY KEY (`ind_id`),
  ADD KEY `fk_t_indisponibilite_ind_t_motif_mot1_idx` (`motif_id`);

--
-- Index pour la table `t_inscription_ins`
--
ALTER TABLE `t_inscription_ins`
  ADD PRIMARY KEY (`cpt_id`,`reu_id`),
  ADD KEY `fk_t_compte_cpt_has_t_reservation_rsv_t_compte_cpt_idx` (`cpt_id`),
  ADD KEY `fk_t_inscription_ins_t_reunion_reu1_idx` (`reu_id`);

--
-- Index pour la table `t_message_msg`
--
ALTER TABLE `t_message_msg`
  ADD PRIMARY KEY (`msg_id`),
  ADD UNIQUE KEY `msg_code` (`msg_code`),
  ADD KEY `cpt_id` (`cpt_id`);

--
-- Index pour la table `t_motif_mot`
--
ALTER TABLE `t_motif_mot`
  ADD PRIMARY KEY (`motif_id`);

--
-- Index pour la table `t_participe_prt`
--
ALTER TABLE `t_participe_prt`
  ADD PRIMARY KEY (`cpt_id`,`rsv_id`),
  ADD KEY `fk_t_reunion_reu_has_t_compte_cpt_t_compte_cpt1_idx` (`cpt_id`),
  ADD KEY `fk_t_participe_prt_t_reservation_rsv1_idx` (`rsv_id`);

--
-- Index pour la table `t_profil_pfl`
--
ALTER TABLE `t_profil_pfl`
  ADD PRIMARY KEY (`cpt_id`),
  ADD UNIQUE KEY `pfl_num_UNIQUE` (`pfl_num`),
  ADD UNIQUE KEY `cpt_id_UNIQUE` (`cpt_id`),
  ADD KEY `fk_t_profil_pfl_t_compte_cpt1_idx` (`cpt_id`),
  ADD KEY `fk_t_profil_pfl_t_adresse_adr1_idx` (`adr_code_postal`);

--
-- Index pour la table `t_reservation_rsv`
--
ALTER TABLE `t_reservation_rsv`
  ADD PRIMARY KEY (`rsv_id`,`rsc_id`),
  ADD KEY `fk_t_reservation_rsv_t_ressource_rsc1_idx` (`rsc_id`);

--
-- Index pour la table `t_ressource_rsc`
--
ALTER TABLE `t_ressource_rsc`
  ADD PRIMARY KEY (`rsc_id`);

--
-- Index pour la table `t_reunion_reu`
--
ALTER TABLE `t_reunion_reu`
  ADD PRIMARY KEY (`reu_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `t_actualite_act`
--
ALTER TABLE `t_actualite_act`
  MODIFY `act_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `t_compte_cpt`
--
ALTER TABLE `t_compte_cpt`
  MODIFY `cpt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=247;

--
-- AUTO_INCREMENT pour la table `t_document_dcm`
--
ALTER TABLE `t_document_dcm`
  MODIFY `doc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `t_indisponibilite_ind`
--
ALTER TABLE `t_indisponibilite_ind`
  MODIFY `ind_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `t_message_msg`
--
ALTER TABLE `t_message_msg`
  MODIFY `msg_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT pour la table `t_profil_pfl`
--
ALTER TABLE `t_profil_pfl`
  MODIFY `cpt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- AUTO_INCREMENT pour la table `t_reservation_rsv`
--
ALTER TABLE `t_reservation_rsv`
  MODIFY `rsv_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `t_ressource_rsc`
--
ALTER TABLE `t_ressource_rsc`
  MODIFY `rsc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=126;

--
-- AUTO_INCREMENT pour la table `t_reunion_reu`
--
ALTER TABLE `t_reunion_reu`
  MODIFY `reu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `t_actualite_act`
--
ALTER TABLE `t_actualite_act`
  ADD CONSTRAINT `fk_t_actualite_act_t_compte_cpt1` FOREIGN KEY (`cpt_id`) REFERENCES `t_compte_cpt` (`cpt_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_association_asc`
--
ALTER TABLE `t_association_asc`
  ADD CONSTRAINT `fk_ind_assoc` FOREIGN KEY (`ind_id`) REFERENCES `t_indisponibilite_ind` (`ind_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rsc_assoc` FOREIGN KEY (`rsc_id`) REFERENCES `t_ressource_rsc` (`rsc_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `t_document_dcm`
--
ALTER TABLE `t_document_dcm`
  ADD CONSTRAINT `fk_t_document_dcm_t_reunion_reu1` FOREIGN KEY (`reu_id`) REFERENCES `t_reunion_reu` (`reu_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_indisponibilite_ind`
--
ALTER TABLE `t_indisponibilite_ind`
  ADD CONSTRAINT `fk_t_indisponibilite_ind_t_motif_mot1` FOREIGN KEY (`motif_id`) REFERENCES `t_motif_mot` (`motif_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_inscription_ins`
--
ALTER TABLE `t_inscription_ins`
  ADD CONSTRAINT `fk_t_compte_cpt_has_t_reservation_rsv_t_compte_cpt` FOREIGN KEY (`cpt_id`) REFERENCES `t_compte_cpt` (`cpt_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_inscription_ins_t_reunion_reu1` FOREIGN KEY (`reu_id`) REFERENCES `t_reunion_reu` (`reu_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_message_msg`
--
ALTER TABLE `t_message_msg`
  ADD CONSTRAINT `t_message_msg_ibfk_1` FOREIGN KEY (`cpt_id`) REFERENCES `t_compte_cpt` (`cpt_id`);

--
-- Contraintes pour la table `t_participe_prt`
--
ALTER TABLE `t_participe_prt`
  ADD CONSTRAINT `fk_t_participe_prt_t_reservation_rsv1` FOREIGN KEY (`rsv_id`) REFERENCES `t_reservation_rsv` (`rsv_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_reunion_reu_has_t_compte_cpt_t_compte_cpt1` FOREIGN KEY (`cpt_id`) REFERENCES `t_compte_cpt` (`cpt_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_profil_pfl`
--
ALTER TABLE `t_profil_pfl`
  ADD CONSTRAINT `fk_t_profil_pfl_t_adresse_adr1` FOREIGN KEY (`adr_code_postal`) REFERENCES `t_adresse_adr` (`adr_code_postal`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_profil_pfl_t_compte_cpt1` FOREIGN KEY (`cpt_id`) REFERENCES `t_compte_cpt` (`cpt_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_reservation_rsv`
--
ALTER TABLE `t_reservation_rsv`
  ADD CONSTRAINT `fk_t_reservation_rsv_t_ressource_rsc1` FOREIGN KEY (`rsc_id`) REFERENCES `t_ressource_rsc` (`rsc_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
