<!--
    Copyright © 2025 Promisan B.V.

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
<cf_screentop height="100%" jquery="Yes"  scroll="Yes" html="No">		

<cfparam name="Form.MandateParent" default="">

<cfoutput>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<cfset STR2 = DateAdd("d","-1",STR)>

<!--- old effective date --->
<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffectiveOld#">
<cfset STR1 = dateValue>
<!--- ------------------- --->

<!--- -- new enddate---- --->
<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateExpiration#">
<cfset END = dateValue>
<!--- ------------------ --->

<!--- old enddate --->
<cfif Form.DateExpirationOld eq "">
   <cfset END1 = END>
<cfelse>
   <cfset dateValue = "">
   <CF_DateConvert Value="#Form.DateExpirationOld#">
   <cfset END1 = dateValue>
</cfif>

<cfif END lte STR>
  
  <script language="JavaScript">
    alert("You have entered an incorrect period. Operation not allowed.")
    history.back()
	history.back()
  </script>
  <cfabort>

</cfif>

<cfparam name="Form.MandateDefault" default="0">

</cfoutput>

<cfif ParameterExists(Form.Update)>
	
	<cftransaction>

	<cfif Form.MandateDefault eq "1">
	
		<cfquery name="Mandate" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Organization.dbo.Ref_Mandate
		WHERE  Mission = '#Form.Mission#'
		</cfquery>
		
		<cfloop query="Mandate">
		
			<cfquery name="EditMandate" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE  Organization.dbo.Ref_Mandate
			  SET   MandateDefault = 0
			  WHERE Mission = '#Form.Mission#'
			  AND   MandateNo = '#MandateNo#'
			</cfquery>
		
		</cfloop>
	
	</cfif>

	<cfquery name="Update" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE  Organization.dbo.Ref_Mandate
	SET 	Description    = '#Form.Description#',
	    	DateEffective  = #STR#,
			MandateDefault = '#Form.MandateDefault#',
			DateExpiration = #END#,
			MandateStatus  = '#Form.MandateStatus#'
	WHERE 	Mission        = '#Form.Mission#'
	AND  	MandateNo      = '#Form.MandateNo#'
	</cfquery>

	<cfquery name="Snapshot" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Organization.dbo.Ref_MandateView
		WHERE Mission    = '#Form.Mission#'
		AND   MandateNo  = '#Form.MandateNo#'
	</cfquery>

	<cfloop index="itm" from="1" to="20" step="1">
	
	    <CFIF Evaluate("FORM.snapshotDate" & #itm#) NEQ "">
	    
		<cfset dte = Evaluate("FORM.snapshotDate" & #itm#)>
	    <cfset dateValue = "">
		<CF_DateConvert Value= "#dte#">
		<cfset sde = dateValue>
	   
	   	<cfset slb = Evaluate("FORM.snapshotLabel" & #itm#)>
		<cfif slb eq "">
			<cfset slb = Evaluate("FORM.snapshotDate" & #itm#)>
		</cfif>
		
			<cfquery name="Snapshot" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Organization.dbo.Ref_MandateView
			(Mission, MandateNo, SnapshotOrder, SnapshotDate, SnapshotLabel)
			VALUES ('#Form.Mission#', '#Form.MandateNo#', #itm#, #sde#, '#slb#')
			</cfquery>
			
		</CFIF>	
		
	</cfloop>

	<!--- what if dates have changed --->

	<cfif STR neq STR1>
	
		<!--- if position date before new mandate date, please adjust--->
		
		<cfquery name="UpdatePar" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE PositionParent
			SET    DateEffective = #STR#
			WHERE  Mission    = '#Form.Mission#'
			AND    MandateNo  = '#Form.MandateNo#'
			AND   (DateEffective < #STR# OR DateEffective = #STR1#)
		</cfquery>
		
		<cfquery name="UpdatePos" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Position
		SET    DateEffective = #STR#
		WHERE  Mission      = '#Form.Mission#'
		AND    MandateNo    = '#Form.MandateNo#'
		AND    (DateEffective < #STR# or DateEffective = #STR1#)
		</cfquery>
						
		<cfquery name="UpdateAss" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE PersonAssignment
			SET    DateEffective = #STR#
			FROM   PersonAssignment INNER JOIN Position ON 
			       PersonAssignment.PositionNo =  Position.PositionNo  
			WHERE  Mission    = '#Form.Mission#'
			AND    MandateNo  = '#Form.MandateNo#'
			AND   (PersonAssignment.DateEffective < #STR# OR PersonAssignment.DateEffective = #STR1#)
		</cfquery>
		
	</cfif>
	
	<cfparam name="form.positionAdjust"  default="0">
	<cfparam name="form.assignmentAdjust" default="0">

	<cfif END neq END1>
	
		<!--- if position or assignment date lies after new mandate date, please adjust--->
		
		<cfif END gt END1>
		
			<cfquery name="Update" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE PositionParent
				SET    DateExpiration = #END#
				WHERE  Mission        = '#Form.Mission#'
				AND    MandateNo      = '#Form.MandateNo#'
				AND    (DateExpiration > #END# OR DateExpiration = #END1#)
			</cfquery>
			
			<cfif form.positionAdjust eq "1">
			
				<cfquery name="Update" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE Position
					SET    DateExpiration = #END#
					WHERE  Mission        = '#Form.Mission#'
					AND    MandateNo      = '#Form.MandateNo#'
					AND   (DateExpiration > #END# OR DateExpiration = #END1#)
				</cfquery>		
			
			</cfif>
			
			<cfif form.positionAdjust eq "1" and Form.AssignmentAdjust eq "1">
			
				<cfquery name="UpdateAss" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE PersonAssignment
					SET    DateExpiration = #END#
					WHERE  PositionNo IN (SELECT PositionNo 
					                      FROM   Position 
										  WHERE  Mission   = '#Form.Mission#' 
										  AND    MandateNo   = '#Form.MandateNo#')
					AND   (PersonAssignment.DateExpiration > #END# OR PersonAssignment.DateExpiration = #END1#)
				</cfquery>
						
			</cfif>
		
		<cfelse>
		
			<cfquery name="Update" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE PositionParent
				SET    DateExpiration = #END#
				WHERE  Mission        = '#Form.Mission#'
				AND    MandateNo      = '#Form.MandateNo#'
				AND    (DateExpiration > #END# OR DateExpiration = #END1#)
			</cfquery>
		
			<cfquery name="Update" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Position
				SET    DateExpiration = #END#
				WHERE  Mission        = '#Form.Mission#'
				AND    MandateNo      = '#Form.MandateNo#'
				AND   (DateExpiration > #END# OR DateExpiration = #END1#)
			</cfquery>		
		
			<cfquery name="UpdateAss" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE PersonAssignment
				SET    DateExpiration = #END#
				WHERE  PositionNo IN (SELECT PositionNo 
				                      FROM   Position 
									  WHERE  Mission   = '#Form.Mission#' 
									  AND    MandateNo   = '#Form.MandateNo#')
				AND   (PersonAssignment.DateExpiration > #END# OR PersonAssignment.DateExpiration = #END1#)
			</cfquery>
		
		<!--- remove positions which start lies after the enddate --->
		
		</cfif>
		
		<cfquery name="Remove" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE PositionParent
			WHERE  Mission    = '#Form.Mission#'
			AND    MandateNo  = '#Form.MandateNo#'
			AND    DateEffective > #END#
		</cfquery>
		
	</cfif>
		
	<cfif STR neq STR1>
		
		<!--- remove positions which start lies after the enddate --->
		
		<cfquery name="Remove" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE PositionParent
			WHERE  Mission       = '#Form.Mission#'
			AND    MandateNo     = '#Form.MandateNo#'
			AND    DateExpiration < #STR#
		</cfquery>
			
	</cfif>	

</cftransaction>	

</cfif>	

<cfif ParameterExists(Form.Delete)>

	<cfif Form.MandateStatus eq "1"> 
	
		<cfquery name="CountRec" 
	      datasource="AppsEmployee" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT *
	      FROM Position
	      WHERE Mission    = '#Form.Mission#'
	      AND   MandateNo  = '#Form.MandateNo#'
	    </cfquery>
	
	    <cfif CountRec.recordCount gt 0>
			 
	     <script language="JavaScript">
	    
		   alert("Mandate period is in use. Operation aborted.")
	     
	     </script>  
		 
	    <cfelse>
		
		    <cftransaction>
		
				<cfquery name="Delete" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE 
				FROM   Employee.dbo.PersonExtension
				WHERE  Mission    = '#Form.Mission#'
				  AND  MandateNo  = '#Form.MandateNo#'
			    </cfquery>
								
				<cfquery name="DeleteObject" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM OrganizationObject
				WHERE OrgUnit IN (SELECT Orgunit 
				                  FROM   Organization
								  WHERE  Mission    = '#Form.Mission#'
			            	      AND    MandateNo  = '#Form.MandateNo#')
			    </cfquery>
				
				<cfquery name="Delete" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM Organization
				WHERE  Mission    = '#Form.Mission#'
				  AND  MandateNo  = '#Form.MandateNo#'
			    </cfquery>
				
				<cfquery name="DeleteAction" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM Employee.dbo.EmployeeAction
				WHERE  Mission    = '#Form.Mission#'
				  AND  MandateNo  = '#Form.MandateNo#'
			    </cfquery>
				
				<cfquery name="DeleteSchedules" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM Employee.dbo.WorkSchedule
				WHERE  Mission    = '#Form.Mission#'
				  AND  MandateNo  = '#Form.MandateNo#'
			    </cfquery>
				
				<cfquery name="DeletePosition" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM Employee.dbo.Position
				WHERE  Mission    = '#Form.Mission#'
				  AND  MandateNo  = '#Form.MandateNo#'
			    </cfquery>
						
				<cfquery name="DeletePositionParent" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM Employee.dbo.PositionParent
				WHERE  Mission    = '#Form.Mission#'
				  AND  MandateNo  = '#Form.MandateNo#'
			    </cfquery>
				
				<cfquery name="DeleteContract" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM Employee.dbo.PersonContract
				WHERE  Mission    = '#Form.Mission#'
				  AND  MandateNo  = '#Form.MandateNo#'
			    </cfquery>		
				
				<cfquery name="DeleteUnits" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM Organization
				WHERE  Mission    = '#Form.Mission#'
				  AND  MandateNo  = '#Form.MandateNo#'
			    </cfquery>
				
				<cfquery name="DeleteMandate" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM Ref_mandate
				WHERE  Mission    = '#Form.Mission#'
				  AND  MandateNo  = '#Form.MandateNo#'
			    </cfquery>
				
				<!--- ------------------------------------  important --------------------------------------------- --->
				<!--- the last one will trigger the removal of PositionParent through the DB trigger DeletePosition --->
				<!--- --------------------------------------------------------------------------------------------- --->
		
		    </cftransaction>
		
		</cfif>
		
	<cfelse>	
	
		<cftransaction>
						
			<cfquery name="DeleteObject" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM OrganizationObject
			WHERE OrgUnit IN (SELECT Orgunit 
			                  FROM   Organization
			                  WHERE  Mission    = '#Form.Mission#'
		            	      AND    MandateNo  = '#Form.MandateNo#')
		    </cfquery>
			
			<cfquery name="DeletePosition" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Employee.dbo.Position
			WHERE  Mission    = '#Form.Mission#'
			  AND  MandateNo  = '#Form.MandateNo#'
		    </cfquery>
					
			<cfquery name="DeletePositionParent" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Employee.dbo.PositionParent
			WHERE  Mission    = '#Form.Mission#'
			  AND  MandateNo  = '#Form.MandateNo#'
		    </cfquery>
			
			<cfquery name="DeleteAction" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Employee.dbo.EmployeeAction
			WHERE  Mission    = '#Form.Mission#'
			  AND  MandateNo  = '#Form.MandateNo#'
		    </cfquery>
			
			<cfquery name="DeleteContract" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Employee.dbo.PersonContract
			WHERE  Mission    = '#Form.Mission#'
			  AND  MandateNo  = '#Form.MandateNo#'
		    </cfquery>		
			
			<cfquery name="DeleteUnits" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Organization
			WHERE  Mission    = '#Form.Mission#'
			  AND  MandateNo  = '#Form.MandateNo#'
		    </cfquery>
				
			<cfquery name="DeleteMandate" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Ref_Mandate
			WHERE  Mission    = '#Form.Mission#'
			AND    MandateNo  = '#Form.MandateNo#'
		    </cfquery>
		
		</cftransaction>	
		
		<!--- trigger will take care of the rest --->
		
		<!--- Annotation by Hanno 3/4/2012
		
		if a contract which was generated by the mandate carry over (Mission/Mandate column in PersonContract) 
		is already in use for the payroll 
		through Payroll.dbo.PersonEntitlement this 	removal will fail and through an error 
		as the trigger will fail --->
			
		
	</cfif>	

</cfif>

<!--- 050622 - Routine for "End-of-Period triggering.  Delete's assignments from future period.  
               Recopies assignments from current period to future period.
               This block is active if user Click Recopy Assignment button in previous page (MandateEdit) 
--->

<cfoutput>
<script language="JavaScript">
     parent.ptoken.navigate('MandateViewTree.cfm?Mission=#form.Mission#&Mandate=#Form.MandateNo#','treebox')
     ptoken.location('MandateListing.cfm?Mission=#Form.Mission#')
</script>  
</cfoutput>
