
<cfparam name="url.box"              default="main">
<cfparam name="url.idmenu"           default="">
<cfparam name="url.systemfunctionid" default="#url.idmenu#">

<table width="98%" height="100%" align="center" class="formpadding">

	<!---
	
	<cfif url.idmenu eq "">
		
    <tr><td height="4"></td></tr>	
	<tr>
		<td height="67px">
			<table height="67px" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden" >												
				<tr>
					<td style="z-index:5; position:absolute; top:25px; left:37px; ">
						<img src="<cfoutput>#SESSION.root#</cfoutput>/images/batch.png" height="42">
					</td>
				</tr>							
				<tr>
					<td style="z-index:3; position:absolute; top:27px; left:90px; color:45617d; font-family:calibri,trebuchet MS; font-size:25px; font-weight:bold;">
						Maintain Locations
					</td>
				</tr>
				<tr>
					<td style="position:absolute; top:14px; left:90px; color:e9f4ff; font-family:calibri,trebuchet MS; font-size:40px; font-weight:bold; z-index:2">
						Maintain Locations
					</td>
				</tr>							
				<tr>
					<td style="position:absolute; top:55px; left:90px; color:45617d; font-family:calibri,trebuchet MS; font-size:12px; font-weight:bold; z-index:4">
						
					</td>
				</tr>							
			</table>
		</td>		
	</tr>	
	<tr><td height="4" class="line"></td></tr>	
	
	</cfif>
	
	--->
	
	<tr>
	
	    <td width="100%" id="listing">
							
					
			<cfparam name="url.id2" default="">	
			<cfparam name="form.operational" default="0">	
				
			<cfquery name="Warehouse" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  Warehouse
				WHERE Warehouse = '#URL.warehouse#'	
			</cfquery>
						
			<cfif url.idmenu neq "" or getAdministrator(warehouse.mission) eq "1">			
			
				<!--- called from maintenance function, so we have access --->			
				<cfset access = "ALL">											
				
			<cfelse>
			
				<!--- called from warehouse --->			
				<cfinvoke component = "Service.Access"  
				   method           = "RoleAccess" 
				   mission          = "#Warehouse.Mission#" 
				   role             = "'WhsPick'"
				   parameter        = "#url.systemfunctionid#"
				   returnvariable   = "accessright">	
				   				   
				   <cfif accessright eq "GRANTED">
				       <cfset access = "ALL">
				   <cfelse>
				   	   <cfset access = "NONE">
				   </cfif>
				   				   			
			</cfif>
						
			<table height="100%" width="99%" id="listbox" align="center">
					
				<cfif client.googleMAP eq "1">	
					
					<cfif Warehouse.Latitude neq "">		
					<cfoutput>	
					<tr>
						<td colspan="7" class="labelmedium" style="padding-left:4px;font-size:20px;height:39px" bgcolor="ffffff">
						<a href="javascript:ColdFusion.navigate('#SESSION.root#/Warehouse/Maintenance/WarehouseLocation/LocationMAP.cfm?mode=maintain&systemfunctionid=#url.systemfunctionid#&box=#url.box#&warehouse=#url.warehouse#&width='+listbox.clientWidth+'&height='+document.body.clientHeight,'#url.box#')">
						<font color="0080C0">Show Warehouse and Storage Locations in Google Maps
						</a>
						</td>
					</tr>	
					</cfoutput>					
					<tr><td height="1" colspan="7" bgcolor="e4e4e4"></td></tr>
					</cfif>		
					
				</cfif>
				
			    <TR height="21"  class="line labelmedium">
				   <td width="10"></td>
				   <td width="60"><cf_tl id="Code"></td>
				   <td width="25%"><cf_tl id="Name"></td>
				   <td width="30%"><cf_tl id="Address"></td>
				   <td width="20%"><cf_tl id="Officer"></td>
				   <td align="right"><cf_tl id="Created"></td>		
				   <td wisth="30"></td>			  	  
			    </TR>		
										
				<cfoutput query="Warehouse">
															
					   <TR class="line labelmedium">					  			   
						   <td align="center"></td>			   
						   <td height="23">#Warehouse#</td>
						   <td>#WarehouseName#</td>			  
						   <td>#Address# #City# #Telephone#</td>
						   <td width="20%">#OfficerLastName#</td>
						   <td align="right">#dateformat(created,CLIENT.DateFormatShow)#</td>
						   <td align="center" width="20"></td>   			   		   
					   </tr>	
					   					   											   
					   <tr>
					   <td></td>
					   <td colspan="6" style="height:100%" id="f#warehouse#_list">	
					       <cf_divscroll>
					     	<cfinclude template="List.cfm">													   						   		
						   </cf_divscroll>	
					   </td>
					   </tr>	 			 			 					
										
				</cfoutput>													
							
			</table>						
		
		</td>
		
	</tr>		
	<tr><td height="5"></td></tr>				

</table>	


	

