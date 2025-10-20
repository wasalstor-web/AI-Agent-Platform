<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

$uploadDir = __DIR__ . '/../uploads/';
if (!file_exists($uploadDir)) {
    mkdir($uploadDir, 0755, true);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['file'])) {
    $file = $_FILES['file'];
    $filename = basename($file['name']);
    $targetPath = $uploadDir . $filename;
    
    if (move_uploaded_file($file['tmp_name'], $targetPath)) {
        echo json_encode(['success' => true, 'message' => 'تم رفع الملف بنجاح', 'filename' => $filename], JSON_UNESCAPED_UNICODE);
    } else {
        echo json_encode(['success' => false, 'message' => 'فشل في حفظ الملف'], JSON_UNESCAPED_UNICODE);
    }
} elseif ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $files = array_diff(scandir($uploadDir), ['.', '..']);
    echo json_encode(['success' => true, 'files' => array_values($files)], JSON_UNESCAPED_UNICODE);
}
?>