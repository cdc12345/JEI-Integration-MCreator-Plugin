<#assign codeEvt = field$operator>

<#assign din1 = input$in1>
<#assign r1l = din1?replace("(", "")>
<#assign r1r = r1l?replace(")", "")>

<#assign din2 = input$in2>
<#assign r2l = din1?replace("(", "")>
<#assign r2r = r2l?replace(")", "")>

<#if codeEvt?contains("Math.")>
    <#assign code = codeEvt + "(" + r1r + ", " + r2r + ")">
<#elseif codeEvt == "double/">
    <#assign code = "(double)" + r1r + "/" + r2r>
<#else>
    <#assign code = r1r + field$operator + r2r>
</#if>

(
    ${code}
)