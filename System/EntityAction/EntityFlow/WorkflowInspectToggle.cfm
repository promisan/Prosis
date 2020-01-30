<cfoutput>

<cfset ToggleValue = Evaluate("#Toggle#")>

<td width="50" id="#Toggle#Red" Class=<cfif ToggleValue neq "0">"hide"<cfelse>"regular"</cfif>>
		 <img src="#SESSION.root#/Images/light_red3.gif"
	     alt="Activate"
	     width="24"
	     height="15"
	     border="0"
	     style="cursor: pointer;"
	     onClick="toggleParam('#Toggle#','#ToggleValue#','#URL.EntityCode#','#URL.EntityClass#','#URL.ActionCode#','#URL.PublishNo#','No')">
</td> 
<td width="50" id="#Toggle#Green" Class=<cfif ToggleValue neq "0">"regular"<cfelse>"hide"</cfif>>
		 <img src="#SESSION.root#/Images/light_green2.gif"
	     alt="Disabled"
	     width="24"
	     height="15"
	     border="0"
	     style="cursor: pointer;"
	     onClick="toggleParam('#Toggle#','#ToggleValue#','#URL.EntityCode#','#URL.EntityClass#','#URL.ActionCode#','#URL.PublishNo#','No')"> 
</td>
</cfoutput>
