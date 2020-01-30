<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cfparam name="url.action" default="">

<cfif url.action eq "delete">

	<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM PurchaseActor
	  WHERE Purchaseno = '#url.id1#'	 		
	  AND   ActorUserId = '#URL.Account#'	   
	</cfquery>

<cfelseif url.action eq "Insert">

	<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM PurchaseActor
	  WHERE Purchaseno = '#url.id1#'	 		
	  AND   ActorUserId = '#URL.Account#'	   
	</cfquery>
	
	<cfquery name="get" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   UserNames 
	   WHERE  Account = '#url.account#'	   
	</cfquery>	
	
	<cfquery name="Insert" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO PurchaseActor
		    (ActorUserId,
			 PurchaseNo,	
			 Role,	
			 ActorLastName,
			 ActorFirstName,	
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
		VALUES
		  ('#URL.Account#',
		    '#url.id1#',	
			'ProcBuyer',	
			'#get.LastName#',
			'#get.FirstName#',	
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#') 
	</cfquery>
			
</cfif>	

<cfoutput>

	<cfquery name="Actor" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT  * 
	 FROM    PurchaseActor P, Organization.dbo.Ref_AuthorizationRole S
	 WHERE   PurchaseNo = '#URL.ID1#'
	 AND     S.Role = P.Role
	</cfquery>
						
		<table width="98%"  align="right" cellspacing="0" cellpadding="0">
		
		<cfif getAdministrator("*") eq "1" or ApprovalAccess eq "EDIT" or ApprovalAccess eq "ALL">
								
			<cfset link = "#SESSION.root#/Procurement/Application/PurchaseOrder/Purchase/POViewActor.cfm?id1=#URL.ID1#">
				
			<tr><td height="25" colspan="2" align="left" class="labelmedium" style="padding-left:4px"><u>
			
			   <cf_selectlookup
			    class    = "User"
			    box      = "actor"
				title    = "Add buyer"
				link     = "#link#"							
				des1     = "Account">
						
			</td>
			</tr> 					
		
		</cfif>
		<tr>
		  <td height="20" width="7"></td>
		  <td class="labelit"><cf_tl id="Role"></td>
		  <td class="labelit"><cf_tl id="Date"></td>
		  <td class="labelit"><cf_tl id="Officer"></td>
		  <td class="labelit"><cf_tl id="Granted by"></td>
		</tr>
		<tr><td height="1" colspan="5" class="line"></td></tr> 		
		<cfloop query="Actor">
		<tr>
		  <td height="20"></td>
		  <td class="labelit">#Actor.Description#</td>
		  <td class="labelit">#dateformat(Created,CLIENT.DateFormatShow)#</td>
		  <td class="labelit">#Actor.ActorFirstName# #Actor.ActorLastName#</td>
		  <td class="labelit">#Actor.OfficerFirstName# #Actor.OfficerLastName#</td>
		  <td><cf_img icon="delete" 
		      onclick="ColdFusion.navigate('#SESSION.root#/Procurement/Application/PurchaseOrder/Purchase/POViewActor.cfm?action=delete&id1=#URL.ID1#&account=#actor.ActorUserId#','actor')">
		  </td>
		</tr>
		<cfif currentRow neq recordcount>
		<tr><td height="1" colspan="5" class="line"></td></tr> 
		</cfif>
		</cfloop>
		</table>
	
</cfoutput>	