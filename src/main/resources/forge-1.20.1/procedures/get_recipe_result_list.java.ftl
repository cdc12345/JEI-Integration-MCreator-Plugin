<#include "mcitems.ftl">
<#assign recipeName = field$recipe?replace("CUSTOM:", "")>
/*@ItemStack*/

(
    new Object() {
        public List<ItemStack> getResultList() {
            List<ItemStack> resultList = new ArrayList<>();
            if (world instanceof Level level) {
                net.minecraft.world.item.crafting.RecipeManager manager = level.getRecipeManager();
                List<${recipeName}Recipe> recipes = manager.getAllRecipesFor(${recipeName}Recipe.Type.INSTANCE).stream().map(RecipeHolder::value).collect(Collectors.toList());
                for (${recipeName}Recipe recipe : recipes) {
                    NonNullList<Ingredient> ingredients = recipe.getIngredients();
                    <#list input_list$entry as entry>
                        if (!ingredients.get(${entry?index}).test(${mappedMCItemToItemStackCode(entry)})) {
                            continue;
                        }
                    </#list>

                    if (recipe.getResultItem(null) != ItemStack.EMPTY) {
                        resultList.add(recipe.getResultItem(null));
                    }
                }
            }
            return resultList;
        }
    }.getResultList()
)