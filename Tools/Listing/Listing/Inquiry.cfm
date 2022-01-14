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
	
	<cfquery name="tree" 
         datasource="AppsSystem" 
         username="#SESSION.login#" 
         password="#SESSION.dbpw#">
             SELECT *
             FROM  Ref_ModuleControlDetailField
             WHERE SystemFunctionId = '#url.SystemFunctionId#'
             AND   FunctionSerialNo = '1'
             AND   FieldTree = 1		
     </cfquery>
	
	<cfparam name="url.webapp" default="Backoffice">
	
	
	<cfif url.webapp eq "Backoffice">	
	
		<cfif tree.recordcount gte "1">		
			<cf_screentop height="100%" label="Listing: #Menu.FunctionName# #url.mission#" line="no" scroll="No" html="no" banner="gray" layout="webapp" MenuAccess="Yes" JQuery="yes" TreeTemplate="Yes">		
		<cfelse>				
			<cf_screentop height="100%" label="Listing: #Menu.FunctionName# #url.mission#" line="no" scroll="No" html="no" banner="gray" layout="webapp" MenuAccess="Yes" JQuery="yes">				
		</cfif>
		
	<cfelseif url.webapp eq "Portal">
	
		<cf_screentop height="100%" scroll="Yes" html="no" banner="gray" JQuery="yes" >
		
	</cfif>	
	
</cfif>	

<cf_listingscript>
<cf_dialogmaterial>
<cf_dialogstaffing>

<cf_layoutScript>

<cfquery name="Menu" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    xl#Client.LanguageId#_Ref_ModuleControl R
	WHERE   SystemFunctionId = '#URL.SystemFunctionId#'	
</cfquery>

<cfinclude template="InquiryListing.cfm">           

<cfif menu.functiontarget eq "right">
    <!--- do not load --->
<cfelse>	
	<cf_screenbottom layout="webdialog">
</cfif>
