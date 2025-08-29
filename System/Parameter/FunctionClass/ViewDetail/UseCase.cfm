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
<cfparam name="URL.ID" default="">

<cfquery name="List" 
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ClassElement
	WHERE ElementClass = 'UseCase'
	ORDER By ListingOrder
</cfquery>


<cfquery name="ctype" 
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT ClassFunctionType
    FROM ClassFunction
	WHERE ClassFunctionId='#url.id#'
</cfquery>

<cfoutput>

<cfset attrib = {type="Tab",name="ClassInfo",tabheight="#client.height-260#",height="#client.height-225#",width="#client.width-106#"}>

<cflayout attributeCollection="#attrib#">
				
		<cfloop query="list">		
				
			 <cflayoutarea 
	          name="n#elementCode#"
			  source="UseCaseTextArea.cfm?id=#url.Id#&elementCode=#elementcode#"
	          title="#ElementDescription#"
	          overflow="auto"/>	
			
		</cfloop>				

		<cfif ctype.ClassFunctionType eq "AService">
		
			 <cflayoutarea 
	          name="Attributes" style="border-color:ffffff;width:100%"
    	      title="Attributes"
	          overflow="auto">		
				  <table cellspacing="0" width="100%"
			      cellpadding="0">
				  <tr>
  				  <td width="2%"></td>
				  <td valign="top">			  
				  <cfdiv id="bAttributes" bind ="url:UseCaseSelectAttr.cfm?id=#url.Id#"/>
	 		  	  </td>
				  <td width="2%"></td>
				  </tr></table>	  
			</cflayoutarea>	
		
		</cfif>
	
	</cflayout>	
		
</cfoutput>	