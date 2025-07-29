<#include "mcitems.ftl">
<#assign recipeName = field$recipe?replace("CUSTOM:", "")>
/*@ItemStack*/

(
    new Object() {
        public boolean isRecipeValid() {
            if (world instanceof ServerLevel level) {
                net.minecraft.world.item.crafting.RecipeManager manager = level.recipeAccess();
                List<${recipeName}Recipe> recipes = manager.recipeMap().byType(${recipeName}Recipe.Type.INSTANCE).stream().map(RecipeHolder::value).collect(Collectors.toList());
                for (${recipeName}Recipe recipe : recipes) {
                    NonNullList<Ingredient> ingredients = recipe.getIngredients();
                    <#list input_list$entry as entry>
                        if (!ingredients.get(${entry?index}).test(${mappedMCItemToItemStackCode(entry)})) {
                            continue;
                        }
                    </#list>
                    if (recipe.getResultItem() != ItemStack.EMPTY) {
                        return true;
                    }
                }
            }
            return false;
        }
    }.isRecipeValid()
)