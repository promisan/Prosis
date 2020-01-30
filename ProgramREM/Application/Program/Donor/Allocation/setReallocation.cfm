
<cfparam name="Form.Transaction_#left(url.contributionLineId,8)#" default="">

<cfset selected = evaluate("Form.Transaction_#left(url.contributionLineId,8)#")>

<cfif selected neq "">

<cfoutput>

		<input type="button"
		       name="action"
		       value="Process"     
			   onclick="contributionreallocate('Transaction_#left(url.contributionlineid,8)#','#url.contributionlineid#','#URL.systemfunctionid#','#URL.contributionid#')"
		       style="height:21;font-size:11px;border:1px solid gray;width: 45; background-color: red; color: white;">
			   
</cfoutput>	   

<cfelse>

</cfif>