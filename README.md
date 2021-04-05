# DS18S20_FPGA_Sensor

DS18S20 1-Wire protocol DIgital Thermometer implementation in NEXYS A7 Digilent Board powered by ARTIX-7 Xilinx FPGA

Those are the principal specifications of the project and the designs to be
developed.

- [x] For this project has to be used a DS18S20 1-Wire Digital Thermometer
- [x] The device has to be able to display from -55 to 125 degrees Celsius, and has to have a way to convert form Degrees Celsius to Degrees Fahrenheit
- [x] The Value of the temperature has to be displayed on the 7 segments display.
- [x] The refreshment rate has to be minimum 1 second.
- [x] For the logic has to be used a NEXYS A7 Digilent Board powered by an ARTIX-7 Xilinx FPGA.
- [x] The design has to be Full synchronous, which means that All input signals have to by synchronized and all flip-flops have to be sensitive to the same clock.
- [x] The design has to be hierarchical and modular.

The designs in that case cover until the maximal precision that the DS18S20 Thermometer can give, being able to display that maximal precision only in degrees centigrade. And the refreshment rate is approximately 800 milliseconds.



