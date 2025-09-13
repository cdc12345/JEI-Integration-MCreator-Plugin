<#include "../mcitems.ftl">

package ${package}.init;

import mezz.jei.api.recipe.RecipeType;

<#compress>
@JeiPlugin
public class ${JavaModName}JeiPlugin implements IModPlugin {
    <#list recipe_types as type>
        public static RecipeType<${type.getModElement().getName()}Recipe> ${type.getModElement().getName()}CategoryType = new RecipeType<>(${type.getModElement().getName()}JeiCategory.UID, ${type.getModElement().getName()}Recipe.class);
    </#list>

    @Override
    public ResourceLocation getPluginUid() {
    	return ResourceLocation.parse("${modid}:jei_plugin");
    }

	@Override
	public void registerCategories(IRecipeCategoryRegistration registration) {
	    <#list recipe_types as type>
	        registration.addRecipeCategories(new
	            ${type.getModElement().getName()}JeiCategory(registration.getJeiHelpers().getGuiHelper()));
	    </#list>
	}

	@Override
	public void registerRecipes(IRecipeRegistration registration) {
		RecipeManager recipeManager = Objects.requireNonNull(Minecraft.getInstance().level).getRecipeManager();

		<#list recipe_types as type>
            List<${type.getModElement().getName()}Recipe> ${type.getModElement().getName()}Recipes = recipeManager.getAllRecipesFor(${type.getModElement().getName()}Recipe.Type.INSTANCE).stream().map(RecipeHolder::value).collect(Collectors.toList());
            registration.addRecipes(${type.getModElement().getName()}CategoryType, ${type.getModElement().getName()}Recipes);
		</#list>
	}

	@Override
	public void registerRecipeCatalysts(IRecipeCatalystRegistration registration) {
	    <#list recipe_types as type>
	        <#if type.enableTables>
	            <#list type.tables as block>
	                registration.addRecipeCatalyst(new ItemStack(${mappedMCItemToItem(block)}), ${type.getModElement().getName()}CategoryType);
	            </#list>
	        </#if>
	    </#list>
	}

    @Override
    public void registerGuiHandlers(IGuiHandlerRegistration registration) {
        <#list recipe_types as type>
            <#if type.enableClickArea>
                <#list type.clickAreaList as ca>
                    registration.addRecipeClickArea(${ca.clickGui}Screen.class, ${ca.clickX}, ${ca.clickY}, ${ca.clickWidth}, ${ca.clickHeight}, ${type.getModElement().getName()}CategoryType);
                </#list>
            </#if>
        </#list>
    }
}</#compress>
