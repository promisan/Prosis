<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr><td height="10"></td></tr>
<tr><td>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">

<tr><td>

<cfform>

<cfquery name="Action" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT * 
	FROM EmployeeAction
	WHERE ActionDocumentNo  = '#URL.ID4#'
	
</cfquery>
   
<cfset MandateNo = Action.MandateNo>
<cfset Mission   = Action.Mission>

<cfquery name="Action" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT * 
	FROM   EmployeeAction A, Ref_Action R
	WHERE  Mission    = '#Mission#'
	AND    MandateNo  = '#MandateNo#'
	AND    A.ActionCode = R.ActionCode
	AND    ActionDocumentNo IN (SELECT ActionDocumentNo FROM EmployeeActionSource)
	ORDER BY A.ActionSource,A.ActionCode, PostType	
</cfquery>

<cftree name="root"
   font="tahoma"
   fontsize="11"		
   bold="No"   
   format="html"    
   required="No">
   
<cfoutput query="Action" group="actionsource">   

<cftreeitem value="#actionsource#"
        display="<span style='padding-top:3px;padding-bottom:3px;color: B08C42;' class='labellarge'><b>#actionsource#</span>"
		parent="root"					
        expand="Yes">		
        
<cfoutput group="actioncode">

	<cftreeitem value="#actioncode#"
        display="<span style='padding-top:3px;padding-bottom:3px;color: B08C42;' class='labelit'><b>#actioncode# #Description#</b></span>"
		parent="#actionsource#"				
        expand="Yes">		
  
	  <cfoutput>
	  
	  	<cfif Posttype neq "">
	  
	  	<cftreeitem value="#actioncode#_#posttype#_#ActionDocumentNo#"
	        display="<span style='padding-top:3px;padding-bottom:3px;color: gray;' class='labelit'>No:</font>#ActionDocumentNo# #PostType#</span>"
			parent="#actioncode#"
			target="right"		
			href="TransformViewGeneral.cfm?ID4=#ActionDocumentNo#"
	        expand="No"/>		
			
		<cfelse>
		
			<cftreeitem value="#actioncode#_all_#ActionDocumentNo#"
	        display="<span style='padding-top:3px;padding-bottom:3px;color: gray;' class='labelit'>No:</font>#ActionDocumentNo# #ActionDescription#</span>"
			parent="#actioncode#"
			target="right"		
			href="TransformViewGeneral.cfm?ID4=#ActionDocumentNo#"
	        expand="No"/>		
		
		</cfif>	
	  
	  </cfoutput>
        
</cfoutput>

</cfoutput>

</cftree>  

</cfform>
	
</td></tr>
 
</table>

</td></tr>

</table>
