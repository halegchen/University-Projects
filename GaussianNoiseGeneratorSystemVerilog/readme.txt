Digital Design using system verilog. 
This project generates uniformly distributed numbers as addresses, then it does Wallace's transformation using the initialized Gaussian distributed numbers to generate more Gaussian noise numbers.

The outputs in the noise.txt are signed binary numbers, and the data transformation to decimal nums is in testNoise.m under Matlab folder

*Note that the data width is 24 bits and the first bit is used as the sign bit. *After the reset and start signal comes, 1024+7 cycles are used for initialization of the RAM and registers in the transformation module. *urng.sv generates start, stride and mask. *addr.sv gernerates p, q, r, s addresses. *transform.sv performs the noise generation. *InitGaussian.m generates the numbers in the ROM. *testNoise.m checks the data distribution of the design. *Please first run the sim.do file and then run the testNoise.m file.
