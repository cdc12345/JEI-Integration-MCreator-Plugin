<#assign io = field$io>

(
    new Object() {
        public String getFluidStackName() {
            <#if io == "Input">
		        if(recipe.${field$name}Fluid${io}() instanceof SizedFluidIngredient sized) {
			        return sized.ingredient().isEmpty() ? "" : sized.getFluids()[0].getHoverName().getString();
		        } else if(recipe.${field$name}Fluid${io}() instanceof Optional<?> opt) {
			        if(opt.isPresent()) {
        				Object o = opt.get();
				        if(opt.get() instanceof SizedFluidIngredient sizedO) {
					        return sizedO.ingredient().isEmpty() ? "" : sizedO.getFluids()[0].getHoverName().getString();
				        }
			        }
		        }
		        return "";
            <#elseif io == "Output">
                return recipe.${field$name}Fluid${io}().getHoverName().getString();
            </#if>
        }
    }.getFluidStackName()
)