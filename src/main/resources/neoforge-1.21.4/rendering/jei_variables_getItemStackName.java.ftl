<#assign io = field$io>

(
    new Object(){
        public String getItemStackName() {
            <#if io == "Input">
                if(recipe.${field$name}Item${io}() instanceof SizedIngredient sized) {
                    return sized.ingredient().isEmpty() ? "" : sized.ingredient().getValues().get(0).getName().getString();
                } else if(recipe.${field$name}Item${io}() instanceof Ingredient ingre) {
                    return ingre.isEmpty() ? "" : ingre.getValues().get(0).getName().getString();
                } else if(recipe.${field$name}Item${io}() instanceof Optional<?> opt) {
                    if(opt.isPresent()) {
                        Object o = opt.get();
                        if(o instanceof SizedIngredient sizedO) {
                            return sizedO.ingredient().isEmpty() ? "" : sizedO.ingredient().getValues().get(0).getName().getString();
                        } else if(o instanceof Ingredient ingreO) {
                            return ingreO.isEmpty() ? "" : ingreO.getValues().get(0).getName().getString();
                        }
                    }
                }
                return "";
            <#elseif io == "Output">
                return recipe.${field$name}Item${io}().getHoverName().getString();
            </#if>
        }
    }.getItemStackName()
)