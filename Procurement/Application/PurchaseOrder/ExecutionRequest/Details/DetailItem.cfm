
<cfparam name="URL.access" default="EDIT">

<cfquery name="Detail" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   UserQuery.dbo.#SESSION.acc#ExecutionRequest_#client.sessionNo# 	
</cfquery>
		
<cfif Detail.recordcount eq "0">
   <cfparam name="URL.ID2" default="new">
<cfelse>
   <cfparam name="URL.ID2" default="">   
</cfif>
	
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	    
  <tr>
    <td width="100%" align="center">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formspacing">
				
	    <tr class="labelit">
		 <td height="16" width="10%"><cf_tl id="Qty"></td> 
		 <td width="10%"><cf_tl id="Code"></td>
		 <td width="60%"><cf_tl id="Name"></td>     		
		 <td align="right" width="10%"><cf_tl id="Amount"></td>	  		  
		 <td width="70" colspan="2" align="center">
	         <cfoutput>
			 <cfif URL.ID2 neq "new" and url.access eq "Edit">
			     <A href="javascript:ColdFusion.navigate('Details/DetailItem.cfm?ID2=new','iservice')"><font color="0080FF">[add]</font></a>			 
			 </cfif>
			 </cfoutput>
		 </td>
		 <td></td>		  
	    </TR>	
		
		<tr><td height="1" colspan="6" class="linedotted"></td></tr>
					
		<cfoutput query="Detail">								
														
		<cfif URL.ID2 eq serialNo>
														
			<TR bgcolor="white">
			  			    
			     <td>
				 
			   	   <input type="Text"
				       name="svcquantity"
				       value="#detailquantity#"
				       validate="float"
					   style="text-align:right;padding-right:1px"
				       required="Yes"
					   style="width:98%"
				       maxlength="6"
				       class="regularxl">
				   
	           </td>
			   <td>
			   
			   	   <input type="Text" 
				     value="#detailReference#" 
					 name="svcreference"
                     id="svcreference" 
					 style="width:98%"
					 maxlength="20" 
					 class="regularxl">
					 
	           </td>		
			   <td>
			   
			   	   <input type="Text" 
					    value="#detaildescription#" 
						name="svcdescription" 
	                    id="svcdescription"
						style="width:98%"
						maxlength="80" 
						class="regularxl">
	           </td>
			  
			  				
			    <td align="right">
				
			   	   <input type="Text"
				       name="svcrate"
	                   id="svcrate"
					   style="text-align: right;" 
				       value="#numberformat(DetailRate,'__,__.__')#"
				       validate="float"
				       required="Yes"
				       size="10"
				       maxlength="10"
				       class="regularxl">
					   
	           </td>			  	 
			   
			   <td align="right" colspan="2">
			   
			   <cf_tl id="Save" var="1">
			   
			   <input type="submit" 
			    value="#lt_text#" 
				style="width:45;height:25px"
			    class="button10g"
			    onclick="ColdFusion.navigate('Details/DetailItemSubmit.cfm?ID2=#url.id2#','iservice','','','POST','requestform')">
				
				</td>
		    </TR>	
					
		<cfelse>
		
			<TR class="labelmedium" bgcolor="white">
			    
				<td style="padding-left:4px">#DetailQuantity#</td>
				<td>#DetailReference#</td>	
			    <td>#DetailDescription#</td>							
				<td align="right">#numberformat(DetailRate,"__,__.__")#</td>				
				<td align="right"><!--- #numberformat(DetailAmount,"__,__.__")# ---></td>
												
			    <td align="center">
					
					<table cellspacing="0" cellpadding="0">
					<tr>
					<cfif url.access eq "Edit">					
						<td>						
							<cf_img icon="edit" onclick="ColdFusion.navigate('Details/DetailItem.cfm?ID2=#serialNo#','iservice')">
						</td>
						<td style="padding-left:5px">		
						  <cf_img icon="delete" onclick="ColdFusion.navigate('Details/DetailItemPurge.cfm?ID2=#serialNo#','iservice')">					  
						</td>					
					</cfif>	  
						  
					</tr>
					</table>	  
				
			  </td>
			   
		    </TR>	
			
			<tr><td height="1" colspan="8" style="border-bottom: 1px dotted Silver;"></td></tr>
		
		</cfif>
				
		</cfoutput>
									
		<cfif URL.ID2 eq "new" and url.access eq "Edit">
		
			<TR bgcolor="white">
			  			  			   
			    <td>
			   	   <input type="Text"
				       name="svcquantity"
	                   id="svcquantity"
				       value="1"
				       validate="float"
				       required="Yes"
					   style="width:40;text-align:right;padding-right:1px"		      
				       maxlength="6"
				       class="regularxl">
	           </td>
			   
			    <td>
			   	   <input type="Text"  name="svcreference" id="svcreference" style="width:98%" maxlength="20" class="regularxl">
	           </td>	
			   
			    <td>
			   	   <input type="text"
				       name="svcdescription"
                       id="svcdescription"
				       style="width:98%"
				       maxlength="80"
				       class="regularxl"
				       message="You must enter a description">
	           </td>
			 			   
			      <td align="right">
			   	   <input type="Text"
				       name="svcrate"
	                   id="svcrate"	
					   value="0"		
					   style="text-align: right;"      
				       validate="float"
				       required="Yes"
				       size="10"
				       maxlength="10"
				       class="regularxl">
	           </td>
			     	 
			  			  								   
			<td colspan="2" align="center">
			
			<cfoutput>
			
				<input type="button"
					  onclick="ColdFusion.navigate('Details/DetailItemSubmit.cfm?ID2=new','iservice','','','POST','requestform')"
					  value="Add" 
					  style="width:45;height:25"
					  class="button10g">
		
			 </cfoutput> 
			  
			 </td>
			    
			</TR>				
		
		</cfif>	
					
	</table>
	</td>
	</tr>
							
</table>