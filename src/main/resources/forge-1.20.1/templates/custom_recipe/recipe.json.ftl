<#include "../mcitems.ftl">
<#compress>
{
    "type": "${modid}:${data.category}",
    <#list data.inputs as input>
        <#if input.type == "Item">
            "${input.name}": {
                ${mappedMCItemToItemObjectJSON(input.itemId)},
                "count": ${input.itemAmount}
            },
        <#elseif input.type == "Fluid">
            "${input.name}": {
                <#assign recipeFluid = mappedMCItemToItemObjectJSON(input.fluidId)>
                <#assign registryFluid = recipeFluid?replace("\"item\"", "\"fluid\"")>
                <#if registryFluid?contains("_get()")>
                    <#assign fluid = registryFluid?replace("_get()", "")>
                <#else>
                    <#assign fluid = registryFluid>
                </#if>
                ${fluid},
                "amount": ${input.fluidAmount}
            },
        <#elseif input.type == "Logic">
            "${input.name}": ${input.logic},
        <#elseif input.type == "Number">
            "${input.name}": ${input.number},
        <#elseif input.type == "Text">
            "${input.name}": "${input.text}",
        </#if>
    </#list>
        <#list data.outputs as output>
            <#if output.type == "Item">
                "${output.name}": {
                    ${mappedMCItemToItemObjectJSON(output.itemId)},
                    "count": ${output.itemAmount}
                },
            <#elseif output.type == "Fluid">
                "${output.name}": {
                    <#assign recipeFluid = mappedMCItemToItemObjectJSON(output.fluidId)>
                    <#assign registryFluid = recipeFluid?replace("\"item\"", "\"fluid\"")>
                    <#if registryFluid?contains("_get()")>
                        <#assign fluid = registryFluid?replace("_get()", "")>
                    <#else>
                        <#assign fluid = registryFluid>
                    </#if>
                    ${fluid},
                    "amount": ${output.fluidAmount}
                },
            <#elseif output.type == "Logic">
                "${output.name}": ${output.logic},
            <#elseif output.type == "Number">
                "${output.name}": ${output.number},
            <#elseif output.type == "Text">
                "${output.name}": "${output.text}",
            </#if>
        </#list>
    "category": [
        "misc"
    ]
}
</#compress>