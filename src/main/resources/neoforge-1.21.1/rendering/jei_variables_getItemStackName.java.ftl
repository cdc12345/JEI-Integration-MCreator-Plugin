<#assign io = field$io>

(
    new Object(){
        public String getItemStackName() {
            <#if io == "Input">
                if(recipe.${field$name}Item${io}() instanceof SizedIngredient sized) {
                    return sized.ingredient().isEmpty() ? "" : sized.getItems()[0].getHoverName().getString();
                } else if(recipe.${field$name}Item${io}() instanceof Ingredient ingre) {
                    return ingre.isEmpty() ? "" : ingre.getItems()[0].getHoverName().getString();
                } else if(recipe.${field$name}Item${io}() instanceof Optional<?> opt) {
                    if(opt.isPresent()) {
                        Object o = opt.get();
                        if(o instanceof SizedIngredient sizedO) {
                            return sizedO.ingredient().isEmpty() ? "" : sizedO.getItems()[0].getHoverName().getString();
                        } else if(o instanceof Ingredient ingreO) {
                            return ingreO.isEmpty() ? "" : ingreO.getItems()[0].getHoverName().getString();
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