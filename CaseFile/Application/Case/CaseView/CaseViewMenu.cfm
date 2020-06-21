
<table height="100%" cellspacing="0" cellpadding="0">
	
	<cfquery name="Claim" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  Claim
			WHERE ClaimId = '#URL.claimid#'	
	</cfquery>
	
	<cfquery name="Person" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			    SELECT *
			    FROM  Person
				WHERE PersonNo = '#Claim.PersonNo#'	
			</cfquery>
	
	<cfoutput>
	
	<tr>
			
	<cfquery name="Object" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  OrganizationObject
				WHERE ObjectKeyValue4 = '#URL.claimid#'	
	</cfquery>		
	
	<cfoutput>
		
		<script language="JavaScript">
		
			function details(objectid,itm) {
			   w = #CLIENT.width# - 100;
			   h = #CLIENT.height# - 130;
			   window.open("#SESSION.root#/tools/entityaction/details/DetailsSelect.cfm?mode=window&objectid=#object.objectid#&item="+itm,itm)
			}
		
		</script>
	
	</cfoutput>
	
	<td align="right" width="350">
	
	<cfmenu 
	    name="claimmenu"
	    font="verdana"
	    fontsize="12"
	    bgcolor="transparent"
	    selecteditemcolor="C0C0C0"
	    selectedfontcolor="FFFFFF">
			 
		<cfinvoke component = "Service.Access"  
			    method           = "CaseFileManager" 
				mission          = "#claim.Mission#" 
			    claimtype        = "#claim.ClaimType#"   
			    returnvariable   = "accessLevel">				
				
		<cfif Accesslevel neq "NONE">		
			
			<cf_tl Id="Time and Expense Sheet" var="1">			  
					  
			<cfmenuitem 
			    display="#lt_text#"
			    name="addact"
			    href="javascript:details('#Object.objectid#','cost')"
			    image="#SESSION.root#/Images/activity.gif"/>			
			
		</cfif>	
		
		<!--- deprecated we now have the messaenger
				  
		<cf_tl Id="Mail and Notes" var="1">			  
					  
		<cfmenuitem 
		     display="#lt_text#"
		     name="addnote"
		     href="javascript:details('#Object.objectid#','mail')"
		     image="#SESSION.root#/Images/broadcast.png"/>		 
			 
		 --->	 
	
	</cfmenu>

</td></tr>

</cfoutput>

</table>
