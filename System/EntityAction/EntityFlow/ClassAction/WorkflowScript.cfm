<cfparam name="attributes.name"        default="">
<cfparam name="attributes.class"       default="regularh">
<cfparam name="attributes.ActionCode"  default="">
<cfparam name="attributes.EntityClass" default="">
<cfparam name="attributes.EntityCode"  default="">
<cfparam name="attributes.PublishNo"   default="">
<cfparam name="attributes.method"      default="embed">

<cfif attributes.PublishNo eq "">
	
		<cfquery name="Script" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_EntityClassActionScript
		WHERE ActionCode  = '#Attributes.ActionCode#'
		AND   EntityClass = '#Attributes.EntityClass#'
		AND   EntityCode  = '#Attributes.EntityCode#' 
		AND   Method      = '#Attributes.Method#'
		</cfquery>
		
	<cfelse>
	
		<cfquery name="Script" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityActionPublishScript
		WHERE  ActionCode      = '#Attributes.ActionCode#'
		  AND  ActionPublishNo = '#Attributes.PublishNo#'	
		  AND  Method          = '#Attributes.Method#'
		</cfquery>
	
</cfif>	

<cfoutput>
<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
  <tr><td>Enabled:</td>
       <td><input type="checkbox" name="#Attributes.name#Enable" id="#Attributes.name#Enable" value="1" <cfif script.MethodEnabled eq "1">checked</cfif>></td>
	   <td class="hide" id="parse#Attributes.name#"></td>
	   <td align="right">
	   <input type="button" name="Parse" id="Parse" value="Parse SQL" class="button10g" 
	   onclick="ColdFusion.navigate('ScriptSyntaxCheck.cfm?entitycode=#attributes.entitycode#&method=#attributes.name#','parse#Attributes.name#','','','POST','actionform')">
	   </td>
  </tr>
  <tr><td colspan="4">
  <textarea style="width:100%;height:40" 
     class="regular" 
	 name="#attributes.name#Script">#Script.MethodScript#</textarea>
   </td>
   </tr>
     
   <tr><td>Script Variables:</td>
       <td colspan="1"><b>@action, @object, @key1, @key2, @key3 and @key4</b> to refer to the object identification</td>
   </tr>		
</table>	 
</cfoutput>			