<#assign io = field$io>

(
    new Object() {
        public int getFluidStackAmount() {
            <#if io == "Input">
		        if(recipe.${field$name}Fluid${io}() instanceof SizedFluidIngredient sized) {
			        return sized.ingredient().isEmpty() ? 0 : sized.amount();
		        } else if(recipe.${field$name}Fluid${io}() instanceof Optional<?> opt) {
			        if(opt.isPresent()) {
        				Object o = opt.get();
				        if(opt.get() instanceof SizedFluidIngredient sizedO) {
					        return sizedO.ingredient().isEmpty() ? 0 : sizedO.amount();
				        }
			        }
		        }
		        return 0;
            <#elseif io == "Output">
                return recipe.${field$name}Fluid${io}().getAmount();
            </#if>
        }
    }.getFluidStackAmount()
)