<#assign io = field$io>

(
    <#if io == "Input">
        recipe.${field$name}Fluid${io}().ingredient().isEmpty() ? "" : recipe.${field$name}Fluid${io}().getFluids()[0].getHoverName().getString()
    <#elseif io == "Output">
        recipe.${field$name}Fluid${io}().getHoverName().getString()
    </#if>
)