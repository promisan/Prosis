
<cfoutput>

<!--- we obtain grouped data upfront to speed up the process --->
<cfif url.listgroupfield neq "">
	<cfinclude template="ListingDataGroup.cfm">
</cfif>

<cfset pre = session.listingdata[box]['colprefix']>	
<cfset agg = session.listingdata[box]['aggregate']>	

<!--- GROUP / PIVOT PRESENTATION --->

<cfif session.listingdata[box]['firstsummary'] gte "3">			   
   <cfset headercols = pre+session.listingdata[box]['firstsummary']-3>	   
<cfelse>  		
   <cfset headercols = cols>		   			   	   		   		
</cfif>	

<cfif headercols eq "2">
	<cfset headercols = "4">
</cfif>

<cfloop query="SearchResult" startrow="1" endrow="#last#">
			
	<cfset currrow = currrow + 1>		
									
	<cfif currrow gte first and currrow lte last>
		
	    <cfif evaluate(url.listgroupfield) neq lst>						
		  <cfinclude template="ListingContentHTMLGroupShow.cfm">	
		  <cfset lst = evaluate(url.listgroupfield)>  						
		</cfif>
																
		<cfset row = row + 1>
		
		<cfif attributes.drillrow eq "Yes" and drilltemplate neq "">
		      <cfset s = evaluate(drillkey)>						  
		<cfelse>
		      <cfset s = currentrow>
		</cfif>  
				
		<cfset dkey = evaluate(drillkey)>
		
		<!--- ----------------------------------------------------------------------------- --->
		<!--- we obtain the content of the 2 or 3rd line if indeed declared in reality 
		       so we can use this information to handle it in the presentation         ---- --->
		<!--- ----------------------------------------------------------------------------- --->
							
		<cfset rowspan = "1">
		<cfset hasContent2  = "No">
		<cfset hasContent3  = "No">
		
		<cfif showrows gte "2"> 	
							
			<cfsavecontent variable="rowcontent2">
				 <cfset hascontent   = "No">	
				 <cfset rowshow      = "2">
			     <cfinclude template = "ListingContentGetCell.cfm">
				 <cfset hasContent2  = hasContent>
			</cfsavecontent>
			
			<cfif hasContent2 eq "Yes">
				<cfset rowspan = rowspan+1>
			</cfif>	
		
		</cfif>
		
		<cfif showrows gte "3"> 
			
			<cfsavecontent variable="rowcontent3">
				<cfset hascontent    = "No">
				 <cfset rowshow      = "3">	
			     <cfinclude template = "ListingContentGetCell.cfm">
				 <cfset hasContent3  = hasContent>
			</cfsavecontent>
			
			<cfif hasContent3 eq "Yes">
				<cfset rowspan = rowspan+1>
			</cfif>
		
		</cfif>	
		
		<!--- was part of tr  keyvalue="#s#" --->		
																						   
		<cfif rowspan eq "1">											   
		   <tr class="#attributes.classheader# navigation_row linedotted" name="#box#_#dkey#" id="r#row#" 
		     style="background-color:#iif(currentrow MOD 2,DE('fafafa'),DE('f4f4f4'))#">					
		<cfelse>
		   <tr class="#attributes.classheader# navigation_row" name="#box#_#dkey#" id="r#row#"
		     style="background-color:#iif(currentrow MOD 2,DE('fafafa'),DE('f4f4f4'))#"> 
		</cfif>				
							
		<td align="right" style="padding-right:4px;height:21px" id="#s#" onclick="var r = $('##r#row#').position();">
				
				<cfif attributes.navtemplate neq "">				
			       <input id="nav#row#" value="#currentrow#" style="width:60px" type="button" onclick="navtarget('#session.root#/#attributes.navtemplate#?ajax=yes&ajaxid=#s#','#attributes.navtarget#')"> 	   	   		   
			   <cfelse>
				   #currentrow#	    
    		   </cfif>	
			 
		</td>	
								   
		   <!--- to be checked 1/9/2013 --->
		  
		   <cfif attributes.selectmode eq "Checkbox">		   
			   <td><input type="checkbox" class="radio" name="ListSelect" id="ListSelect" value="#s#"></td>		   		   
		   <cfelseif attributes.selectmode eq "Radio">		   		   
			   <td><input type="radio"    class="radio" name="ListSelect" id="ListSelect" value="#s#"></td>				   		    	   		   
    	   </cfif>						   			   				   
																
		   <cfif attributes.listtype eq "Directory">
				
				<td align="center" rowspan="#rowspan#" style="padding-top:1px">							
					<cf_img icon="open" id="img0_#currentrow#" onclick="showtemplate('#attributes.listpath#','#attributes.listquery#\\#name#')">
				</td>
						  							
		   <cfelseif drillmode eq "">
			
				<td align="center" style="padding-top:1px"></td>
				<!--- do not show drill --->
											
		   <cfelseif drillmode eq "Embed" or drillmode eq "EmbedXT" or drillmode eq "Workflow">
		   
		        <cfif drillmode eq "EmbedXT">
					<cfset tdrillmode ="Embed">
				<cfelse>
					<cfset tdrillmode = drillmode>								
				</cfif>
							
			   <cfset cl = "toggledrill('#lcase(tdrillmode)#','box#dkey#','#drilltemplate#','#dkey#','#argument#','#drillbox#','#drillstring#')">							
			   <td align="center" style="padding-top:7px;padding-left:5px">		
			   <cf_img id="exp#currentrow#" icon="expand"  toggle="Yes" onclick="#cl#">	
			   
			   <!---					  						  						   				   						   
			   <img style="cursor:pointer" id="exp#dkey#" 
			     class="regular" src="#client.VirtualDir#/Images/arrowright.gif" align="absmiddle" alt="Expand" height="9" width="7" onclick="#cl#"> 								 
			   <img style="cursor:pointer" id="col#dkey#" 
			     class="hide" src="#client.VirtualDir#/Images/arrowdown.gif" align="absmiddle" height="10" width="9" alt="Hide" onclick="#cl#"> 							 
				 --->
				 
			   </td>
				 
			<cfelse>						
									
			   <cfset cl = "toggledrill('#lcase(drillmode)#','box#dkey#','#drilltemplate#','#dkey#','#argument#','#drillbox#','#drillstring#')">							   					  	  					 						   
			   <td class="navigation_action">						   						   
			   <cf_img id="exp#currentrow#" icon="open" onclick="#cl#">
			   </td>
			 													 
			</cfif>  		
			
			<!--- ------------------------------------------------------------------- --->
			<!--- ----------------------OBTAIN FIELD CONTENT ------------------------ --->				
			<!--- ------------------------------------------------------------------- --->			
			<cfset rowshow = 1>		
			
						
			<cfinclude template="ListingContentgetCell.cfm">		
			
						
			<!--- ------------------------------------------------------------------- --->	
			<!--- ------------------------------------------------------------------- --->			
			
			<cfset endcell = 0>																	
									
			<cfif attributes.listtype eq "Directory">			
				<td style="border-left:1px dotted ##C0C0C0;"><input type="checkbox" value="#attributes.listquery#\#name#"></td>			
				<cfset endcell = endcell+1>		
			</cfif>
									
			<cfif annotation neq "">		
				
				<td style="padding:3px" id="note#dkey#" align="center">			
				
					<cfif doc.entityKeyField4 neq "">				
						<cf_annotationshow entity="#annotation#" keyvalue4="#dkey#" docbox="note#dkey#">					   
					<cfelse>				
						<cf_annotationshow entity="#annotation#" keyvalue1="#dkey#" docbox="note#dkey#">				
					</cfif>							
																									
				</td>		
				<cfset endcell = endcell+1>									
				
			</cfif>			
			
			<cfif deletescript neq "">		
			
				<td align="right" style="padding-top:2px;padding-right:5px;padding-left:3px" 
				 onclick="#deletescript#('#box#','#dkey#')">			   
				     <img src="#session.root#/images/delete.png" id="del#row#" style="height:17px;cursor:pointer" alt="Remove record">															
				</td>				
				<cfset endcell = endcell+1>		
								
			<cfelseif deletetable neq "">								
				
				<td align="right" style="padding-top:2px;padding-right:5px;padding-left:3px" 
				 onclick="deleterow('#box#','#attributes.datasource#','#deletetable#','#drillkey#','#dkey#')">					   
				     <img src="#session.root#/images/delete.png" id="del#row#" style="height:17px;cursor:pointer" alt="Remove record">						
					<!----
				     <cf_img icon="delete" id="del#row#_2">
					 ---->					
				</td>	
				
				<cfset endcell = endcell+1>														
			</cfif>					
			
		</tr>
							
		<!--- determine if we need to show 2nd and 3rd row --->
												
		<cfif hasContent2 eq  "Yes"> 									
																						
			<tr name="f#box#_#dkey#" style="background-color:##FCFFE0;border-top:1px dotted silver;border-bottom:1px" 
			    class="#attributes.classheader#">
				<cfloop index="itm" from="1" to="2"><td style="background-color:#iif(currentrow MOD 2,DE('fafafa'),DE('efefef'))#"></td></cfloop>
				#rowcontent2#
				<cfloop index="itm" from="1" to="#endcell#"><td style="background-color:#iif(currentrow MOD 2,DE('fafafa'),DE('efefef'))#"></td></cfloop>
			</tr>						
							
		</cfif>					
		
		<cfif hasContent3 eq "Yes">		
												    				    				
			<tr name="f#box#_#dkey#" style="background-color:##FCFFE0;border-top:1px dotted silver;border-bottom:1px solid silver" 
			    class="#attributes.classheader#">
				<cfloop index="itm" from="1" to="2"><td style="background-color:#iif(currentrow MOD 2,DE('fafafa'),DE('efefef'))#"></td></cfloop>
				#rowcontent2#
				<cfloop index="itm" from="1" to="#endcell#"><td style="background-color:#iif(currentrow MOD 2,DE('fafafa'),DE('efefef'))#"></td></cfloop>
			</tr>								
																
		</cfif>		
		
		<cfif drilltemplate neq "" and drillkey neq "" and drillmode neq "">					

			    <cfset divId = replace(evaluate(drillkey)," ","","ALL")>
									  
				<tr class="hide" id="box#divId#" name="#box#_#dkey#">
				      <cfif drillmode eq "workflow">
					  <!--- contains a dynamic reference to the content for refresh --->
				      <td id="workflowlink_c#divId#" value="#SESSION.root#/tools/listing/listing/ListingDetailWorkflow.cfm"></td>
					  <cfelse>
					  <td></td>
					  </cfif>
				      <td align="center" style="padding:4px" id="c#divId#" colspan="#cols+1#"></td>
				</tr>
			
		</cfif>								
					
	</cfif>								

</cfloop>	
			
</cfoutput>