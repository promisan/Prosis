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

<cfparam name="URL.ActionCode"         default="">
<cfparam name="URL.ObjectId"           default="">
<cfparam name="URL.NotificationGlobal" default="1">
<cfparam name="URL.Text"               default="NOTIFY">

<script language="JavaScript">
	
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
	function hl(itm,fld){
	
	     if (ie){
	          while (itm.tagName!="TR")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TR")
	          {itm=itm.parentNode;}
	     }	 
		 	 		 	
		 if (fld != false){		
			 itm.className = "highLight2 line";
		 }else{		
		     itm.className = "labelmedium2 line";		
		 }
	  }
    
</script>

<cfquery name="Object" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT   DISTINCT O.*, OA.OrgUnit, OA.ActionId, OA.Created
		 FROM     OrganizationObject O, OrganizationObjectAction OA
		 WHERE    O.ObjectId      = '#URL.ObjectId#'
		 AND      O.ObjectId      = OA.ObjectId
		 AND      OA.ActionCode   = '#URL.ActionCode#'
		 AND      O.Operational   = 1    
		 ORDER BY OA.Created DESC
		 
</cfquery>

<cfquery name="Action" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT  *
		 FROM    Ref_EntityActionPublish
		 WHERE   ActionCode      = '#URL.ActionCode#'
		 AND     ActionPublishNo = '#Object.ActionPublishNo#' 		 
</cfquery>

<!--- layout --->

<cfquery name="Layout" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT   D.EntityCode, D.DocumentDescription
			FROM     Ref_EntityActionPublish AS EAP INNER JOIN
	                 Ref_EntityAction AS R ON EAP.ActionCode = R.ActionCode INNER JOIN
	                 Ref_EntityDocument AS D ON R.EntityCode = D.EntityCode AND EAP.DueMailCode = D.DocumentCode
			WHERE    EAP.ActionCode      = '#URL.ActionCode#' 
			AND      EAP.ActionPublishNo = '#Object.ActionPublishNo#' 
			AND      D.DocumentType      = 'mail'
</cfquery>

<cfoutput>

<cfif URL.Text eq "Reminder">
	<cfset vTitle="REMIND actors by eMail">
<cfelse>
	<cfset vTitle="NOTIFY actors by eMail">
</cfif>

<cf_screentop height="100%" label="Notification" layout="webapp" scroll="no" banner="gray" option="#vTitle#">

<form action="ProcessMailDialogSubmit.cfm" target="submit" method="post" style="height:100%">
	
<table width="91%" height="100%" align="center"  class="formpadding">
	
	<cfif Layout.recordcount eq "1">
	
	<tr class="line"><td class="labellarge" style="padding-top:10px;font-size:22px;font-weight:200">#Layout.DocumentDescription#</td></tr>
	
	<cfelse>
	
	<tr class="line"><td class="labellarge" style="padding-top:10px;font-size:22px;font-weight:200">Standard notification</td></tr>	
	
	</cfif>	
		
	<tr><td></td></tr>		
	<tr>
	<td height="25" class="labelmedium" style="padding-left:5px;font-weight:200">
	 Actors defined for step:</font>&nbsp;&nbsp;<b>#Action.ActionDescription#&nbsp;</font>
	</td>
	<td align="right">
	
	</td>
	</tr>
	
	<input type="hidden" name="Text"            id="Text" value="#URL.Text#">
	<input type="hidden" name="ObjectId"        id="ObjectId" value="#Object.ObjectId#">
	<input type="hidden" name="ActionCode"      id="ActionCode" value="#Action.ActionCode#">
	<input type="hidden" name="ActionPublishNo" id="ActionPublishNo" value="#Object.ActionPublishNo#">
	<input type="hidden" name="EntityCode"      id="EntityCode" value="#Object.EntityCode#">	
	<input type="hidden" name="ActionId"        id="ActionId" value="#Object.ActionId#">	
	
	<!--- query potential actors --->

	<cfquery name="Org" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     Organization
	 WHERE    OrgUnit = '#Object.OrgUnit#'
	 </cfquery>
	
	
	<cfquery name="Potential" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 
		 <cfif Action.NotificationGlobal eq "1">
		 		 	 
			 SELECT   A.UserAccount, 
			          A.AccessLevel,  
			          U.*
			 FROM     OrganizationAuthorization A INNER JOIN
					  System.dbo.UserNames U ON A.UserAccount = U.Account  
			 WHERE    A.ClassParameter = '#Action.ActionCode#' 
			 AND      A.GroupParameter = '#Object.EntityGroup#' 
			 AND      A.AccessLevel IN ('0','1')  <!--- '0' = info --->	 
			 AND      U.Disabled = 0
			 
			 <cfif Object.OrgUnit eq "0" or Object.OrgUnit eq "">
			 
			 AND      (A.Mission = '#Object.Mission#' or A.Mission is NULL)
			 
			 <cfelse>
			 AND     (     
			               (A.OrgUnit = '#Object.OrgUnit#')
			            OR (A.OrgUnit is NULL and A.Mission = '#Object.Mission#')
				        OR (A.OrgUnit is NULL and A.Mission is NULL)
					 ) 
			 </cfif>		 
			 AND      U.AccountType = 'Individual'
			   
			 UNION
						 			 		 
		 </cfif>
		 
		 <cfif Action.NotificationFly eq "1">
		 
			 <!--- fly access --->
			 
			 SELECT   A.UserAccount, 
			          '1' as AccessLevel,
			          U.*
			 FROM     OrganizationObjectActionAccess A INNER JOIN
					  System.dbo.UserNames U ON A.UserAccount = U.Account
			 WHERE    A.ObjectId      = '#Object.ObjectId#' 
			 AND      U.Disabled      = 0
			 AND      A.ActionCode    = '#Action.ActionCode#' 
			 AND      A.AccessLevel   >= '0' 
			 	 
			 UNION 
		 
		 </cfif>
		 
		 <!--- if this action was performed by a specific 
		 user before in the same workflow, send the same person a mail --->
		 
		 SELECT   A.OfficerUserId as UserAccount, 
		          '1' as AccessLevel,
		          U.*
	     FROM     OrganizationObjectAction A INNER JOIN
	              System.dbo.UserNames U ON A.OfficerUserId = U.Account
		 WHERE    A.ObjectId      = '#Object.ObjectId#'
		 AND      U.Disabled = 0
		 AND      A.ActionCode    = '#Action.ActionCode#'
		 ORDER BY LastName, FirstName 	
	 	 
	</cfquery>	
	
	<script>
	 
	 function check(val) {
	 
		 var count = 1
		 se = document.getElementsByName("account")
		
		 while (count <= "#Potential.recordcount#") {
		     if (se[count]) {
			 se[count].checked = val
			 row = document.getElementById("d"+count)		 
			 if (row) {
				 if (val == true) {
				 row.className = "highlight1 line"
				 } else {
				 row.className = "labelmedium2 line regular"
				 }
		 		 }		 
			 }
			 count++
		 }
	 	 
	 }
	 	 
	</script>
	 	  
	<tr><td colspan="2" valign="top" style="height:100%">
	
		<cf_divscroll>
		 		    
		 <table width="100%" align="center" class="formpadding">
		 <tr class="labelmedium2 line">
			 <td width="5%">&nbsp;</td>
			 <td><cf_tl id="Name"></td>
			 <td><cf_tl id="Last logon"></td>
			 <td><cf_tl id="Last alert">:</td>
			 <td><cf_tl id="EMail address"></td>
			 <td align="center">
				 <input type="checkbox" name="account" id="account" value="" <cfif potential.recordcount lte "4">checked</cfif> onClick="check(this.checked)">
			 </td>
		 </tr>	 
		 
		 <cfquery name="UpdateAddress" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE  UserNames
				SET     EMailAddress = eMailAddressExternal
				WHERE   (eMailAddress is NULL or eMailAddress = '')
				AND     eMailAddressExternal > ''  
		 </cfquery>
					 
		 <cfif Potential.recordcount eq "0">
		 
			 <tr><td height="5"></td></tr>
	 		 <tr><td colspan="6" class="labelit">
			     <cf_message message="No actors with an eMail adressed were defined for the next step. Please contact your administrator" return="No">		
			 </td></tr>
			 
		 </cfif>
		
		 
		 
		 <cfset row = 0>
		 
		 <cfloop query="Potential">
		 
		 
			 <cfquery name="Notify" 
				 datasource="AppsSystem"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT   *
				 FROM     UserEntitySetting
				 WHERE    Account     = '#Account#'  
				 AND      EntityCode  = '#Object.EntityCode#'
				 
			</cfquery>
			
			<!--- if not record exist we assume the user wants a mail --->
						
			<cfif Notify.EnableMailNotification eq "1" or Notify.recordcount eq "0">
		 
				<cfinvoke component="Service.Access"  
					method         = "AccessEntity" 
					objectid       = "#Object.ObjectId#"
					actioncode     = "#Action.ActionCode#" 
					orgunit        = "#Object.OrgUnit#" 
					mission        = "#Object.Mission#"
					user           = "#Account#"
					entitygroup    = "#Object.EntityGroup#" 
					returnvariable = "entityaccess">					
								  
			    <cfif entityaccess eq "EDIT">
																
					<cfquery name="Last" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT   TOP 1 *
					    FROM     UserStatusLog
					    WHERE    Account = '#Account#'
						ORDER BY Created DESC
					</cfquery>
					
					<cfquery name="LastMail" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					   SELECT *
					   FROM   OrganizationObjectMail
					   WHERE  Account    = '#Account#'
					   AND    ObjectId   = '#Object.ObjectId#'
					   AND    ActionCode = '#Action.ActionCode#'
					   ORDER BY Created DESC
					</cfquery>
			  
				    <cfif Potential.eMailAddress neq "">
					   <cfset row = row+1>
				       <tr class="labelmedium2 highlight1 line" id="d#row#">
					<cfelse>
					   <tr class="labelmedium2 line">
					</cfif>
					<td style="padding-left:7px">#currentRow#</td>
					<td>#Potential.FirstName# #Potential.LastName#</td>
					<td>
						<cfif Last.Created eq ""><font color="FF0000"><b><cf_tl id="Never"></b>
						<cfelse>#DateFormat(Last.Created, CLIENT.DateFormatShow)#
						</cfif>
					</td>
					
					<td style="padding-left:3px">				
						<cfif LastMail.Created neq "">
						<b>#DateFormat(LastMail.Created, CLIENT.DateFormatShow)# at #TimeFormat(LastMail.Created, "HH:MM")# [#lastMail.recordcount#]</b>					
						<cfelse>
						n/a
						</cfif>								
					</td>
					<td>#Potential.emailAddress#</td>
					<td height="25" align="center">
						<cfif Potential.eMailAddress neq "">
					    	<input type="checkbox" name="account" class="radiol" id="account" value="'#Account#'" <cfif potential.recordcount lte "4">checked</cfif> onClick="hl(this,this.checked)">
						<cfelse>
							<cf_tl id="Not available">	
						</cfif>
					</td>
					</tr>
							         			  
			    </cfif>	
				
			</cfif>	
			
		 </cfloop>	
		 
		 </tr>
		 		 	 	 
		 <script language="JavaScript">
		 
			 function exit() {
				   window.close(); 
				//   opener.history.go();
			 }  
		 
		 </script>
		  	 	 			   
		 </table>
		 
		 </cf_divscroll>
	 	 	 
	 </td></tr>
	 
	 <cfif Potential.recordcount gte "1">
	 
	 <tr>
	 	<td height="45" align="center" colspan="2">
		 <input type="button" name="Cancel" id="Cancel" value="Close" class="button10g" onClick="javascript:exit()">
		 <input type="submit" class="button10g" name="Send" id="Send" value="Send Mail">
		 </td>
	 </tr>
	 
	 <cfif getAdministrator("*") eq "1">
	  <tr class="hide">	
		 <td><iframe name="submit" id="submit" width="100%" height="100" scrolling="yes" frameborder="0"></iframe></td>
	 </tr>
	 <cfelse>
	  <tr class="hide">	
		 <td><iframe name="submit" id="submit" width="100%" height="100" scrolling="yes" frameborder="0"></iframe></td>
	 </tr>
	 
	 </cfif>
			
	 </cfif>	 
	  	 
 </table>
 
</form>
 
 <cf_screenbottom layout="webapp">
 
 </cfoutput>
 
