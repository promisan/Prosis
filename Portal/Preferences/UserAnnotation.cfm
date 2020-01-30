
<table width="91%" cellspacing="0" id="tableprocess" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>
	
	<tr><td colspan="2"><font size="4"><cf_tl id="Manage Annotation Categories (up to 10)"></b></font></td></tr>
	<tr><td height="10"></td></tr>
   
	<tr><td height="4"></td></tr>
		
	<cfquery name="List" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   UserAnnotation
		WHERE  Account = '#SESSION.acc#'
		ORDER BY ListingOrder
	</cfquery>	
			
	<cfquery name="Last" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT Max(ListingOrder)+1 as Last
	    FROM   UserAnnotation
		WHERE  Account = '#SESSION.acc#'
	</cfquery>
	
	<cfif Last.last eq "">	
	  <cfset lst = "1">	  
	<cfelse>	
	  <cfset lst = last.last>	    
	</cfif>
	
	<cfparam name="URL.ID2" default="new">
	
	<tr><td height="4" colspan="2">

	<cfform 
   		method="POST" 
		name="element" id="element">					
			
	<table width="450" border="0" cellspacing="0" cellpadding="0" class="formpadding navigation_table">
	  				
				<cfif list.recordcount eq "0">			
				     <cfset url.id2 = "new">				 
				</cfif>  
				
			    <TR class="linedotted labelmedium">
				   <td width="30">S</td>			  
				   <td width="70%"><cf_tl id="Description"></td>
				   <td align="center" width="50"><cf_tl id="Color"><cf_space spaces="20"></td>				 
				   <td width="30" align="center"><cf_tl id="Active"></td>
				   <td width="40" colspan="2" align="right" style="padding-left:10px">
			       <cfoutput>
					 <cfif URL.ID2 neq "new" and list.recordcount lt 6>
					     <a href="javascript:pref('UserAnnotation.cfm?id2=new')" title="Add new category">
						 <font color="6688aa"><cf_tl id="add"></a>
					 </cfif>
					 </cfoutput>
				   </td>		  
			    </TR>										
					
			<cfoutput>
			
			<cfloop query="List">
			
				<cfset id = AnnotationId>					
				<cfset de = Description>
				<cfset ls = ListingOrder>
				<cfset op = Operational>
																									
				<cfif URL.ID2 eq id>		
								  														
					<TR class="linedotted labelmedium navigation_row">
						<td height="22">
						
					   	<cfinput type="Text"
						       name="ListingOrder"
						       value="#ls#"
							   class="regularxl"
						       validate="integer"
						       required="Yes"
							   message="Please enter an order value" 
						       visible="Yes"
						       enabled="Yes"					      
						       size="2"
						       maxlength="2"
							   style="text-align:center;width:34">
					   			   
					   </td>
					 
					   <td style="padding-left:1px">
					   
					   	   <cfinput type="Text" 
						   	value="#de#" 
							name="Description" 
							message="You must enter a description" 
							required="Yes" 
							size="30" 							
							maxlength="50" 
							class="regularxl">
					  
			           </td>					  
					   <td>					   	
						<cf_input name="color" type="colorPicker" palette="basic" ajax=true value="#color#">					   				     
					   </td>
					   <td align="center">
					      <input type="checkbox" class="radiol" name="Operational" value="1" <cfif "1" eq op>checked</cfif>>
						</td>
					   <td colspan="2" align="right" style="padding-right:2px">
					  	<cfoutput>
					   	<input type="button" onclick="ptoken.navigate('#SESSION.root#/Portal/Preferences/UserAnnotationSubmit.cfm?id2=#url.id2#','tableprocess','','','POST','element') " class="button10g" value="Save" style="height:23;width:45">
						</cfoutput>
					   </td>
				    </TR>	
																
				<cfelse>
							
					<TR class="linedotted labelmedium navigation_row">
					   <td style="padding-left:2px">#ls#.</td>					 
					   <td style="padding-left:4px">#de#</td>				   
					  
					   <td height="20" align="center">
					   
						   <table height="16" width="17" cellspacing="0" cellpadding="0" bordercolor="gray">
						   		<tr><td style="border:1px solid gra;border-radius:9px" bgcolor="#color#"></td></tr>
						   </table>
					   
					   </td>
					   <td align="center"><cfif op eq "1"><cf_tl id="Yes"></cfif></td>	
					   
					   <td align="right" style="padding-top:4px padding-left:7px">
					   				   
							<cf_img icon="edit" navigation="yes" onclick="pref('UserAnnotation.cfm?ID2=#id#')">					       
						   
					   </td>
					   
					   <td align="center"  style="padding-top:2px">					    
							<cf_img icon="delete" onclick="pref('UserAnnotationPurge.cfm?ID2=#id#')">					       						  
					    </td>
						
					 </TR>					
							
				</cfif>
							
			</cfloop>
			
			</cfoutput>
														
			<cfif URL.ID2 eq "new">			
						
				<TR>
				
				<td>				
				   <cfinput type="Text" 
					      name="ListingOrder" 
						  message="You must enter an order" 
						  required="Yes" 
						  size="2" 
						  style="text-align:center;width:34"
						  value="#lst#"
						  validate="integer"
						  class="regularxl"					  
						  maxlength="2">					  
				</td>						
				<td style="padding-left:4px">					  
				   	<cfinput type="Text" 
					       name="Description" 
						   message="You must enter a name" 
						   required="Yes" 
						   size="40" 
						   maxlength="50" 
						   class="regularxl">							 
				</td>							
				<td align="center"><cf_input name="color" type="colorPicker" palette="basic" ajax="true"></td>						
				<td align="center">
					<input type="checkbox" class="radiol" name="Operational" value="1" checked>
				</td>									   
				<td colspan="2" align="center" style="padding-right:2px">		
					<cfoutput>
					<input class="button10g" type="button" onclick="ptoken.navigate('#SESSION.root#/Portal/Preferences/UserAnnotationSubmit.cfm?id2=#url.id2#','tableprocess','','','POST','element')" value="Add" style="height:24px;width:40px;">								
					</cfoutput>		
				</td>			    
				
			</TR>	
												
			</cfif>			
	
		 
	 <cfif url.id2 neq "new" and list.recordcount lt 6>
	 <tr>
		 <td colspan="6" align="center" height="25" class="labelmedium">	
		 <cfoutput>			 
		     <a href="javascript:pref('UserAnnotation.cfm?id2=new')" title="Add new category">
			 	<font color="6688aa">Add a new category</font>
			 </a>						
		 </cfoutput>	
		 </td>
	 </tr>		
	 </cfif>			
	 
	</table>	

	</cfform>
	
</td></tr>	
	
</table>	

<script>
	Prosis.busy('no');	
</script>

<cfset ajaxOnload("doHighlight")>

<cfset AjaxOnLoad("ProsisUI.doColor")> 