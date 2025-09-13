{
    BlockEntity blockEntity = world.getBlockEntity(BlockPos.containing(${input$x}, ${input$y}, ${input$z}));
    final FluidStack stack = ${input$fluid};
    if(blockEntity != null && !stack.isEmpty()) {
        final int tankIndex = ${opt.toInt(input$tank)};
        int fluidAmount = blockEntity.getCapability(ForgeCapabilities.FLUID_HANDLER, null)
                                     .map(fluidHandler -> fluidHandler.getFluidInTank(tankIndex).getAmount())
                                     .orElse(0) + stack.getAmount();
        int tankSize = blockEntity.getCapability(ForgeCapabilities.FLUID_HANDLER, null)
                                  .map(fluidHandler -> fluidHandler.getTankCapacity(tankIndex))
                                  .orElse(0);

        if(fluidAmount > tankSize) {
            fluidAmount = tankSize;
        }
        final int amount = fluidAmount;

		blockEntity.getCapability(ForgeCapabilities.FLUID_HANDLER, null).ifPresent(fluidHandler -> {
		    try {
                var method = fluidHandler.getClass().getMethod("getTank", int.class);
                method.setAccessible(true);
                Object tankObj = method.invoke(fluidHandler, tankIndex);
                if(tankObj instanceof FluidTank fTank) {
                    fTank.setFluid(new FluidStack(stack, amount));
                } else {
                    if(fluidHandler instanceof FluidTank fTankA) {
                        fTankA.setFluid(new FluidStack(stack.getFluid(), amount));
                    } else {
                        fluidHandler.fill(stack.copy(), IFluidHandler.FluidAction.EXECUTE);
                    }
                }
		    } catch (NoSuchMethodException fallback) {
                if(fluidHandler instanceof FluidTank fTankF) {
                    fTankF.setFluid(new FluidStack(stack.getFluid(), amount));
                } else {
                    fluidHandler.fill(stack.copy(), IFluidHandler.FluidAction.EXECUTE);
                }
		    } catch (IllegalAccessException | InvocationTargetException e) {
		        e.printStackTrace();
		    }
		});
    }
}