<#assign io = field$io>

(
    <#if io == "Input">
        recipe.${field$name}Item${io}().getIngredient().isEmpty() ? 0 : recipe.${field$name}Item${io}().getItems()[0].getCount()
    <#elseif io == "Output">
        recipe.${field$name}Item${io}().getCount()
    </#if>
)