<#assign io = field$io>

(
    <#if io == "Input">
        recipe.${field$name}Fluid${io}().ingredient().isEmpty() ? 0 : recipe.${field$name}Fluid${io}().getFluids()[0].getAmount()
    <#elseif io == "Output">
        recipe.${field$name}Fluid${io}().getAmount()
    </#if>
)