<#include "../mcitems.ftl">

package ${package}.integration.jei;

import mezz.jei.api.recipe.RecipeType;

import java.util.Optional;
import java.util.List;

public class ${name}JeiCategory implements IRecipeCategory<${name}Recipe> {
    public static final ResourceLocation UID = new ResourceLocation("${modid}", "${data.getModElement().getRegistryName()}");
    public static final ResourceLocation TEXTURE = new ResourceLocation("${modid}", "textures/screens/${data.texture}.png");

    private final IDrawable background;
    private final IDrawable icon;

    public ${name}JeiCategory(IGuiHelper helper) {
        this.background = helper.createDrawable(TEXTURE, ${data.x}, ${data.y}, ${data.width}, ${data.height});
        this.icon = helper.createDrawableIngredient(VanillaTypes.ITEM_STACK, new ItemStack(${mappedMCItemToItem(data.icon)}));
    }

    @Override
    public RecipeType<${name}Recipe> getRecipeType() {
        return ${JavaModName}JeiPlugin.${name}CategoryType;
    }

    @Override
    public Component getTitle() {
        return Component.translatable("jei.${modid}.${data.getModElement().getRegistryName()}");
    }

    @Override
    public IDrawable getBackground() {
        return this.background;
    }

    @Override
    public IDrawable getIcon() {
        return this.icon;
    }

    <#if data.enableRendering>
        @Override
        public void draw(${name}Recipe recipe, IRecipeSlotsView recipeSlotsView, GuiGraphics guiGraphics, double mouseX, double mouseY) {
            Font font = Minecraft.getInstance().font;
            long ticks = Minecraft.getInstance().level.getGameTime();

            <#list data.slotList as slot>
                <#if slot.io == "Render">
                    ResourceLocation ${slot.name}Resource = new ResourceLocation("${modid}:textures/screens/${slot.resource}.png");
                    int ${slot.name}Width = ${slot.resourceWidth}, ${slot.name}Height = ${slot.resourceHeight};
                </#if>
            </#list>

            ${code}
        }
    </#if>

    @Override
    public void setRecipe(IRecipeLayoutBuilder builder, ${name}Recipe recipe, IFocusGroup focuses) {
        <#list data.slotList as slot>
            <#if slot.io == "Input">
                <#if slot.type == "Item">
                    builder.addSlot(RecipeIngredientRole.INPUT, ${slot.x}, ${slot.y}).addIngredients(VanillaTypes.ITEM_STACK, getItemStacks(recipe.${slot.name}ItemInput()));
                <#elseif slot.type == "Fluid">
                    builder.addSlot(RecipeIngredientRole.INPUT, ${slot.x}, ${slot.y}).addFluidStack(recipe.${slot.name}FluidInput().getFluid(), recipe.${slot.name}FluidInput().getAmount())
                    <#if slot.fullTank>
                        .setFluidRenderer(${slot.tankCapacity}, false, 16, ${slot.height});
                    <#else>
                        .setFluidRenderer(1, false, 16, ${slot.height});
                    </#if>

                </#if>
            <#elseif slot.io == "Output">
                <#if slot.type == "Item">
                    builder.addSlot(RecipeIngredientRole.OUTPUT, ${slot.x}, ${slot.y}).addItemStack(recipe.getItemStackResult("${slot.name}"));
                <#elseif slot.type == "Fluid">
                    builder.addSlot(RecipeIngredientRole.OUTPUT, ${slot.x}, ${slot.y}).addFluidStack(recipe.getFluidStackResult("${slot.name}").getFluid(), (long) recipe.getFluidStackResult("${slot.name}").getAmount())
                    <#if slot.fullTank>
                        .setFluidRenderer(${slot.tankCapacity}, false, 16, ${slot.height});
                    <#else>
                        .setFluidRenderer(1, false, 16, ${slot.height});
                    </#if>
                </#if>
            </#if>
        </#list>
    }

    // JeiI: Returns a List<ItemStack> based on either a SizedIngredient or Optional<SizedIngredient>
    private List<ItemStack> getItemStacks(Object in) {
        if(in instanceof SizedIngredient sized) {
            return Arrays.asList(sized.getItems());
        } else if(in instanceof Optional<?> opt) {
            if(opt.isPresent()) {
                Object o = opt.get();
                if(o instanceof SizedIngredient sizedO) {
                    return Arrays.asList(sizedO.getItems());
                }
            }
        }
        return new ArrayList<>();
    }
}