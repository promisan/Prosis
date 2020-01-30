
<cfquery name="List" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_TransportTrack
	WHERE TransportCode = '#URL.Code#'	
	ORDER By TrackingOrder
</cfquery>

<cfquery name="Last" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Max(TrackingOrder)+1 as Last
    FROM  Ref_TransportTrack
	WHERE TransportCode = '#URL.Code#'	
</cfquery>

<cfif Last.last eq "">

  <cfset lst = "1">
  
<cfelse>

  <cfset lst = last.last>
    
</cfif>

<cfparam name="URL.ID2" default="new">
	
<cfform action="ListSubmit.cfm?Code=#URL.Code#&id2=#url.id2#" 
  		method="POST" 
		name="element">
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
				
		<cfif list.recordcount eq "0">
		  <cfset url.id2 = "new">
		</cfif>  
			
		    <TR height="18" class="line labelit">
			  
			   <td width="60%">Transportation Stage</td>
			   <td width="50">Sort</td>
			   <td width="30" align="center">Active</td>
			   <td colspan="2" align="right">
		       <cfoutput>
				 <cfif URL.ID2 neq "new">
				     <A href="javascript:ColdFusion.navigate('List.cfm?Code=#URL.Code#&ID2=new','#url.code#_list')">
					 <font color="0080FF">[add]</font></a>
				 </cfif>
				 </cfoutput>&nbsp;
			   </td>		  
		    </TR>
			<tr><td colspan="5" class="line"></td></tr>							
				
		<cfoutput>
		
		<cfloop query="List">
					
			<cfset nm = TrackingId>
			<cfset de = Description>
			<cfset ls = TrackingOrder>
			<cfset op = Operational>
																								
			<cfif URL.ID2 eq nm>		
			
			    <input type="hidden" name="TopicValueCode" id="TopicValueCode" value="<cfoutput>#nm#</cfoutput>">
													
				<TR>
				  
				   <td>
				   	   <cfinput type="Text" 
					   	value="#de#" 
						name="Description" 
						message="You must enter a description" 
						required="Yes" 
						size="60" 
						maxlength="60" 
						class="regular">
				  
		           </td>
				   <td height="22">
				   	<cfinput type="Text"
					       name="TrackingOrder"
					       value="#ls#"
						   class="regular"
					       validate="integer"
					       required="Yes"
						   message="Please enter an order value" 
					       visible="Yes"
					       enabled="Yes"
					       typeahead="No"
					       size="1"
					       maxlength="2"
						   style="text-align:center">
				   			   
				     </td>
				  
				   <td align="center">
				      <input type="checkbox" name="Operational" id="Operational" value="1" <cfif "1" eq op>checked</cfif>>
					</td>
				   <td colspan="2" align="right">
				   <input type="submit" 
				        value="Save" 
						class="button10s" 
						style="width:50">&nbsp;</td>
			    </TR>	
				
															
			<cfelse>
								
						
				<TR class="labelit linedotted" color="fcfcfc">
				   
				   <td>#de#</td>
				   <td>#ls#</td>
				   <td align="center"><cfif op eq "0"><b>No</b><cfelse>Yes</cfif></td>
				   <td align="right" style="padding-top:3px;">
				   		<cf_img icon="edit" onclick="ColdFusion.navigate('List.cfm?Code=#URL.Code#&ID2=#nm#','#url.code#_list');">
				   </td>
			   			   
				   <cfquery name="Check" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    	SELECT *
					    FROM  PurchaseTracking
						WHERE TrackingId = '#TrackingId#'
				   </cfquery>
				   
				   <td align="center" width="20" style="padding-top:3px;">
				     <cfif check.recordcount eq "0">
						   <cf_img icon="delete" onclick="ColdFusion.navigate('ListPurge.cfm?Code=#URL.Code#&ID2=#nm#','#url.code#_list');">
					 </cfif>	   
					  
				    </td>
					
				 </TR>	
				
			</cfif>
						
		</cfloop>
		</cfoutput>
													
		<cfif URL.ID2 eq "new">
		
					
			<TR>
									   
			    <td>
				   	<cfinput type="Text" 
				         name="Description" 
						 message="You must enter a name" 
						 required="Yes" 
						 size="50" 
						 maxlength="50" 
						 class="regular">
				</td>								 
				<td>
				   <cfinput type="Text" 
				      name="TrackingOrder" 
					  message="You must enter an order" 
					  required="Yes" 
					  size="1" 
					  style="text-align:center"
					  value="#lst#"
					  validate="integer"
					  class="regular"
					  maxlength="2">
				</td>
				
						
			<td align="center">
				<input type="checkbox" name="Operational" id="Operational" value="1" checked>
			</td>
								   
			<td colspan="2" align="right">
			<cfoutput>
			<input type="submit" 
				value="Add" 
				class="button10s" 
				style="width:50">
			&nbsp;
			</cfoutput>
			</td>			    
			</TR>	
								
											
		</cfif>								
</table>		
						

</cfform>
