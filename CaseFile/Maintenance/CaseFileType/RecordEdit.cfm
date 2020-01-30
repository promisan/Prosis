<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Maintain Case File Item" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="gradient" 
			  menuAccess="Yes" 
			  jquery="yes"
			  systemfunctionid="#url.idmenu#">

<cfajaximport tags="cfform">

<cfquery name="Get" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ClaimType
	WHERE  Code = '#URL.ID1#'
</cfquery>


<!--- edit form --->

<table width="94%" cellspacing="0" cellpadding="0" align="center">
	
	 <cfoutput>
	 <TR>
		 <TD width="100%" colspan="2">
		 	<cfdiv id="editheader" bind="url:RecordEditHeader.cfm?id1=#Get.Code#">
		 </TD>  
	 </TR>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" id="mainEdit">
		<cfinclude template="RecordEditTab.cfm">
	</td></tr>
		
    </cfoutput>
    	
</TABLE>
