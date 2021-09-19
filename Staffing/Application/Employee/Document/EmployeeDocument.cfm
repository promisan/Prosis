<cfparam name="url.scope" default="Backoffice">

<cfif url.scope neq "Backoffice">
	 <cfset url.id = CLIENT.personno>
</cfif>


<cfajaximport tags="cfform,cfdiv">
<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop label="Issued documents" 
        height="100%" jQuery="Yes" 
		scroll="yes" 
		html="No" 
		menuaccess="context"
        actionobject="Person"
		actionobjectkeyvalue1="#url.id#">

   
<cfparam name="url.webapp" default="">		
<cfparam name="URL.Status" default="0">

<cfinclude template="EmployeeDocumentContentScript.cfm">

<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
 <tr><td>

<cfif url.webapp eq "">

	  <table cellpadding="0" cellspacing="0" width="99%" align="center">
		
			<tr><td height="10" style="padding-left:7px">	
				  <cfset ctr      = "0">		
			      <cfset openmode = "close"> 
				  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
				 </td>
			</tr>	
			
	  </table>

<cfelse>

	  <table cellpadding="0" cellspacing="0" width="99%" align="center">
		
			<tr><td height="10">	
				  <cfset ctr      = "0">		
			      <cfset openmode = "open"> 
				  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
				 </td>
			</tr>	
			
	 </table>

</cfif>	

</td>
</tr>
	
<tr><td id="dialog">
	<cfinclude template="EmployeeDocumentContent.cfm">
	</td>
</tr>

</table>
