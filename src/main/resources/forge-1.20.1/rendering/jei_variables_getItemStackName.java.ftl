<#assign io = field$io>

(
    <#if io == "Input">
        recipe.${field$name}Item${io}().getIngredient().isEmpty() ? "" : recipe.${field$name}Item${io}().getItems()[0].getDisplayName().getString()
    <#elseif io == "Output">
        recipe.${field$name}Item${io}().getDisplayName().getString()
    </#if>
)