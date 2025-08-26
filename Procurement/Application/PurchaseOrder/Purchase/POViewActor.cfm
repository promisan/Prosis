<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
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
						
		<table width="98%"  align="right" class="navigation_table">
		
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
		<tr class="fixlengthlist labelmedium2 line">
		  <td height="20" width="7"></td>
		  <td><cf_tl id="Role"></td>
		  <td><cf_tl id="Date"></td>
		  <td><cf_tl id="Officer"></td>
		  <td><cf_tl id="Granted by"></td>
		  <td></td>
		</tr>		
		<cfloop query="Actor">
		<tr class="fixlengthlist labelmedium2 line navigation_row">
		  <td height="20"></td>
		  <td>#Actor.Description#</td>
		  <td>#dateformat(Created,CLIENT.DateFormatShow)#</td>
		  <td>#Actor.ActorFirstName# #Actor.ActorLastName#</td>
		  <td>#Actor.OfficerFirstName# #Actor.OfficerLastName#</td>
		  <td><cf_img icon="delete" 
		      onclick="ptoken.navigate('#SESSION.root#/Procurement/Application/PurchaseOrder/Purchase/POViewActor.cfm?action=delete&id1=#URL.ID1#&account=#actor.ActorUserId#','actor')">
		  </td>
		</tr>
		
		</cfloop>
		</table>
	
</cfoutput>	

<cfset ajaxonload("doHighlight")>
