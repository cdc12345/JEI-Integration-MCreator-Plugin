<#include "../mcitems.ftl">

package ${package}.init;

<#compress>
@JeiPlugin
public class ${JavaModName}JeiPlugin implements IModPlugin {
    <#list jeirecipetypes as type>
        public static mezz.jei.api.recipe.types.IRecipeType<${type.getModElement().getName()}Recipe> ${type.getModElement().getName()}_Type =
            mezz.jei.api.recipe.types.IRecipeType.create(${type.getModElement().getName()}RecipeCategory.UID, ${type.getModElement().getName()}Recipe.class);

            //(${type.getModElement().getName()}RecipeCategory.UID, ${type.getModElement().getName()}Recipe.class);
    </#list>

    @Override
    public ResourceLocation getPluginUid() {
    	return ResourceLocation.parse("${modid}:jei_plugin");
    }

	@Override
	public void registerCategories(IRecipeCategoryRegistration registration) {
	    <#list jeirecipetypes as type>
	        registration.addRecipeCategories(new
	            ${type.getModElement().getName()}RecipeCategory(registration.getJeiHelpers().getGuiHelper()));
	    </#list>
	}

	@Override
	public void registerRecipes(IRecipeRegistration registration) {
	    /**
	    * level resembling the ClientLevel class where the getRecipeManager() method was removed
		RecipeManager recipeManager = Minecraft.getInstance().level.getRecipeManager();

		<#list jeirecipetypes as type>
            List<${type.getModElement().getName()}Recipe> ${type.getModElement().getName()}Recipes = recipeManager.recipeMap().byType(${type.getModElement().getName()}Recipe.Type.INSTANCE).stream().map(RecipeHolder::value).collect(Collectors.toList());
            registration.addRecipes(${type.getModElement().getName()}_Type, ${type.getModElement().getName()}Recipes);
		</#list>
		*/
	}

	@Override
	public void registerRecipeCatalysts(IRecipeCatalystRegistration registration) {
	    <#list jeirecipetypes as type>
	        <#if type.enableCraftingtable>
	            registration.addCraftingStation(
	                ${type.getModElement().getName()}_Type
	            <#list type.craftingtables as block>
	                ,new ItemStack(${mappedMCItemToItem(block)})
	            </#list>
	            );
	        </#if>
	    </#list>
	}

}</#compress>
