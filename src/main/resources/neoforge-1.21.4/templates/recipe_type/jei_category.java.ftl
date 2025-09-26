<#include "../mcitems.ftl">

package ${package}.integration.jei;

import mezz.jei.api.recipe.types.IRecipeType;

import java.util.Optional;
import java.util.List;

public class ${name}JeiCategory implements IRecipeCategory<${name}Recipe> {
    public static final ResourceLocation UID = ResourceLocation.parse("${modid}:${data.getModElement().getRegistryName()}");
    public static final ResourceLocation TEXTURE = ResourceLocation.parse("${modid}:textures/screens/${data.texture}.png");

    private final IDrawable background;
    private final IDrawable icon;

    public ${name}JeiCategory(IGuiHelper helper) {
        this.background = helper.createDrawable(TEXTURE, ${data.x}, ${data.y}, ${data.width}, ${data.height});
        this.icon = helper.createDrawableIngredient(VanillaTypes.ITEM_STACK, new ItemStack(${mappedMCItemToItem(data.icon)}));
    }

    @Override
    public IRecipeType<${name}Recipe> getRecipeType() {
        return ${JavaModName}JeiPlugin.${name}CategoryType;
    }

    @Override
    public Component getTitle() {
        return Component.translatable("jei.${modid}.${data.getModElement().getRegistryName()}");
    }

    @Override
    public IDrawable getIcon() {
        return this.icon;
    }

    @Override
    public int getWidth() {
        return this.background.getWidth();
    }

    @Override
    public int getHeight() {
        return this.background.getHeight();
    }

    @Override
    public void draw(${name}Recipe recipe, IRecipeSlotsView recipeSlotsView, GuiGraphics guiGraphics, double mouseX, double mouseY) {
        this.background.draw(guiGraphics);
        <#if data.enableRendering>
            Font font = Minecraft.getInstance().font;
            long ticks = Minecraft.getInstance().level.getGameTime();

            <#list data.slotList as slot>
                <#if slot.io == "Render">
                    ResourceLocation ${slot.name}Resource = ResourceLocation.parse("${modid}:textures/screens/${slot.resource}.png");
                    int ${slot.name}Width = ${slot.resourceWidth}, ${slot.name}Height = ${slot.resourceHeight};
                </#if>
            </#list>

            ${code}
        </#if>
    }

    @Override
    public void setRecipe(IRecipeLayoutBuilder builder, ${name}Recipe recipe, IFocusGroup focuses) {
        <#list data.slotList as slot>
            <#if slot.io == "Input">
                <#if slot.type == "Item">
                    builder.addSlot(RecipeIngredientRole.INPUT, ${slot.x}, ${slot.y}).addIngredients(VanillaTypes.ITEM_STACK, getItemStacks(recipe.${slot.name}ItemInput()));
                <#elseif slot.type == "Fluid">
                    builder.addSlot(RecipeIngredientRole.INPUT, ${slot.x}, ${slot.y}).addIngredients(NeoForgeTypes.FLUID_STACK, getFluidStacks(recipe.${slot.name}FluidInput()))
                    <#if slot.fullTank>
                        .setFluidRenderer(${slot.tankCapacity}, false, 16, ${slot.height});
                    <#else>
                        .setFluidRenderer(1, false, 16, ${slot.height});
                    </#if>

                </#if>
            <#elseif slot.io == "Output">
                <#if slot.type == "Item">
                    builder.addSlot(RecipeIngredientRole.OUTPUT, ${slot.x}, ${slot.y}).add(recipe.getItemStackResult("${slot.name}"));
                <#elseif slot.type == "Fluid">
                    builder.addSlot(RecipeIngredientRole.OUTPUT, ${slot.x}, ${slot.y}).add(recipe.getFluidStackResult("${slot.name}").getFluid(), (long) recipe.getFluidStackResult("${slot.name}").getAmount())
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
        List<ItemStack> stacks = new ArrayList<>();
        if(in instanceof SizedIngredient sized) {
            for(int i = 0; i < sized.ingredient().getValues().size(); i++) {
                stacks.add(new ItemStack(sized.ingredient().getValues().get(i), sized.count()));
            }
        } else if(in instanceof Ingredient ingre) {
            for(int i = 0; i < ingre.getValues().size(); i++) {
                stacks.add(new ItemStack(ingre.getValues().get(i)));
            }
        } else if(in instanceof Optional<?> opt) {
            if(opt.isPresent()) {
                Object o = opt.get();
                if(o instanceof SizedIngredient sizedO) {
                    for(int i = 0; i < sizedO.ingredient().getValues().size(); i++) {
                        stacks.add(new ItemStack(sizedO.ingredient().getValues().get(i), sizedO.count()));
                    }
                }
            }
        }
        return stacks;
    }

    // JeiI: Returns a List<FluidStack> based on either a SizedFluidIngredient or Optional<SizedFluidIngredient>
	private List<FluidStack> getFluidStacks(Object in) {
		List<FluidStack> stacks = new ArrayList<>();
		if(in instanceof SizedFluidIngredient sized) {
			for(int i = 0; i < sized.ingredient().fluids().size(); i++) {
				stacks.add(new FluidStack(sized.ingredient().fluids().get(i).value(), sized.amount()));
			}
		} else if(in instanceof Optional<?> opt) {
			if(opt.isPresent()) {
				Object o = opt.get();
				if(opt.get() instanceof SizedFluidIngredient sizedO) {
					for(int i = 0; i < sizedO.ingredient().fluids().size(); i++) {
						stacks.add(new FluidStack(sizedO.ingredient().fluids().get(i).value(), sizedO.amount()));
					}
				}
			}
		}
		return stacks;
	}
}