<cfquery name="ListElement" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM ClassFunctionElement
		WHERE ClassFunctionId = '#url.Id#' and ElementCode='#url.ElementCode#'
</cfquery>	

<cfoutput>
			
	
		<table width="100%" height="100%" bgcolor="f4f4f4" cellspacing="0" cellpadding="0" class="formpadding">
				
		<cfform method="post" 
		  name="classForm#url.elementcode#">

  		<tr>
		<td width="100%" style="border: 1px solid Silver;">
		
		  <cfTextarea 
		  		 name="T_#url.elementCode#" 				 			 
				 toolBar="Default" 	
				 toolbaronfocus="Yes"
				 tooltip="Comments,Relevant Information"			 
				 richtext="true" 
				 skin="silver">
		
		 		#ListElement.TextContent#
				
		  </cftextarea>		
		 </td> 
		 </tr>	
		 
		   <tr>
			<td  height="10" width="100%" align="center">
			<input type="submit" value=" Save " class="button10g" onclick = "javascript:save_text('#url.id#','#url.elementcode#','classForm#url.elementcode#')">
			</td>
		</tr>
		 
		 </cfform>
		 	
		</table>


</cfoutput>