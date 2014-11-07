close all; clear all; clear classes; clear java; clc
rng(1);
n = 120;

dcg = DynamicColorGraph(n);
% dcg.addAgents('nl.coenvl.sam.agents.CooperativeAgent');
dcg.addAgents('nl.coenvl.sam.agents.UniqueFirstCooperativeAgent');
h = dcg.show();

set(h, 'Position', [-1599 -240 1600 824]);
shg;
%dcg.startDCOP
%dcg.getCost
%shg