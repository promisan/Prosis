
<cfparam name="url.access" default="edit">
<cfparam name="url.myform" default="lineform">
<cfset table = "stInvoiceIncomingLine">

<cfquery name="Check" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Invoice 
	WHERE  InvoiceId = '#URL.Id#'
</cfquery>

<cfparam name="URL.access" default="EDIT">

<cfquery name="Detail" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   #table# 
	WHERE InvoiceId = '#URL.Id#'	
</cfquery>

<cfquery name="Total" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT sum(LineAmount) as Total
    FROM   #table# 
	WHERE InvoiceId = '#URL.Id#'		
</cfquery>
		
<cfif Detail.recordcount eq "0">
   <cfparam name="URL.ID2" default="new">
<cfelse>
   <cfparam name="URL.ID2" default="">   
</cfif>

<cfif url.myform eq "lineform">
	
	<form name="lineform" id="lineform">
	
</cfif>

	<table width="100%" height="100%" class="formpadding">
	
	  <tr><td height="8"></td></tr>	 
	  
	  <tr>
	    <td width="95%" align="center" valign="top" style="padding:14px">
	    <table width="96%" align="center">
					
		    <tr class="labelmedium">
			 
			 <td colspan="2" width="80%"><cf_tl id="Description"> 
			     <cfoutput>
				 <cfif URL.ID2 neq "new" and url.access eq "Edit">
				     <A href="javascript:ptoken.navigate('#SESSION.root#/procurement/application/invoice/InvoiceEntry/InvoiceEntryLine.cfm?myform=#url.myform#&tax=#url.tax#&mission=#url.mission#&ID=#URL.ID#&ID2=new','linedetail')">[add]</a>
				 </cfif>
			   </cfoutput>
		     </td>     
			 <td width="21%"><cf_tl id="Reference"></td>		
			 <td width="80"><cf_tl id="Amount"></td>	 
			  
		    </TR>			
			
			<cfif URL.ID2 eq "new" and url.access eq "Edit">
							
				<TR>
							
				<td colspan="2" style="padding: 2px;">
				
				  	 <input type="text"
				    	  name="linedescription"
						  id="linedescription"
					      style="width:100%"
					      maxlength="100"
					      class="regularxl enterastab"
				    	  message="You must enter a description">
						  
		        </td>
				
				<td style="padding: 2px;">
				
						<input type="text" 
					      name="linereference" 
						  id="linereference"
						  style="width:100%"
						  maxlength="20" 
						  class="regularxl enterastab"						  
				    	  message="You must enter a description">
						  
			    </td>	
				  			   
				<td align="right" style="padding: 2px;">
				
				   	   <input type="Text"
					       name="lineamount"	
						   id="lineamount"
						   value="0"		
						   style="text-align: right;"      
					       validate="float"
					       required="Yes"
					       style="width:100%"
					       maxlength="10"
					       class="regularxl enterastab">
					   
		           </td>
				   			    
				</TR>	
				
				<tr><td colspan="4" style="padding: 2px;">
				
						<cfoutput>
							<cf_assignid>		
					        <input type="hidden" name="InvoiceLineId" id="InvoiceLineId" value="#rowguid#">
							<cfset access = "edit">									
							<cfset url.lineid = rowguid>
							<cfinclude template="InvoiceEntryLineAttachment.cfm">	
						</cfoutput>
				</td></tr>
				
				<tr>
					<td colspan="4" height="34" align="center">
								
					  <cfoutput>
					  
					  <cf_tl id="Apply" var="1">
					
						<input type="button"
						  onclick="ptoken.navigate('#SESSION.root#/procurement/application/invoice/InvoiceEntry/InvoiceEntryLineSubmit.cfm?myform=#url.myform#&tax=#url.tax#&mission=#url.mission#&ID=#URL.ID#&ID2=new','documentamounttotal','','','POST','#url.myform#')"
						  value="#lt_text#" 
						  style="width:100"						 
						  class="button10g">
				
					 </cfoutput> 			
					
					</td>
				</tr>		
				
				<tr><td colspan="4" height="1" class="line"></td></tr>	
			
			</cfif>	
						
			<cfoutput query="Detail">								
			
																	
			<cfif URL.ID2 eq invoicelineid>
			
				<tr><td height="2"></td></tr>
			    
					<input type="hidden" name="ID" id="ID" value="<cfoutput>#url.id#</cfoutput>">
													
				<TR>
				
				   <td style="padding: 2px;" width="30">#currentrow#.</td>
				  
				   <td style="padding: 2px;" width="80%">
				   	   <input type="Text" 
					    value="#Linedescription#" 
						name="linedescription" 
						ID="linedescription"
						style="width:100%"
						maxlength="100" 
						class="regularxl enterastab">
		           </td>
				   
				   <td style="padding: 2px;">
				   	   <input type="Text" 
					     value="#LineReference#" 
						 name="linereference" 
						 id="linereference"
						 style="width:100%"
						 maxlength="20" 
						 class="regularxl enterastab">
		          </td>		
				  			  
				  <td align="right" style="padding: 2px;">
				  
				   	   <input type="Text"
					       name="lineamount"
						   id="lineamount"
						   style="text-align: right;" 
					       value="#LineAmount#"			      
					       required="Yes"
						   style="width:100%"			      
					       maxlength="10"
					       class="regularxl enterastab">
						   
		          </td>				  		  	 
				  
			    </TR>	
				
				<tr><td colspan="4">
				
				     <cfset access = "edit">	
					 <cfset url.lineid = url.id2>				
					 <cfinclude template="InvoiceEntryLineAttachment.cfm">	
				
				</td></tr>
				
				<tr class="line">
				
				<td align="center" colspan="4" height="27">
				  
				   <cf_tl id="Apply" var="1">
				   
					   <input type="button" 
						    value="#lt_text#" 
							style="width:180;height:23px"
						    class="button10g"
						    onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/procurement/application/invoice/InvoiceEntry/InvoiceEntryLineSubmit.cfm?myform=#url.myform#&tax=#url.tax#&mission=#url.mission#&ID=#URL.ID#&ID2=#url.id2#','documentamounttotal','','','POST','#url.myform#')">
							
					</td>
				
				</tr>
										
			<cfelse>
			
				<TR class="labelmedium line">
				
					 <td width="40" align="center">
					 
						 <table>
						 <tr class="labelmedium">
						 <td style="padding: 2px;">#currentrow#.</td>
						 				 
						 <cfif url.access eq "Edit">
							<td style="padding-top:2px;padding-left:3px;">						
								<cf_img icon="edit" onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/procurement/application/invoice/InvoiceEntry/InvoiceEntryLine.cfm?myform=#url.myform#&tax=#url.tax#&mission=#url.mission#&ID=#URL.ID#&ID2=#InvoiceLineId#','linedetail')">
							</td>
							<td style="padding-left:2px;padding-top: 2px;">								
								 <cf_img icon="delete"   onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/procurement/application/invoice/InvoiceEntry/InvoiceEntryLineSubmit.cfm?myform=#url.myform#&tax=#url.tax#&action=delete&mission=#url.mission#&ID=#URL.ID#&ID2=#InvoiceLineId#','documentamounttotal')">						  
							 </td>	 
							 
							</cfif>	  
							</tr> 
						 </table>
											
				    </td>
				  
				    <td height="20">#LineDescription#</td>			 
					<td>#LineReference#</td>								
					<td align="right">#numberformat(LineAmount,",.__")#</td>
				 
			    </TR>	
				
				<tr class="line"><td colspan="4">
						<cfset access = "view">		
						<cfset url.lineid = invoicelineid>											
						<cfinclude template="InvoiceEntryLineAttachment.cfm">	
				</td></tr>
				
			</cfif>
					
			</cfoutput>
			
			<cfif url.myform eq "lineform">
			
				<cfif Total.Total neq "">
				
				<tr class="labelmedium line">
				   <td height="20"><cf_tl id="Total"></td>
				   <td></td>
				   <td></td>
				   <td align="right"><cfoutput>#numberformat(total.total,",.__")#</cfoutput></td>
				   <td></td>
				</tr>
							
			</cfif>				
			
			</cfif>
						
		</table>
		</td>
		</tr>
								
	</table>

<cfif url.myform eq "lineform">
</form>	
</cfif>