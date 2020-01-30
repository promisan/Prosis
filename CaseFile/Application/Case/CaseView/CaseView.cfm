
<cfajaximport tags="cfform,cfmenu,cfdiv,cfinput-datefield,cfinput-autosuggest,cfwindow">

<cf_ActionListingScript>
<cf_FileLibraryScript>
<cf_dialogStaffing>
<cf_dialogOrganization>
<cf_dialogAsset>
<cf_dialogLedger>
<cf_dialogPosition>
<cf_menuscript>
<cf_SubmenuScript>
<cf_listingscript>
<cf_mapscript scope="embed">
<cf_textareascript>

<cfif url.claimid neq "">

	<cfquery name="Claim" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *, CTC.Description ClassDescription
	    FROM  Claim C 
			INNER JOIN Ref_ClaimTypeClass CTC
				ON C.ClaimTypeClass = CTC.Code
		WHERE ClaimId = '#URL.claimid#'	
	</cfquery>

	<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		    SELECT *
		    FROM  Person
			WHERE PersonNo = '#Claim.PersonNo#'	
	</cfquery>
	
	<cfif Person.recordcount eq "1">
	<cfset label = "#Claim.ClassDescription# : #claim.DocumentNo# #claim.DocumentDescription# for #Person.FirstName# #Person.LastName#">		
	<cfelse>
	<cfset label = "#Claim.ClassDescription# : #claim.DocumentNo# #claim.DocumentDescription#">			
	</cfif>

	<cf_screentop height="100%" band="no" scroll="no" label="#label#" layout="webapp" banner="blue" bannerforce="Yes" jquery="Yes"
	systemmodule="Insurance" functionClass="Window" functionName="Case File">
	
	<!--- option="Maintenance and inquiry of case file" --->

<cfelse>

	<cf_tl id="New Case File" var="1">

	<cfset label = "#lt_text#">

	<cf_tl id="Record a new CaseFile" var="1">
	
	<cfset FDescription = "#lt_text#">
	
	<!--- option="#FDescription#" --->
	
	<cf_screentop height="100%" border="no" scroll="Yes" title="#label#" label="#label#" layout="webapp" banner="blue" jquery="Yes"
	systemmodule="Insurance" functionClass="Window" functionName="Case File">

</cfif>

<cfif Client.googlemap eq "1">
     <cfajaximport tags="cfmap" params="#{googlemapkey='#client.googlemapid#'}#">
</cfif>

		
<cfparam name="URL.ClaimId" default="00000000-0000-0000-0000-000000000000">
		
<cfif URL.claimid eq "">
	<cfset init = 1>
    <cf_assignId>
    <cfset URL.ClaimId = rowguid>
<cfelse>
    <cfset init = 0>	
</cfif>	

<cfparam name="Client.googlemapid" default="">
	
<cfoutput>	
	
<script language="JavaScript">

function getunit(role,org) {
	ptoken.navigate('../Institution/InstitutionSubmit.cfm?claimid=#url.claimid#&role='+role+'&orgunit='+org,'a'+role)	
}

function addressedit(persno,addressid) {
    ptoken.open("#SESSION.root#/Staffing/Application/Employee/Address/AddressEdit.cfm?header=0&ID="+persno+"&ID1="+addressid,"_new","width=900, height=790, toolbar=no, scrollbars=yes, resizable=yes")	
}

function toggleheader() {
  se = document.getElementsByName("claimheader")
  cnt = 0
  if (se[0].className = "regular") {
  
     while (se[cnt]) {
	    se[cnt].className = "hide"
		cnt++
	 }	
  
  } else {
  
  	  while (se[cnt]) {
	    se[cnt].className = "regular"
		cnt++
	 }	
  
  }

}

function validateincident(id,box) {
	document.formincident.onsubmit() 
	
	if( _CF_error_messages.length == 0 ) {    	    
		ptoken.navigate('#SESSION.root#/CaseFile/Application/Case/Incident/IncidentDetailSubmit.cfm?ClaimId='+id+'&box='+box,'incidentprocess','','','POST','formincident')
	 }   
}	 

</script>

</cfoutput>

<cfquery name="Claim" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Claim
		WHERE  ClaimId = '#URL.claimid#'	
</cfquery>

<cfif init eq "0">		

    <cfset label =	"#Claim.ClaimType# #claim.DocumentNo#">	
	<cfset vmission="#Claim.Mission#" >

<cfelse>		

	<cf_tl id="New Claim" var="1">	
   	<cfset label =	"#lt_text#">			
	<cfset vmission="#URL.mission#">
	
</cfif>	

<table width="99%" height="100%" border="0" align="center" cellspacing="0" cellpadding="0">		
		
	<cfif init eq "1">
	
		<tr><td height="8"></td></tr>	
		<tr><td valign="top" height="100%">
		
		    <cfinclude template="../Header/ClaimHeader.cfm">
			
		</td></tr>
				
	<cfelse>
		
		<cfinvoke component="Service.Access"  
		     method="CaseFileManager" 
		     mission="#claim.Mission#" 
			 claimtype="#claim.ClaimType#"
		     returnvariable="access">
					 
		<cfif access eq "NONE">
		
		<tr><td style="height:80" class="labelit" align="center">
			<font size="2">You do not have access to this record</font>
		</td></tr>	
		<cfabort>
				
		<cfelse>			 
		
		<tr><td valign="top" style="padding-left:6px;padding-right:6px;height:38px">
			<cfinclude template="CaseViewMenu.cfm">
		</td></tr>	
						
		<tr  class="line"><td valign="top" style="padding-left:6px;padding-right:6px">
		    <cfset url.mission = vmission>
			<cfinclude template="CaseViewTab.cfm">		 			
		</td></tr>
		
		<!--- --------- --->
		<!--- container --->
		<!--- --------- --->		
				
		<tr><td height="100%" style="padding:5px">
			
			<table width="100%" height="100%" align="center"><tr>
			
			<cfoutput>
			
			<cf_menucontainer item="1" class="regular">					
			
				<cfinclude template="../Header/ClaimHeader.cfm">					
			
			</cf_menucontainer>
						
			<cf_menucontainer item="2" class="hide">
			
			<cfquery name="myTabs" 
					datasource="AppsCaseFile" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   *
					FROM     Ref_ClaimTypeTab
					WHERE    Code = '#Claim.ClaimType#'	
					AND      (
					          ClaimTypeClass is NULL 
					                 OR 
							  ClaimTypeClass = '#claim.ClaimTypeClass#'
							 )
					AND      TabName != 'Control'
					AND      Mission = '#url.mission#'
					AND      TabNameParent is NULL
					AND      Operational = 1 
					ORDER BY TabOrder				    
			</cfquery>				
			
			<cfset itm = 2>					 
			
			<cfloop query="mytabs">
			
				<cfif accessgranted gte accesslevelread and accessgranted neq "">		
							
					<cfset itm = itm+1>
					
					<cfif tabtemplate eq "element" or ModeOpen eq "Bind">						
						<cf_menucontainer item="#itm#" class="hide">														
					<cfelse>								
					    <cf_menucontainer item="#itm#" class="hide">										
							<cfinclude template="#TabTemplate#">
					</cf_menucontainer>						
					</cfif>
				
				</cfif>
			
			</cfloop>
			
			</cfoutput>
			
			</tr>
			</table>
			
		</td></tr>
		
		</cfif>
		
	</cfif>
			
</table>

<cfdiv id="detailsubmit" class="hide">

<script>
	try {
		document.getElementById("menu1").click()
	} catch(err) {	}
</script>
