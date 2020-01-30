<cfoutput>

<cfparam name="url.status" default="0">

<table cellspacing="0" cellpadding="0" class="formspacing">

	<cfif url.status eq "0">
	<tr><td class="labelit">Was this information helpful?</td>
	<td style="padding-left:4px"><img alt="useful" src="<cfoutput>#SESSION.root#</cfoutput>/Images/ratepositive.gif" 
	    style="cursor: pointer;" onclick = "feedback('#url.topicid#','1')"
		border="0">
	</td>
	<td style="padding-left:4px"><img alt="somewhat useful" src="<cfoutput>#SESSION.root#</cfoutput>/Images/ratenormal.gif" 
	    style="cursor: pointer;" onclick = "feedback('#url.topicid#','2')"
	  	border="0">
	</td>
	<td style="padding-left:4px"><img alt="not useful" src="<cfoutput>#SESSION.root#</cfoutput>/Images/ratenegative.gif" 
		style="cursor: pointer;" onclick = "feedback('#url.topicid#','3')"
	    border="0">
	</td>
	</tr>
	<cfelse>
	<tr><td  class="labelit"><b>Thank you!</b></td></tr>
	</cfif>
</table>

</cfoutput>