<#assign io = field$io>

(
    <#if io == "Input">
        recipe.${field$name}Item${io}().ingredient().isEmpty() ? "" : recipe.${field$name}Item${io}().getItems()[0].getHoverName().getString()
    <#elseif io == "Output">
        recipe.${field$name}Item${io}().getHoverName().getString()
    </#if>
)