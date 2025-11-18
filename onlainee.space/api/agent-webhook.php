<?php
/**
 * ملف استقبال بيانات الوكيل الذكي
 * المخصص لدومين onlainee.space
 * تم إنشاؤه بواسطة Zapier في Nov 18, 2025 08:42:42 PM
 */

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, X-Agent-Token, X-Agent-Source');

// معالجة طلبات OPTIONS
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

// التحقق من طريقة الطلب
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode([
        'error' => 'Method not allowed',
        'allowed_methods' => ['POST'],
        'server' => 'onlainee.space'
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

// التحقق من المفتاح الأمني
$headers = getallheaders();
$expected_token = 'QweAsdZxc@555_SECURE';

if (!isset($headers['X-Agent-Token']) || $headers['X-Agent-Token'] !== $expected_token) {
    http_response_code(401);
    echo json_encode([
        'error' => 'Unauthorized - Invalid token',
        'server' => 'onlainee.space',
        'timestamp' => date('Y-m-d H:i:s')
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

// قراءة البيانات الواردة
$input = file_get_contents('php://input');
$data = json_decode($input, true);

if (!$data) {
    http_response_code(400);
    echo json_encode([
        'error' => 'Invalid JSON format',
        'received_data' => substr($input, 0, 200)
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

// ملفات التسجيل
$reports_file = __DIR__ . '/agent_reports.json';
$activity_log = __DIR__ . '/agent_activity.log';
$error_log = __DIR__ . '/agent_errors.log';

try {
    // قراءة التقارير الحالية
    $reports = [];
    if (file_exists($reports_file)) {
        $reports = json_decode(file_get_contents($reports_file), true) ?: [];
    }
    
    // إضافة معلومات الخادم
    $data['received_at'] = date('Y-m-d H:i:s');
    $data['server_domain'] = 'onlainee.space';
    $data['server_ip'] = $_SERVER['SERVER_ADDR'] ?? gethostbyname($_SERVER['SERVER_NAME']);
    $data['processed_by'] = 'onlainee-webhook-v1.0';
    $data['user_agent'] = $_SERVER['HTTP_USER_AGENT'] ?? 'unknown';
    
    // إضافة التقرير الجديد
    $reports[] = $data;
    
    // الاحتفاظ بآخر 150 تقرير
    if (count($reports) > 150) {
        $reports = array_slice($reports, -150);
    }
    
    // حفظ التقارير
    file_put_contents($reports_file, json_encode($reports, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
    
    // تسجيل النشاط
    $log_entry = date('[Y-m-d H:i:s] ') . "SUCCESS: {$data['agent_name']} - Status: {$data['status']} - Tasks: {$data['tasks_completed']}\n";
    file_put_contents($activity_log, $log_entry, FILE_APPEND | LOCK_EX);
    
    // معالجة التقارير الناجحة
    if ($data['status'] === 'completed') {
        processSuccessfulReport($data);
    }
    
    // إرسال رد ناجح
    echo json_encode([
        'status' => 'success',
        'message' => 'تم استلام التقرير بنجاح',
        'report_id' => count($reports),
        'timestamp' => date('c'),
        'server_info' => [
            'domain' => 'onlainee.space',
            'php_version' => PHP_VERSION,
            'server_time' => date('Y-m-d H:i:s'),
            'total_reports' => count($reports)
        ],
        'received_data' => [
            'agent_name' => $data['agent_name'],
            'report_date' => $data['report_date'],
            'tasks_completed' => $data['tasks_completed']
        ]
    ], JSON_UNESCAPED_UNICODE);
    
} catch (Exception $e) {
    // تسجيل الأخطاء
    $error_entry = date('[Y-m-d H:i:s] ') . "ERROR: " . $e->getMessage() . "\n";
    file_put_contents($error_log, $error_entry, FILE_APPEND | LOCK_EX);
    
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'message' => 'خطأ في معالجة التقرير',
        'error_details' => $e->getMessage(),
        'timestamp' => date('c')
    ], JSON_UNESCAPED_UNICODE);
}

function processSuccessfulReport($data) {
    // معالجة إضافية للتقارير الناجحة
    $success_log = __DIR__ . '/successful_reports.log';
    $entry = date('[Y-m-d H:i:s] ') . "COMPLETED: Agent '{$data['agent_name']}' finished {$data['tasks_completed']} tasks\n";
    file_put_contents($success_log, $entry, FILE_APPEND | LOCK_EX);
    
    // يمكن إضافة المزيد من المعالجة هنا:
    // - إرسال إشعارات
    // - تحديث قواعد البيانات
    // - تشغيل مهام إضافية
    
    return true;
}
?>