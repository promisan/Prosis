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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="Form.ParentOrgUnit" default="">
<cfparam name="Form.ParentOrgUnitOld" default="">
<cfparam name="Form.OrganizationCode" default="">
<cfparam name="Form.Terms" default="">

<cfif Form.OrgUnitCode neq Form.OrgUnitCodeOld>

	<cfquery name="Check" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Organization
		 WHERE  Mission   = '#Form.Mission#'
		 AND    MandateNo = '#Form.MandateNo#'
		 AND    OrgUnitCode = '#Form.OrgUnitCode#'
	</cfquery>
	
	<cfoutput>
	
		<cfif Check.recordcount gte "1">
		
		  <script>
		  alert("You have entered a organization code (#Form.OrgUnitCode#) which is already used. Operation not allowed.")
		  </script>	
		  <cfabort>
					
		</cfif>
	
	</cfoutput>
			

</cfif>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<cfset dateValue = "">
<cfif Form.DateExpiration neq ''>
	  <CF_DateConvert Value="#Form.DateExpiration#">
	  <cfset END = #dateValue#>
<cfelse>
	  <cfset END = 'NULL'>
</cfif>	

<cfif Len(Form.Remarks) gt 300>
	  <cfset remarks = left(Form.Remarks,300)>
<cfelse>
	  <cfset remarks = Form.Remarks>
</cfif>  

<cfif ParameterExists(Form.Update)>

		<!--- Remove quotes from Organization Name (can affect tree view)--->
		<cfset OrgName=Replace(Form.OrgUnitName,'"','','ALL')>
		<cfset OrgName=Replace(OrgName,"'","",'ALL')>
		
		<cfset OrgNameShort=Replace(Form.OrgUnitNameShort,'"','','ALL')>
		<cfset OrgNameShort=Replace(OrgNameShort,"'","",'ALL')>
		
		<cfset Parent = Form.ParentOrgUnit>
		
		<cfquery name="Check" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Organization
		WHERE  OrgUnit = '#Form.OrgUnitOld#'
		</cfquery>
		
		<cfif Check.ParentOrgUnit eq ""> <!--- was a root unit --->
		
			<cfquery name="Check2" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Organization
			WHERE  OrgUnitCode = '#Form.ParentOrgUnit#'
			AND    Mission = '#Check.Mission#'
			AND    MandateNo = '#Check.MandateNo#'
			</cfquery>
			
			<cfif Check2.ParentOrgUnit eq "#Check.OrgUnitCode#">
			   <cfset Parent = "reset">
			</cfif> 
		
		</cfif>
		
		<cfif Form.TreeUnit eq "1">
		
			<cfquery name="Update" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 UPDATE Organization
			 SET    TreeUnit = 0
			 WHERE  TreeUnit = 1
			 AND    Mission   = '#Form.Mission#'
			 AND    MandateNo = '#Form.MandateNo#'
			 </cfquery>
			 
		</cfif>	 
		
		<cfif form.NameEffective neq "">
		
			<cfset dateValue = "">
			<CF_DateConvert Value="#Form.NameEffective#">
			<cfset NMD = dateValue>
			<cfset NMD = dateAdd("D","-1",NMD)>
						
			<cfquery name="Clean" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 DELETE   FROM OrganizationName
			 WHERE    OrgUnit = '#Form.OrgUnitOld#'
			 AND      DateExpiration >= #NMD#			 
			 </cfquery>	
			 
			 <cfquery name="language" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT   * 
			 FROM     System.dbo.Ref_SystemLanguage
			 WHERE    SystemDefault = '1'
			 </cfquery>
			 
			 <cfquery name="AddDefault" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 	INSERT INTO OrganizationName
				(OrgUnit,DateExpiration,LanguageCode,OrgUnitName,OrgUnitNameShort,OfficerUserId,OfficerLastName,OfficerFirstName)
				VALUES
				('#Form.OrgUnitOld#', #NMD#, '#language.code#','#check.OrgUnitName#','#check.OrgUnitNameShort#','#session.acc#','#session.last#','#session.first#')			 
			 </cfquery>	
			 
			 <cfquery name="AddOtherLanguage" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 	INSERT INTO OrganizationName
						(OrgUnit,
						 DateExpiration,
						 LanguageCode,
						 OrgUnitName,
						 OrgUnitNameShort,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
				SELECT '#Form.OrgUnitOld#', #NMD#, LanguageCode,OrgUnitName,OrgUnitNameShort,'#session.acc#','#session.last#','#session.first#'
				FROM   Organization_Language
				WHERE  OrgUnit = '#Form.OrgUnitOld#'			 
			 </cfquery>				 		
		
		</cfif>
		   
		<cfquery name="Update" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Organization
		SET     OrgUnitClass          = '#Form.OrgUnitClassEdit#',
				OrgUnitCode           = '#Form.OrgUnitCode#',
				OrgUnitName           = '#OrgName#',
				OrgUnitNameShort      = '#OrgNameShort#',
				Autonomous            = '#Form.Autonomous#',
				DateEffective         = #STR#,				
				DateExpiration        = #END#,
				ParentSupport         = '#Form.ParentSupport#',
				TreeUnit              = '#Form.TreeUnit#',
				TreeOrder             = '#Form.TreeOrder#',		
				WorkSchema            = '#Form.WorkSchema#',
				WorkSchemaEntityClass = '#form.WorkSchemaEntityClass#',		
				<cfif Parent eq "reset">
					     ParentOrgUnit = NULL,
				<cfelse>
					<cfif parent eq "Root">
						 ParentOrgUnit = NULL,
					<cfelse>
					     ParentOrgUnit = '#Form.ParentOrgUnit#',
					</cfif>
				</cfif>
				<cfif Form.ParentOrgUnitOld neq Form.ParentOrgUnit>
				HierarchyCode    = '',
				</cfif>
				SourceCode       = '#Form.SourceCode#',
				<cfif Form.OrganizationCode neq "">
				OrganizationCode = '#Form.OrganizationCode#',
				</cfif>
				<cfif Form.Terms neq "">
				Terms            = '#Form.Terms#',
				</cfif>
				ApplicationServer = '#Form.ApplicationServer#',
				Source           = '#Form.Source#',
				Remarks          = '#remarks#'
		WHERE OrgUnit = '#Form.OrgUnitOld#'
		</cfquery>
		
		<cf_LanguageInput
		TableCode       = "Organization" 
		Key1Value       = "#Form.OrgUnitOld#"
		Mode            = "Save"
		Lines           = "3"
		Name1           = "OrgUnitName"
		Name2           = "OrgUnitNameShort"
		Name3           = "Remarks">
						
		<cfif Form.ParentOrgUnitOld neq Form.ParentOrgUnit>
		
			 <script language="JavaScript">
				    parent.window.close();			
					parent.opener.location.reload();				
					parent.opener.parent.left.location.reload();				    	       
			 </script>	
					
			<cfset URL.Mis = "#Form.Mission#">
			<cfset URL.Man = "#Form.MandateNo#">
			
			<cfinclude template="OrganizationHierarchy.cfm">
			
			<!---<cfset url.mission = "#Form.Mission#">
			<cfset url.mandate = "#Form.MandateNo#">
			<cfset url.OrgUnit = "#Form.OrgUnitOld#">
			<cfset url.ParentOrgUnit = "#Form.ParentOrgUnit#">
			
			<cfinclude template="OrganizationHierarchySingle.cfm">--->
				
		</cfif>
		
		<cfif Form.OrgUnitCode neq Form.OrgUnitCodeOld>
		
			<cfquery name="UpdateChild" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Organization
			SET    ParentOrgUnit   = '#Form.OrgUnitCode#'
			WHERE  ParentOrgUnit   = '#Form.OrgUnitCodeOld#'
			  AND  Mission         = '#Form.Mission#'
			</cfquery>
			
			<!---
			<cf_refresh	tablecode="Organization">
			--->
			
			<!--- mission linkage to higher unit --->
			<cfquery name="UpdateMission" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Ref_Mission
			SET    MissionParentOrgUnit  = '#Form.OrgUnitCode#'
			WHERE  MissionParentOrgUnit  = '#Form.OrgUnitCodeOld#'
			AND    MissionParent = '#Form.Mission#'
			</cfquery>
			
			 <script language="JavaScript">
				    parent.window.close();			
					parent.opener.location.reload();				
					parent.opener.parent.left.location.reload();				    	       
			 </script>	
			
		</cfif>

</cfif>	

<cfif ParameterExists(Form.Delete)> 
		
		<cfset st = "Go">
		
		<!--- write children to a temp table --->
		
		<cfquery name="Mandate" 
		      datasource="AppsOrganization" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
		      SELECT DISTINCT Mission, MandateNo
			  FROM Organization
		      WHERE OrgUnit = '#Form.OrgUnitOld#' 
		</cfquery>
		
		<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#OrgDelete">
		
		<cfquery name="Verify" 
		      datasource="AppsOrganization" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
		      SELECT OrgUnit, OrgUnitCode, OrgUnit as Id
			  INTO userQuery.dbo.tmp#SESSION.acc#OrgDelete
		      FROM Organization
		      WHERE OrgUnit = '#Form.OrgUnitOld#' 
		</cfquery>
		
		<cfloop index="Itm" from="1" to="6">
			
			<cfquery name="Level01" 
			      datasource="AppsOrganization" 
			      username="#SESSION.login#" 
			      password="#SESSION.dbpw#">
			      INSERT INTO UserQuery.dbo.tmp#SESSION.acc#OrgDelete
				   (OrgUnit, OrgUnitCode, Id)
				   SELECT OrgUnit, OrgUnitCode, '0'
			       FROM Organization
			       WHERE ParentOrgUnit IN (SELECT DISTINCT OrgUnitCode FROM UserQuery.dbo.tmp#SESSION.acc#OrgDelete)
				    AND Mission = '#Mandate.Mission#'
				    AND MandateNo = '#Mandate.MandateNo#'
			</cfquery>
		
		</cfloop>

		<!--- checking if deletion can be performed --->

		<cfquery name="Check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_SystemModule
		WHERE  SystemModule = 'Staffing'
		AND    Operational = '1'
		</cfquery>
		
		<cfset er = "">
		
		<cfif Check.recordcount eq "1">
		
		    <cfquery name="Verify" 
		      datasource="AppsEmployee" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
		      SELECT OrgUnitOperational
		      FROM PositionParent
		      WHERE OrgUnitOperational IN (SELECT OrgUnit 
			                               FROM userQuery.dbo.tmp#SESSION.acc#OrgDelete)
		    </cfquery>
			
			<cfif Verify.recordCount gt 0>
			    <cfset er = "#er#-PositionParent-">
			    <cfset st = "Stop">
			</cfif>
				
		</cfif>	
		
		<cfquery name="Check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_SystemModule
		WHERE  SystemModule = 'Program'
		AND    Operational = '1'
		</cfquery>
		
		<cfif Check.recordcount eq "1">
					
		    <cfquery name="Verify" 
		      datasource="AppsProgram" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
		      SELECT OrgUnit
		      FROM ProgramPeriod
		      WHERE OrgUnit IN (SELECT OrgUnit 
			                    FROM userQuery.dbo.tmp#SESSION.acc#OrgDelete)
		    </cfquery>	
			
			<cfif Verify.recordCount gt 0>
			  <cfset er = "#er#-Program-">
			  <cfset st = "Stop">
			</cfif>
			
		</cfif>	
		
		<cfquery name="Check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_SystemModule
		WHERE  SystemModule = 'Procurement'
		AND    Operational = '1'
		</cfquery>
		
		<cfif Check.recordcount eq "1">
					
		    <cfquery name="Verify" 
		      datasource="AppsPurchase" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
		      SELECT OrgUnitVendor
		      FROM Purchase
		      WHERE OrgUnitVendor IN (SELECT OrgUnit 
			                    FROM userQuery.dbo.tmp#SESSION.acc#OrgDelete)
		    </cfquery>	
			
			<cfif Verify.recordCount gt 0>
			  <cfset er = "#er#-Purchase-">
			  <cfset st = "Stop">
			</cfif>
			
		</cfif>	
		
		<cfquery name="Check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_SystemModule
		WHERE  SystemModule = 'WorkOrder'
		AND    Operational = '1'
		</cfquery>
		
		<cfif Check.recordcount eq "1">
					
		    <cfquery name="Verify" 
		      datasource="AppsWorkorder" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
		      SELECT OrgUnit
		      FROM   Customer
		      WHERE  OrgUnit  IN (SELECT OrgUnit FROM userQuery.dbo.tmp#SESSION.acc#OrgDelete)
		    </cfquery>	
			
			<cfif Verify.recordCount gt 0>
			  <cfset er = "#er#-WorkOrder-">
			  <cfset st = "Stop">
			</cfif>
			
		</cfif>	
								
	    <cfquery name="Verify" 
	      datasource="AppsOrganization" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT OrgUnit
	      FROM   OrganizationObject
	      WHERE  OrgUnit IN (SELECT OrgUnit 
		                    FROM userQuery.dbo.tmp#SESSION.acc#OrgDelete)
		  AND    OrgUnit is not NULL					
	    </cfquery>	
		
		<cfif Verify.recordCount gt 0>
		  <cfset er = "#er#-Workflow-">
		  
		  <cfset st = "Stop">
		</cfif>			
				
		<cfif st eq "Stop">
			
		 <cfoutput>
	     <script language="JavaScript">    
		     alert("Code is in use (#er#). Operation aborted.")	        
	     </script>  
		 </cfoutput>	 
			 
	    <cfelse>
					
			<cfquery name="Delete" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Organization
			WHERE OrgUnit IN  
			     (SELECT OrgUnit FROM userQuery.dbo.tmp#SESSION.acc#OrgDelete)
		    </cfquery>
				
			<!--- provision to check children as well --->
			
			<cfif url.source eq "base">
			
				 <script language="JavaScript">
				    parent.window.close();			
					parent.opener.location.reload();			
					parent.opener.parent.left.location.reload();				    	       
				 </script>	
				 
				 <cfabort>
					 
			 </cfif>
		
		</cfif>
		
	</cfif>	
	
<cfoutput>

<cfif Form.OrgUnitCode neq Form.ParentOrgUnit>

	<script language="JavaScript">
    	parent.window.close();
		parent.opener.location.reload();
	</script>	

<cfelse>

	<script language="JavaScript">
		parent.window.close();
		parent.opener.location.reload();
	</script>	

</cfif>

</cfoutput>
