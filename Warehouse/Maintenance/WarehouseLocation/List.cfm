
<cfparam name="url.systemfunctionid" default="">
<cfparam name="url.action" default="">

<cfif url.action eq "delete">
	
	<cfquery name="Delete" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     DELETE FROM ItemWarehouseLocation
			 WHERE  Warehouse = '#URL.Warehouse#'
			 AND    Location  = '#URL.id2#'
	</cfquery>
	
	<cfquery name="Delete" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     DELETE FROM WarehouseLocation
			 WHERE  Warehouse = '#URL.Warehouse#'
			 AND    Location  = '#URL.id2#'
	</cfquery>
	
	<cfset url.id2 = "">

</cfif>

<cfquery name="getWhs" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Warehouse
	WHERE  Warehouse = '#url.warehouse#'	
</cfquery>

<cfif url.systemfunctionid neq "">
	
	
	<cfquery name="check" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ModuleControl
		WHERE  SystemFunctionId = '#url.systemfunctionid#'	
	</cfquery>

	<cfif check.FunctionClass eq "Maintain">
		
		 <cfset access = "ALL">

	<cfelse>
	
				
		<cfinvoke component = "Service.Access"  
		   method           = "RoleAccess" 
		   mission          = "#getWhs.Mission#" 
		   role             = "'WhsPick'"
		   parameter        = "#url.systemfunctionid#"
		   accesslevel      = "'1','2'"
		   returnvariable   = "accessright">	
						   
	   <cfif accessright eq "GRANTED">
	       <cfset access = "ALL">
	   <cfelse>
	   	   <cfset access = "NONE">
	   </cfif>
	   
	 </cfif>  

<cfelse>

	<cfparam name="Access" default="EDIT">
	
</cfif>	

<cfquery name="List" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *,(SELECT count(*) 
	          FROM   ItemWarehouseLocation 
			  WHERE  Warehouse = L.Warehouse 
			  AND   Location = L.Location) as Items,
			  
			 (SELECT AssetBarCode
	          FROM   AssetItem
			  WHERE  AssetId = L.AssetId 
			  ) as AssetBarCode,
			  
			 (SELECT AssetDecalNo
	          FROM   AssetItem
			  WHERE  AssetId = L.AssetId 
			  ) as AssetDecalNo,
			  
			 (SELECT TOP 1 Location
			  FROM   ItemTransaction
			  WHERE  Warehouse = L.Warehouse	
			  AND    Location  = L.Location) as Used			  
			  
    FROM      WarehouseLocation L
	WHERE     Warehouse = '#URL.Warehouse#'	
	ORDER BY  LocationClass,ListingOrder, Location
</cfquery>

<cfquery name="Last" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Max(ListingOrder)+1 as Last
    FROM   WarehouseLocation	
	WHERE  Warehouse = '#URL.Warehouse#'	
</cfquery>

<cfif Last.last eq "">

  <cfset lst = "1">
  
<cfelse>

  <cfset lst = last.last>
    
</cfif>

<cfparam name="URL.ID2" default="new">
	
<cfif list.recordcount eq "0">
	  <cfset url.id2 = "new">
</cfif> 

<cfform action="#SESSION.root#/warehouse/maintenance/warehouselocation/ListSubmit.cfm?systemfunctionid=#url.systemfunctionid#&Warehouse=#URL.Warehouse#&id2=#url.id2#" 
 		method="POST" name="element">
	
<table width="98%" class="navigation_table">
			
		<TR class="labelmedium" style="height:1px">
		   <td style="min-width:100px"></td>
		   <td style="min-width:100px"></td>			  
		   <td style="width:100%"></td>
		   <td style="min-width:100px"></td>
		   <td style="min-width:100px"></td>
		   <td style="min-width:50px"></td>
		   <td style="min-width:20px"></td>
		   <td colspan="2" align="right" style="min-width:80px"></td>		  
		</TR>
		
		<tr class="hide"><td id="_list"></td></tr>
					
						
		<cfoutput>
						
		<cfquery name="class" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_WarehouseLocationClass	
		</cfquery>
		
		<cfloop query="List">
					
			<cfset nm = Location>
			<cfset de = Description>
			<cfset ls = ListingOrder>
			<cfset op = Operational>
																								
			<cfif URL.ID2 eq nm>		
						
			    <input type="hidden" name="ListCode" id="ListCode" value="<cfoutput>#nm#</cfoutput>">
													
				<TR class="line labelmedium">
				
				   <td style="height:30">
				   				   
				   <select name="LocationClass" id="LocationClass" class="regularxl">
						<cfloop query="class">
							<option value="#code#" <cfif List.LocationClass eq code>selected</cfif>>#Description#</option>
						</cfloop>
				   </select>				   
				   
				   </td>
				   
				   <td style="padding-right:7px">#nm#</td>
				   				   
				   <td>
				   	   <cfinput type="Text" 
					   	value="#de#" 
						name="Description" 
						message="You must enter a name" 
						required="Yes" 
						style="width:99%"						
						maxlength="100" 
						class="regularxl">
				  
		           </td>
				   
				   <td>
				   	<cfinput type="Text" 
				         name="StorageCode" 
						 message="You must enter a code" 
						 required="Yes" 
						 style="width:99%"
						 value="#storagecode#"
						 maxlength="20" 
						 class="regularxl">
				  </td>		
				
				  <td>#AssetDecalNo#</td>
				  
				  <!---
				   
				   <td height="22">
				   
				   	<cfinput type="Text"
					       name="ListingOrder"
					       value="#ls#"
						   class="regular"
					       validate="integer"
					       required="Yes"
						   message="Please enter an order value" 
					       visible="Yes"
					       enabled="Yes"
					       typeahead="No"						 			      
					       maxlength="2"
						   style="width:20;text-align:center">
				   			   
				     </td>
					 
					 --->
				   <td align="right" style="padding-right:4px">#Items#</td>
				   <td align="center">
				     
					   <input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif "1" eq op>checked</cfif>>
					   
				   </td>
				   				  
				   <td  align="right" style="padding-left:4px">
				   
					   	<input type="submit" 
					        value="Save" 
							class="button10s" 
							style="width:50;height:25">
						
					</td>
					
					<td></td>
					
			    </TR>	
																			
			<cfelse>
						
				<TR class="navigation_row labelmedium line" style="height:20px">
				
				   <cfquery name="loc" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   Ref_WarehouseLocationClass	
						WHERE  Code = '#locationClass#'
				   </cfquery>
				   
				   <td style="padding-left:2px">#loc.description#</td>			
				   
				   <td style="padding-left:3px" class="labelit">				   				   
					   <cfif Access eq "EDIT" or Access eq "ALL">
					   		<a class="navigation_action" href="javascript:editwarehouselocation('#URL.Warehouse#','#nm#','#access#','#url.systemfunctionid#')">#nm#</a>
					   <cfelse>
					   		#nm#
					   </cfif>				   
				   </td>			   
				   	   
				   <td style="padding-left:3px">#de#</td>
				   <td style="padding-left:3px">#StorageCode#</td>
				   <td style="padding-left:3px">#AssetDecalNo#</td>
				   <td style="padding-left:3px">#Items#</td>
				   <td style="padding-left:3px" align="center"><cfif op eq "0"><b>No</b><cfelse>Yes</cfif></td>				   
				  
				   <td align="right">
				   
					   <table>
					      <tr>						  
						    <td style="padding-top:1px;padding-left:3px">					      
						  	<cfif Access eq "ALL"  or Access eq "EDIT">							  
							    <cf_img icon="edit" onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/warehouse/maintenance/warehouselocation/List.cfm?systemfunctionid=#url.systemfunctionid#&Warehouse=#URL.Warehouse#&ID2=#nm#','f#URL.Warehouse#_list')">																					   
							</cfif>						  
						   </td>						   
						   <td style="padding-top:1px;padding-left:4px">						   						   						   
						    <cfif Access eq "EDIT" or Access eq "ALL">
							    <cf_img icon="open" onclick="editwarehouselocation('#URL.Warehouse#','#nm#','#access#','#url.systemfunctionid#')">														   		
							</cfif>						   						   
						   </td>						 
						   </tr>
					   </table>
				   	   
				   </td>				      			   			   
				  				   
				   <td style="padding-left:3px">
				   
				     <cfif used eq "" and Access eq "ALL">
					      
						  <cf_img icon="delete" 
						     onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/warehouse/maintenance/warehouselocation/ListPurge.cfm?systemfunctionid=#url.systemfunctionid#&Warehouse=#URL.Warehouse#&ID2=#nm#','_list')">
				 	      
					 </cfif>	   
					  
				    </td>
					
				 </TR>	
				
										
			</cfif>
						
		</cfloop>
		
		</cfoutput>
													
		<cfif URL.ID2 eq "new">
							
			<TR>
						
			  <td style="height;30;padding-right:7px">
				   				   
				   <select name="LocationClass" id="LocationClass" class="regularxl">
						<cfoutput query="class">
							<option value="#code#">#Description#</option>
						</cfoutput>
				   </select>				   
				   
				   </td>
				   
				   <td height="28">
			
				    <cfinput type="Text" 
				         value="" 
						 name="Location" 
						 message="You must enter a code" 
						 required="Yes" 
						 size="2" 
						 maxlength="20" 
						 class="regularxl">
	              </td>
						   
			      <td>
				   	<cfinput type="Text" 
				         name="Description" 
						 message="You must enter a name" 
						 required="Yes" 
						 style="width:99%"
						 maxlength="100" 
						 class="regularxl">
				  </td>		
				
				  <td>
				   	<cfinput type="Text" 
				         name="StorageCode" 
						 message="You must enter a code" 
						 required="Yes" 
						 style="width:99%"
						 maxlength="20" 
						 class="regularxl">
				  </td>		
				
				  <td></td>							
				  <td></td>	
				  <td></td>
						
				  <td align="center">
						<input type="checkbox" name="Operational" id="Operational" value="1" checked>
				  </td>
										   
				  <td colspan="2" align="right" style="padding-right:3px">
						
							<input type="submit" 
								value="Add" 
								class="button10s" 
								style="width:50;height:25">			
						
				  </td>			    
				  
			</TR>	
																
		</cfif>			
							
</table>	

</cfform>	

<cfset AjaxOnLoad("doHighlight")>	
					

