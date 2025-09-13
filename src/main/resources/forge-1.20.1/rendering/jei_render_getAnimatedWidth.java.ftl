<#assign dur = input$duration>
<#assign dur = dur?replace("(", "")>
<#assign dur = dur?replace(")", "")>

<#assign wid = input$width>
<#assign wid = wid?replace("(", "")>
<#assign wid = wid?replace(")", "")>

(
	((int) (ticks % ${dur}) * (${wid} + 1)) / ${dur}
)