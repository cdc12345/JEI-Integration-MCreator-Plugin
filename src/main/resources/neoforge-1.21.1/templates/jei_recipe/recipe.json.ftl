<#include "../mcitems.ftl">
<#compress>
{
    "type": "${modid}:${data.category}",
    "category": "misc",
    <#list data.inputs as input>
        <#if input.type == "ITEM_INPUT">
            "${input.name}": {
                ${mappedMCItemToItemObjectJSON(input.itemInput, "item")},
                "count": ${input.itemAmount}
            },
        <#elseif input.type == "FLUID_INPUT">
            "${input.name}": {
                <#assign registryFluid = mappedMCItemToItemObjectJSON(input.fluidInput, "id")>
                <#if registryFluid?contains("_get()")>
                    <#assign fluid = registryFluid?replace("_get()", "")>
                <#else>
                    <#assign fluid = registryFluid>
                </#if>
                ${fluid},
                "amount": ${input.fluidAmount}
            },
        </#if>
    </#list>
    "output": {
      ${mappedMCItemToItemObjectJSON(data.output, "item")},
      "count": ${data.outputAmount}
    }
}
</#compress>