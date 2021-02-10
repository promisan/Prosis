
<cfquery name="Line" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*
    FROM   Ref_ModuleControl L
	WHERE  SystemFunctionId = '#URL.ID#'
</cfquery>

<cfform style="height:100%" method="POST" name="entry">
	
	<cfoutput>
	
	 <table width="100%" height="100%" align="center">
	 
	 		<tr class="hide"><td id="process"></td></tr>
							
			<tr class="line"><td valign="top" height="100%" style="padding-left:20px;padding-right:10px">			

				<cf_textarea 
					 name="FunctionInfo"  		          
					 height="90%"					 				 		 
					 color="ffffff"
					 init = "No"
					 toolbar="mini"					 
					 resize="true">#Line.FunctionInfo#</cf_textarea>
				 
				 </td>
			 </tr>			
				
			 <tr><td height="35" style="height:40px" align="center">
							     
				  <input style="width:190px;height:28px;font-size:14px;padding:4px"
				     class="button10g" 
					 onclick="updateTextArea();ColdFusion.navigate('FunctionMemoSubmit.cfm?systemfunctionid=#url.id#','process','','','POST','entry')" 
					 type="button" 
					 name="update" 
					 id="update" 
					 value ="Apply">
				  
				 </td>
			 </tr>
																  
	</table> 	
	
	</cfoutput>

</cfform>	

<cfset ajaxonload("initTextArea")>

	
