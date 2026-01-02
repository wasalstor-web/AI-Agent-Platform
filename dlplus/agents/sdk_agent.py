"""
SDK Agent - Professional Universal Agent
وكيل SDK - الوكيل الشامل الاحترافي

A highly professional, executive, and analytical SDK agent that provides:
- Advanced task analysis and planning
- Parallel execution optimization
- Performance monitoring and analytics
- Learning and memory systems
- Comprehensive reporting
- Error handling and recovery
- Auto-optimization
"""

import logging
import asyncio
import time
import json
from typing import Dict, Any, List, Optional, Union, Tuple
from datetime import datetime, timedelta
from collections import defaultdict, deque
from dataclasses import dataclass, asdict
from enum import Enum
from .base_agent import BaseAgent

# Import all agents
from .web_retrieval_agent import WebRetrievalAgent
from .code_generator_agent import CodeGeneratorAgent
from .translation_agent import TranslationAgent
from .analysis_agent import AnalysisAgent

# Import core components
from ..core.arabic_processor import ArabicProcessor
from ..core.context_analyzer import ContextAnalyzer

logger = logging.getLogger(__name__)


class TaskPriority(Enum):
    """Task priority levels"""
    CRITICAL = 1
    HIGH = 2
    NORMAL = 3
    LOW = 4


class TaskStatus(Enum):
    """Task execution status"""
    PENDING = "pending"
    ANALYZING = "analyzing"
    PLANNING = "planning"
    EXECUTING = "executing"
    COMPLETED = "completed"
    FAILED = "failed"
    OPTIMIZING = "optimizing"


@dataclass
class TaskMetrics:
    """Task execution metrics"""
    task_id: str
    action: str
    start_time: float
    end_time: Optional[float] = None
    duration: Optional[float] = None
    success: bool = False
    error: Optional[str] = None
    agent_used: Optional[str] = None
    result_size: Optional[int] = None
    memory_used: Optional[float] = None
    cpu_time: Optional[float] = None
    retry_count: int = 0
    optimization_applied: bool = False


@dataclass
class PerformanceMetrics:
    """System performance metrics"""
    total_tasks: int = 0
    successful_tasks: int = 0
    failed_tasks: int = 0
    average_duration: float = 0.0
    total_duration: float = 0.0
    peak_memory: float = 0.0
    average_memory: float = 0.0
    cache_hits: int = 0
    cache_misses: int = 0
    optimization_count: int = 0


class SDKAgent(BaseAgent):
    """
    Professional SDK Agent - Universal Agent
    وكيل SDK الاحترافي - الوكيل الشامل
    
    A highly professional, executive, and analytical agent with:
    - Advanced task analysis and intelligent planning
    - Parallel execution and optimization
    - Comprehensive performance monitoring
    - Learning and adaptive memory systems
    - Detailed analytics and reporting
    - Advanced error handling and recovery
    """
    
    def __init__(self, config: Dict[str, Any] = None):
        """Initialize the professional SDK agent"""
        super().__init__("Professional SDK Agent", config)
        self.config = config or {}
        
        # Initialize core components
        self.arabic_processor = ArabicProcessor()
        self.context_analyzer = ContextAnalyzer(
            max_history=config.get('max_history', 50) if config else 50
        )
        
        # Initialize all sub-agents
        self.web_agent = WebRetrievalAgent(config.get('web_retrieval', {}))
        self.code_agent = CodeGeneratorAgent(config.get('code_generator', {}))
        self.translation_agent = TranslationAgent(config.get('translation', {}))
        self.analysis_agent = AnalysisAgent(config.get('analysis', {}))
        
        # Agent registry with metadata
        self.agents = {
            'search': {'agent': self.web_agent, 'priority': 3, 'capabilities': ['web_search', 'fact_check']},
            'web': {'agent': self.web_agent, 'priority': 3, 'capabilities': ['web_search', 'fact_check']},
            'retrieval': {'agent': self.web_agent, 'priority': 3, 'capabilities': ['web_search', 'fact_check']},
            'code': {'agent': self.code_agent, 'priority': 2, 'capabilities': ['code_generation', 'code_review']},
            'generate': {'agent': self.code_agent, 'priority': 2, 'capabilities': ['code_generation', 'code_review']},
            'programming': {'agent': self.code_agent, 'priority': 2, 'capabilities': ['code_generation', 'code_review']},
            'translate': {'agent': self.translation_agent, 'priority': 4, 'capabilities': ['translation', 'language_detection']},
            'translation': {'agent': self.translation_agent, 'priority': 4, 'capabilities': ['translation', 'language_detection']},
            'analyze': {'agent': self.analysis_agent, 'priority': 3, 'capabilities': ['sentiment', 'topic', 'entity']},
            'analysis': {'agent': self.analysis_agent, 'priority': 3, 'capabilities': ['sentiment', 'topic', 'entity']},
            'sentiment': {'agent': self.analysis_agent, 'priority': 3, 'capabilities': ['sentiment']}
        }
        
        # Performance and analytics
        self.performance_metrics = PerformanceMetrics()
        self.task_metrics: Dict[str, TaskMetrics] = {}
        self.task_history: deque = deque(maxlen=1000)
        
        # Memory and learning systems
        self.memory_cache: Dict[str, Any] = {}
        self.learning_patterns: Dict[str, Any] = defaultdict(lambda: {'count': 0, 'success_rate': 0.0, 'avg_duration': 0.0})
        self.optimization_rules: List[Dict[str, Any]] = []
        
        # Execution queue and parallel processing
        self.execution_queue: asyncio.Queue = asyncio.Queue()
        self.max_parallel_tasks = config.get('max_parallel_tasks', 5) if config else 5
        self.active_tasks: Dict[str, asyncio.Task] = {}
        
        # Analytics and reporting
        self.analytics_data: Dict[str, Any] = {
            'daily_stats': defaultdict(lambda: {'tasks': 0, 'success': 0, 'duration': 0.0}),
            'agent_usage': defaultdict(int),
            'action_distribution': defaultdict(int),
            'error_patterns': defaultdict(int),
            'optimization_history': []
        }
        
        # Advanced features
        self.enable_analytics = config.get('enable_analytics', True) if config else True
        self.enable_learning = config.get('enable_learning', True) if config else True
        self.enable_optimization = config.get('enable_optimization', True) if config else True
        self.enable_parallel = config.get('enable_parallel', True) if config else True
        
        logger.info("🚀 Professional SDK Agent initialized with advanced features")
    
    async def execute(self, task: Dict[str, Any]) -> Dict[str, Any]:
        """
        Execute any task with professional analysis and optimization
        
        Args:
            task: Task dictionary with comprehensive parameters
            
        Returns:
            Professional result with analytics and insights
        """
        task_id = task.get('task_id') or f"task_{int(time.time() * 1000)}"
        start_time = time.time()
        
        # Create task metrics
        metrics = TaskMetrics(
            task_id=task_id,
            action=task.get('action', 'auto'),
            start_time=start_time
        )
        
        try:
            # Phase 1: Advanced Analysis
            analysis_result = await self._analyze_task_advanced(task)
            metrics.agent_used = analysis_result.get('recommended_agent')
            
            # Phase 2: Intelligent Planning
            execution_plan = await self._create_execution_plan(task, analysis_result)
            
            # Phase 3: Check cache and memory
            cache_key = self._generate_cache_key(task, analysis_result)
            if cache_key in self.memory_cache:
                logger.info(f"📦 Cache hit for task {task_id}")
                self.performance_metrics.cache_hits += 1
                cached_result = self.memory_cache[cache_key]
                return self._enrich_result(cached_result, metrics, analysis_result, execution_plan)
            else:
                self.performance_metrics.cache_misses += 1
            
            # Phase 4: Execute with monitoring
            action = analysis_result.get('action', 'auto')
            result = await self._execute_with_monitoring(action, task, metrics, execution_plan)
            
            # Phase 5: Post-execution analysis
            post_analysis = await self._analyze_result(result, task, metrics)
            
            # Phase 6: Learning and optimization
            if self.enable_learning:
                await self._learn_from_execution(task, result, metrics)
            
            # Phase 7: Cache result
            self.memory_cache[cache_key] = result
            if len(self.memory_cache) > 1000:
                # Remove oldest entries
                oldest_key = next(iter(self.memory_cache))
                del self.memory_cache[oldest_key]
            
            # Update metrics
            metrics.end_time = time.time()
            metrics.duration = metrics.end_time - metrics.start_time
            metrics.success = result.get('success', False)
            metrics.result_size = len(str(result))
            self.task_metrics[task_id] = metrics
            self.task_history.append({
                'task_id': task_id,
                'timestamp': datetime.now().isoformat(),
                'action': action,
                'success': metrics.success,
                'duration': metrics.duration
            })
            
            # Update performance metrics
            self._update_performance_metrics(metrics)
            
            # Enrich and return result
            return self._enrich_result(result, metrics, analysis_result, execution_plan, post_analysis)
            
        except Exception as e:
            logger.error(f"❌ Error in SDK Agent execution: {e}", exc_info=True)
            metrics.end_time = time.time()
            metrics.duration = metrics.end_time - metrics.start_time
            metrics.success = False
            metrics.error = str(e)
            self.task_metrics[task_id] = metrics
            self.performance_metrics.failed_tasks += 1
            
            return {
                'success': False,
                'error': str(e),
                'error_type': type(e).__name__,
                'task_id': task_id,
                'metrics': asdict(metrics),
                'timestamp': datetime.now().isoformat(),
                'recommendations': await self._generate_error_recommendations(e, task)
            }
    
    async def _analyze_task_advanced(self, task: Dict[str, Any]) -> Dict[str, Any]:
        """Advanced task analysis with multiple dimensions"""
        description = task.get('description', '') or task.get('query', '') or task.get('text', '')
        
        # Arabic language analysis
        arabic_analysis = await self.arabic_processor.analyze(description) if description else {}
        
        # Context analysis
        context = await self.context_analyzer.analyze(
            description,
            [h for h in self.task_history],
            task.get('context', {})
        )
        
        # Action detection with confidence
        action = task.get('action', 'auto')
        if action == 'auto':
            action = await self._detect_action_advanced(task, arabic_analysis)
        
        # Complexity analysis
        complexity = self._analyze_complexity(task, arabic_analysis)
        
        # Resource estimation
        resource_estimate = self._estimate_resources(task, action)
        
        # Priority calculation
        priority = self._calculate_priority(task, arabic_analysis, context)
        
        # Agent recommendation
        recommended_agent = self._recommend_agent(action, task, arabic_analysis)
        
        return {
            'action': action,
            'recommended_agent': recommended_agent,
            'arabic_analysis': arabic_analysis,
            'context': context,
            'complexity': complexity,
            'resource_estimate': resource_estimate,
            'priority': priority,
            'confidence': arabic_analysis.get('intent_confidence', 0.5),
            'entities': arabic_analysis.get('entities', []),
            'sentiment': arabic_analysis.get('sentiment', 'neutral')
        }
    
    async def _create_execution_plan(self, task: Dict[str, Any], analysis: Dict[str, Any]) -> Dict[str, Any]:
        """Create intelligent execution plan"""
        action = analysis.get('action')
        complexity = analysis.get('complexity', {})
        
        plan = {
            'steps': [],
            'estimated_duration': complexity.get('estimated_duration', 5.0),
            'parallel_opportunities': [],
            'optimization_strategies': [],
            'risk_assessment': {}
        }
        
        # Single action plan
        if action in self.agents:
            plan['steps'].append({
                'step': 1,
                'action': action,
                'agent': analysis.get('recommended_agent'),
                'estimated_duration': complexity.get('estimated_duration', 5.0)
            })
        
        # Multi-action plan detection
        description = task.get('description', '')
        if any(kw in description.lower() for kw in ['و', 'ثم', 'بعد', 'and', 'then', 'after']):
            # Detect multiple actions
            plan['parallel_opportunities'] = await self._detect_parallel_opportunities(task)
        
        # Optimization strategies
        if self.enable_optimization:
            plan['optimization_strategies'] = await self._suggest_optimizations(task, analysis)
        
        # Risk assessment
        plan['risk_assessment'] = self._assess_risks(task, analysis)
        
        return plan
    
    async def _execute_with_monitoring(
        self,
        action: str,
        task: Dict[str, Any],
        metrics: TaskMetrics,
        plan: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Execute task with comprehensive monitoring"""
        agent_info = self.agents.get(action)
        
        if not agent_info:
            raise ValueError(f"Unknown action: {action}")
        
        agent = agent_info['agent']
        
        # Transform task
        agent_task = self._transform_task(action, task)
        
        # Apply optimizations
        if self.enable_optimization and plan.get('optimization_strategies'):
            agent_task = await self._apply_optimizations(agent_task, plan['optimization_strategies'])
            metrics.optimization_applied = True
        
        # Execute with retry logic
        max_retries = task.get('max_retries', 3)
        for attempt in range(max_retries):
            try:
                result = await agent.execute(agent_task)
                if result.get('success'):
                    return result
                elif attempt < max_retries - 1:
                    metrics.retry_count += 1
                    await asyncio.sleep(0.5 * (attempt + 1))  # Exponential backoff
            except Exception as e:
                if attempt < max_retries - 1:
                    metrics.retry_count += 1
                    await asyncio.sleep(0.5 * (attempt + 1))
                else:
                    raise
        
        return {'success': False, 'error': 'Max retries exceeded'}
    
    async def _analyze_result(
        self,
        result: Dict[str, Any],
        task: Dict[str, Any],
        metrics: TaskMetrics
    ) -> Dict[str, Any]:
        """Analyze execution result"""
        analysis = {
            'quality_score': 0.0,
            'completeness': 0.0,
            'relevance': 0.0,
            'insights': [],
            'recommendations': []
        }
        
        if result.get('success'):
            # Quality assessment
            analysis['quality_score'] = self._assess_quality(result, task)
            analysis['completeness'] = self._assess_completeness(result, task)
            analysis['relevance'] = self._assess_relevance(result, task)
            
            # Generate insights
            analysis['insights'] = await self._generate_insights(result, task, metrics)
            
            # Recommendations
            analysis['recommendations'] = await self._generate_recommendations(result, task)
        else:
            analysis['quality_score'] = 0.0
            analysis['insights'].append('Task execution failed')
        
        return analysis
    
    async def _learn_from_execution(
        self,
        task: Dict[str, Any],
        result: Dict[str, Any],
        metrics: TaskMetrics
    ):
        """Learn from execution for future optimization"""
        action = metrics.action
        pattern_key = f"{action}_{task.get('description', '')[:50]}"
        
        pattern = self.learning_patterns[pattern_key]
        pattern['count'] += 1
        pattern['success_rate'] = (
            (pattern['success_rate'] * (pattern['count'] - 1) + (1.0 if metrics.success else 0.0)) /
            pattern['count']
        )
        pattern['avg_duration'] = (
            (pattern['avg_duration'] * (pattern['count'] - 1) + (metrics.duration or 0.0)) /
            pattern['count']
        )
    
    def _generate_cache_key(self, task: Dict[str, Any], analysis: Dict[str, Any]) -> str:
        """Generate cache key for task"""
        key_parts = [
            analysis.get('action', ''),
            task.get('description', '')[:100],
            task.get('query', '')[:100],
            task.get('text', '')[:100],
            str(task.get('language', '')),
            str(task.get('target_language', ''))
        ]
        return hash('|'.join(str(p) for p in key_parts))
    
    def _enrich_result(
        self,
        result: Dict[str, Any],
        metrics: TaskMetrics,
        analysis: Dict[str, Any],
        plan: Dict[str, Any],
        post_analysis: Optional[Dict[str, Any]] = None
    ) -> Dict[str, Any]:
        """Enrich result with analytics and insights"""
        enriched = {
            **result,
            'analytics': {
                'task_id': metrics.task_id,
                'execution_time': metrics.duration,
                'action': metrics.action,
                'agent_used': metrics.agent_used,
                'quality_score': post_analysis.get('quality_score', 0.0) if post_analysis else 0.0,
                'optimization_applied': metrics.optimization_applied,
                'retry_count': metrics.retry_count,
                'cache_used': metrics.task_id not in self.task_metrics
            },
            'analysis': analysis,
            'execution_plan': plan,
            'post_analysis': post_analysis,
            'timestamp': datetime.now().isoformat(),
            'performance': {
                'duration': metrics.duration,
                'success_rate': self.performance_metrics.successful_tasks / max(self.performance_metrics.total_tasks, 1),
                'average_duration': self.performance_metrics.average_duration
            }
        }
        
        return enriched
    
    # ========== Advanced Detection and Analysis Methods ==========
    
    async def _detect_action_advanced(self, task: Dict[str, Any], arabic_analysis: Dict[str, Any]) -> str:
        """Advanced action detection with multiple signals"""
        description = task.get('description', '').lower()
        query = task.get('query', '').lower()
        text = task.get('text', '').lower()
        
        combined = f"{description} {query} {text}".lower()
        intent = arabic_analysis.get('intent', 'general')
        intent_confidence = arabic_analysis.get('intent_confidence', 0.5)
        
        # Use intent from Arabic analysis if confidence is high
        if intent_confidence > 0.7:
            intent_map = {
                'code': 'code',
                'search': 'search',
                'translate': 'translate',
                'analyze': 'analyze'
            }
            if intent in intent_map:
                return intent_map[intent]
        
        # Fallback to keyword detection
        return await self._detect_action(task)
    
    def _analyze_complexity(self, task: Dict[str, Any], arabic_analysis: Dict[str, Any]) -> Dict[str, Any]:
        """Analyze task complexity"""
        description = task.get('description', '')
        text_complexity = arabic_analysis.get('complexity', {})
        
        # Count operations
        operation_count = len([k for k in task.keys() if k in ['query', 'description', 'text', 'code']])
        
        # Estimate duration based on complexity
        base_duration = 2.0
        complexity_multiplier = text_complexity.get('score', 0.5)
        estimated_duration = base_duration * (1 + complexity_multiplier)
        
        return {
            'level': 'simple' if complexity_multiplier < 0.4 else 'medium' if complexity_multiplier < 0.7 else 'complex',
            'score': complexity_multiplier,
            'operation_count': operation_count,
            'estimated_duration': estimated_duration,
            'resource_intensive': complexity_multiplier > 0.7
        }
    
    def _estimate_resources(self, task: Dict[str, Any], action: str) -> Dict[str, Any]:
        """Estimate resource requirements"""
        agent_info = self.agents.get(action, {})
        complexity = self._analyze_complexity(task, {})
        
        return {
            'memory_mb': 50.0 + (complexity.get('score', 0.5) * 100),
            'cpu_time_seconds': complexity.get('estimated_duration', 5.0),
            'network_requests': 1 if action == 'search' else 0,
            'agent_priority': agent_info.get('priority', 3)
        }
    
    def _calculate_priority(self, task: Dict[str, Any], arabic_analysis: Dict[str, Any], context: Dict[str, Any]) -> TaskPriority:
        """Calculate task priority"""
        # Check explicit priority
        if 'priority' in task:
            try:
                return TaskPriority[task['priority'].upper()]
            except:
                pass
        
        # Calculate based on context
        if context.get('topic_changed', False):
            return TaskPriority.HIGH
        
        if arabic_analysis.get('sentiment') == 'negative':
            return TaskPriority.HIGH
        
        return TaskPriority.NORMAL
    
    def _recommend_agent(self, action: str, task: Dict[str, Any], arabic_analysis: Dict[str, Any]) -> str:
        """Recommend best agent for task"""
        agent_info = self.agents.get(action)
        if agent_info:
            return agent_info['agent'].name
        
        # Fallback recommendation
        return "Unknown Agent"
    
    def _assess_risks(self, task: Dict[str, Any], analysis: Dict[str, Any]) -> Dict[str, Any]:
        """Assess execution risks"""
        risks = {
            'level': 'low',
            'factors': [],
            'mitigation': []
        }
        
        complexity = analysis.get('complexity', {})
        if complexity.get('resource_intensive', False):
            risks['level'] = 'medium'
            risks['factors'].append('High resource requirements')
            risks['mitigation'].append('Consider parallel execution')
        
        if analysis.get('confidence', 0.5) < 0.5:
            risks['level'] = 'medium'
            risks['factors'].append('Low confidence in action detection')
            risks['mitigation'].append('Manual verification recommended')
        
        return risks
    
    async def _detect_parallel_opportunities(self, task: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Detect opportunities for parallel execution"""
        opportunities = []
        
        # Check for batch operations
        if 'texts' in task and isinstance(task['texts'], list):
            opportunities.append({
                'type': 'batch_processing',
                'items': len(task['texts']),
                'estimated_speedup': min(len(task['texts']), self.max_parallel_tasks)
            })
        
        return opportunities
    
    async def _suggest_optimizations(self, task: Dict[str, Any], analysis: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Suggest optimization strategies"""
        optimizations = []
        
        # Cache optimization
        if analysis.get('confidence', 0.5) > 0.8:
            optimizations.append({
                'type': 'cache_result',
                'reason': 'High confidence, likely to be repeated'
            })
        
        # Parallel optimization
        if 'texts' in task and len(task.get('texts', [])) > 3:
            optimizations.append({
                'type': 'parallel_execution',
                'reason': 'Multiple items can be processed in parallel'
            })
        
        return optimizations
    
    async def _apply_optimizations(self, task: Dict[str, Any], strategies: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Apply optimization strategies"""
        optimized_task = task.copy()
        
        for strategy in strategies:
            if strategy['type'] == 'parallel_execution' and 'texts' in task:
                # Mark for parallel processing
                optimized_task['_parallel'] = True
        
        return optimized_task
    
    def _assess_quality(self, result: Dict[str, Any], task: Dict[str, Any]) -> float:
        """Assess result quality"""
        score = 0.5  # Base score
        
        if result.get('success'):
            score += 0.3
        
        if result.get('result'):
            score += 0.1
        
        if 'analytics' in result or 'analysis' in result:
            score += 0.1
        
        return min(score, 1.0)
    
    def _assess_completeness(self, result: Dict[str, Any], task: Dict[str, Any]) -> float:
        """Assess result completeness"""
        if not result.get('success'):
            return 0.0
        
        completeness = 0.5
        
        if result.get('result'):
            completeness += 0.3
        
        if 'analytics' in result:
            completeness += 0.2
        
        return min(completeness, 1.0)
    
    def _assess_relevance(self, result: Dict[str, Any], task: Dict[str, Any]) -> float:
        """Assess result relevance"""
        # Simple relevance check
        return 0.8 if result.get('success') else 0.0
    
    async def _generate_insights(
        self,
        result: Dict[str, Any],
        task: Dict[str, Any],
        metrics: TaskMetrics
    ) -> List[str]:
        """Generate insights from execution"""
        insights = []
        
        if metrics.duration and metrics.duration > 10:
            insights.append(f"Task took {metrics.duration:.2f}s - consider optimization")
        
        if metrics.retry_count > 0:
            insights.append(f"Task required {metrics.retry_count} retries")
        
        if metrics.optimization_applied:
            insights.append("Optimizations were applied to improve performance")
        
        return insights
    
    async def _generate_recommendations(
        self,
        result: Dict[str, Any],
        task: Dict[str, Any]
    ) -> List[str]:
        """Generate recommendations"""
        recommendations = []
        
        if result.get('success'):
            recommendations.append("Task completed successfully")
        else:
            recommendations.append("Consider reviewing task parameters")
        
        return recommendations
    
    async def _generate_error_recommendations(self, error: Exception, task: Dict[str, Any]) -> List[str]:
        """Generate error-specific recommendations"""
        recommendations = []
        
        if isinstance(error, ValueError):
            recommendations.append("Check task parameters and format")
        elif isinstance(error, TimeoutError):
            recommendations.append("Task timed out - consider increasing timeout or simplifying task")
        else:
            recommendations.append("Review error details and retry with adjusted parameters")
        
        return recommendations
    
    def _update_performance_metrics(self, metrics: TaskMetrics):
        """Update system performance metrics"""
        self.performance_metrics.total_tasks += 1
        
        if metrics.success:
            self.performance_metrics.successful_tasks += 1
        else:
            self.performance_metrics.failed_tasks += 1
        
        if metrics.duration:
            self.performance_metrics.total_duration += metrics.duration
            self.performance_metrics.average_duration = (
                self.performance_metrics.total_duration / self.performance_metrics.total_tasks
            )
        
        if metrics.optimization_applied:
            self.performance_metrics.optimization_count += 1
    
    # ========== Original Methods (Maintained for Compatibility) ==========
    
    async def _detect_action(self, task: Dict[str, Any]) -> str:
        """Detect user intent from text"""
        description = task.get('description', '').lower()
        query = task.get('query', '').lower()
        text = task.get('text', '').lower()
        
        combined = f"{description} {query} {text}".lower()
        
        # Search keywords
        if any(kw in combined for kw in ['ابحث', 'بحث', 'search', 'find', 'lookup', 'معلومات', 'information']):
            return 'search'
        
        # Code keywords
        if any(kw in combined for kw in ['كود', 'code', 'برمجة', 'programming', 'اكتب', 'write', 'generate', 'سكريبت', 'script']):
            return 'code'
        
        # Translation keywords
        if any(kw in combined for kw in ['ترجم', 'translate', 'translation', 'حول', 'convert']):
            return 'translate'
        
        # Analysis keywords
        if any(kw in combined for kw in ['حلل', 'analyze', 'analysis', 'تحليل', 'sentiment', 'مشاعر']):
            return 'analyze'
        
        # Default to search
        return 'search'
    
    def _transform_task(self, action: str, task: Dict[str, Any]) -> Dict[str, Any]:
        """Transform SDK task to agent-specific task format"""
        if action in ['search', 'web', 'retrieval']:
            return {
                'query': task.get('query') or task.get('description') or task.get('text', ''),
                'search_type': task.get('search_type', 'web'),
                'max_results': task.get('max_results', 10),
                'filters': task.get('filters', {})
            }
        
        elif action in ['code', 'generate', 'programming']:
            return {
                'description': task.get('description') or task.get('query') or task.get('text', ''),
                'language': task.get('language', 'python'),
                'requirements': task.get('requirements', []),
                'include_tests': task.get('include_tests', False),
                'optimize': task.get('optimize', False)
            }
        
        elif action in ['translate', 'translation']:
            return {
                'text': task.get('text') or task.get('description') or task.get('query', ''),
                'source_language': task.get('source_language', 'auto'),
                'target_language': task.get('target_language', 'en'),
                'style': task.get('style', 'formal')
            }
        
        elif action in ['analyze', 'analysis', 'sentiment']:
            return {
                'text': task.get('text') or task.get('description') or task.get('query', ''),
                'analysis_type': task.get('analysis_type', 'comprehensive'),
                'language': task.get('language', 'auto')
            }
        
        return task
    
    # ========== Convenience Methods (Enhanced) ==========
    
    async def search(self, query: str, max_results: int = 10, **kwargs) -> Dict[str, Any]:
        """Search the web with professional analytics"""
        return await self.execute({
            'action': 'search',
            'query': query,
            'max_results': max_results,
            **kwargs
        })
    
    async def generate_code(
        self,
        description: str,
        language: str = 'python',
        include_tests: bool = False,
        **kwargs
    ) -> Dict[str, Any]:
        """Generate code with professional analytics"""
        return await self.execute({
            'action': 'code',
            'description': description,
            'language': language,
            'include_tests': include_tests,
            **kwargs
        })
    
    async def translate(
        self,
        text: str,
        source_language: str = 'auto',
        target_language: str = 'en',
        **kwargs
    ) -> Dict[str, Any]:
        """Translate text with professional analytics"""
        return await self.execute({
            'action': 'translate',
            'text': text,
            'source_language': source_language,
            'target_language': target_language,
            **kwargs
        })
    
    async def analyze(
        self,
        text: str,
        analysis_type: str = 'comprehensive',
        **kwargs
    ) -> Dict[str, Any]:
        """Analyze text with professional analytics"""
        return await self.execute({
            'action': 'analyze',
            'text': text,
            'analysis_type': analysis_type,
            **kwargs
        })
    
    # ========== Analytics and Reporting Methods ==========
    
    async def get_analytics(self, period: str = 'all') -> Dict[str, Any]:
        """Get comprehensive analytics"""
        return {
            'performance': asdict(self.performance_metrics),
            'task_history': list(self.task_history)[-100:],  # Last 100 tasks
            'learning_patterns': dict(self.learning_patterns),
            'agent_usage': dict(self.analytics_data['agent_usage']),
            'action_distribution': dict(self.analytics_data['action_distribution']),
            'error_patterns': dict(self.analytics_data['error_patterns']),
            'cache_stats': {
                'hits': self.performance_metrics.cache_hits,
                'misses': self.performance_metrics.cache_misses,
                'hit_rate': (
                    self.performance_metrics.cache_hits /
                    max(self.performance_metrics.cache_hits + self.performance_metrics.cache_misses, 1)
                )
            },
            'optimization_stats': {
                'total_optimizations': self.performance_metrics.optimization_count,
                'optimization_rate': (
                    self.performance_metrics.optimization_count /
                    max(self.performance_metrics.total_tasks, 1)
                )
            }
        }
    
    async def generate_report(self, format: str = 'json') -> Union[str, Dict[str, Any]]:
        """Generate comprehensive execution report"""
        analytics = await self.get_analytics()
        
        report = {
            'report_id': f"report_{int(time.time())}",
            'generated_at': datetime.now().isoformat(),
            'summary': {
                'total_tasks': self.performance_metrics.total_tasks,
                'success_rate': (
                    self.performance_metrics.successful_tasks /
                    max(self.performance_metrics.total_tasks, 1)
                ),
                'average_duration': self.performance_metrics.average_duration,
                'cache_hit_rate': (
                    self.performance_metrics.cache_hits /
                    max(self.performance_metrics.cache_hits + self.performance_metrics.cache_misses, 1)
                )
            },
            'analytics': analytics,
            'recommendations': await self._generate_system_recommendations()
        }
        
        if format == 'json':
            return report
        else:
            return json.dumps(report, indent=2, ensure_ascii=False)
    
    async def _generate_system_recommendations(self) -> List[str]:
        """Generate system-level recommendations"""
        recommendations = []
        
        success_rate = (
            self.performance_metrics.successful_tasks /
            max(self.performance_metrics.total_tasks, 1)
        )
        
        if success_rate < 0.8:
            recommendations.append("Success rate is below 80% - review error patterns")
        
        if self.performance_metrics.average_duration > 10:
            recommendations.append("Average duration is high - consider optimization")
        
        cache_hit_rate = (
            self.performance_metrics.cache_hits /
            max(self.performance_metrics.cache_hits + self.performance_metrics.cache_misses, 1)
        )
        
        if cache_hit_rate < 0.3:
            recommendations.append("Cache hit rate is low - tasks may be too diverse")
        
        return recommendations
    
    # ========== Utility Methods ==========
    
    def get_available_actions(self) -> List[str]:
        """Get list of available actions"""
        return list(self.agents.keys())
    
    def get_agent_info(self) -> Dict[str, Any]:
        """Get information about all agents"""
        return {
            'sdk_agent': {
                'name': self.name,
                'enabled': self.enabled,
                'execution_count': self.execution_count,
                'features': {
                    'analytics': self.enable_analytics,
                    'learning': self.enable_learning,
                    'optimization': self.enable_optimization,
                    'parallel': self.enable_parallel
                }
            },
            'sub_agents': {
                name: {
                    'name': info['agent'].name,
                    'enabled': info['agent'].enabled,
                    'execution_count': info['agent'].execution_count,
                    'priority': info['priority'],
                    'capabilities': info['capabilities']
                }
                for name, info in self.agents.items()
            },
            'available_actions': self.get_available_actions(),
            'performance': asdict(self.performance_metrics)
        }
    
    async def health_check(self) -> Dict[str, Any]:
        """Comprehensive health check"""
        health = {
            'sdk_agent': {
                'status': 'healthy' if self.enabled else 'disabled',
                'execution_count': self.execution_count,
                'features_enabled': {
                    'analytics': self.enable_analytics,
                    'learning': self.enable_learning,
                    'optimization': self.enable_optimization
                }
            },
            'sub_agents': {},
            'performance': {
                'total_tasks': self.performance_metrics.total_tasks,
                'success_rate': (
                    self.performance_metrics.successful_tasks /
                    max(self.performance_metrics.total_tasks, 1)
                ),
                'average_duration': self.performance_metrics.average_duration
            },
            'system': {
                'cache_size': len(self.memory_cache),
                'learning_patterns': len(self.learning_patterns),
                'active_tasks': len(self.active_tasks)
            }
        }
        
        for name, info in self.agents.items():
            agent = info['agent']
            health['sub_agents'][name] = {
                'status': 'healthy' if agent.enabled else 'disabled',
                'execution_count': agent.execution_count,
                'last_execution': agent.last_execution
            }
        
        return health
    
    # Maintain compatibility with original methods
    async def fact_check(self, claim: str) -> Dict[str, Any]:
        """Fact-check a claim"""
        return await self.web_agent.fact_check(claim)
    
    async def review_code(self, code: str, language: str = 'python') -> Dict[str, Any]:
        """Review and improve code"""
        return await self.code_agent.review_code(code, language)
    
    async def search_and_analyze(self, query: str, analyze_results: bool = True, **kwargs) -> Dict[str, Any]:
        """Search and analyze results"""
        search_result = await self.search(query, **kwargs)
        if not search_result.get('success'):
            return search_result
        
        results = {'search': search_result, 'analysis': None}
        
        if analyze_results and search_result.get('result', {}).get('summary'):
            analysis = await self.analyze(
                search_result['result']['summary'],
                analysis_type='comprehensive'
            )
            results['analysis'] = analysis
        
        return {'success': True, 'results': results, 'timestamp': datetime.now().isoformat()}
    
    async def translate_and_analyze(self, text: str, target_language: str = 'en', **kwargs) -> Dict[str, Any]:
        """Translate and analyze text"""
        translation = await self.translate(text, target_language=target_language, **kwargs)
        if not translation.get('success'):
            return translation
        
        analysis_original = await self.analyze(text, analysis_type='comprehensive')
        translated_text = translation.get('result', {}).get('translated_text', '')
        analysis_translated = await self.analyze(translated_text, analysis_type='comprehensive') if translated_text else None
        
        return {
            'success': True,
            'translation': translation,
            'analysis_original': analysis_original,
            'analysis_translated': analysis_translated,
            'timestamp': datetime.now().isoformat()
        }
    
    async def generate_code_with_search(self, description: str, language: str = 'python', search_first: bool = True, **kwargs) -> Dict[str, Any]:
        """Generate code with optional web search"""
        search_context = None
        if search_first:
            search_query = f"{description} {language} best practices"
            search_result = await self.search(search_query, max_results=3)
            if search_result.get('success'):
                search_context = search_result.get('result', {})
        
        code_result = await self.generate_code(description, language, **kwargs)
        
        return {
            'success': code_result.get('success', False),
            'code': code_result,
            'search_context': search_context,
            'timestamp': datetime.now().isoformat()
        }
    
    async def comprehensive_analysis(self, text: str, translate: bool = False, target_language: str = 'en', **kwargs) -> Dict[str, Any]:
        """Comprehensive analysis with optional translation"""
        results = {
            'original_text': text,
            'analysis': None,
            'translation': None,
            'translated_analysis': None
        }
        
        analysis = await self.analyze(text, analysis_type='comprehensive', **kwargs)
        results['analysis'] = analysis
        
        if translate:
            translation = await self.translate(text, target_language=target_language)
            results['translation'] = translation
            
            if translation.get('success'):
                translated_text = translation.get('result', {}).get('translated_text', '')
                if translated_text:
                    translated_analysis = await self.analyze(translated_text, analysis_type='comprehensive', **kwargs)
                    results['translated_analysis'] = translated_analysis
        
        return {'success': True, 'results': results, 'timestamp': datetime.now().isoformat()}
    
    async def batch_translate(self, texts: List[str], source_language: str = 'auto', target_language: str = 'en', **kwargs) -> Dict[str, Any]:
        """Translate multiple texts"""
        return await self.translation_agent.translate_batch(texts, source_language, target_language)
    
    async def batch_analyze(self, texts: List[str], analysis_type: str = 'comprehensive', **kwargs) -> Dict[str, Any]:
        """Analyze multiple texts"""
        results = []
        for text in texts:
            result = await self.analyze(text, analysis_type=analysis_type, **kwargs)
            results.append(result)
        
        return {
            'success': True,
            'results': results,
            'count': len(results),
            'timestamp': datetime.now().isoformat()
        }
