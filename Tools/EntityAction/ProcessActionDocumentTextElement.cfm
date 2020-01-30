
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
		SET TEXTSIZE 1000000
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
           toolbar        = "Default"><cfoutput><cf_paragraph>#text#</cf_paragraph></cfoutput></cf_textarea>
	
	<cfelse>
		
		<cf_textarea name="FieldDocument#no#" height="480" allowedContent = "yes">
				<cfoutput><cf_paragraph>#text#</cf_paragraph></cfoutput>
		</cf_textarea>	
			
	
	</cfif>
				  		   
	  <!--- height is automatically been assigned height = "#client.height#-300"	--->
	 
	  <input type="hidden" name="margintop"    id="margintop"    value="#doc.DocumentMarginTop#">
	  <input type="hidden" name="marginbottom" id="marginbottom" value="#doc.DocumentMarginBottom#">
	
  <cfelse>  
  
	  <table width="100%" height="100%" border="0" class="formpadding" cellspacing="0" cellpadding="0">
	  
	  <tr>
	     <td class="labellarge" height="24"><b>Header (PDF only)</td>
		 <td class="labelit" align="right">Margin:<select name="margintop" id="margintop" class="regularxl">
			 <cfloop index="m" from="0.5" to="5" step="0.5">
			     <option value="#m#" <cfif doc.DocumentMarginTop eq m>selected</cfif>>#m#</option>
	    	  </cfloop>
	     </td>
	  </tr>
	  
	  <tr><td colspan="2">
	  
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
	  
	  </td></tr>
	  
	  <tr><td height="1" colspan="2" class="linedotted"></td></tr> 
	  
	  <tr>
	     <td class="labellarge" height="24"><b>Footer (PDF only)</td>
		 <td class="labelit" align="right">Margin:<select name="marginbottom" id="marginbottom" class="regularxl">
			 <cfloop index="m" from="0.5" to="5" step="0.5">
			     <option value="#m#" <cfif doc.DocumentMarginBottom eq m>selected</cfif>>#m#</option>
	    	  </cfloop>
	     </td>
	  </tr>
	  
	  <tr><td height="1" colspan="2" class="linedotted"></td></tr> 
	    
	  <tr><td colspan="2">

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
	  
	  </td></tr>	
	    
	  </table>
  
  </cfif>	
  
</cfoutput>  

<cfset ajaxonload("initTextArea")>				

<!-- </cfform>	-->	