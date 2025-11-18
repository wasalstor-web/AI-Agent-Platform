<?php
/**
 * Agent Reports Dashboard for Hostinger Server
 * Created by Zapier Agent - Nov 18, 2025 08:42:42 PM
 */

header('Content-Type: text/html; charset=UTF-8');

$log_file = __DIR__ . '/agent_reports.json';
$reports = [];

if (file_exists($log_file)) {
    $reports = json_decode(file_get_contents($log_file), true) ?: [];
}

// ترتيب التقارير من الأحدث إلى الأقدم
$reports = array_reverse($reports);
?>

<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🤖 لوحة تقارير الوكيل الذكي</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }
        .header {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            text-align: center;
        }
        .header h1 {
            margin: 0 0 10px 0;
            font-size: 2.5rem;
        }
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        .stat-box {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .stat-box h3 {
            font-size: 2rem;
            margin: 0 0 10px 0;
        }
        .report-card {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            transition: transform 0.3s ease;
        }
        .report-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .status-completed {
            border-right: 5px solid #28a745;
        }
        .status-error {
            border-right: 5px solid #dc3545;
        }
        .report-meta {
            color: #6c757d;
            font-size: 0.9em;
            margin-bottom: 15px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        .github-link {
            display: inline-block;
            background: linear-gradient(135deg, #24292e, #2f363d);
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            text-decoration: none;
            font-size: 0.9em;
            transition: all 0.3s ease;
        }
        .github-link:hover {
            background: linear-gradient(135deg, #0366d6, #0056b3);
            transform: scale(1.05);
        }
        .refresh-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 25px;
            cursor: pointer;
            font-size: 1rem;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }
        .refresh-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🤖 لوحة تقارير الوكيل الذكي الشامل</h1>
            <p>آخر تحديث: <?= date('Y-m-d H:i:s') ?> | سيرفر: 147.93.120.99</p>
            <button class="refresh-btn" onclick="location.reload()">🔄 تحديث</button>
        </div>
        
        <div class="stats">
            <div class="stat-box">
                <h3><?= count($reports) ?></h3>
                <p>📄 إجمالي التقارير</p>
            </div>
            <div class="stat-box">
                <h3><?= count(array_filter($reports, fn($r) => $r['status'] === 'completed')) ?></h3>
                <p>✅ مهام مكتملة</p>
            </div>
            <div class="stat-box">
                <h3><?= date('d') ?></h3>
                <p>📅 يوم من الشهر</p>
            </div>
            <div class="stat-box">
                <h3><?= date('H:i') ?></h3>
                <p>🕐 الوقت الحالي</p>
            </div>
        </div>

        <?php foreach($reports as $report): ?>
        <div class="report-card status-<?= $report['status'] ?>">
            <div class="report-meta">
                <span>📅 <?= $report['report_date'] ?></span>
                <span>⏰ <?= $report['report_time'] ?></span>
                <span>🔗 استُلِم: <?= $report['received_at'] ?></span>
            </div>
            
            <h3>📄 <?= htmlspecialchars($report['agent_name']) ?></h3>
            
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px; margin: 15px 0;">
                <p><strong>🟢 الحالة:</strong> 
                    <?= $report['status'] === 'completed' ? '✅ مكتمل' : '❌ خطأ' ?>
                </p>
                
                <p><strong>⚙️ المهام المنجزة:</strong> <?= $report['tasks_completed'] ?></p>
                
                <p><strong>📈 جدول بيانات:</strong> 
                    <?= $report['spreadsheet_created'] ? '✅ تم إنشاؤه' : '❌ لم يتم' ?>
                </p>
                
                <p><strong>📧 إيميل:</strong> 
                    <?= $report['email_sent'] ? '✅ تم إرساله' : '❌ لم يرسل' ?>
                </p>
            </div>
            
            <?php if (isset($report['github_report_url'])): ?>
            <a href="<?= $report['github_report_url'] ?>" target="_blank" class="github-link">
                📁 عرض التقرير في GitHub
            </a>
            <?php endif; ?>
        </div>
        <?php endforeach; ?>
        
        <?php if (empty($reports)): ?>
        <div class="report-card" style="text-align: center; padding: 50px;">
            <h3 style="color: #6c757d;">🔍 لم يتم استلام أي تقارير بعد...</h3>
            <p>سيظهر أول تقرير عند تشغيل الوكيل في تمام الساعة 9:00 صباحاً</p>
        </div>
        <?php endif; ?>
        
        <div style="text-align: center; margin-top: 30px; padding: 20px; background: #f8f9fa; border-radius: 10px;">
            <p><strong>🔗 روابط مهمة:</strong></p>
            <a href="/api/agent-webhook.php" style="margin: 0 10px;">API Endpoint</a> |
            <a href="https://github.com/wasalstor-web/AI-Agent-Platform" style="margin: 0 10px;">GitHub Repository</a> |
            <a href="https://zapier.com/app/zaps" style="margin: 0 10px;">Zapier Dashboard</a>
        </div>
    </div>
</body>
</html>