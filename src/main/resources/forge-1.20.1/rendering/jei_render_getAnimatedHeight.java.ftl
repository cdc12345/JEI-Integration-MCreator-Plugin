<#assign dur = input$duration>
<#assign dur = dur?replace("(", "")>
<#assign dur = dur?replace(")", "")>

<#assign hei = input$height>
<#assign hei = hei?replace("(", "")>
<#assign hei = hei?replace(")", "")>

(
	((int) (ticks % ${dur}) * (${hei} + 1)) / ${dur}
)