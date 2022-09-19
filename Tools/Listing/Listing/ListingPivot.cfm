
<cfoutput>

<cfif url.systemfunctionid neq "" and group eq "Yes">
		
	<table>
	<tr>	
	
	<td class="labelmedium2" style="padding-right:6px;padding-left:10px;height:30px;border-right:1px solid silver"><cf_tl id="Grouping"></td>
	<td style="padding-left:6px">
	
	<select name="groupfield" id="groupfield" class="regularxb" onchange="filtergroup('#box#',this);applyfilter('','1','content')">
	    <option value="none" <cfif url.listgroup eq "">selected</cfif>><cf_tl id="None"></option>
		
		<cfset hasGroup = "0">
					 
		<cfloop array="#attributes.listlayout#" index="current">	
			<cfif (current.filtermode gte "1" and current.filtermode lte "4" ) and current.search neq "">	 
				<cfset hasGroup = "1">	
				<option value="#current.field#" <cfif url.listgroupfield eq current.field>selected</cfif>>#current.labelfilter#</option>																					
			</cfif>
		</cfloop>
												
	</select>	
	
	</td>	
							
	<cfif url.listgroup eq "">
		<cfset cl = "hide">
	<cfelse>
		<cfset cl = "regular">	
	</cfif>
						
	<cfif hasGroup eq "1">		
	
		<td id="#box#_groupselection" class="#cl#">
		
			<table>
				<tr>	
				    									
				 <td style="padding-left:8px;min-width:70px">  <!--- allow to hide and show --->
					<table id="#box#_groupsort">
					    <tr>
						 <td><input type="checkbox" class="radiol" name="groupdir" onclick="applyfilter('','1','content')" value="DESC" <cfif url.listgroupdir eq "DESC">checked></cfif></td>				 
						 <td style="padding-left:4px;padding-right:7px"><cf_tl id="DESC"></td>		
					    </tr>
					</table>
				 </td>
				 
				 <td style="padding-left:8px;border-right:1px solid silver;border-left:1px solid silver">  <!--- allow to hide and show --->
				     <table id="#box#_group">
					   <tr>
					   <td><input type="checkbox" class="radiol" name="grouptotal" onclick="applyfilter('','1','content')" value="1" <cfif url.listgrouptotal eq "1">checked></cfif></td>
					   <td style="padding-left:4px;padding-right:7px"><cf_tl id="Explore"></td>		
					   </tr>
				      </table>
				 </td>
				 				 				  				  		 		 
				 <td style="padding-left:8px;border-left:1px solid silver" id="#box#_column1">
				 					 
					 <cfparam name="url.listcolumn" default="">
					 					
						<select name="colfield1" id="colfield1" class="regularxb" onchange="applyfilter('','1','content')">
						    <option value="" <cfif url.listcolumn1 eq "">selected</cfif>><cf_tl id="Summary"></option>
							
							<cfset hasGroup = "0">
																 
							<cfloop array="#attributes.listlayout#" index="current">	
								<cfif current.column eq "month" or current.column eq "common">	 													
									<option value="#current.field#" <cfif findnocase(current.field,url.listcolumn1)>selected</cfif>>#current.labelfilter#</option>																					
								</cfif>
							</cfloop>
																	
						</select>	
						
				 </td>
				  
				  <!--- cell content field for column to be shown --->
					  
				  <cfset agg = "0">
					  
					  <td style="padding-left:10px;padding-right:7px;border-left:1px solid silver">
					   
						   <table id="#box#_groupcell1">
						      <tr class="labelmedium">
							  <td><cf_tl id="Content"></td>	
							  <td style="padding-left:10px">					  
							  <select name="datacell1" id="datacell1" class="regularxb" onchange="applyfilter('','1','content')">							   
								   <option value="total" <cfif url.datacell1 eq "">selected</cfif>><cf_tl id="Count"></option>				  
								  <cfloop array="#attributes.listlayout#" index="current">	
								        <cfset agg = "1">
								        <cfparam name="current.aggregate" default="">
										<cfif current.aggregate eq "sum">	 													
											<option value="#current.field#" <cfif findnocase(current.field,url.datacell1)>selected</cfif>>#current.labelfilter#</option>																					
										</cfif>
									</cfloop>								
							  </select>							  
						  	 </td>
							 </tr>
						  </table>			  
					  
					  </td>	
				  
					  <cfif url.datacell1formula eq "">
					  	<cfset url.datacell1formula = "SUM">
					  </cfif>				  				   
					  
					  <td style="padding-left:10px;padding-right:7px;border-left:1px solid silver;border-right:1px solid silver">
					  
					  	<table id="#box#_groupcell1formula">
						      <tr class="labelmedium">
							  <td><cf_tl id="Formula"></td>								 
							  <cfloop index="itm" list="SUM,AVG,MAX,MIN,PER">
							   <td style="padding-left:10px">	
							   <input class="radiol" type="checkbox" onclick="applyfilter('','1','content')" name="datacell1formula" value="#itm#" <cfif findnocase(itm,url.datacell1formula)>checked</cfif>>
							   </td><td><cfif itm eq "PER">%<cfelse>#itm#</cfif></td>						  
							  </cfloop>									 			  
						  	 </td>
							 </tr>
						  </table>						  
					  
					  </td>		
					  
				 </cfif> 		   	 
				 
				</tr>
			</table>
		</td>					 
	
	</tr>
	</table>		
				
</cfif>

</cfoutput>