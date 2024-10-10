<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
require 'db.php';

// Récupérer toutes les tâches
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $stmt = $pdo->query('SELECT * FROM task_api');
    $tasks = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($tasks);
}

// Ajouter une nouvelle tâche
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);
    $stmt = $pdo->prepare("INSERT INTO task_api (title, description, status, due_date) VALUES (?, ?, ?, ?)");
    $stmt->execute([$data['title'], $data['description'], $data['status'], $data['due_date']]);
    echo json_encode(['message' => 'Tâche ajoutée avec succès']);
}

// Modifier une tâche
if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $data = json_decode(file_get_contents("php://input"), true);
    $stmt = $pdo->prepare("UPDATE task_api SET title = ?, description = ?, status = ?, due_date = ? WHERE id = ?");
    $stmt->execute([$data['title'], $data['description'], $data['status'], $data['due_date'], $data['id']]);
    echo json_encode(['message' => 'Tâche mise à jour avec succès']);
}


// Supprimer une tâche
if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $data = json_decode(file_get_contents("php://input"), true);
    
    if (isset($data['id'])) {
        $stmt = $pdo->prepare("DELETE FROM task_api WHERE id = ?");
        $stmt->execute([$data['id']]);
        echo json_encode(['message' => 'Tâche supprimée avec succès']);
    } else {
        echo json_encode(['error' => 'ID non fourni']);
    }
}
?>
