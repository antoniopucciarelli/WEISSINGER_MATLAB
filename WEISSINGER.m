% this program computes the velocity around a finite 3-D wing
% the wing is invested by an external flow of V_inf = 1
% the wing can have multiple displacement wrt the airstream
% the wing position is described by aerodynamic angles
%
% INPUT: 
%   WING properties:
%       sweep angle            -- gamma [deg]
%       dihedral angle         -- delta [deg]
%       root chord             -- root
%       semi-wing length       -- L
%       taper ratio            -- taper
%       # of spanwise panels   -- M
%       # of chordwise panels  -- N
%
%   AIRSTREAM properties:
%       AOA            -- alpha [deg]
%       sideslip angle -- beta  [deg]
%       U                 = 1   [m/s]
%

clc
clear 
close all

alpha = 5;
beta  = 0;
delta = 0;
gamma = 0;
root  = 8;
L     = 30;
taper = 0.7;

M = 7;
N = 5;

flag = "plot";

% panel creation function 
[PANELwing] = PANELING(delta,gamma,root,taper,L,M,N,flag);

% system matrix generation
% setting tollerance --> useful to avoid singular MATRIX 
toll        = 1e-4;
[MATRIX]    = BS(PANELwing,M,N,L,toll);

% system known vector 
[b]         = compute_vector(PANELwing,alpha,beta,M,N);

% solve system
GAMMA       = MATRIX\b;

for i=1:N*2*M
    PANELwing(i).GAMMA = GAMMA(i);
end 

% computing total circulation
U         = 1;
rho       = 1;
[L,L_vec] = compute_LIFT(GAMMA,PANELwing,M,N,rho,U);

% computing induced velocity 
[v_ind]   = compute_INDUCEDvel(GAMMA,PANELwing,M,N); 





