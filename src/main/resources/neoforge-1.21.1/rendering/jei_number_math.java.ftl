<#assign codeEvt = field$operator>

<#assign din = input$number>
<#assign rl = din?replace("(", "")>
<#assign rr = rl?replace(")", "")>

<#assign code = codeEvt + "(" + rr + ")">

(
    ${code}
)