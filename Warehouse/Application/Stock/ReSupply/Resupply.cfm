<!--- Query returning detail information for selected item --->

<cfoutput>

<!--- capture for next time --->

<cfparam name="session.mysupply.category" default="">
<cfparam name="session.mysupply.programcode" default="">

<cfset client.stmenu = "stockresupply('s','#url.systemfunctionid#')">

<table width="100%" style="height:99.5%">

<tr>
<td valign="top" height="100%" style="padding:3px"> 	 

<cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.SystemFunctionId#"
	Key2Value       = "#url.mission#"				
	Label           = "Yes">
	
	  <form name="criteria" method="post" style="height:100%">

	  <table width="100%" height="100%" align="center" align="center">		  
	        
	  <tr>
	    <td height="40"> 	 
				
		  <table width="100%" border="0" align="center" class="formpadding">
		
			<input type="hidden" name="mission"   id="mission"   value="#URL.mission#">	
			<input type="hidden" name="warehouse" id="warehouse" value="#URL.warehouse#">			
			<input type="hidden" name="tratpe"    id="tratpe"    value="#URL.id#">		
					
			 <TR> 
			 
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
			 
			<TD valign="top" style="padding-top:5px" class="labelmedium"><cf_tl id="Program">:</TD>
	        <td align="left" valign="top" style="padding-top:3px">
			   			
			    <select name="programcode" id="programcode" style="width:300px;height:105px" multiple class="regularxl" 
				    onChange="resupply('s','#url.systemfunctionid#',document.getElementById('restocking').value)">
					
					<cfloop query="Program">
					<option value="'#ProgramCode#'" <cfif find(programcode,session.mysupply['programcode'])>selected</cfif>>#ProgramName#</option>
					</cfloop>
				</select>
		  	</td>			
	                  		
			<input type="hidden" name="restocking" id="restocking" value="">
			  
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
				ORDER BY Description
			</cfquery>
					 
	          <TD valign="top" style="padding-top:5px" class="labelmedium"><cf_tl id="Category">:</TD>
	          <td align="left" valign="top" style="padding-top:3px">
			    			
			    <select name="category" id="category" style="width:300px;height:105px" class="regularxl" multiple 
				    onChange="resupply('s','#url.systemfunctionid#',document.getElementById('restocking').value)">
					
					<cfloop query="CategorySelect">
					<option value="'#Category#'" <cfif find(category,session.mysupply['category'])>selected</cfif>>#Description#</option>
					</cfloop>
				</select>
				
		  	  </td>		
			  	  	   
	        </TR>
			
			  <cfquery name="get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      Warehouse
				WHERE     Warehouse   = '#URL.warehouse#'				
			</cfquery>
							
			<tr class="line"> 
			 
			 <TD align="left" valign="top" style="padding-top:5px" class="labelmedium"><cf_tl id="Restock through">:</TD>
	         <td colspan="1" align="left" valign="top" style="padding-top:3px;padding-left:3px">
			  
			    <table cellspacing="0" cellpadding="0">
				<tr>
				
				<td>
			    <input type="radio" name="restockingselect" id="restockingselect" value="Warehouse" checked class="radiol" onclick="document.getElementById('restocking').value='Warehouse';resupply('s','#url.systemfunctionid#','Warehouse')">
				</td>
				<td class="labelmedium" style="padding-left:4px"><cf_tl id="Internal"></td>
				<cfif get.SupplyWarehouse eq "">
					<td style="padding-left:4px">			
				    <input type="radio" name="restockingselect" id="restockingselect" value="Procurement" checked class="radiol" onclick="document.getElementById('restocking').value='Procurement';resupply('s','#url.systemfunctionid#','Procurement')">
					</td>				
					<td class="labelmedium" style="padding-left:4px"><cf_tl id="Procurement"></td>
				</cfif>
				</tr>
				</table>
				
		  	  </td>		
			  
			   <TD class="labelmedium"><cf_tl id="Refresh content">:</TD>
	           <td align="left" valign="top" style="padding-top:3px">
			    <input type="checkbox" name="refreshcontent" id="refreshcontent" value="1" class="radiol" onclick="resupply('s','#url.systemfunctionid#','Procurement')">
				
			   </td>
			  
			 </tr>
													
			</table>
						
		</td>
	</tr>
	
	<TR>
		<td colspan="3" valign="top" height="100%" id="subbox" bgcolor="ffffff"></td>	
	</tr>
	
	</table>
	
	</form>
 	 	
</td>
 
</tr>
</table>
	
</cfoutput>		
