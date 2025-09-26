<#include "mcitems.ftl">
<#assign recipeName = field$recipe?replace("CUSTOM:", "")>
(

<#assign typeArray = field_list$type>
<#assign nameArray = field_list$name>
<#assign consumeArray = field_list$consume>

    new Object() {
        public boolean getResult(
            <#assign head = []>
            <#list input_list$entry as entry>
                <#assign i = entry?index>

                <#if typeArray[i] == "MCItem">
                    <#assign head += ["ItemStack ${nameArray[i]}ItemInput"]>
                <#elseif typeArray[i] == "FluidStack">
                    <#assign head += ["FluidStack ${nameArray[i]}FluidInput"]>
                <#elseif typeArray[i] == "Boolean">
                    <#assign head += ["boolean ${nameArray[i]}LogicInput"]>
                <#elseif typeArray[i] == "Number">
                    <#assign head += ["double ${nameArray[i]}NumberInput"]>
                <#elseif typeArray[i] == "String">
                    <#assign head += ["String ${nameArray[i]}StringInput"]>
                </#if>
            </#list>
            ${head?join(", ")}
        ) {
            boolean result = false;

            List<${recipeName}Recipe> recipes = new ArrayList<>();
            if(world instanceof Level level) {
                net.minecraft.world.item.crafting.RecipeManager manager = level.getRecipeManager();
                recipes.addAll(manager.getAllRecipesFor(${recipeName}Recipe.Type.INSTANCE).stream().map(RecipeHolder::value).collect(Collectors.toList()));
            }

            boolean recipeInputNotConsumed = true;

            for(${recipeName}Recipe recipe : recipes) {
                boolean _itemMatch = true
                    <#list input_list$entry as entry>
                        <#assign i = entry?index>

                        <#if typeArray[i] == "MCItem">
                            && recipe.validate(${nameArray[i]}ItemInput, recipe.${nameArray[i]}ItemInput())
                        </#if>
                    </#list>
                ;
                boolean _fluidMatch = true
                    <#list input_list$entry as entry>
                        <#assign i = entry?index>

                        <#if typeArray[i] == "FluidStack">
                            && recipe.validate(${nameArray[i]}FluidInput, recipe.${nameArray[i]}FluidInput())
                        </#if>
                    </#list>
                ;
                boolean _logicMatch = true
                    <#list input_list$entry as entry>
                        <#assign i = entry?index>

                        <#if typeArray[i] == "Boolean">
                            && recipe.validate(${nameArray[i]}LogicInput, ${nameArray[i]}LogicInput())
                        </#if>
                    </#list>
                ;
                boolean _numberMatch = true
                    <#list input_list$entry as entry>
                        <#assign i = entry?index>

                        <#if typeArray[i] == "Number">
                            && recipe.validate(${nameArray[i]}NumberInput, recipe.${nameArray[i]}NumberInput())
                        </#if>
                    </#list>
                ;
                boolean _textMatch = true
                    <#list input_list$entry as entry>
                        <#assign i = entry?index>

                        <#if typeArray[i] == "String">
                            && recipe.validate(${nameArray[i]}TextInput, recipe.${nameArray[i]}TextInput())
                        </#if>
                    </#list>
                ;

                if(_itemMatch && _fluidMatch && _logicMatch && _numberMatch && _textMatch) {
                    result = recipe.getBooleanResult("${field$name}");

                    if(recipeInputNotConsumed) {
                        <#list input_list$entry as entry>
                            <#assign i = entry?index>

                            <#if consumeArray[i] == "TRUE">
                                <#if typeArray[i] == "MCItem">
                                    ${nameArray[i]}ItemInput.shrink(recipe.amount(recipe.${nameArray[i]}ItemInput()));
                                <#elseif typeArray[i] == "FluidStack">
                                    ${nameArray[i]}FluidInput.shrink(recipe.amount(recipe.${nameArray[i]}FluidInput().getAmount()));
                                </#if>
                            </#if>
                        </#list>

                        recipeInputNotConsumed = false;
                    }

                    break;
                }
            }
        return result;
        }
    }.getResult(
        <#list input_list$entry as entry>
            ${entry}<#sep>,
        </#list>
    )
)