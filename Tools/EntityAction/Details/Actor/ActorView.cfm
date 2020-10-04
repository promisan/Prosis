
<!--- actors we obtain the enabled fly-actors for this action and allow them to record inputs (descision and comment --->

<cfquery name="Object" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT      *
	FROM        OrganizationObject
	WHERE       ObjectId   = '#ObjectId#' 	
</cfquery>

<cfquery name="Actor" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT      UserAccount, AccessLevel, FirstName, LastName
	FROM        OrganizationObjectActionAccess A INNER JOIN System.dbo.UserNames U ON A.UserAccount = U.Account
	WHERE       ObjectId   = '#ObjectId#' 
	AND         ActionCode = '#ActionCode#'
</cfquery>

<form method="post" name="actorform" id="actorform">

<table style="width:100%" class="navigation_table">

	<tr><td style="height:1px"></td></tr>
	
	<tr><td id="process"></td></tr>
	
	<tr class="line labelmedium">
	   <td style="min-width:250px"><cf_tl id="Officer"></td>
	   <td style="min-width:160px"><cf_tl id="Decision"></td>
	   <td style="width:100%"><cf_tl id="Memo"></td>
	   <td style="min-width:90px"><cf_tl id="Stamp"></td>
	</tr>

	<cfoutput query="Actor">
	
		<!--- get the last input for this user --->
		
		<cfquery name="Process" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
			SELECT     TOP 1 *
			FROM       OrganizationObjectActionAccessProcess
			WHERE      ObjectId     = '#ObjectId#' 
			AND        ActionCode   = '#ActionCode#'
			AND        UserAccount  = '#useraccount#'
			ORDER BY   Created DESC
		</cfquery>	
	
	    <cfif (useraccount eq session.acc and process.recordcount eq "0" or process.decision eq "") or getAdministrator("#Object.Mission#") eq "9"> 
		
			<tr class="line labelmedium">
			   <td style="padding-left:9px;background-color:f4f4f4;padding-right:5px">#FirstName# #LastName#</td>
			   <td valign="top" style="padding-top:1px">
				   <table>
				   <tr>
				   <td style="padding-left:4px"><input type="radio" class="radiol" name="#userAccount#_Decision" value="0" <cfif Process.decision eq "0" or Process.decision eq "">checked</cfif>></td><td style="padding-top:3px;padding-left:4px"><cf_tl id="N/A"></td>
				   <td style="padding-left:8px"><input type="radio" class="radiol" name="#userAccount#_Decision" value="3" <cfif Process.decision eq "3">checked</cfif>></td><td style="padding-top:3px;padding-left:4px"><cf_tl id="Yes"></td>
				   <td style="padding-left:8px"><input type="radio" class="radiol" name="#userAccount#_Decision" value="9" <cfif Process.decision eq "9">checked</cfif>></td><td style="padding-top:3px;padding-left:4px"><cf_tl id="No"></td>
				   </tr>
				   </table>
			   </td>   
			   <td style="border-left:1px solid silver;border-right:1px solid silver">
			     <input name="#userAccount#_DecisionMemo" style="background-color:ffffcf;width:99%;border:0px" class="regularxl" type="text" value="#Process.DecisionMemo#">
			   </td>
			   <td align="center" style="padding-left:4px;padding-right:4px">
			   <cf_tl id="Submit" var="1">
			   <input type="button" value="#lt_text#" style="width:100%"
			    onclick="Prosis.busy('yes');ptoken.navigate('#session.root#/Tools/EntityAction/Details/Actor/ActorViewSubmit.cfm?objectid=#objectid#&actionCode=#actionCode#&useraccount=#useraccount#','process','','','POST','actorform')">
				</td>
			</tr>
			
		<cfelse>
		
			<tr class="line labelmedium navigation_row">
			   <td style="padding-left:4px">#FirstName# #LastName#</td>
			   <td style="border-left:1px solid silver;padding-left:5px">
			    <cfif Process.decision eq "0">--<cfelseif Process.decision eq "">--<cfelseif Process.decision eq "3"><cf_tl id="Yes"><cfelse><cf_tl id="No"></cfif>		  
			   </td>   
			   <td style="border-left:1px solid silver;padding-left:5px">#Process.DecisionMemo#</td>
			   <td style="border-left:1px solid silver;padding-left:4px;min-width:150px">#dateformat(Process.Created,'#client.dateformatshow# HH:MM:SS')#</td>
			</tr>		
			
		</cfif>
		
	</cfoutput>

</table>	

</form>

<cfset ajaxonload("doHighlight")>

