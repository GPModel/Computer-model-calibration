# Computer-model-calibration

Requirements: 
Matlab R2020b, Matlab Global Optimization Toolbox, Matlab Statistics and Machine Learning Toolbox, and EnergyPlus 9.4.0;

%%%%%%%%%%%%%%%%%%%%% Step for replicating results for Example 1%%%%%%%%%%%%%%%%%%%%%

Step: Run MainExample1.m to replicates the simulations and shows results for Example 1

%%%%%%%%%%%%%%%%%%%%% Steps for replicating results for EnergyPlus Example %%%%%%%%%%%%%%%%%%%%%

Step 1: Install the EnergyPlus 9.4.0  on the folder C:\EnergyPlusV9-4-0

Step 2: Move the current folder to a new folder, and the address of the new folder can not contain space ' ', i.e., the address of the new folder should be <C:\Users\ABC\Desktop\MatlabCodes_ModifiedSl>

Step 3: Run MainExample2.m

%%%%%%%%%%%%%%%%%%%%%% Descriptions of files%%%%%%%%%%%%%%%%%%%%%
CalibrationAGP.m----------Implements bi-fidelity Bayesian optimization with the MBC-AGP, BC-AGP, SR-AGP and ID-AGP methods

CalibrationBCGP.m----------Implements single fidelity Bayesian optimization with the BC-GP method

CalibrationNested.m----------Implements bi-fidelity Bayesian optimization with the Nested method

CalibrationSRGP_LR.m----------Implements single fidelity Bayesian optimization with the SR-GP and LR methods

ComputeRmatrix.m----------Computes the prior correlation matrix given by the product Matern correlation function with smoothness parameter 3/2 for a set of experiment design points 

ComputeRmatrix2.m----------Computes the prior correlation matrix with added nugeet, given by the product Matern correlation function with smoothness parameter 3/2 for a set of experiment design points 

EPBasicFile.idf----------Gives a basic EnergyPlus input editor file to be modified for running EnergyPlus simulations

EPWeather.epw---------- Includes Hong Kong weather data as required for completion of EnergyPlus simulations

GenerateNestedLHD.m----------Generates one nested LHD using the method described in Qian, P.Z.G. (2009) Nested Latin hypercube designs. Biometrika, 96(4), 957–970

invandlogdet.m----------Gives the inverse and log determinant of a positive definite matrix

MainExample1.m----------Replicates the simulations and shows results for Example 1

MainExample2.m----------Replicates the simulations and shows results for Example 2 (EnergyPlus Example )

Simulator.m----------Gives the simulated functions in Example 1 and Example 2 (EnergyPlus Example)

TransformData.m----------Gives the Box-Cox, squared root, and identity transformations, and its log of absolute Jacobian

TransformData_inv.m----------Gives the inverse of Box-Cox, squared root, and identity transformations
