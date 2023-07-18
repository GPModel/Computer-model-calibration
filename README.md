Requirements: 
Matlab R2020b, Matlab Global Optimization Toolbox, Matlab Statistics and Machine Learning Toolbox, and EnergyPlus 9.4.0;


%%%%%%%%%%%%%%%%%%%%% Steps for replicating results for Example 1 %%%%%%%%%%%%%%%%%%%%%

Step 1: Install EnergyPlus 9.4.0 in the folder C:\EnergyPlusV9-4-0

Step 2: Put all the Matlab codes, the EPBasicFile.idf file, and the EPWeather.epw file in a single folder.

Step 3: Run MainExample1.m


%%%%%%%%%%%%%%%%%%%%% Step for replicating results for Example 2 %%%%%%%%%%%%%%%%%%%%%

Step: Run MainExample2.m to obtain the results for Example 2


%%%%%%%%%%%%%%%%%%%%%% Descriptions of files %%%%%%%%%%%%%%%%%%%%%

CalibrationAGP.m----------Implements the bi-fidelity MAGP, BC-AGP, SR-AGP, or ID-AGP method.

CalibrationBCGP.m----------Implements the single fidelity BC-GP method.

CalibrationNested.m----------Implements the bi-fidelity Nested method.

CalibrationSRGP.m----------Implements the single fidelity SR-GP method.

ComputeRmatrix.m----------Computes the prior correlation matrix given by the product Matern correlation function with 
smoothness parameter 3/2 for a set of experiment design points. 

ComputeRmatrix2.m----------Computes the prior correlation matrix given by the product Matern correlation function with 
smoothness parameter 3/2 with a nugget added to each diagonal element of the matrix for a set of experiment design points. 

EPBasicFile.idf----------Gives a basic EnergyPlus input editor file for running EnergyPlus simulations.

EPWeather.epw---------- Includes Hong Kong weather data for use in the EnergyPlus simulations.

GenerateNestedLHD.m----------Generates one pair of nested LHDs using the method described in Qian (2009). Reference: Qian, P. Z. G. (2009). Nested Latin hypercube designs. Biometrika, 96(4), 957–970.

invandlogdet.m----------Gives the inverse and log determinant of a positive definite matrix.

MainExample1.m----------Replicates the simulations and gives all results for Example 1.

MainExample2.m----------Replicates the simulations and gives all results for Example 2.

Simulator.m----------Gives the HF and LF simulator outputs for Example 1 and the Example 2.

TransformData.m----------Gives the Box-Cox, square root, or identity transformation, and the log absolute value of the 

Jacobian for the transformation.

TransformData_inv.m----------Gives the inverse of the Box-Cox, square root, or identity transformation.

Example1.mat----------Saved simulations data for Example 1.

Example2.mat----------Saved simulations data for Example 2.
