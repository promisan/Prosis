<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="Form.Inherit" default="0">
<cfparam name="Form.Level" default="Root">
<cfparam name="Form.OrganizationCode" default="">

<cfparam name="Link" default="">

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = #dateValue#>

<cfset dateValue = "">
<cfif #Form.DateExpiration# neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = #dateValue#>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<cfif Form.Mandate eq "">

     <cf_message message = "You have not identified a mandate. Operation not allowed."
	  return = "back">
	  <cfabort>

</cfif>

<cfif Len(#Form.Remarks#) gt 300>
	  <cfset remarks = left(Form.Remarks,300)>
<cfelse>
	  <cfset remarks = Form.Remarks>
</cfif>  

<!--- manual entry ; verify if record exist --->

<cfif Form.Inherit eq "0">

    <cfif Form.OrgUnitName eq "">

    <cf_message message = "You have not identified an org unit. Operation not allowed."
	  return = "back">
	  <cfabort>
	  
	</cfif>  

	<cfquery name="Verify" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT OrgUnitCode
	FROM  Organization
	WHERE Mission     = '#FORM.Mission#'
	AND   OrgUnitCode = '#FORM.OrgUnitCode#'
	</cfquery>

<cfelse>

    <cfif Form.OrgUnit1 eq "">
	
	 <cf_message message = "You have not identified a org unit. Operation not allowed."
	  return = "back">
	  <cfabort>
	
	</cfif>
  
    <cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Organization
	WHERE OrgUnit = '#Form.OrgUnit1#'
	</cfquery>

   <cfquery name="Verify" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT OrgUnitCode
	FROM Organization
	WHERE Mission = '#FORM.Mission#'
	AND OrgUnitCode IN (SELECT DISTINCT OrgUnitCode
						FROM Organization
						WHERE HierarchyCode LIKE '#Org.HierarchyCode#%'
						AND Mission = '#Org.Mission#'
						AND MandateNo = '#Org.MandateNo#')
	</cfquery>

</cfif>

<!--- now the updating starts --->

<cfif Verify.RecordCount gt 0>

	 <cf_message message = "The organization code is already in use for this tree!. Operation not allowed."
	  return = "back">
	  <cfabort>

<cfelse>

		<cfswitch expression="#Form.Level#">
			<cfcase value="Root">
			   <cfset Parent = "NULL">
			</cfcase>
			<cfcase value="Same">
			   <cfif FORM.ParentParentOrgUnit eq "">
			       <cfset Parent = "NULL">
			   <cfelse>
			       <cfset Parent = "'#FORM.ParentParentOrgUnit#'">
			   </cfif>
			</cfcase>
			<cfcase value="Child">
			   <cfif FORM.ParentOrgUnit eq "">
			       <cfset Parent = "NULL">
			   <cfelse>
			       <cfset Parent = "'#FORM.ParentOrgUnit#'">
			   </cfif>
			</cfcase>
		</cfswitch>
		
		<!--- Remove quotes from Organization Name (can affect tree view)--->
		<cfset OrgName=Replace(Form.OrgUnitName,'"','','ALL')>
		<cfset OrgName=Replace(OrgName,"'","",'ALL')>
		
		<cfset OrgNameShort=Replace(Form.OrgUnitNameShort,'"','','ALL')>
		<cfset OrgNameShort=Replace(OrgNameShort,"'","",'ALL')>
			 
		<cfif Form.TreeUnit eq "1">
		
			<cfquery name="Update" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				 UPDATE Organization
				 SET TreeUnit = 0
				 WHERE TreeUnit = 1
				 AND Mission   = '#Form.Mission#'
				 AND MandateNo = '#Form.Mandate#'
		     </cfquery>
			 
		</cfif>	
		
		<cfif Form.Inherit eq "0"> 
		  
			<cfquery name="InsertOrganization" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Organization
			         (Mission,
					  MandateNo, 
					  OrgUnitCode,
					  TreeOrder,
					  OrgUnitName,
					  OrgUnitNameShort,
					  OrgUnitClass,
					  ParentOrgUnit,					  
					  Source,
					  SourceCode,
					  <cfif Form.OrganizationCode neq "">
					  OrganizationCode,
					  </cfif>
					  DateEffective,
					  DateExpiration,
					  TreeUnit,
					  Autonomous,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName,	
					  Remarks)
			      VALUES
				     ('#Form.Mission#',
			          '#Form.Mandate#',
					  '#Form.OrgUnitCode#',
					  '#Form.TreeOrder#',
					  '#OrgName#',
					  '#OrgNameShort#',
					  '#Form.OrgUnitClass#',
					  #PreserveSingleQuotes(Parent)#,					
					  '#Form.Source#',
					  '#Form.SourceCode#',
					  <cfif Form.OrganizationCode neq "">
					  '#Form.OrganizationCode#',
					  </cfif>
					  #STR#,
					  #END#,
					  '#Form.TreeUnit#', 
					  '#Form.Autonomous#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#',
					  '#Form.Remarks#')
			</cfquery>
			
			<cfquery name="Select" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT Max(OrgUnit) as OrgUnit
				 FROM Organization
				 WHERE Mission   = '#Form.Mission#'
				 AND MandateNo   = '#Form.Mandate#'
			</cfquery>
			
			<cfif Form.Account neq "">				
			  				 
				 <cfquery name="Delete" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 DELETE FROM UserMission
					 WHERE  Account  = '#Form.account#'
					 AND    Mission  = '#Form.Mission#'
					 AND    OrgUnit  = '#Select.OrgUnit#'						 	
			     </cfquery>
					
				<cfquery name="Insert" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 INSERT INTO UserMission
					 (Account,
					  Mission,
					  OrgUnit,
					  OfficerUserid,
					  OfficerLastName,
					  OfficerFirstName)
					 VALUES
					 ('#Form.Account#',
					  '#form.mission#',
					  '#Select.OrgUnit#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')				
			     </cfquery>
			
			</cfif>
								
		<cfelse>
	
			<cfquery name="InsertOrganization" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Organization
			         (Mission,
					  MandateNo, 
					  OrgUnitCode,
					  TreeOrder,
					  OrgUnitName,
					  OrgUnitNameShort,
					  OrgUnitClass,
					  ParentOrgUnit,
					  SourceCode,
					  <cfif Form.OrganizationCode neq "">
					  OrganizationCode,
					  </cfif>
					  DateEffective,
					  DateExpiration,
					  TreeUnit,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName,	
					  Remarks,	
					  Created)
			      VALUES ('#Form.Mission#',
			          '#Form.Mandate#',
					  '#Org.OrgUnitCode#',
					  '#Form.TreeOrder#',
					  '#Form.OrgUnitName1#',
					  '#OrgNameShort#',
					  '#Form.OrgUnitClass#',
					  #PreserveSingleQuotes(Parent)#,
					  '#Form.SourceCode#',
					  <cfif Form.OrganizationCode neq "">
					  '#Form.OrganizationCode#',
					  </cfif>
					  #STR#,
					  #END#,
					  '#Form.TreeUnit#', 
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#',
					  '#Form.Remarks#',
					  '#DateFormat(Now(),CLIENT.DateSQL)#')
			</cfquery>
			
			<cfquery name="Select" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT Max(OrgUnit) as OrgUnit
				 FROM Organization
				 WHERE Mission   = '#Form.Mission#'
				 AND MandateNo = '#Form.Mandate#'
			</cfquery>
							
			<!--- the rest --->
			
			<cfquery name="InsertOrganization" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Organization
			         (Mission,
					  MandateNo, 
					  OrgUnitCode,
					  TreeOrder,
					  OrgUnitName,
					  OrgUnitNameShort,
					  OrgUnitClass,
					  ParentOrgUnit,
					  SourceCode,
					  DateEffective,
					  DateExpiration,
					  TreeUnit,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName,	
					  Remarks)
				 SELECT '#Form.Mission#', 
				        '#Form.Mandate#', 
						OrgUnitCode, 
						TreeOrder, 
						OrgUnitName, 
						OrgUnitNameShort, 
						OrgUnitClass,
				        ParentOrgUnit, 
						SourceCode, 
						#STR#, 
						#END#, 
						'0', 
						'#SESSION.acc#', 
						'#SESSION.last#', 
						'#SESSION.first#', 
						'Inherited'
				 FROM Organization
				 WHERE HierarchyCode LIKE '#Org.HierarchyCode#.%'
			  	 AND Mission   = '#Org.Mission#'
			 	 AND MandateNo = '#Org.MandateNo#'
			</cfquery>
			
	</cfif>
	
	<!--- the should take care of all language matters also for inherit, to be checked --->
	
	<cf_LanguageInput
		TableCode       = "Organization" 
		Key1Value       = "#Select.OrgUnit#"
		Mode            = "Save"
		Lines           = "3"
		Name1           = "OrgUnitName"
		Name2           = "OrgUnitNameShort"
		Name3           = "Remarks">	
		
	<cfif url.source eq "base">	
	   
		<cfswitch expression="#Form.Level#">
		
			<cfcase value="Root">
			
				<cfquery name="Org" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT *
				 FROM Organization
				 WHERE Mission   = '#Form.Mission#'
				 AND   MandateNo = '#Form.Mandate#'
				 AND   OrgUnitCode = '#Form.OrgUnitCode#'
				 </cfquery>
			 
			     <cfset link = "OrganizationListing.cfm?ID1=#Org.OrgUnit#&ID2=#Form.Mission#&ID3=#Form.Mandate#">
			</cfcase>
			
			<cfcase value="Same">
			
				<cfquery name="Org" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT *
				 FROM Organization
				 WHERE Mission   = '#Form.Mission#'
				 AND   MandateNo = '#Form.Mandate#'
				 AND   OrgUnitCode = '#Form.OrgUnitCode#'
				 </cfquery>
				 
			    <cfset link = "OrganizationListing.cfm?ID1=#Org.OrgUnit#&ID2=#Form.Mission#&ID3=#Form.Mandate#">
			</cfcase>
			
			<cfcase value="Child">
			  
				<cfquery name="Org" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT *
				 FROM Organization
				 WHERE Mission   = '#Form.Mission#'
				 AND   MandateNo = '#Form.Mandate#'
				 AND   OrgUnitCode = '#FORM.MasterOrgUnit#'
				 </cfquery>				
				
			    <cfset link = "OrganizationListing.cfm?ID1=#Org.OrgUnit#&ID2=#Form.Mission#&ID3=#Form.Mandate#">
			</cfcase>
		
		</cfswitch>				
	
	<cfelse>
		
		<cfswitch expression="#url.source#">
		
			<cfcase value="TravelClaim">
			     <cfset link = "#SESSION.root#/TravelClaim/Maintenance/RequestUnit/RecordListing.cfm">
			</cfcase>		
			
			<cfcase value="STMaintain">
			     <cfset link = "#client.link#">
			</cfcase>	
		
		</cfswitch>
		
	</cfif>
	
	<cfset url.mission = Form.Mission>
	<cfset url.mandate = Form.Mandate>
	<cfset url.href = "save">
	
	<cfinclude template="OrganizationHierarchy.cfm">
	
	<!--- retreive assigned orgunit --->
	
	<cfquery name="Org" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				 SELECT *
				 FROM Organization
				 WHERE Mission   = '#Form.Mission#'
				 AND   MandateNo = '#Form.Mandate#'
				 AND   OrgUnitCode = '#Form.OrgUnitCode#'
     </cfquery>
	
	
		
	<cfoutput>
        <script language="JavaScript">
		
		    try {
	    	parent.unitshow('#org.orgunit#')			
			} catch(e) {}			
			window.location = "#link#&id4=#url.mode#&mid=#mid#"
	    </script>	
	</cfoutput> 
	
</cfif>
