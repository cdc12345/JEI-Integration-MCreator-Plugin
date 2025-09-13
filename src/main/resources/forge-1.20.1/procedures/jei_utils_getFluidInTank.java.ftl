<#include "mcelements.ftl">
(
	new Object() {
		public FluidStack getFluidInTank(LevelAccessor level, BlockPos pos, int tank) {
		    FluidStack stack = FluidStack.EMPTY;
			BlockEntity blockEntity = level.getBlockEntity(pos);
			if(blockEntity != null) {
				stack = blockEntity.getCapability(ForgeCapabilities.FLUID_HANDLER, null)
					               .map(fluidHandler -> fluidHandler.getFluidInTank(tank))
					               .orElse(FluidStack.EMPTY);
			}
			return stack;
		}
	}.getFluidInTank(world, BlockPos.containing(${input$x}, ${input$y}, ${input$z}), ${opt.toInt(input$tank)})
)