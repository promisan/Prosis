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
<cfparam name="url.save" default="0">

<cfif url.save eq "1">

	<cfinclude template="ProcessActionDocumentTextSubmit.cfm">	
	
</cfif>

<!-- <cfform style="height:100%">	-->

<cfoutput>

  <cfquery name="Doc" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SET TEXTSIZE 1500000
		SELECT  O.*, R.DocumentMode, R.DocumentEditor
		FROM    OrganizationObjectActionReport O INNER JOIN
                   Ref_EntityDocument R ON O.DocumentId = R.DocumentId
		WHERE   O.ActionId   = '#url.MemoActionID#'
		AND     O.DocumentId = '#url.documentid#'
  </cfquery>			
						
  <cfif url.element eq "documentcontent">
     <cfset text = replace(doc.DocumentContent,"<script","<disable","all")>				 
  <cfelseif url.element eq "documentheader">
     <cfset text = replace(doc.DocumentHeader,"<script","<disable","all")>
  <cfelse>
     <cfset text = replace(doc.DocumentFooter,"<script","<disable","all")>
  </cfif>	
    
  <cfif url.element eq "documentcontent">
    	
  	<cfset text = replace(doc.DocumentContent,"<script","<disable","all")>	
    <cfset text = replace(text,"<iframe","<disable","all")>
	
	<cfif Doc.DocumentEditor eq "FCK">
	
		  <cf_textarea name="FieldDocument#no#"                 
           toolbaronfocus = "No"
           bindonload     = "No" 	      			 			 				          
           richtext       = "Yes"     
		   height         = "630"		      
           toolbar        = "Basic"><cfoutput><cf_paragraph>#text#</cf_paragraph></cfoutput></cf_textarea>
	
	<cfelse>
			
		<cf_textarea name="FieldDocument#no#" height="95%" toolbar = "Basic" allowedContent = "yes">
				<cfoutput><cf_paragraph>#text#</cf_paragraph></cfoutput>
		</cf_textarea>	
			
	
	</cfif>
				  		   
	  <!--- height is automatically been assigned height = "#client.height#-300"	--->
	 
	  <input type="hidden" name="margintop"    id="margintop"    value="#doc.DocumentMarginTop#">
	  <input type="hidden" name="marginbottom" id="marginbottom" value="#doc.DocumentMarginBottom#">
	
  <cfelse>  
  
	  <table width="98%" border="0" class="formpadding" align="center">
	  
	  <tr>
	     <td class="labelmedium" style="font-size:24px;padding-left:4px">Header <font size="1">[PDF only]</td>
		 <td class="labelit" align="right">Margin:<select name="margintop" id="margintop" class="regularxl">
			 <cfloop index="m" from="0.1" to="5" step="0.1">
			     <option value="#m#" <cfif doc.DocumentMarginTop eq m>selected</cfif>>#m#</option>
	    	  </cfloop>
	     </td>
	  </tr>
	  
	  <tr><td colspan="2">
	  
	  	 <textarea name="hdrFieldDocument#no#" style="padding:5px;border:0px;background-color:efefef;width:100%;height:50px">#doc.DocumentHeader#</textarea>	
	  
	  
	  	 <!--- remove hanno 
	  
	     <cfset text = replace(doc.DocumentHeader,"<script","<disable","all")>
	     <cfset text = replace(text,"<iframe","<disable","all")>
	     <cf_textarea name="hdrFieldDocument#no#"                 
	           toolbaronfocus = "No"
			   height         = "100"
	           bindonload     = "No"	     		 			 				          
	           richtext       = "Yes"             
	           allowedContent = "Yes"
	           toolbar        = "Basic"><cfoutput><cf_paragraph>#text#</cf_paragraph></cfoutput>
		 </cf_textarea>
		 
		 --->
	  
	  </td></tr>
	  
	   <tr>
	     <td class="labelmedium" style="font-size:24px;padding-left:4px">Footer <font size="1">[PDF only]</td>
		 <td class="labelit" align="right">Margin:<select name="marginbottom" id="marginbottom" class="regularxl">
			 <cfloop index="m" from="0.1" to="5" step="0.1">
			     <option value="#m#" <cfif doc.DocumentMarginBottom eq m>selected</cfif>>#m#</option>
	    	  </cfloop>
	     </td>
	  </tr>	  
	    
	  <tr><td colspan="2">
	  
	  	<textarea name="ftrFieldDocument#no#" style="padding:5px;border:0px;background-color:efefef;width:100%;height:50px">#doc.DocumentFooter#</textarea>	
	  
	  	 <!---

	     <cfset text = replace(doc.DocumentFooter,"<script","<disable","all")>
	     <cfset text = replace(text,"<iframe","<disable","all")>
	     <cf_textarea name="ftrFieldDocument#no#"                 
	           toolbaronfocus = "No"
			   height="100"
	           bindonload     = "No" 	       			 			 				          
	           richtext       = "Yes"          
	           allowedContent = "Yes"   
	           toolbar        = "Basic"><cfoutput><cf_paragraph>#text#</cf_paragraph></cfoutput>
		 </cf_textarea>
		 
		 --->
	  
	  </td></tr>	
	 
	 <tr class="labelmedium2"><td style="font-size:20px" colspan="2">Available shortcut</td></tr> 
	 <tr><td colspan="2">@default : This will render the page and total number as well as the date and person</td></tr>
	    
	  </table>
  
  </cfif>	
  
</cfoutput>  

<cfset ajaxonload("initTextArea")>				

<!-- </cfform>	-->	