<?php
/**
 * Agent Webhook Receiver for Hostinger Server
 * Created by Zapier Agent - Nov 18, 2025 08:42:42 PM
 */

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, X-Agent-Token, X-Agent-Source');

// معالجة الـ OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

// التحقق من صحة الطلب
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

// التحقق من الـ token الأمني
$headers = getallheaders();
$expected_token = 'QweAsdZxc@555_SECURE';

if (!isset($headers['X-Agent-Token']) || $headers['X-Agent-Token'] !== $expected_token) {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

// قراءة البيانات الواردة
$input = file_get_contents('php://input');
$data = json_decode($input, true);

if (!$data) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid JSON']);
    exit;
}

// مسار ملف السجلات
$log_file = __DIR__ . '/agent_reports.json';
$reports = [];

// قراءة السجلات الموجودة
if (file_exists($log_file)) {
    $reports = json_decode(file_get_contents($log_file), true) ?: [];
}

// إضافة التقرير الجديد
$data['received_at'] = date('Y-m-d H:i:s');
$data['server_processed'] = true;
$data['server_ip'] = '147.93.120.99';
$reports[] = $data;

// الاحتفاظ بآخر 100 تقرير فقط
if (count($reports) > 100) {
    $reports = array_slice($reports, -100);
}

// حفظ السجلات
file_put_contents($log_file, json_encode($reports, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));

// تسجيل في ملف لوج منفصل
$log_entry = date('[Y-m-d H:i:s] ') . "Agent Report: {$data['agent_name']} - Status: {$data['status']}\n";
file_put_contents(__DIR__ . '/agent.log', $log_entry, FILE_APPEND | LOCK_EX);

// تشغيل مهام إضافية
if ($data['status'] === 'completed') {
    // يمكنك إضافة مهام إضافية هنا
    processCompletedAgent($data);
}

// إرسال استجابة نجاح
echo json_encode([
    'status' => 'success',
    'message' => 'Agent report received successfully',
    'report_id' => count($reports),
    'timestamp' => date('c'),
    'server' => 'Hostinger-147.93.120.99'
]);

function processCompletedAgent($data) {
    // معالجة إضافية عند اكتمال المهام
    error_log("Agent completed successfully: " . $data['agent_name']);
}
?>