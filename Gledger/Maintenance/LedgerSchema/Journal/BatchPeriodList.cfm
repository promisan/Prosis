
<cfset alias = "appsledger">

<cfquery name="List" 
datasource="#alias#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     JournalBatch
	WHERE    Journal= '#URL.Journal#'	
	ORDER BY JournalBatchNo
</cfquery>

<cfquery name="Last" 
datasource="#alias#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT MAX(JournalBatchNo)+1 as Last
    FROM   JournalBatch
	WHERE  Journal= '#URL.Journal#'	
</cfquery>

<cfif Last.last eq "">

  <cfset lst = "1">
  
<cfelse>

  <cfset lst = last.last>
    
</cfif>

<cfparam name="URL.ID2" default="new">

<cfform action="BatchPeriodSubmit.cfm?alias=#alias#&journal=#URL.journal#&id2=#url.id2#" method="POST" name="element">
	
	<table width="96%" border="0" align="center" cellspacing="0" cellpadding="0" class="navigation_table formpadding">
	   				
			<cfif list.recordcount eq "0">
			  <cfset url.id2 = "new">
			</cfif>  
				
		    <TR class="line labelmedium2">
			   <td width="30">No</td>
			   <td width="50">Class</td>
			   <td width="60%">Description</td>
			   <!---
			   <td width="50">Def.</td>
			   --->
			   <td width="30" align="center">Active</td>
			   <td colspan="2" align="right">
		       <cfoutput>
				 <cfif URL.ID2 neq "new">
				     <A href="javascript:ColdFusion.navigate('BatchPeriodList.cfm?alias=#alias#&Journal=#URL.Journal#&ID2=new','list')">
					 [add]</a>
				 </cfif>
				 </cfoutput>
			   </td>		  
		    </TR>
						
					
			<cfoutput>
			
			<cfloop query="List">
						
				<cfset nm  = BatchCategory>
				<cfset de  = Description>
				<cfset ls  = JournalBatchNo>
				<cfset op  = Operational>
				<!---
				<cfset def = ListDefault>
				--->
																						
				<cfif URL.ID2 eq ls>			
													
				    <input type="hidden" name="ListCode" value="<cfoutput>#nm#</cfoutput>">
														
					<TR>
						<td height="22" style="padding-left:2px">
						
					   	<cfinput type="Text"
						       name="JournalBatchNo"
						       value="#ls#"
							   class="regularxxl"
						       validate="integer"
						       required="Yes"
							   message="Please enter a numeric value" 
						       visible="Yes"
						       size="4"
						       maxlength="6"
							   style="text-align:center">
					   			   
					   </td>
					   <td style="padding-left:2px">
					   
					     <cfinput type="Text" 
						   	value="#nm#" 
							name="BatchCategory" 
							message="You must enter a class" 
							required="Yes" 
							size="20" 
							style="width:95%"
							maxlength="20" 
							class="regularxxl">
					   
					   </td>
					   <td style="padding-left:2px">
					   
					   	   <cfinput type="Text" 
						   	value="#de#" 
							name="Description" 
							message="You must enter a description" 
							required="Yes" 
							size="60" 
							style="width:95%"
							maxlength="80" 
							class="regularxxl">
					  
			           </td>				  
					 
					   <td align="center" style="padding-left:2px">
					      <input type="checkbox" name="Operational" value="1" <cfif "1" eq op>checked</cfif>>
					   </td>
					   
					   <td colspan="2" align="right" style="padding-left:2px">
					      <input type="submit" 
					        value="Save" 
							class="button10g" 
							style="width:50px;height:25px">
						</td>
				    </TR>	
																				
				<cfelse>					
							
					<TR class="line labelmedium2 navigation_row">
					
					   <td>#ls#.</td>
					   <td>#nm#</td>
					   <td>#de#</td>				   
					   <!---
					   <td><cfif def eq "1">Yes</cfif></td>	
					   --->
					   <td align="center"><cfif op eq "0"><b>No</b><cfelse>Yes</cfif></td>
					   <td align="right">
					   
					   	<cf_img icon="edit" onclick="javascript:ptoken.navigate('BatchPeriodList.cfm?alias=#alias#&Journal=#URL.Journal#&ID2=#ls#','list')">
							
					   </td>
				   			   
					   <cfquery name="Check" 
						datasource="#alias#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    	SELECT *
						    FROM  TransactionHeader
							WHERE Journal = '#URL.journal#'	
							AND   JournalBatchNo = '#ls#'
					   </cfquery>
					   
					   <td align="left" style="padding-left:4px">
					   
					     <cfif check.recordcount eq "0">
						 
						       <cf_img icon="delete" onclick="ptoken.navigate('BatchPeriodPurge.cfm?alias=#alias#&journal=#URL.journal#&ID2=#ls#','list')">
							   
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
					      name="JournalBatchNo" 
						  message="You must enter an no" 
						  required="Yes" 
						  size="1" 
						  style="text-align:center;width:30"
						  value="#lst#"
						  validate="integer"
						  class="regularxxl"
						  maxlength="2">
						  
					</td>
					
					<td height="28" style="padding-left:2px">
					
						 <cfinput type="Text" 
						     value="" 
							 name="BatchCategory" 
							 message="You must enter a class" 
							 required="Yes" 
							 size="10" 
							 style="width:95%"
							 maxlength="20" 
							 class="regularxxl">
			        </td>	
					
					<td style="padding-left:2px">
					
						<cfinput type="Text" 
						     name="Description" 
							 message="You must enter a description" 
							 required="Yes" 
							 size="60" 
							 style="width:95%"
							 maxlength="80" 
							 class="regularxxl">
					</td>		
									
					<td align="center" style="padding-left:2px">
					  <input type="checkbox" name="Operational" value="1" checked>
					</td>
										   
					<td colspan="2" align="center">
					
						<cfoutput>
						
						<input type="submit" 
							value="Add" 
							class="button10g" 
							style="width:50;height:25">		
								
						</cfoutput>
					
					</td>		
						    
				</TR>	
													
			</cfif>			
								
	</table>
				
</cfform>							

