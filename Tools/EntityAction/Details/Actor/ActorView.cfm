
<!--- actors we obtain the enabled fly-actors for this action and allow them to record inputs (descision and comment --->

<cfquery name="Actor" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT      UserAccount, AccessLevel, FirstName, LastName
	FROM        OrganizationObjectActionAccess A INNER JOIN System.dbo.UserNames U ON A.UserAccount = U.Account
	WHERE       ObjectId   = '#ObjectId#' 
	AND         ActionCode = '#ActionCode#'
</cfquery>

<table style="width:100%" class="navigation_table">

	<tr><td style="height:1px"></td></tr>
	
	<tr class="line labelmedium">
	   <td style="min-width:150px"><cf_tl id="Officer"></td>
	   <td style="min-width:200px"><cf_tl id="Input"></td>
	   <td style="width:100%"><cf_tl id="Memo"></td>
	   <td  style="min-width:90px"><cf_tl id="Stamp"></td>
	</tr>

	<cfoutput query="Actor">
	
		<!--- get the last input for this user --->
		
		<cfquery name="Process" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
			SELECT     TOP 1 *
			FROM       OrganizationObjectActionAccessProcess
			WHERE      ObjectId = '#ObjectId#' 
			AND        ActionCode = '#ActionCode#'
			AND        UserAccount = '#useraccount#'
			ORDER BY   Created DESC
		</cfquery>	
	
	    <cfif useraccount eq session.acc or getAdministrator("*") eq "1"> 
		
			<tr class="line labelmedium" style="background-color:f4f4f4">
			   <td style="padding-left:4px">#FirstName# #LastName#</td>
			   <td valign="top">
				   <table style="padding:0px">
				   <tr>
				   <td style="padding-left:4px"><input type="radio" class="radiol" name="#userAccount#_Decision" value="0" <cfif Process.decision eq "0" or Process.decision eq "">checked</cfif>></td><td style="padding-top:3px;padding-left:4px"><cf_tl id="N/A"></td>
				   <td style="padding-left:8px"><input type="radio" class="radiol" name="#userAccount#_Decision" value="3" <cfif Process.decision eq "3">checked</cfif>></td><td style="padding-top:3px;padding-left:4px"><cf_tl id="Yes"></td>
				   <td style="padding-left:8px"><input type="radio" class="radiol" name="#userAccount#_Decision" value="9" <cfif Process.decision eq "9">checked</cfif>></td><td style="padding-top:3px;padding-left:4px"><cf_tl id="No"></td>
				   </tr>
				   </table>
			   </td>   
			   <td style="border-left:1px solid silver;border-right:1px solid silver">
			     <input name="#userAccount#_DecisionMemo" style="width:99%;border:0px" class="regularxl" type="text" value="#Process.DecisionMemo#">
			   </td>
			   <td align="center">[save]</td>
			</tr>
			
		<cfelse>
		
			<tr class="line labelmedium navigation_row">
			   <td>#FirstName# #LastName#</td>
			   <td>
			   <cfif Process.decision eq "1"><cf_tl id="Yes"><cfelse><cf_tl id="No"></cfif>		  
			   </td>   
			   <td style="border-left:1px solid silver">#Process.DecisionMemo#</td>
			   <td style="border-left:1px solid silver">#dateformat(Process.Created,'#client.dateformatshow# HH:MM')#</td>
			</tr>		
			
		</cfif>
		
	</cfoutput>

</table>	

<cfset ajaxonload("doHighlight")>

