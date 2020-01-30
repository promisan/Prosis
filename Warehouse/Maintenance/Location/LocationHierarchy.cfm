
<!--- 

<title>Update Hierarchy</title>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfset cnt = "0">

<cfparam name="URL.Mission" default="x">
<cfparam name="URL.Mis" default="#URL.Mission#"> 
<cfparam name="URL.Man" default=""> 
<cfparam name="URL.href" default="">

<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Mandate
WHERE Mission = '#URL.Mis#' 
<cfif #URL.Man# neq "">
AND MandateNo = '#URL.Man#' 
</cfif>
ORDER BY MandateNo DESC 
</cfquery>

<cfoutput query="Mandate">

<cf_wait text="Please wait, while I am updating the organization hierarchy">
<cfflush>

	<cf_waitEnd>
	<cf_wait text="Please wait, Processing: mandate #MandateNo#">
	<cfflush>

    <cfset level01 = 0>
	
	<!--- reset --->
	
	<cfquery name="Reset" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Organization 
	SET HierarchyCode = NULL, HierarchyRootUnit = NULL
	WHERE Mission   = '#URL.Mis#'
	AND MandateNo   = '#MandateNo#'
	</cfquery>
			
	<cfquery name="Q1" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	    FROM Organization 
		WHERE Mission   = '#URL.Mis#'
		AND MandateNo   = '#MandateNo#'
		AND (ParentOrgUnit = '' OR ParentOrgUnit is NULL)
	ORDER BY TreeOrder
	</cfquery>
	
	<cfloop query="Q1">
	
	   <cfset level01 = #level01# + 1>
	   <cfif level01 lt 10>
	     <cfset level1 = "0#level01#">
	   <cfelse>
	     <cfset level1 = "#Level01#">
	   </cfif>
	   <cfset root    = #Q1.OrgUnitCode#>
	       
		<cfquery name="Update" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Organization 
		SET HierarchyCode = '#Level1#', 
		    HierarchyRootUnit = '#root#'
		WHERE OrgUnit = '#Q1.OrgUnit#'
		</cfquery>
		
		<cfset cnt = cnt+1>
		<!--- <cfoutput><font face="Arial" size="1">#cnt#</font></cfoutput> --->
		<cfflush>
	
	   <cfset level02 = 0>
	
	   <cfquery name="Q2" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
	    FROM Organization 
		WHERE Mission   = '#URL.Mis#'
		AND MandateNo = '#MandateNo#'
		AND (ParentOrgUnit = '#Q1.OrgUnitCode#')
	    ORDER BY TreeOrder
	   </cfquery>
	   
	   <cfloop query="Q2">
	
	   <cfset level02 = #level02# + 1>
	   <cfif level02 lt 10>
	     <cfset level2 = "0#level02#">
	   <cfelse>
	     <cfset level2 = "#Level02#">
	   </cfif>
	   
		<cfquery name="Update" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Organization
		SET HierarchyCode = '#Level1#.#Level2#',
		    HierarchyRootUnit = '#root#'
		WHERE OrgUnit = '#Q2.OrgUnit#'
		</cfquery>
		
			
	    <cfset level03 = 0>
	
	    <cfquery name="Q3" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
	    FROM Organization 
		WHERE Mission   = '#URL.Mis#'
		AND MandateNo = '#MandateNo#'
		AND (ParentOrgUnit = '#Q2.OrgUnitCode#')
	    ORDER BY TreeOrder
	    </cfquery>
	   
	       <cfloop query="Q3">
	
					  <cfset level03 = #level03# + 1>
					    <cfif level03 lt 10>
					     <cfset level3 = "0#level03#">
					  <cfelse>
					     <cfset level3 = "#Level03#">
					  </cfif>
	   
					  <cfquery name="Update" 
					  datasource="AppsOrganization" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  UPDATE Organization
					  SET HierarchyCode = '#Level1#.#Level2#.#Level3#', 
					      HierarchyRootUnit = '#root#'
					  WHERE OrgUnit = '#Q3.OrgUnit#'
					  </cfquery>
					  
									
					  <cfset level04 = 0>
					
					  <cfquery name="Q4" 
					    datasource="AppsOrganization" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
					    SELECT *
					    FROM Organization 
						WHERE Mission   = '#URL.Mis#'
						AND MandateNo = '#MandateNo#'
						AND (ParentOrgUnit = '#Q3.OrgUnitCode#')
					    ORDER BY TreeOrder
					  </cfquery>
	   
	                  <cfloop query="Q4">
	
							<cfset level04 = #level04# + 1>
							<cfif level04 lt 10>
							    <cfset level4 = "0#level04#">
							<cfelse>
							     <cfset level4 = "#Level04#">
							</cfif>
							   
							<cfquery name="Update" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							UPDATE Organization
							SET HierarchyCode = '#Level1#.#Level2#.#Level3#.#Level4#', 
							    HierarchyRootUnit = '#root#'
							WHERE OrgUnit = '#Q4.OrgUnit#'
							</cfquery>
							
							
	                        <cfset level05 = 0>
	
						    <cfquery name="Q5" 
						    datasource="AppsOrganization" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
						    SELECT *
						    FROM Organization 
							WHERE Mission   = '#URL.Mis#'
							AND MandateNo = '#MandateNo#'
							AND (ParentOrgUnit = '#Q4.OrgUnitCode#')
						    ORDER BY TreeOrder
						    </cfquery>
								   
							<cfloop query="Q5">
							
							   <cfset level05 = #level05# + 1>
							    <cfif level05 lt 10>
							     <cfset level5 = "0#level05#">
							   <cfelse>
							     <cfset level5 = "#Level05#">
							   </cfif>
								   
								   <cfquery name="Update" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								UPDATE Organization
								SET HierarchyCode = '#Level1#.#Level2#.#Level3#.#Level4#.#Level5#', 
								    HierarchyRootUnit = '#root#'
								WHERE OrgUnit = '#Q5.OrgUnit#'
								</cfquery>
								
														
								<cfset level06 = 0>
								
								   <cfquery name="Q6" 
								    datasource="AppsOrganization" 
								    username="#SESSION.login#" 
								    password="#SESSION.dbpw#">
								    SELECT *
								    FROM Organization 
									WHERE Mission   = '#URL.Mis#'
									AND MandateNo = '#MandateNo#'
									AND (ParentOrgUnit = '#Q5.OrgUnitCode#')
								    ORDER BY TreeOrder
								   </cfquery>
								   
								   <cfloop query="Q6">
								
									   <cfset level06 = #level06# + 1>
									    <cfif level06 lt 10>
									     <cfset level6 = "0#level06#">
									   <cfelse>
									     <cfset level6 = "#Level06#">
									   </cfif>
									   
										   <cfquery name="Update" 
										datasource="AppsOrganization" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										UPDATE Organization
										SET HierarchyCode = '#Level1#.#Level2#.#Level3#.#Level4#.#Level5#.#Level6#', 
										    HierarchyRootUnit = '#root#'
										WHERE OrgUnit = '#Q6.OrgUnit#'
										</cfquery>
																																					
										<cfset level07 = 0>
									
									   <cfquery name="Q7" 
										datasource="AppsOrganization" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT *
										FROM Organization 
										WHERE Mission   = '#URL.Mis#'
										AND MandateNo = '#MandateNo#'
										AND (ParentOrgUnit = '#Q6.OrgUnitCode#')
										ORDER BY TreeOrder
									   </cfquery>
									   
									   <cfloop query="Q7">
									
										   <cfset level07 = #level07# + 1>
											<cfif level07 lt 10>
											 <cfset level7 = "0#level07#">
										   <cfelse>
											 <cfset level7 = "#Level07#">
										   </cfif>
										   
											   <cfquery name="Update" 
											datasource="AppsOrganization" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											UPDATE Organization
											SET HierarchyCode = '#Level1#.#Level2#.#Level3#.#Level4#.#Level5#.#Level6#', 
												HierarchyRootUnit = '#root#'
											WHERE OrgUnit = '#Q7.OrgUnit#'
											</cfquery>
										
																					
										  </cfloop>	
									
								   </cfloop>
	
	                        </cfloop>
	
	                  </cfloop>
	
	             </cfloop>
	
	   </cfloop>

</cfloop>

<!--- invalid characters --->

<cfquery name="Listing" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Organization
WHERE Mission = '#URL.Mis#'
</cfquery>

<cfloop query="Listing">

	<cfset Name=Replace(#OrgUnitName#,"'",'','ALL')>
	<cfset NameShort=Replace(#OrgUnitNameShort#,"'",'','ALL')>
		
	<cfif #Name# neq #OrgUnitName# or NameShort neq #OrgUnitNameShort#>
	
		<cfquery name="Update" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Organization
		SET    OrgUnitName = '#Name#', 
		       OrgUnitNameShort = '#NameShort#' 
		WHERE OrgUnit = '#OrgUnit#'
		</cfquery>

	</cfif>

</cfloop>

<cf_waitEnd>

<cfif #URL.href# eq "">

   <cf_waitEnd>
 
<cfelse>

   <script>
      window.location = "#URL.href#?#CLIENT.search#"
   </script>

</cfif>

</cfoutput>

--->

