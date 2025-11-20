"""
Integration Bridge
جسر التكامل

Bridge between AI models and agents for seamless collaboration.
"""

import logging
from typing import Dict, Any, Optional, List
from datetime import datetime
from enum import Enum

logger = logging.getLogger(__name__)


class ExecutionMode(Enum):
    """Execution mode enumeration"""
    MODEL_ONLY = "model_only"
    AGENT_ONLY = "agent_only"
    COLLABORATIVE = "collaborative"
    SEQUENTIAL = "sequential"
    PARALLEL = "parallel"


class IntegrationBridge:
    """
    Integration Bridge for Models and Agents
    جسر التكامل بين النماذج والوكلاء
    
    Enables seamless communication and collaboration between AI models and agents.
    """
    
    def __init__(self, model_manager: Any, agent_registry: Optional[Dict] = None):
        """
        Initialize the integration bridge
        
        Args:
            model_manager: ModelManager instance
            agent_registry: Dictionary of available agents
        """
        self.model_manager = model_manager
        self.agent_registry = agent_registry or {}
        self.execution_history: List[Dict[str, Any]] = []
        
        logger.info("🌉 Integration Bridge initialized")
    
    async def execute_with_model(
        self,
        model_id: str,
        task: Dict[str, Any],
        agent_name: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Execute task using AI model, optionally with agent support
        
        Args:
            model_id: Model identifier
            task: Task dictionary
            agent_name: Optional agent name for collaboration
            
        Returns:
            Execution result
        """
        try:
            logger.info(f"🎯 Executing task with model '{model_id}'")
            
            # Extract task data
            input_text = task.get('input', task.get('query', ''))
            parameters = task.get('parameters', {})
            
            # Run model inference
            model_result = await self.model_manager.inference(
                model_id,
                input_text,
                parameters
            )
            
            # If agent collaboration is requested
            if agent_name and agent_name in self.agent_registry:
                agent = self.agent_registry[agent_name]
                
                # Enhance task with model output
                enhanced_task = {
                    **task,
                    'model_output': model_result.get('output'),
                    'model_id': model_id
                }
                
                # Run agent with model context
                agent_result = await agent.run(enhanced_task)
                
                # Combine results
                combined_result = {
                    'success': True,
                    'model_result': model_result,
                    'agent_result': agent_result,
                    'mode': ExecutionMode.COLLABORATIVE.value,
                    'timestamp': datetime.now().isoformat()
                }
                
                self._log_execution(model_id, agent_name, combined_result)
                return combined_result
            
            # Return model-only result
            result = {
                'success': model_result.get('success', True),
                'output': model_result.get('output'),
                'model_id': model_id,
                'mode': ExecutionMode.MODEL_ONLY.value,
                'timestamp': datetime.now().isoformat()
            }
            
            self._log_execution(model_id, None, result)
            return result
            
        except Exception as e:
            logger.error(f"❌ Error executing with model: {e}")
            return {
                'success': False,
                'error': str(e),
                'timestamp': datetime.now().isoformat()
            }
    
    async def execute_collaborative(
        self,
        task: Dict[str, Any],
        models: List[str],
        agents: List[str]
    ) -> Dict[str, Any]:
        """
        Execute task collaboratively using multiple models and agents
        
        Args:
            task: Task dictionary
            models: List of model IDs to use
            agents: List of agent names to use
            
        Returns:
            Collaborative execution result
        """
        try:
            logger.info(f"🤝 Collaborative execution with {len(models)} models and {len(agents)} agents")
            
            results = {
                'models': {},
                'agents': {},
                'collaboration_flow': []
            }
            
            # Step 1: Run models
            for model_id in models:
                model_result = await self.model_manager.inference(
                    model_id,
                    task.get('input', ''),
                    task.get('parameters', {})
                )
                results['models'][model_id] = model_result
                results['collaboration_flow'].append({
                    'step': 'model',
                    'executor': model_id,
                    'timestamp': datetime.now().isoformat()
                })
            
            # Step 2: Aggregate model outputs
            aggregated_model_output = self._aggregate_model_outputs(results['models'])
            
            # Step 3: Run agents with model context
            for agent_name in agents:
                if agent_name in self.agent_registry:
                    agent = self.agent_registry[agent_name]
                    
                    # Enhance task with aggregated model output
                    enhanced_task = {
                        **task,
                        'model_outputs': aggregated_model_output,
                        'models_used': models
                    }
                    
                    agent_result = await agent.run(enhanced_task)
                    results['agents'][agent_name] = agent_result
                    results['collaboration_flow'].append({
                        'step': 'agent',
                        'executor': agent_name,
                        'timestamp': datetime.now().isoformat()
                    })
            
            # Step 4: Generate final response
            final_response = self._generate_collaborative_response(results)
            
            return {
                'success': True,
                'results': results,
                'final_response': final_response,
                'mode': ExecutionMode.COLLABORATIVE.value,
                'timestamp': datetime.now().isoformat()
            }
            
        except Exception as e:
            logger.error(f"❌ Error in collaborative execution: {e}")
            return {
                'success': False,
                'error': str(e),
                'timestamp': datetime.now().isoformat()
            }
    
    async def execute_sequential(
        self,
        task: Dict[str, Any],
        execution_chain: List[Dict[str, str]]
    ) -> Dict[str, Any]:
        """
        Execute task in sequential chain of models and agents
        
        Args:
            task: Initial task dictionary
            execution_chain: List of {'type': 'model'/'agent', 'id': 'name'}
            
        Returns:
            Sequential execution result
        """
        try:
            logger.info(f"⛓️ Sequential execution with {len(execution_chain)} steps")
            
            current_output = task.get('input', '')
            results = []
            
            for step_idx, step in enumerate(execution_chain):
                step_type = step.get('type')
                step_id = step.get('id')
                
                if step_type == 'model':
                    # Execute model
                    result = await self.model_manager.inference(
                        step_id,
                        current_output,
                        task.get('parameters', {})
                    )
                    current_output = result.get('output', current_output)
                    
                elif step_type == 'agent':
                    # Execute agent
                    if step_id in self.agent_registry:
                        agent = self.agent_registry[step_id]
                        result = await agent.run({
                            'input': current_output,
                            'previous_steps': results
                        })
                        current_output = result.get('output', current_output)
                    else:
                        result = {'error': f"Agent '{step_id}' not found"}
                
                results.append({
                    'step': step_idx + 1,
                    'type': step_type,
                    'id': step_id,
                    'result': result,
                    'timestamp': datetime.now().isoformat()
                })
            
            return {
                'success': True,
                'final_output': current_output,
                'steps': results,
                'mode': ExecutionMode.SEQUENTIAL.value,
                'timestamp': datetime.now().isoformat()
            }
            
        except Exception as e:
            logger.error(f"❌ Error in sequential execution: {e}")
            return {
                'success': False,
                'error': str(e),
                'timestamp': datetime.now().isoformat()
            }
    
    async def execute_parallel(
        self,
        task: Dict[str, Any],
        executors: List[Dict[str, str]]
    ) -> Dict[str, Any]:
        """
        Execute task in parallel with multiple models/agents
        
        Args:
            task: Task dictionary
            executors: List of {'type': 'model'/'agent', 'id': 'name'}
            
        Returns:
            Parallel execution result
        """
        try:
            logger.info(f"⚡ Parallel execution with {len(executors)} executors")
            
            import asyncio
            
            async def execute_single(executor: Dict[str, str]):
                exec_type = executor.get('type')
                exec_id = executor.get('id')
                
                if exec_type == 'model':
                    return await self.model_manager.inference(
                        exec_id,
                        task.get('input', ''),
                        task.get('parameters', {})
                    )
                elif exec_type == 'agent' and exec_id in self.agent_registry:
                    agent = self.agent_registry[exec_id]
                    return await agent.run(task)
                
                return {'error': f"Executor '{exec_id}' not found"}
            
            # Execute all in parallel
            results = await asyncio.gather(
                *[execute_single(executor) for executor in executors]
            )
            
            # Combine results
            combined_results = {}
            for executor, result in zip(executors, results):
                key = f"{executor['type']}_{executor['id']}"
                combined_results[key] = result
            
            return {
                'success': True,
                'results': combined_results,
                'mode': ExecutionMode.PARALLEL.value,
                'timestamp': datetime.now().isoformat()
            }
            
        except Exception as e:
            logger.error(f"❌ Error in parallel execution: {e}")
            return {
                'success': False,
                'error': str(e),
                'timestamp': datetime.now().isoformat()
            }
    
    def _aggregate_model_outputs(self, model_results: Dict[str, Any]) -> str:
        """Aggregate outputs from multiple models"""
        outputs = []
        for model_id, result in model_results.items():
            if result.get('success'):
                outputs.append(f"[{model_id}]: {result.get('output', '')}")
        
        return "\n\n".join(outputs)
    
    def _generate_collaborative_response(self, results: Dict[str, Any]) -> str:
        """Generate final response from collaborative execution"""
        response_parts = []
        
        # Add model insights
        if results.get('models'):
            response_parts.append("نتائج النماذج:")
            for model_id, result in results['models'].items():
                if result.get('success'):
                    response_parts.append(f"- {model_id}: {result.get('output', '')}")
        
        # Add agent actions
        if results.get('agents'):
            response_parts.append("\nإجراءات الوكلاء:")
            for agent_name, result in results['agents'].items():
                if result.get('success'):
                    response_parts.append(f"- {agent_name}: منفذ بنجاح")
        
        return "\n".join(response_parts)
    
    def _log_execution(
        self,
        model_id: Optional[str],
        agent_name: Optional[str],
        result: Dict[str, Any]
    ):
        """Log execution for history tracking"""
        self.execution_history.append({
            'model_id': model_id,
            'agent_name': agent_name,
            'result': result,
            'timestamp': datetime.now().isoformat()
        })
        
        # Keep only last 100 executions
        if len(self.execution_history) > 100:
            self.execution_history = self.execution_history[-100:]
    
    def register_agent(self, agent_name: str, agent_instance: Any):
        """Register an agent with the bridge"""
        self.agent_registry[agent_name] = agent_instance
        logger.info(f"✅ Agent '{agent_name}' registered with Integration Bridge")
    
    def unregister_agent(self, agent_name: str):
        """Unregister an agent from the bridge"""
        if agent_name in self.agent_registry:
            del self.agent_registry[agent_name]
            logger.info(f"🗑️ Agent '{agent_name}' unregistered from Integration Bridge")
    
    def get_execution_history(self, limit: int = 10) -> List[Dict[str, Any]]:
        """Get recent execution history"""
        return self.execution_history[-limit:]
    
    def get_statistics(self) -> Dict[str, Any]:
        """Get integration statistics"""
        return {
            'total_executions': len(self.execution_history),
            'registered_agents': list(self.agent_registry.keys()),
            'loaded_models': self.model_manager.get_loaded_models()
        }
