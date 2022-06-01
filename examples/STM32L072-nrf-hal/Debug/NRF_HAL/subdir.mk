################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (10.3-2021.10)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../NRF_HAL/nrf_hal_stm32.c 

OBJS += \
./NRF_HAL/nrf_hal_stm32.o 

C_DEPS += \
./NRF_HAL/nrf_hal_stm32.d 


# Each subdirectory must supply rules for building sources it contributes
NRF_HAL/%.o NRF_HAL/%.su: ../NRF_HAL/%.c NRF_HAL/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m0plus -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32L072xx -c -I../Core/Inc -I../Drivers/STM32L0xx_HAL_Driver/Inc -I../Drivers/STM32L0xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32L0xx/Include -I../Drivers/CMSIS/Include -I"C:/Users/Dell/STM32CubeIDE/workspace_1.9.0/STM32L072-nrf-hal/NRF_HAL" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-NRF_HAL

clean-NRF_HAL:
	-$(RM) ./NRF_HAL/nrf_hal_stm32.d ./NRF_HAL/nrf_hal_stm32.o ./NRF_HAL/nrf_hal_stm32.su

.PHONY: clean-NRF_HAL

