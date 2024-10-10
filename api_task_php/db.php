<?php
$host = 'localhost';
$db = 'task_api'; // Remplacez par le nom de votre base de données
$user = 'root'; // Utilisateur par défaut de WAMP
$password = ''; // Mot de passe par défaut (généralement vide)

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db;charset=utf8", $user, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo 'Erreur de connexion : ' . $e->getMessage();
}
?>
