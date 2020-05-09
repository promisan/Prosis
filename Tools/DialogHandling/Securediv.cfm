
<cfparam name="Attributes.bind"   default="">
<cfparam name="Attributes.Id" 	  default="">
<cfparam name="Attributes.Name"   default="">
<cfparam name="Attributes.Style"  default="">

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfdiv bind="#attributes.bind#&mid=#mid#" name="#attributes.Name#" id="#attributes.id#" style="#attributes.style#">		