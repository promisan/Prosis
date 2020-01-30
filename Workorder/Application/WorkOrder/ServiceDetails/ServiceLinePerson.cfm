
<cfparam name="url.personNo" 			default="">
<cfparam name="url.getDefaultPerson" 	default="1">

<cfquery name="Line" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		 SELECT *	
	     FROM   WorkOrderLine
		 WHERE  WorkOrderLine     = '#url.workorderline#'	
		 AND    WorkOrderId       = '#url.workorderid#'
		 <cfif url.getDefaultPerson eq 0>
		 	 AND	1=0
		 </cfif>
</cfquery>

<cfif url.personNo neq "">
		
		<cfquery name="Person" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Person
			WHERE  PersonNo = '#url.personNo#'	
		</cfquery>
	
<cfelse>
	
	<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Person
		WHERE  PersonNo = '#Line.personNo#'	
	</cfquery>
	
</cfif>

<table width="300" cellspacing="0" cellpadding="0">
  <tr>
	
	<cfoutput query="Person">
		<input type="hidden" name="PersonNo" id="PersonNo" value="#Person.personNo#">
		<input type="hidden" name="Name" id="Name" value="#Person.FirstName# #Person.LastName#" class="regular3">				
		<input type="hidden" name="Index" id="Index" readonly value="#Person.IndexNo#" class="regular3">		
	</cfoutput>
	
	<td class="labelmedium" style="padding-left:3px;padding-top:1px;padding-bottom:1px;height:25px;border-left: 1px solid Silver;border-right: 1px solid Silver;border-top: 1px solid Silver;border-bottom: 1px solid Silver;">
	<cfoutput query="Person">
	#Person.FirstName#&nbsp;#Person.LastName#
	</cfoutput>
	</td>
	
</tr></table>
