
<cfparam name="Attributes.bind"        default="">
<cfparam name="Attributes.Id" 	       default="mydivcontent">
<cfparam name="Attributes.Name"        default="">
<cfparam name="Attributes.Style"       default="">
<cfparam name="Attributes.Class"       default="">
<cfparam name="Attributes.bindOnLoad"  default="true">

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")>
<cfset mid = oSecurity.gethash()>   

<cfif findNoCase("?",attributes.bind)>

	<cfdiv bind="#attributes.bind#&mid=#mid#" name="#attributes.Name#" id="#attributes.id#" style="#attributes.style#" class="#attributes.class#" bindOnLoad="#attributes.bindOnLoad#">	

<cfelse>

    <cfdiv bind="#attributes.bind#?mid=#mid#" name="#attributes.Name#" id="#attributes.id#" style="#attributes.style#" class="#attributes.class#" bindOnLoad="#attributes.bindOnLoad#">		

</cfif>
