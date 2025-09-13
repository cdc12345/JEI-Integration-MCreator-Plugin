<#include "mcelements.ftl">
<#include "mcitems.ftl">
{
    BlockEntity blockEntity = world.getBlockEntity(BlockPos.containing(${input$x}, ${input$y}, ${input$z}));
    final ItemStack stack = ${mappedMCItemToItemStackCode(input$item)};
    if(blockEntity != null && !stack.isEmpty()) {
        final int slot = ${opt.toInt(input$slot)};
        int itemAmount = blockEntity.getCapability(ForgeCapabilities.ITEM_HANDLER, null)
                            .map(itemHandler -> itemHandler.getStackInSlot(slot).getCount())
                            .orElse(0) + stack.getCount();
        if(itemAmount > 64) {
            itemAmount = 64;
        }
        final int amount = itemAmount;

        blockEntity.getCapability(ForgeCapabilities.ITEM_HANDLER, null).ifPresent(
            itemHandler -> {
                if(itemHandler instanceof IItemHandlerModifiable modify) {
                    modify.setStackInSlot(slot, new ItemStack(stack.getItem(), amount));
                }
            }
        );
    }
}