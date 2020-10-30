<!--- ----------------------------------------------- --->
<!--- main container to show label and content holder --->
<!--- ----------------------------------------------- --->

<cfparam name="URL.IDMenu" default="">
<cfparam name="URL.SystemFunctionId" default="#URL.IDMenu#">
<cfparam name="URL.Mission" default="">

<!--- kherrera [20130107]: Added to rewrite SystemFunctionId in case is already defined --->
<cfset URL.SystemFunctionId = URL.IDMenu>

<cfif not IsValid("GUID", url.SystemFunctionId)>

      <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		 <tr><td align="center" height="40">
		   <font face="Verdana" color="FF0000">
			   <cf_tl id="Detected a Problem with your access"  class="Message">
		   </font>
			</td>
		 </tr>
	  </table>	
	  <cfabort>	

<cfelse>
			
	<cfquery name="check" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ModuleControlDetailField
		WHERE  SystemFunctionId = '#URL.SystemFunctionId#'	
	</cfquery>
	
	<cfif check.recordcount eq "0">
	
		<title>Listing Preview</title>
		
		<table align="center">
			<tr><td height="160" align="center"><font face="Verdana" size="3" color="FF0000">There are no fields selected for this listing</td></tr>
		</table>
		
		<cfabort>
	
	</cfif>
	
	<cfquery name="Menu" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   xl#Client.LanguageId#_Ref_ModuleControl R
		WHERE SystemFunctionId = '#URL.SystemFunctionId#'	
	</cfquery>
	
	<cfparam name="url.webapp" default="Backoffice">
					
	<cfif url.webapp eq "Backoffice">	
				
		<cf_screentop height="100%" icon="list2.png" label="Listing: #Menu.FunctionName#" line="no" band="no"  scroll="No" html="no" banner="gray" layout="webapp" MenuAccess="Yes" JQuery="yes" TreeTemplate="Yes">
			
	<cfelseif url.webapp eq "Portal">
	
		<cf_screentop height="100%" scroll="Yes" html="no" banner="gray" JQuery="yes">
		
	</cfif>	
	
</cfif>	

<cf_listingscript>
<cf_layoutScript>

<cfquery name="Menu" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   xl#Client.LanguageId#_Ref_ModuleControl R
	WHERE SystemFunctionId = '#URL.SystemFunctionId#'	
</cfquery>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
    
	<tr id="log">
	
        <td valign="top" height="100%">
            
            <cfdiv id="inquirydetail" style="width:100%; height:100%; min-height:100%;">		
                <cfinclude template="InquiryContent.cfm">
            </cfdiv>		
                   
        </td>
		
    </tr>
	
</table>

<cfif menu.functiontarget eq "right">
    <!--- do not load --->
<cfelse>	
	<cf_screenbottom layout="webdialog">
</cfif>
