classdef PSO < matlab.mixin.Copyable
    % PSO Particle Swarm Optimization for Formation Pathfinding.
    %
    % (c) https://github.com/clausqr for ECI2015
    properties (GetAccess = public, SetAccess = protected)
        
        Particle           % Array of Particles
        ParticlesCount     % Number of Particles
        CostFunction       % Cost function used to weight the fitness
        
    end
    
    methods (Access = public)
        
        function obj = PSO(Agent, ParticleCount, CostFunction)
            % PSO Constructor
            obj = obj.reset(Agent, ParticleCount, CostFunction);
        end
    
        function obj = Iterate(obj)
           for k = 1:obj.ParticlesCount
               x = obj.Particle(k).Agent.State;
               y = obj.Particle(k).Agent.getNewRandomState;
               u = obj.Particle(k).Agent.InverseKinematicsFcn(x, y);
               obj.Particle(k).Agent.UpdateState(u);
               obj.Particle(k).Agent.PlotState(obj.Particle(k).Agent.State,'.k');
           end
        end
    end
    
    methods (Access = private)
        
        function obj = AddParticle(obj, a)
            % PSO Constructor
            n = obj.ParticlesCount;
            if (n == 0)
                obj.Particle.Agent = a;
            else
                obj.Particle(n+1).Agent = a;
            end
            obj.ParticlesCount = n+1;
        end
        function obj = reset(obj, Agent, ParticleCount, CostFunction)
            obj.CostFunction = CostFunction;
            obj.ParticlesCount = 0;
            for k = 1:ParticleCount
                % copy the Agent passed as a reference, don't touch the
                % original. Each copy will behave separately. Agent needs
                % to be a subclass of matlab.mixin.Copyable superclass,
                % otherwise this won't work and we'd be moving the same
                % agent in different directions instead of cloning them.
                % For detail see http://www.mathworks.com/help/matlab/ref/matlab.mixin.copyable-class.html
                a = copy(Agent);
                obj.AddParticle(a)
            end
        end
    end
end