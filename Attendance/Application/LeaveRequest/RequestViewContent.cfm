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

<cfparam name="URL.SRC" default="SelfService">

<!--- now show request for confirmation or denial --->

<cfquery name="get" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	    SELECT L.*, P.LastName, P.FirstName, P.IndexNo, P.BirthDate
		FROM   PersonLeave L, Person P
        WHERE  L.LeaveId = '#url.id#'
		AND    L.PersonNo = P.Personno
		<!---
		AND    L.TransactionType = 'Request'
		--->
</cfquery>

<cfif get.recordcount eq "0">

	<table align="center"><tr><td height="40" align="center"><b>Attention : </b>Document no longer exists</td></tr></table>
	
<cfelse>


	<table width="96%" border="0" align="center">
	
	<tr><td height="6"></td></tr>
	<tr><td>
	
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
			
		<tr class="labelmedium">
		  <td width="100"><cf_tl id="Staff name">:</td>
		  <td style="font-size:15px" width="85%"><cfoutput>#Get.firstName# #Get.lastName#</cfoutput></td>
		</tr>
		
		<tr class="labelmedium">
		  <td><cf_tl id="IndexNo">:</td>
		  <td style="font-size:15px"><cfoutput>#Get.indexNo#</cfoutput></td>
		</tr>
		
		<tr class="labelmedium">
		  <td><cf_tl id="Birth date">:</td>
		  <td style="font-size:15px"><cfoutput>#dateformat(Get.birthdate,CLIENT.DateFormatShow)#</cfoutput></td>
		</tr>
		
		<cfquery name="Org" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Organization
			WHERE OrgUnit = '#Get.OrgUnit#'
		</cfquery>
		 
		<tr class="labelmedium">
		  <td><cf_tl id="Unit">:</td>
		  <td style="font-size:15px"><cfoutput>#Org.OrgUnitName#</cfoutput></td>
		</tr>
		
		<cfif Get.FirstReviewerUserId neq "">
		
			<cfquery name="Reviewer1" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					SELECT
	
					CASE 
					   WHEN P.FullName IS NULL THEN U.FirstName + ' ' +U.LastName
					   ELSE P.FullName
					   END  ReviewerName
					
					FROM  System.dbo.UserNames U
					LEFT JOIN Employee.dbo.Person P
					ON U.PersonNo = P.PersonNo
					WHERE Account = '#Get.FirstReviewerUserId#'
								
			</cfquery>
			
			<tr class="labelmedium">
			  <td><cf_tl id="Approval">:</td>
			  <td style="font-size:15px">
			  	1: <cfoutput>#Reviewer1.ReviewerName#</cfoutput>
				
				<cfif Get.SecondReviewerUserId neq "">
				
					<cfquery name="Reviewer2" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
							SELECT
			
							CASE 
							   WHEN P.FullName IS NULL THEN U.FirstName + ' ' +U.LastName
							   ELSE P.FullName
							   END  ReviewerName
							
							FROM  System.dbo.UserNames U
							LEFT JOIN Employee.dbo.Person P
							ON U.PersonNo = P.PersonNo
							WHERE Account = '#Get.SecondReviewerUserId#'
										
					</cfquery>
					
					<cfoutput>&nbsp;&nbsp;2: #Reviewer2.ReviewerName#</cfoutput>
				
				</cfif>
				
			  </td>
			</tr>	
		
		</cfif>
		
		<tr class="labelmedium">
		  <td><cfoutput><cfif get.TransactionType eq "Request">Portal<cfelse>#get.TransactionType#</cfif></cfoutput> :</td>
		  <td style="font-size:15px" width="70%"><cfoutput>#get.OfficerLastName# #dateformat(get.created,client.dateformatshow)#:#timeformat(get.created,"HH:MM")#</cfoutput></td>
		</tr>	
				
		<cfquery name="Class" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_LeaveTypeClass 
			WHERE  LeaveType = '#Get.LeaveType#' 		
			AND    Code = '#Get.LeaveTypeClass#'		
		</cfquery>	 	
						
		<cfquery name="Type" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_LeaveType 
			WHERE  LeaveType = '#Get.LeaveType#' 			
		</cfquery>	
				
		<tr class="labelmedium">
		  <td><cf_tl id="Type of leave">:</td>
		  <td style="font-size:15px" width="70%"><cfoutput>#Type.Description# <cfif class.recordcount eq "1" and class.description neq type.description>: #Class.Description#</cfif>
		  
		  <cfif get.GroupCode neq "">
		  
		   <cfquery name="getReason" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT    *
				    FROM     Ref_PersonGroupList
					WHERE    GroupCode     = '#get.groupCode#'
					AND      GroupListCode = '#get.groupListCode#'						
		   </cfquery>
				
		     : <font color="8000FF">#getReason.Description#
		  
		  </cfif>
		  
		  </cfoutput></td>
		</tr>				
			
		<cfif get.Status eq "9">		
			<tr class="labelmedium">
			  <td><cf_tl id="Status">:</td>
			  <td style="font-size:15px"><font color="FF0000"><cf_tl id="Cancelled"></font></td>
			</tr>
		</cfif>
			
		<tr class="labelmedium">
		  <td><cf_tl id="Period">:</td>
		  <td>
		  <table cellspacing="0" cellpadding="0">
		  <tr class="labelmedium"><td style="font-size:15px">
		  <cfoutput>#DateFormat(Get.DateEffective,CLIENT.DateFormatShow)#</cfoutput>
		  <cfif Get.DateEffectiveFull eq "1"><cfelse>[Half <cfif get.DateEffectiveHour eq "6">/ AM<cfelse>/ PM</cfif>]</cfif>
		  </td>
		  
		  <cfif get.DateExpiration neq get.DateEffective>
			  <td style="padding-left:4px;padding-right:4px" align="center">-</td>
			  <td style="font-size:15px"><cfoutput>#DateFormat(Get.DateExpiration,CLIENT.DateFormatShow)#</cfoutput>
			  <cfif Get.DateExpirationFull eq "1"><cfelse>[Half] </cfif>
			  </td>
		  </cfif>
		  </tr>
		  </table>
		  </td>
		</tr>
			
		<tr class="labelmedium">
		  <td><cf_tl id="Days"> <cfif Get.DaysDeduct gt "0"><font color="FF0000">(<cf_tl id="deduct">)</font></cfif>&nbsp;:</td>
		  <td style="font-size:17px"><cfoutput>#numberFormat(Get.DaysLeave,"__._")# <font color="FF0000"><cfif Get.DaysDeduct gt "0">(#numberFormat(Get.DaysDeduct,"_._")#)</cfif></cfoutput></td>
		</tr>		
			
		<cfif get.memo neq "">
			<tr class="labelmedium">
			  <td><cf_tl id="Memo">:</td>
			  <td style="font-size:15px"><cfoutput>#Get.Memo#</cfoutput></td>
			</tr>
		</cfif>
				
		<tr><td height="1" colspan="2" class="line"></td></tr>
		
		<tr><td height="6" class="header"></td></tr>
		
		<tr><td colspan="2">
		
		     <!--- pending ajax embedding --->
		
			 <cfset link = "Attendance/Application/LeaveRequest/RequestView.cfm?id=#Get.LeaveId#">
			 
			 <cfif get.Status eq "9">
				 <cfset hd = "Yes">
			 <cfelse>
				 <cfset hd = "No"> 
			 </cfif>	
			 
							
			<cf_ActionListing 
			    TableWidth       = "100%"
			    EntityCode       = "EntLVE"
				EntityClass      = "Standard"
				EntityGroup      = "#Get.LeaveType#"
				EntityStatus     = ""
				HideProcess      = "#hd#"
				CompleteFirst    = "Yes"
				PersonNo         = "#Get.PersonNo#"
				OrgUnit          = "#Get.OrgUnit#"
				ObjectReference  = "#Type.Description# #dateFormat(get.DateEffective,client.dateformatshow)# - #dateformat(get.DateExpiration,client.dateformatshow)#"
				ObjectReference2 = "#Get.firstName# #Get.lastName#"			
				ObjectKey1		 = "#Get.PersonNo#"
				ObjectKey4       = "#Get.LeaveId#"
			  	ObjectURL        = "#link#"
				ObjectDue        = "#dateFormat(get.DateEffective,client.dateSQL)#"
				DocumentStatus   = "0">
			
		</td></tr>
		
		</table>
	
	</td></tr>
	
	</table>
	
</cfif>
