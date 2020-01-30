
<!-- show the annotation colors --->

<cfparam name="attributes.annotationid"  default="">
<cfparam name="attributes.OnChange"      default="">

<cfquery name="List" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   UserAnnotation
		WHERE  Account = '#SESSION.acc#'
		ORDER BY ListingOrder
	</cfquery>	

	
<table cellspacing="0" cellpadding="0">
<cfoutput>
<input type="hidden" name="annotationsel" id="annotationsel" value="#attributes.annotationid#">

<tr>

	<td>
	
	 <input type="radio" 
     		onclick="document.getElementById('annotationsel').value='';#attributes.onchange#" 
		 	name="AnnotationFilter" 
			id="AnnotationFilter"
			style="width:14px;height:14px"
		 	value="" checked>
	 
	</td>
	 
	<td onclick="document.getElementById('annotationsel').value='';#attributes.onchange#" style="padding-left:3px" class="labelit">

		Any
		
	    <!---
		<cfloop query="List">
		
			<td onclick="document.getElementById('annotationsel').value='#annotationid#';#attributes.onchange#" style="cursor:pointer">
	
			   <table border="1" height="14" width="5" cellspacing="0" cellpadding="0" bordercolor="gray">
		   			<tr> <cf_UIToolTip  tooltip="#Description#"><td bgcolor="#color#"></td></cf_UIToolTip></tr>
			   </table>
	
	   		</td>
			
		</cfloop>	
		--->
	
	</td>
		
	<td>&nbsp;|&nbsp;</td>
	 
	<cfloop query="List">
			 
	<td>	 
	
	     <input type="radio" 
	     onclick="document.getElementById('annotationsel').value='#annotationid#';#attributes.onchange#" 
		 name="AnnotationFilter" 
		 id="AnnotationFilter" style="width:14px;height:14px"
		 value="#annotationid#" <cfif attributes.annotationid eq annotationid>checked</cfif>></td>
		 
		 <td>&nbsp;</td>
	
		<td onclick="document.getElementById('annotationsel').value='#annotationid#';#attributes.onchange#" style="cursor:pointer">
	
	   <table height="13" width="14" cellspacing="0" cellpadding="0">
		   		<tr> <cf_UIToolTip  tooltip="#Description#"><td style="border:1px solid silver" bgcolor="#color#"></td></cf_UIToolTip></tr>
	   </table>
	
	   </td>
	   
	<td>&nbsp;&nbsp;|&nbsp;</td>	

	</cfloop>
	
	<td>
	
	 <input type="radio" 
     		onclick="document.getElementById('annotationsel').value='none';#attributes.onchange#" 
		 	name="AnnotationFilter"
			id="AnnotationFilter" 
		 	value="none" <cfif attributes.annotationid eq "none">checked</cfif>>
	 
	</td>
	<td>&nbsp;</td>	
	<td onclick="document.getElementById('annotationsel').value='none';#attributes.onchange#">
	
	 <table border="0" height="13" width="14" cellspacing="0" cellpadding="0">
		   		<tr> <cf_UIToolTip  tooltip="Not classified"><td style="border:1px solid silver" bgcolor="white"></td></cf_UIToolTip></tr>
	   </table>
	
	</td>
	

</cfoutput>	
</tr>
</table>
