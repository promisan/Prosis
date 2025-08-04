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


<!--- redefine people to be extended --->


<cfif url.extend eq "true">
	
	<cfquery name="Extend" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO PersonExtension
		                 (PersonNo, 
						  Mission, 
						  MandateNo, 
						  OfficerUserId, 
						  OfficerLastName, 
						  OfficerFirstName)
		SELECT    DISTINCT Ass.PersonNo AS personNo, 
		                   M.Mission AS Mission, 
						   M.MandateNo AS MandateNo, 
						   '#SESSION.acc#', 
						   '#SESSION.last#', 
						   '#SESSION.first#'
		FROM      Position Pos INNER JOIN
	              Organization.dbo.Ref_Mandate M ON Pos.Mission = M.Mission AND Pos.MandateNo = M.MandateNo INNER JOIN
	              PersonAssignment Ass ON Pos.PositionNo = Ass.PositionNo AND M.DateExpiration = Ass.DateExpiration
		WHERE     M.Mission   = '#URL.Mission#' 
		AND       M.MandateNo = '#URL.MandateParent#' 
		AND       Ass.PersonNo NOT IN
	                          (SELECT   PersonNo
	                            FROM    PersonExtension
	                            WHERE   Mission   = '#URL.Mission#' 
								AND     MandateNo = '#URL.MandateParent#')
		AND       AssignmentStatus IN ('0','1') 						
	</cfquery>		

</cfif>
  
 <!--- Ensure that this is the new financial period, status=0 --->

 <!--- first clear all assignments in new financial period --->
  
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#PersonExtension">  
 
 <!--- get the new mandate which has to be refreshed --->
  
<cfquery name="Mandate" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Ref_Mandate
	  WHERE  Mission   = '#url.Mission#'
	  AND    MandateNo = '#url.MandateNo#' 	 
</cfquery> 
  
<cfset dateValue = "">
<CF_DateConvert Value="#dateformat(Mandate.DateEffective,CLIENT.DateFormatShow)#">
<cfset STR = dateValue>

<cfset STR1 = DateAdd("d","-1",STR)>

<cfset dateValue = "">
<CF_DateConvert Value="#dateformat(Mandate.DateExpiration,CLIENT.DateFormatShow)#">
<cfset END = dateValue> 
 
<!--- Ensure that this is the new financial period, status=0 --->
 
<cfquery name="Check" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   PersonAssignment
	  WHERE  PositionNo IN  (
	                         SELECT PositionNo 
							 FROM   Position
							 WHERE  Mission   = '#url.Mission#'
							 AND    MandateNo = '#url.MandateNo#' 
							 )
	   AND   AssignmentStatus = '1'					 
</cfquery> 
 
<cfif check.recordcount gte "1">
 
     <cfoutput>
     <script>
	 	alert("Staffing period [#url.MandateNo#] is in use. Operation no longer allowed")
	 </script>
	 </cfoutput>
 
	 <cfabort>
 
</cfif>

<cftransaction>

<cfif url.onlynew eq "false">

	<!--- add only records for people that were not carried over before --->
	 
	<cfquery name="DeleteAssignments" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		  DELETE FROM Employee.dbo.PersonAssignment
		  WHERE PositionNo IN  ( SELECT PositionNo 
								 FROM   Employee.dbo.Position
								 WHERE  Mission   = '#url.Mission#'
								 AND    MandateNo = '#url.MandateNo#' )				 			 
	</cfquery> 

    <!--- remove the contracts that are added in the prior batch  --->
  
   <cfquery name="DeleteEntitlements" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		  DELETE FROM Payroll.dbo.PersonEntitlement
		  WHERE  Contractid IN (	         
						  		  SELECT Contractid	  
						  		  FROM   Employee.dbo.PersonContract
								  WHERE  Mission   = '#url.Mission#'
								  AND    MandateNo = '#url.MandateNo#' )	
	</cfquery> 
  
	<cfquery name="DeleteContracts" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		  DELETE FROM Employee.dbo.PersonContract
		  WHERE  Mission   = '#url.Mission#'
		  AND    MandateNo = '#url.MandateNo#'
	</cfquery> 

</cfif>
 
<!--- copy over the assignments again --->
 
<cfif url.mandateParent neq "">
 
      <cfset man                  = Mandate.MandateNo>
	  <!--- base mandate --->
 	  <cfset form.MissionTemplate = Mandate.MandateParent>
      <cfinclude template="MandateEntryAssignment.cfm"> 
	 	
</cfif>

</cftransaction>
 
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#PersonExtension"> 	

<cfoutput>
	
	<script language="JavaScript">    
	    ptoken.navigate('RecopyAssignmentResult.cfm?mission=#url.Mission#&mandateNo=#url.MandateNo#','boxcopy')	
	    ProsisUI.closeWindow('mydialog',true)	
	</script>

</cfoutput>

 