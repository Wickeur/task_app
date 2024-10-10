-- Créer la table `task_api` si elle n'existe pas déjà
CREATE TABLE IF NOT EXISTS task_api (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('En attente', 'En cours', 'Terminée') DEFAULT 'En attente',
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insérer des fausses données en français dans la table `task_api`
INSERT INTO task_api (title, description, status, due_date) VALUES
('Acheter des courses', 'Acheter du lait, des œufs et du pain à l’épicerie.', 'En attente', '2024-09-25'),
('Terminer le rapport de projet', 'Rédiger la version finale du rapport de projet pour relecture.', 'En cours', '2024-09-28'),
('Prendre rendez-vous chez le dentiste', 'Appeler le dentiste et réserver un rendez-vous pour la semaine prochaine.', 'Terminée', '2024-09-15'),
('Assister à la réunion d’équipe', 'Participer à la réunion d’équipe hebdomadaire pour discuter des progrès du projet.', 'En cours', '2024-09-22'),
('Faire du sport', 'Faire une séance d’entraînement de 30 minutes à la salle de sport.', 'En attente', '2024-09-26'),
('Lire un livre', 'Terminer la lecture des trois premiers chapitres du livre.', 'Terminée', '2024-09-20'),
('Organiser une escapade le week-end', 'Rechercher et réserver un hébergement pour le voyage du week-end.', 'En attente', '2024-09-30'),
('Soumettre les formulaires fiscaux', 'Rassembler tous les documents nécessaires et soumettre les formulaires fiscaux avant la date limite.', 'Terminée', '2024-09-18'),
('Nettoyer la maison', 'Faire un nettoyage général du salon et de la cuisine.', 'En attente', '2024-09-27'),
('Répondre aux e-mails des clients', 'Répondre à tous les e-mails des clients en attente de la semaine dernière.', 'En cours', '2024-09-22');

-- Vérifier que les données ont été insérées correctement
SELECT * FROM task_api;
