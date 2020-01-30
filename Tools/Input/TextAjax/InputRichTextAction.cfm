
<cfparam name="url.keyvalue"   default="FCA625C6-508B-6D75-2177-29DC1951AE5D">
<cfparam name="url.mode"       default="FCA625C6-508B-6D75-2177-29DC1951AE5D">
 <cfoutput>	

	<cfquery name="Get" 
		datasource="#url.DataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		     SELECT #url.field#
		     FROM #url.TableName# 
			 WHERE #url.keyfield1# = '#url.keyvalue1#'
			 <cfif url.keyfield2 neq "">
			 AND   #url.keyfield2# = '#url.keyvalue2#' 
			 </cfif>
	</cfquery>	
	
	<cfif url.mode eq "Edit">
	
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="d0d0d0" class="formpadding">
						
		<cfform name="frm#url.name#" method="POST">
						
			<tr>
						
			<td width="100%">
			
			<cf_textarea name="fld#url.name#"
		         toolbaronfocus="No"
				 toolbar="Basic"
				 skin="silver"
		         richtext="Yes">
			
					#evaluate("get.#url.field#")#
								
				</cf_textarea>
				
			</td></tr>
			
			<tr><td bgcolor="silver"></td></tr>
			
			<tr><td align="center">
			
			<cfoutput>
			
			    <button type="button" 
			          name="View" id="View"
			          class="button10g" 
					  onclick="javascript:getformfield('view','#url.datasource#','#url.tablename#','#url.keyfield1#','#url.keyvalue1#','#url.keyfield2#','#url.keyvalue2#','#url.field#','#url.name#')">
				  
			 	    Cancel
				
				
			  </button>		
						
			<button type="button" 
			          name="Save" 	id="Save"		         
			          class="button10g" 
					  onclick="saveFormField('#url.datasource#','#url.tablename#','#url.keyfield1#','#url.keyvalue1#','#url.keyfield2#','#url.keyvalue2#','#url.field#','#url.name#')">
				  
			 	 <img src="#SESSION.root#/Images/save_template1.gif" align="absmiddle" alt="Save" border="0"> Save
								
			  </button>		
			  
								
			</td></tr>
			
			</cfoutput>
		
		  </cfform>
		
	<cfelse>
	
	<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="d5d5d5" class="formpadding">
	
	   <cfif url.mode eq "view">
			
		<tr><td valign="top" height="100%" bgcolor="ffffff" style="border-left: 1px solid Silver;">
						  
			  <button type="button" 
			          name="Save" id="Save"
			          style="width:21;height:21"
			          class="button3" 
					  onclick="javascript:getformfield('edit','#url.datasource#','#url.tablename#','#url.keyfield1#','#url.keyvalue1#','#url.keyfield2#','#url.keyvalue2#','#url.field#','#url.name#')">
				  				  
			 	 <img src="#SESSION.root#/Images/edit.gif" align="absmiddle" alt="Save" border="0">
							
			  </button>		
			  			   
			</td>
			
			<td style="border-left: 1px solid Silver;"></td>
	
		    <td width="100%" bgcolor="ffffff">
			
			#evaluate("get.#url.field#")#
			
		</td></tr>
		
		<cfelse>
		
		<tr>							
		   <td width="100%" bgcolor="ffffff">#evaluate("get.#url.field#")#</td>
		</tr>	
		
		</cfif>
		
	</table>	
	
	</cfif>
		
	
</cfoutput>	



