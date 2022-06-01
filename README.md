# NRF24L01+ API for STM32 Platforms

*This is a library to abstract all register access from Nordic NRF24L01+ and provide programmer easy programming interface to this chip. Credits to the author [Piotr Stolarz](https://github.com/pstolarz) whose original [library](https://github.com/pstolarz/NRF_HAL) is here ported from Arduino to STM32 devices by using the HAL API provided by STM32CubeIDE.*

Some considerations before using this module:<br>
1. For proper functioning of the chip ***always*** attach a 4.7uF capacitor to the VCC and GND of the module.
2. The chip was tested on the platform B-L072Z-LRWAN with the microcontroller STM32L072 on-board. 
3. For some reason the interrupt through IRQ pin doesn't seem to be working in the modules. Further versions might support communication through interrupt.

## *Usage*
*Here are the steps to follow for using the library in the CubeIDE enviroment*
<ol>
<li> Watch <a href="(https://www.youtube.com/watch?v=VXX38EtfreM)">this</a> video for understanding how to include custom libraries in STM32 projects.
<li> Move the contents of this repo in the source folder created in the above step.
<li> The library needs the following settings as prerequisite  for working:
    <ol type="a">
    <li> In the STMCubeIDE IOC perspective SPI connectivity has to provided with 
        <ul type="circle">
        <li> Software SS Functionality 
        <li> 1MHz Frequency clock 
        <li> MSBFirst 
        <li> SPI MODE 0
        </ul>
    <li>A GPIO pin has to be configured in the same perspective as GPIO_Output and labeled as SS. By default the pin labeled the same is PB6, but it also has to configured as an output.
    </ol>
</ol>

