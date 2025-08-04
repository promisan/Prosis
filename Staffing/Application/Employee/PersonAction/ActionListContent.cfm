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

<cfparam name="url.header"    default="0">
<cfparam name="url.mandateno" default="">
<cfparam name="url.id1"       default="">
<cfparam name="url.init"      default="1">
<cfparam name="url.Mode"      default="Person">

<cfif url.header eq "1">	
	<cf_screentop jquery="yes" html="yes" layout="webapp">	
</cfif>	

<!--- generate the listing for the presentation --->

<cf_verifyOperational       
         module    = "Payroll" 
		 Warning   = "No">
		 
<cfif url.init eq "1">
			 
	<cfset FileNo = round(Rand()*100)>		 
			 
	<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#StaffingLog">	 


	<cfsavecontent variable="queryselect">
	
		 <cfoutput>
		 			
				<cfif url.mode neq "Person">		
					P.PersonNo,
					P.LastName,
					P.FirstName,
					P.LastName+', '+P.FirstName as Name,
					P.IndexNo,			
				</cfif>
				
		        A.ActionDocumentNo,
		        A.ActionSource, 
		        A.ActionDate, 
				A.ActionExpiration,
				A.Mission, 
				A.Created,
								 
				(CASE A.ActionStatus WHEN '1' 
				   THEN 'Active' 
				   ELSE (CASE A.ActionStatus WHEN '0' THEN 'Pending' ELSE 'Revoked' END) END) as ActionStatus,
								
				<!--- obtaining reasons --->
				
				
				CASE A.ActionSource
				
				 WHEN 'Contract'    THEN (SELECT   R.Description
									      FROM     PersonContract PC INNER JOIN Ref_PersonGroupList R ON PC.GroupCode = R.GroupCode AND PC.GroupListCode = R.GroupListCode
									      WHERE    A.ActionSourceId = PC.ContractId										 
									      AND      PC.PersonNo      = <cfif url.mode eq "person">'#url.id#'<cfelse>A.ActionPersonNo</cfif>)
										
				 WHEN 'Dependent'   THEN (SELECT   R.Description
									      FROM     PersonDependent PD INNER JOIN Ref_PersonGroupList R ON PD.GroupCode = R.GroupCode AND PD.GroupListCode = R.GroupListCode
									      WHERE    A.ActionSourceId = PD.DependentId										  
									      AND      PD.PersonNo      = <cfif url.mode eq "person">'#url.id#'<cfelse>A.ActionPersonNo</cfif>)	
										
				 ELSE ''
				END as ActionReason,													
								
				<!--- processing status from workflow --->	
				
				CASE A.ActionStatus WHEN 9 THEN '' ELSE (
				
				CASE (
	
				CASE A.ActionSource
				
					WHEN 'Assignment' THEN 
					
					(SELECT    count(*)
					 FROM      Organization.dbo.OrganizationObject OO INNER JOIN
		                       Organization.dbo.OrganizationObjectAction OA ON OO.ObjectId = OA.ObjectId
					 WHERE     OO.ObjectkeyValue1 = A.ActionSourceNo
					 AND       OO.EntityCode = 'Assignment'
					 AND       OO.Operational = 1
					 AND       OA.ActionStatus = '0') 	
					
					ELSE
					
					(SELECT    count(*)
					 FROM      Organization.dbo.OrganizationObject OO INNER JOIN
		                       Organization.dbo.OrganizationObjectAction OA ON OO.ObjectId = OA.ObjectId
					 WHERE     OO.ObjectkeyValue4 = A.ActionSourceId
					 AND       OO.Operational = 1
					 AND       OA.ActionStatus = '0') 
					 
					 END ) WHEN 0 THEN 'Completed' ELSE 'In Process' END ) END as Workflow,
					 
				
				CASE A.ActionSource
				
					WHEN 'Assignment' THEN 
					
					(SELECT    MAX(OfficerDate) as DateProcessed
					 FROM      Organization.dbo.OrganizationObject OO INNER JOIN
		                       Organization.dbo.OrganizationObjectAction OA ON OO.ObjectId = OA.ObjectId
					 WHERE     OO.ObjectkeyValue1 = A.ActionSourceNo
					 AND       OO.EntityCode = 'Assignment'
					 AND       OO.Operational = 1) 	
					
					ELSE
					
					(SELECT    MAX(OfficerDate) as DateProcessed
					 FROM      Organization.dbo.OrganizationObject OO INNER JOIN
		                       Organization.dbo.OrganizationObjectAction OA ON OO.ObjectId = OA.ObjectId
					 WHERE     OO.ObjectkeyValue4 = A.ActionSourceId
					 AND       OO.Operational = 1) 
					 
					 END  as LastProcessed,
										
				R.ActionCode, 
				R.ActionCode + ' ' + R.Description as ActionDescription,
				R.ActionCode + ' ' + R.Description+ 
				
				ISNULL(
				
				
					 CASE   A.ActionSource
					
					 WHEN 'Contract'   THEN ': ' + (SELECT   R.Description
										      FROM     PersonContract PC INNER JOIN Ref_PersonGroupList R ON PC.GroupCode = R.GroupCode AND PC.GroupListCode = R.GroupListCode
										      WHERE    A.ActionSourceId = PC.ContractId										 
										      AND      PC.PersonNo      = <cfif url.mode eq "person">'#url.id#'<cfelse>A.ActionPersonNo</cfif>)
											
					 WHEN 'Dependent'   THEN ': ' + (SELECT   R.Description
										      FROM     PersonDependent PD INNER JOIN Ref_PersonGroupList R ON PD.GroupCode = R.GroupCode AND PD.GroupListCode = R.GroupListCode
										      WHERE    A.ActionSourceId = PD.DependentId										  
										      AND      PD.PersonNo      = <cfif url.mode eq "person">'#url.id#'<cfelse>A.ActionPersonNo</cfif>)	
											  
					 WHEN 'Entitlement' THEN ': ' + (SELECT  TOP 1   R.PayrollItemName
											  FROM     Payroll.dbo.PersonEntitlement AS PE INNER JOIN
											           Payroll.dbo.Ref_PayrollItem AS R ON PE.PayrollItem = R.PayrollItem
											  WHERE    A.ActionSourceId = PE.EntitlementId				   
											  AND      PE.PersonNo = <cfif url.mode eq "person">'#url.id#'<cfelse>A.ActionPersonNo</cfif>)							  
										
					 ELSE ''
					 END ,'') as PersonnelAction,
				
				A.OfficerUserId, 
					(SELECT U.LastName+', '+U.FirstName
					 FROM   System.dbo.UserNames U
					 WHERE  Account = A.OfficerUserId) as Officer,
					 
				UPPER(A.OfficerLastName) as OfficerLastName, 
				A.OfficerFirstName
				
		</cfoutput>		
	
	</cfsavecontent>
	
	<cftransaction isolation="read_uncommitted">
	
	<cfif url.mode eq "Person">		
	
		<cfquery name="getDate" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		 SELECT #preserveSingleQuotes(queryselect)#	
	    
		 INTO   userQuery.dbo.tmp#SESSION.acc#StaffingLog
						
		    FROM    EmployeeAction A INNER JOIN
		            Ref_Action R ON A.ActionCode = R.ActionCode			
					
			WHERE   A.ActionStatus IN ('0','1','9')							
			AND     A.ActionPersonNo = '#url.id#' 
			
			UNION
			
			SELECT #preserveSingleQuotes(queryselect)#	
			FROM    EmployeeAction A INNER JOIN
		            Ref_Action R ON A.ActionCode = R.ActionCode		
			
			WHERE   A.ActionStatus IN ('0','1','9')							
			AND     A.ActionDocumentNo IN (SELECT ActionDocumentNo 
			                               FROM   EmployeeActionSource 
										   WHERE  ActionDocumentNo = A.ActionDocumentNo
										   AND    PersonNo = '#url.id#')	
										   
		</cfquery>								   
				
	<cfelse>
			
		<cfquery name="getDate" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		 SELECT  #preserveSingleQuotes(queryselect)#	
	   
		 INTO    userQuery.dbo.tmp#SESSION.acc#StaffingLog
						
		 FROM    Person P 
			     INNER JOIN EmployeeAction A ON P.PersonNo = A.ActionPersonNo
			     INNER JOIN Ref_Action R ON A.ActionCode = R.ActionCode			
					
		 WHERE   A.ActionStatus IN ('0','1')  <!--- 9 was removed for this purpose of overview --->
			   
			<cfif url.mode eq "assignment">							 			   
				AND     A.ActionSource = 'Assignment'
				AND     A.Mission      = '#URL.Mission#'
				AND     A.MandateNo    = '#URL.MandateNo#'
				
			<cfelse>
			
				AND     A.ActionSource != 'Assignment'
				<!--- exclude person actions --->
				AND     A.ActionCode >= '2000'
				
				AND     A.ActionPersonNo IN (
			                             SELECT PersonNo 
			                             FROM   PersonAssignment
										 WHERE  PositionNo IN (SELECT PositionNo 
										                       FROM   Position 
															   WHERE  Mission   = '#URL.Mission#' 
															   <cfif url.mandateNo neq "">
															   AND    MandateNo = '#URL.MandateNo#'
															   </cfif>) 	 
										 AND    AssignmentStatus IN ('0','1')
										 )		
			</cfif>
			
			<cfif url.id1 neq "">
			AND A.ActionSource = '#url.id1#'
			</cfif>
								
		</cfquery>	
		
	</cfif>
	
	</cftransaction>
	
	<!---
		
<cfcatch>

	<table width="100%" height="100%">
	<tr><td class="linedotted"></td></tr>
	<tr><td class="labelmedium" align="center" valign="top" style="padding-left:20px">
			<font color="0080C0">Information could not be retrieved from the database at this moment, please wait and make your selection again. <br>If this problem persists inform your administrator
	</td></tr>
	<tr><td class="linedotted"></td></tr>
	</table>
	<cfabort>

</cfcatch>

</cftry>

--->

</cfif>

<cfoutput>
<cfsavecontent variable="myquery">
   SELECT *, LastProcessed, ActionDate, Created 
   FROM   tmp#SESSION.acc#StaffingLog R
</cfsavecontent>
</cfoutput>

<table width="100%" height="100%">
		
   <tr>

   <td colspan="1" height="100%" valign="top" style="<cfif url.init eq '1'>padding:10px</cfif>">
	
	<cfif url.mode eq "Person">	
		<cfinclude template="ActionListContentPerson.cfm">		
	<cfelse>		
		<cfinclude template="ActionListContentMandate.cfm">			
	</cfif>
	
	</td>
	
	</tr>
	
</table>	
