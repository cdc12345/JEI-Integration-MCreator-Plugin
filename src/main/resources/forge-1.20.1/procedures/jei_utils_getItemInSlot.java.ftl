<#include "mcelements.ftl">
/*@ItemStack*/
(
    new Object() {
        public ItemStack getItemInSlot(LevelAccessor level, BlockPos pos, int slot) {
            ItemStack stack = ItemStack.EMPTY;
            BlockEntity blockEntity = level.getBlockEntity(pos);
            if(blockEntity != null) {
                stack = blockEntity.getCapability(ForgeCapabilities.ITEM_HANDLER, null)
                                   .map(itemHandler -> itemHandler.getStackInSlot(slot))
                                   .orElse(ItemStack.EMPTY);
            }
            return stack;
        }
    }.getItemInSlot(world, BlockPos.containing(${input$x}, ${input$y}, ${input$z}), ${opt.toInt(input$slot)})
)