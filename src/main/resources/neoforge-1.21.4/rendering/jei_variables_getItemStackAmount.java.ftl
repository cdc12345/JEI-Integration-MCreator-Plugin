<#assign io = field$io>

(
    new Object(){
        public int getItemStackAmount() {
            <#if io == "Input">
                if(recipe.${field$name}Item${io}() instanceof SizedIngredient sized) {
                    return sized.ingredient().isEmpty() ? 0 : sized.count();
                } else if(recipe.${field$name}Item${io}() instanceof Ingredient ingre) {
                    return ingre.isEmpty() ? 0 : 1;
                } else if(recipe.${field$name}Item${io}() instanceof Optional<?> opt) {
                    if(opt.isPresent()) {
                        Object o = opt.get();
                        if(o instanceof SizedIngredient sizedO) {
                            return sizedO.ingredient().isEmpty() ? 0 : sizedO.count();
                        } else if(o instanceof Ingredient ingreO) {
                            return ingreO.isEmpty() ? 0 : 1;
                        }
                    }
                }
                return 0;
            <#elseif io == "Output">
                return recipe.${field$name}Item${io}().getCount();
            </#if>
        }
    }.getItemStackAmount()
)