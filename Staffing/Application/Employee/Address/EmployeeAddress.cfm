<cfparam name="url.scope" default="Backoffice">
<cfparam name="url.showheader" default="Yes">
<cfparam name="url.id1" default="">

<cfif url.scope neq "Backoffice">
	 <cfset url.id = CLIENT.personno>
</cfif>

<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop jquery="Yes" height="100%" scroll="yes" html="No" menuaccess="context" actionobject="Person"
		actionobjectkeyvalue1="#url.id#">

<!--- scripts --->
<cf_dialogstaffing>
<cf_dialogPosition>
<cf_ActionListingScript>
<cf_fileLibraryScript>
<cf_calendarscript>

<cf_mapscript scope="embed" height="300" width="360">

<cfif CLIENT.googlemap eq "1">
	<cfajaximport tags="cfmap,cfform" params="#{googlemapkey='#client.googlemapid#'}#"> 
<cfelse>
	<cfajaximport tags="cfform"> 
</cfif>

<cfparam name="url.header" default="1">
<cfparam name="url.webapp" default="">
	
<cfinvoke component="Service.Access" 
    	method="contract"  
		personno="#URL.ID#" 
		returnvariable="ContractAccess">			
					
<cfinvoke component="Service.Access"  
		method="employee"  
		owner = "Yes" <!--- 01/03/2011 check if this person is the owner of the record --->
		personno="#URL.ID#" 
		returnvariable="HRAccess"> 
		 
<cfif ContractAccess eq "EDIT" or ContractAccess eq "ALL" or HRAccess eq "EDIT" or HRAccess eq "ALL">
	 <cfset mode = "edit">
</cfif>		 
		 
<cfif url.header eq "0">
    <cfset mode = "view">
</cfif>		

<!--- Query returning search results --->

<cfquery name="Search" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   A.*, 
	         B.Name, R.Description as AddressTypeDescription
	FROM     vwPersonAddress A, 
	         System.dbo.Ref_Nation B, 
		     Ref_AddressType R
	WHERE    PersonNo      = '#URL.ID#'
	AND      A.Country     = B.Code
	AND      A.AddressType = R.AddressType
	ORDER BY A.AddressType DESC
	
</cfquery>

<cfif url.webapp eq "">
	
	<cf_divscroll>	 
	  	
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	
	<cfif header gte "1">
	
		<cfif url.showheader eq "Yes">
		<tr>
		<td height="40">
						
		<table cellpadding="0" cellspacing="0" width="99%" align="center">
		
			<tr><td height="10" style="padding-left:7px">	
				  <cfset ctr      = "0">		
			      <cfset openmode = "close"> 
				  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
				 </td>
			</tr>	
			
		</table>
	
		</td>
		</tr>
		</cfif>
		
	</cfif> 
	
	<tr><td valign="top" style="padding-top:1px">
	  
		<table width="100%" height="100%">
		<tr>
			<td valign="top" id="addressdetail" style="padding-left:15px;padding-right:15px">
			
			<cfif url.id1 eq "">
				<cfinclude template="EmployeeAddressDetail.cfm">
			<cfelse>
			    <cfinclude template="AddressEdit.cfm">
			</cfif>
			
			</td>
		</tr>
		</table>
		
	</td></tr>
	</table>
	
	</cf_divscroll>	
	
<cfelse>
	  	
	<table width="99%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" >
		
	<cfif header gte "1">
			
		<cfif url.showheader eq "Yes">				
			<tr>
			<td height="40">
			<cfset ctr      = "0">		
			<cfset openmode = "open"> 
			<cfinclude template="../PersonViewHeaderToggle.cfm">
			</td>
			</tr>		
		</cfif>		
	</cfif> 
	
	<tr><td valign="top" style="padding-top:1px">
	  
		<table width="98%" height="100%" align="center">
		<tr>
			<td valign="top" id="addressdetail" style="padding-left:15px;padding-right:15px">
			
			<cfif url.id1 eq "">
				<cfinclude template="EmployeeAddressDetail.cfm">
			<cfelse>
			    <cfinclude template="AddressEdit.cfm">
			</cfif>
			
			</td>
		</tr>
		</table>
		
	</td></tr>
	</table>
	
</cfif>	
