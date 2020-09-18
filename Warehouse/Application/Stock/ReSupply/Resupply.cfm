<!--- Query returning detail information for selected item --->

<cfoutput>

<!--- capture for next time --->

<cfparam name="session.mysupply.category" default="">
<cfparam name="session.mysupply.programcode" default="">

<cfset client.stmenu = "stockresupply('s','#url.systemfunctionid#')">

<table width="100%" style="height:100%">

<tr>
<td valign="top" height="100%"> 	 

	<cf_LanguageInput
		TableCode       = "Ref_ModuleControl" 
		Mode            = "get"
		Name            = "FunctionName"
		Key1Value       = "#url.SystemFunctionId#"
		Key2Value       = "#url.mission#"				
		Label           = "Yes">
	
	  <form name="criteria" method="post" style="height:100%" onsubmit="return false">

	  <table width="100%" height="100%" align="center" align="center">		
	  
	  <tr class="line">
	    <td class="labelmedium" style="height:25px;font-size:18px">
		<table width="100%">
		<tr>
		<td style="font-size:18px"><a href="javascript:$('##filter').toggle();"><font size="2"><cf_tl id="Filter"></font></a>&nbsp;#lt_content#</td>		
		</tr>
		</table>
		</td>
	  </tr>  
	  
	  	  <cfquery name="get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      Warehouse
				WHERE     Warehouse   = '#URL.warehouse#'				
			</cfquery>
	        
	  <tr id="filter">
	    <td height="40"> 	 
				
		  <table width="100%" border="0" align="center" class="formpadding">
		
			<input type="hidden" name="mission"   id="mission"   value="#URL.mission#">	
			<input type="hidden" name="warehouse" id="warehouse" value="#URL.warehouse#">			
			<input type="hidden" name="tratpe"    id="tratpe"    value="#URL.id#">		
					
			 <TR class="line"> 
			 
			 <cfquery name="Program" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				   SELECT * 
				   FROM   Program
				   WHERE  ProgramClass = 'Project'
				   AND    Mission = '#url.mission#'
				   ORDER BY Created DESC	   
				</cfquery>		
			 
			<TD valign="top" style="padding-top:5px" class="labelmedium">
			
			<table border="0" class="formpadding formspacing">
			
			<tr class="line">
			
			<cfif get.ModeSetItem eq "Category">
			
				  <cfquery name="CategorySelect" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    DISTINCT R.*
					FROM      Ref_Category R INNER JOIN
			                  WarehouseCategory W ON W.Category = R.Category
					WHERE     W.Warehouse   = '#URL.warehouse#'
					AND       W.Operational = 1		
					AND       R.Operational = 1					
					ORDER BY  Description
				</cfquery>
				
			<cfelseif get.ModeSetItem eq "Location">	
			
				  <cfquery name="CategorySelect" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    R.*
					FROM      Ref_Category R 
					WHERE     Category IN (SELECT ItemCategory 
					                       FROM   ItemTransaction 
										   WHERE Warehouse = '#url.warehouse#')				
					AND       R.Operational = 1					
					ORDER BY  Description
				</cfquery>
			
			<cfelse>
						  
				  <cfquery name="CategorySelect" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    DISTINCT R.*
					FROM      Ref_Category R INNER JOIN
			                  Item I ON R.Category = I.Category INNER JOIN
			                  ItemWarehouse W ON I.ItemNo = W.ItemNo
					WHERE     W.Warehouse   = '#URL.warehouse#'
					AND       I.ItemClass   = 'Supply'
					ORDER BY  Description
				</cfquery>
			
			</cfif>
					 
	         <TD class="labelmedium">
				  <table>
				  <tr class="line"><td style="font-size:10px"><cf_tl id="Category"></TD></tr>
				  <tr>
		        
		          <td align="left" valign="top" style="padding-left:3px;padding-top:3px">
				    			
				    <select name="category" id="category" style="border:0px;width:300px;height:105px" class="regularxl" multiple onchange="ptoken.navigate('#session.root#/Warehouse/Application/Stock/Resupply/getCategoryItem.cfm','subcategory','','','POST','criteria')">						
						<cfloop query="CategorySelect">
						<option value="'#Category#'" <cfif find(category,session.mysupply['category'])>selected</cfif>>#Description#</option>
						</cfloop>
					</select>
					
			  	  </td>				
				  </tr>
				  </table>			
			 </td>  	
			 
			 <TD class="labelmedium" valign="top">
				  <table height="100%">
				  <tr class="line"><td valign="top" style="height:10px;font-size:10px"><cf_tl id="Sub Category"></TD></tr>
				  <tr>
		        
		          <td align="left" valign="top" style="width:310px;padding-left:3px;padding-top:3px" id="subcategory">
				    
					<!---			
				    <select name="category" id="category" style="width:300px;height:105px" class="regularxl" multiple 
					    onChange="resupply('s','#url.systemfunctionid#',document.getElementById('restocking').value)">
						
						<cfloop query="CategorySelect">
						<option value="'#Category#'" <cfif find(category,session.mysupply['category'])>selected</cfif>>#Description#</option>
						</cfloop>
					</select>
					--->
					
			  	  </td>				
				  </tr>
				  </table>			
			 </td>  	
			 
			 
		
			 
			 <cfif Program.recordcount gte "1" and get.SupplyWarehouse eq "">
			<td>
			
				<table>
				<tr class="line"><td style="font-size:10px"><cf_tl id="Program"></TD></tr>
				<tr>
		        <td align="left" valign="top" style="padding-top:3px">
				   			
				    <select name="programcode" id="programcode" style="border:0px;width:300px;height:105px" multiple class="regularxl">
						
						<cfloop query="Program">
						<option value="'#ProgramCode#'" <cfif find(programcode,session.mysupply['programcode'])>selected</cfif>>#ProgramName#</option>
						</cfloop>
					</select>
			  	</td>				
				</tr>
				</table>							
			</td>
			</cfif>      
	
	        </TR>
			
							
			<tr> 			
			<td colspan="3" style="padding-left:4px">
			 
				 <table>
					 <tr>	
					 
					 <TD align="left" class="labelmedium"><cf_tl id="Restock through">:</TD>
			         <td colspan="1" align="left" style="padding-left:3px">
					  
					    <table cellspacing="0" cellpadding="0">
						<tr>						
						<td>
					    <input type="radio" name="restockingselect" id="restockingselect" value="Warehouse" checked class="radiol">
						</td>
						<td class="labelmedium" style="padding-left:4px"><cf_tl id="Internal"></td>
						<cfif get.SupplyWarehouse eq "">
							<td style="padding-left:4px">			
						    <input type="radio" name="restockingselect" id="restockingselect" value="Procurement" checked class="radiol">
							</td>				
							<td class="labelmedium" style="padding-left:4px"><cf_tl id="Procurement"></td>
						</cfif>						
						</tr>
						</table>
						
						<cfif get.SupplyWarehouse eq "">
							<input type="hidden" name="restocking" id="restocking" value="Procurement">
						<cfelse>
						    <input type="hidden" name="restocking" id="restocking" value="Warehouse">
						</cfif>	
						
				  	</td>		
					
					<td style="padding-left:10px">			
					<cf_tl id="Apply filter" var="1">
					<cfoutput>
						<input type="button" name="apply" style="width:200px;height:25px;font-size:13px" class="button10g" value="#lt_text#" onclick="resupply('s','#url.systemfunctionid#',document.getElementById('restocking').value)">
					</cfoutput>				
					</td>		
					<td align="left" style="padding-left:5px"><input type="checkbox" name="refreshcontent" id="refreshcontent" value="1" class="radiol"></td>	
					<TD style="padding-left:5px" class="labelmedium"><cf_uitooltip tooltip="Refresh listing with NEW items that were recorded since"><cf_tl id="Refresh content"></cf_uitooltip></TD>			   			
				
										 			 
					</tr>
								
				 </table>
				 
			</td>			 
			</tr>
												
			</table>
			
			</td></tr>
									
			</table>
						
		</td>
	</tr>
	
	<tr>
		<td colspan="3" valign="top" height="100%" id="subbox" bgcolor="ffffff"></td>	
	</tr>
	
	</table>
	
	</form>
 	 	
</td>
 
</tr>
</table>
	
</cfoutput>		
