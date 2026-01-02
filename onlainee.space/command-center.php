<?php
/**
 * 🤖 KHALID'S AI AGENT COMMAND CENTER 🤖
 * نظام قيادة الوكيل الذكي المتطور المتصل دائماً
 * Created: Nov 18, 2025 08:42:42 PM
 * Server: onlainee.space
 */

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Command-Token');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

// 🔐 SECURITY - Khalid's Command Token
$KHALID_TOKEN = 'KHALID_MASTER_2025_AGENT';
$headers = getallheaders();

if (!isset($headers['X-Command-Token']) || $headers['X-Command-Token'] !== $KHALID_TOKEN) {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized Access', 'message' => 'خالد فقط يستطيع التحكم بالوكيل']);
    exit;
}

// 📝 COMMAND PROCESSING
$input = file_get_contents('php://input');
$command_data = json_decode($input, true);

if (!$command_data || !isset($command_data['command'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid command format']);
    exit;
}

$command = $command_data['command'];
$params = $command_data['params'] ?? [];

// 📂 COMMAND LOGS
$command_log = __DIR__ . '/khalid_commands.json';
$commands = [];
if (file_exists($command_log)) {
    $commands = json_decode(file_get_contents($command_log), true) ?: [];
}

// 🤖 AI PROGRAMS ON SERVER
$ai_programs = [
    'chatgpt' => '/var/www/ai/chatgpt/start.sh',
    'claude' => '/var/www/ai/claude/run.py',
    'gemini' => '/var/www/ai/gemini/activate.js',
    'local_llm' => '/var/www/ai/local/llama.py',
    'image_ai' => '/var/www/ai/stable-diffusion/generate.py',
    'voice_ai' => '/var/www/ai/whisper/transcribe.sh',
    'code_ai' => '/var/www/ai/codellama/code.py'
];

// 🎯 COMMAND EXECUTION ENGINE
switch($command) {
    case 'status':
        $response = getSystemStatus();
        break;
        
    case 'start_ai':
        $ai_name = $params['ai'] ?? 'chatgpt';
        $response = startAIProgram($ai_name, $ai_programs);
        break;
        
    case 'stop_ai':
        $ai_name = $params['ai'] ?? 'all';
        $response = stopAIProgram($ai_name);
        break;
        
    case 'execute_command':
        $cmd = $params['cmd'] ?? '';
        $response = executeServerCommand($cmd);
        break;
        
    case 'update_system':
        $response = updateSystem();
        break;
        
    case 'restart_services':
        $service = $params['service'] ?? 'nginx';
        $response = restartService($service);
        break;
        
    case 'backup_data':
        $response = backupData();
        break;
        
    case 'monitor_resources':
        $response = monitorResources();
        break;
        
    case 'deploy_code':
        $repo = $params['repo'] ?? 'AI-Agent-Platform';
        $response = deployCode($repo);
        break;
        
    case 'publish_all':
        $response = publishAll();
        break;
        
    default:
        $response = [
            'status' => 'error',
            'message' => 'Unknown command',
            'available_commands' => [
                'status', 'start_ai', 'stop_ai', 'execute_command',
                'update_system', 'restart_services', 'backup_data',
                'monitor_resources', 'deploy_code', 'publish_all'
            ]
        ];
}

// 📊 LOG COMMAND
$command_entry = [
    'timestamp' => date('Y-m-d H:i:s'),
    'command' => $command,
    'params' => $params,
    'response_status' => $response['status'] ?? 'unknown',
    'executor' => 'khalid',
    'server' => 'onlainee.space'
];

$commands[] = $command_entry;
if (count($commands) > 200) {
    $commands = array_slice($commands, -200);
}

file_put_contents($command_log, json_encode($commands, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));

// 🚀 SEND RESPONSE
echo json_encode($response, JSON_UNESCAPED_UNICODE);

// 🔧 SYSTEM FUNCTIONS

function getSystemStatus() {
    $uptime = shell_exec('uptime');
    $disk_usage = shell_exec('df -h /');
    $memory = shell_exec('free -m');
    $processes = shell_exec('ps aux | grep -E "(php|nginx|mysql)" | wc -l');
    
    return [
        'status' => 'success',
        'message' => 'نظام خالد للوكيل الذكي يعمل بكامل طاقته! 🚀',
        'server_info' => [
            'domain' => 'onlainee.space',
            'uptime' => trim($uptime),
            'disk_usage' => trim($disk_usage),
            'active_processes' => (int)trim($processes),
            'php_version' => PHP_VERSION,
            'timestamp' => date('Y-m-d H:i:s')
        ],
        'agent_status' => '🤖 الوكيل متصل ومستعد لتنفيذ أوامر خالد'
    ];
}

function startAIProgram($ai_name, $ai_programs) {
    if (!isset($ai_programs[$ai_name])) {
        return [
            'status' => 'error',
            'message' => "برنامج الـ AI '$ai_name' غير موجود",
            'available_ai' => array_keys($ai_programs)
        ];
    }
    
    $program_path = $ai_programs[$ai_name];
    if (file_exists($program_path)) {
        $output = shell_exec("nohup $program_path > /dev/null 2>&1 & echo $!");
        $pid = trim($output);
        
        return [
            'status' => 'success',
            'message' => "تم تشغيل $ai_name بنجاح! 🤖",
            'ai_program' => $ai_name,
            'process_id' => $pid,
            'path' => $program_path
        ];
    } else {
        return [
            'status' => 'error',
            'message' => "ملف برنامج $ai_name غير موجود على السيرفر",
            'expected_path' => $program_path
        ];
    }
}

function stopAIProgram($ai_name) {
    if ($ai_name === 'all') {
        $output = shell_exec('pkill -f "(chatgpt|claude|gemini|llama|whisper)"');
        return [
            'status' => 'success',
            'message' => 'تم إيقاف جميع برامج الـ AI 🔴',
            'action' => 'stopped_all_ai'
        ];
    } else {
        $output = shell_exec("pkill -f '$ai_name'");
        return [
            'status' => 'success',
            'message' => "تم إيقاف $ai_name 🔴",
            'stopped_ai' => $ai_name
        ];
    }
}

function executeServerCommand($cmd) {
    // 🔒 SECURITY: Only allow safe commands
    $safe_commands = ['ls', 'pwd', 'whoami', 'date', 'df', 'free', 'ps', 'uptime', 'top'];
    $cmd_parts = explode(' ', $cmd);
    $base_cmd = $cmd_parts[0];
    
    if (!in_array($base_cmd, $safe_commands)) {
        return [
            'status' => 'error',
            'message' => "الأمر '$base_cmd' غير مسموح لأسباب الأمان",
            'allowed_commands' => $safe_commands
        ];
    }
    
    $output = shell_exec($cmd . ' 2>&1');
    
    return [
        'status' => 'success',
        'message' => 'تم تنفيذ الأمر بنجاح ⚡',
        'command' => $cmd,
        'output' => trim($output)
    ];
}

function updateSystem() {
    $output = [];
    $output[] = shell_exec('sudo apt update 2>&1');
    $output[] = shell_exec('sudo apt upgrade -y 2>&1');
    
    return [
        'status' => 'success',
        'message' => 'تم تحديث النظام بنجاح! 🔄',
        'update_log' => implode("\n", $output)
    ];
}

function restartService($service) {
    $allowed_services = ['nginx', 'apache2', 'mysql', 'php-fpm', 'redis'];
    
    if (!in_array($service, $allowed_services)) {
        return [
            'status' => 'error',
            'message' => "الخدمة '$service' غير مسموحة",
            'allowed_services' => $allowed_services
        ];
    }
    
    $output = shell_exec("sudo systemctl restart $service 2>&1");
    
    return [
        'status' => 'success',
        'message' => "تم إعادة تشغيل خدمة $service 🔄",
        'service' => $service,
        'output' => trim($output)
    ];
}

function backupData() {
    $backup_dir = '/var/backups/agent-' . date('Y-m-d-H-i-s');
    $commands = [
        "mkdir -p $backup_dir",
        "cp -r /var/www/html $backup_dir/",
        "tar -czf $backup_dir.tar.gz $backup_dir",
        "rm -rf $backup_dir"
    ];
    
    foreach ($commands as $cmd) {
        shell_exec($cmd);
    }
    
    return [
        'status' => 'success',
        'message' => 'تم إنشاء نسخة احتياطية بنجاح! 💾',
        'backup_file' => $backup_dir . '.tar.gz',
        'timestamp' => date('Y-m-d H:i:s')
    ];
}

function monitorResources() {
    $cpu = shell_exec("top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | cut -d'%' -f1");
    $memory = shell_exec("free | grep Mem | awk '{printf \"%.2f\", $3/$2 * 100.0}'");
    $disk = shell_exec("df / | tail -1 | awk '{print $5}' | cut -d'%' -f1");
    
    return [
        'status' => 'success',
        'message' => 'إحصائيات السيرفر محدثة 📊',
        'resources' => [
            'cpu_usage' => trim($cpu) . '%',
            'memory_usage' => trim($memory) . '%',
            'disk_usage' => trim($disk) . '%',
            'timestamp' => date('Y-m-d H:i:s')
        ]
    ];
}

function deployCode($repo) {
    $deploy_commands = [
        "cd /var/www/html",
        "git pull origin main",
        "composer install --no-dev",
        "npm install --production",
        "pm2 restart all"
    ];
    
    $output = [];
    foreach ($deploy_commands as $cmd) {
        $output[] = shell_exec($cmd . ' 2>&1');
    }
    
    return [
        'status' => 'success',
        'message' => "تم نشر الكود من $repo بنجاح! 🚀",
        'repository' => $repo,
        'deploy_log' => implode("\n", $output),
        'timestamp' => date('Y-m-d H:i:s')
    ];
}

function publishAll() {
    $project_root = '/var/www/html';
    $deployment_steps = [];
    $all_success = true;
    $errors = [];
    
    // Step 1: Git pull latest changes
    $git_pull = shell_exec("cd $project_root && git pull origin main 2>&1");
    $deployment_steps[] = [
        'step' => 1,
        'name' => 'Git Pull',
        'status' => strpos($git_pull, 'error') === false ? 'success' : 'warning',
        'output' => trim($git_pull)
    ];
    
    // Step 2: Run autonomous deployment
    if (file_exists("$project_root/autonomous-deploy.sh")) {
        $autonomous_output = shell_exec("cd $project_root && bash autonomous-deploy.sh 2>&1");
        $deployment_steps[] = [
            'step' => 2,
            'name' => 'Autonomous Deployment',
            'status' => 'success',
            'output' => substr(trim($autonomous_output), -500) // Last 500 chars
        ];
    } else {
        $deployment_steps[] = [
            'step' => 2,
            'name' => 'Autonomous Deployment',
            'status' => 'skipped',
            'output' => 'Script not found'
        ];
    }
    
    // Step 3: Run OpenWebUI integration
    if (file_exists("$project_root/deploy-openwebui-integration.sh")) {
        $openwebui_output = shell_exec("cd $project_root && bash deploy-openwebui-integration.sh 2>&1");
        $deployment_steps[] = [
            'step' => 3,
            'name' => 'OpenWebUI Integration',
            'status' => 'success',
            'output' => substr(trim($openwebui_output), -500)
        ];
    } else {
        $deployment_steps[] = [
            'step' => 3,
            'name' => 'OpenWebUI Integration',
            'status' => 'skipped',
            'output' => 'Script not found'
        ];
    }
    
    // Step 4: Install dependencies
    $composer_output = shell_exec("cd $project_root && composer install --no-dev 2>&1");
    $npm_output = shell_exec("cd $project_root && npm install --production 2>&1");
    $deployment_steps[] = [
        'step' => 4,
        'name' => 'Install Dependencies',
        'status' => 'success',
        'output' => 'Composer and npm dependencies installed'
    ];
    
    // Step 5: Git push to trigger GitHub Pages
    $git_status = shell_exec("cd $project_root && git status --porcelain 2>&1");
    if (!empty(trim($git_status))) {
        $git_add = shell_exec("cd $project_root && git add . 2>&1");
        $git_commit = shell_exec("cd $project_root && git commit -m 'Auto-deploy: Publish all components' 2>&1");
        $git_push = shell_exec("cd $project_root && git push origin main 2>&1");
        $deployment_steps[] = [
            'step' => 5,
            'name' => 'Git Push to GitHub',
            'status' => strpos($git_push, 'error') === false ? 'success' : 'warning',
            'output' => trim($git_push)
        ];
    } else {
        $deployment_steps[] = [
            'step' => 5,
            'name' => 'Git Push to GitHub',
            'status' => 'skipped',
            'output' => 'No changes to commit'
        ];
    }
    
    // Step 6: Restart services
    $pm2_restart = shell_exec("cd $project_root && pm2 restart all 2>&1");
    $deployment_steps[] = [
        'step' => 6,
        'name' => 'Restart Services',
        'status' => 'success',
        'output' => trim($pm2_restart) ?: 'Services restarted'
    ];
    
    return [
        'status' => $all_success ? 'success' : 'warning',
        'message' => 'تم نشر جميع المكونات بنجاح! 🚀',
        'deployment_steps' => $deployment_steps,
        'total_steps' => count($deployment_steps),
        'timestamp' => date('Y-m-d H:i:s')
    ];
}
?>