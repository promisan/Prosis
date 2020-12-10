
<cfset vContentHeight = "100%">		

<cfset orderset = 0>
<cfset col      = 0>
<cfset total    = 0>
<cfset showrows = 1>	

<cf_divscroll id="_divContentFields" height="#vContentHeight#">

	<cfoutput>
	   		   
		<table style="width:98.5%" class="navigation_table" id="#box#_table" border="0">
								
			<cfif searchresult.recordcount eq "0">				
				<cfinclude template="ListingHeader.cfm">								    								
				<tr><td style="height:50" align="center" colspan="#cols#" class="labelmedium"><cf_tl id="NoRecords" var="tlNoRecords">#tlNoRecords#.</td></tr>										
			<cfelse>						 					
			    <cfinclude template="ListingHeader.cfm">				
			</cfif>		
									
			<cfsavecontent variable="mytablecontent">					
			
				<cfloop query="SearchResult" startrow="1" endrow="#last#">
							
					<cfset currrow = currrow + 1>		
													
					<cfif currrow gte first and currrow lte last>
						
					    <cfif evaluate(url.listgroupfield) neq lst>		
								   										
						  <cfset val = ltrim(rtrim(evaluate(url.listgroupfield)))>
						  <cfset val = Replace( val, "'", "''", "ALL" )>	
						  <cfset aggregate = "">												
																		
						  <cftry>			  	
							  
							  <!--- get sum fields --->
							  
							  <cfloop array="#attributes.listlayout#" index="fields">
							  			  
									<cfparam name="fields.aggregate"   default="">					
									<cfparam name="fields.searchfield" default="">
									<cfparam name="fields.searchalias" default="">
									
									<cfif fields.aggregate eq "SUM">	
																	
											<cfset aggregate = "SUM(#fields.field#) as #fields.field#">													
											<cfset aggregateformat = fields.formatted>		
											<cfset aggregateformat = replaceNoCase(aggregateformat,fields.field,"subtotal.#fields.field#")> 				
															
									</cfif>
					
							  </cfloop>
							 						  			  								  
							  <cfquery name="subtotal"       
						         dbtype="query">
								 SELECT COUNT(*) as counted <cfif aggregate neq "">,#aggregate#</cfif>
								 FROM   SearchResult
								 WHERE  #url.listgroupfield# = '#val#'			 
							  </cfquery>			  
							  
							  <cfif subtotal.recordcount eq "0"> 						  
							  			  								  
								  <cfquery name="subtotal"       
							         dbtype="query">
									 SELECT COUNT(*) as counted <cfif aggregate neq "">,#aggregate#</cfif>
									 FROM   SearchResult
									 WHERE  #url.listgroupfield# LIKE '#val#%'			 
								  </cfquery>			  
							  
							   </cfif>
							  
							  <!--- query of query does not mix integer and strings --->	
									  
							  <cfcatch>		
							  
							  	<cfif val eq "">
									 <cfset val = 0>
								 </cfif>
							    	
								 <cfquery name="subtotal"       
								    dbtype="query">
									 SELECT  COUNT(*) as counted <cfif aggregate neq "">,#aggregate#</cfif>
									 FROM    SearchResult
									 WHERE   #url.listgroupfield# = #val#									 					 
								  </cfquery>	
																				  
							  </cfcatch>
						  
						  </cftry>		
						  
						  <!--- grouping record --->
																	
						  <tr class="line fixrow240 navigation_row labelmedium2">
						  <td colspan="#cols-2#" class="labellarge" style="font-weight:bold;padding-left:5px;height:30px">	
						  					      
							   <cfif findNoCase('00:00',evaluate(url.listgroupfield))>
							   
							     <!--- this is no longer needed as the below will take care of this : can be removed --->
								 
								 #dateformat(evaluate(url.listgroupfield),CLIENT.DateFormatShow)#
								 
							   <cfelse>		
							   					   
							   	 <cfif evaluate(url.listgroupfield) neq "">							 
								    <cfset groupfield = url.listgroupfield>								 
								 <cfelse>							   
								   	<cfset groupfield = url.listgroup>																 
								 </cfif>						    
							    
								<!--- we check if for the selected field we have a special formatting set --->
								
								<cfloop array="#attributes.listlayout#" index="itm">		
								
									<cfif itm.field eq groupfield>
																
										<cfif itm.formatted neq "">
										#evaluate(itm.formatted)#
										<cfelse>
										#evaluate(groupfield)#
										</cfif>																	
									
									</cfif>
							   	
							      </cfloop>
							   															 
							   </cfif>				 
							   </td>		
							   <cfif aggregate eq "">		 
							   <td align="right" colspan="3" style="font-weight:bold;padding-top:4px;padding-bottom:2px;padding-right:10px">#subtotal.counted#</td>				 
							   <cfelse>
							   <td align="right" colspan="3" style="font-weight:bold;padding-top:4px;padding-bottom:2px;padding-right:10px">
							   <cfif subtotal.counted gt "1">
							   (#subtotal.counted#)&nbsp;
							   </cfif>#evaluate(aggregateformat)#</td>	
							   </cfif>
						  </tr>		
												
						  <cfset lst = evaluate(url.listgroupfield)>
						
						</cfif>
								
						<cfset row = row + 1>
						
						<cfif attributes.drillrow eq "Yes" and drilltemplate neq "">
						      <cfset s = evaluate(drillkey)>						  
						<cfelse>
						      <cfset s = currentrow>
						</cfif>  
						
						<cfset dkey = evaluate(drillkey)>
						
						<!--- we obtain the content of the 2 and 3 line if it is indeed declared inreality --->
											
						<cfset rowspan = "1">
						<cfset hasContent2  = "No">
						<cfset hasContent3  = "No">
						
						<cfif showrows gte "2"> 	
											
							<cfsavecontent variable="rowcontent2">
								 <cfset hascontent   = "No">	
								 <cfset rowshow      = "2">
							     <cfinclude template = "ListingContentField.cfm">
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
							     <cfinclude template = "ListingContentField.cfm">
								 <cfset hasContent3  = hasContent>
							</cfsavecontent>
							
							<cfif hasContent3 eq "Yes">
								<cfset rowspan = rowspan+1>
							</cfif>
						
						</cfif>			
																										   
						<cfif rowspan eq "1">											   
						   <tr class="#attributes.classheader# navigation_row line" name="f#box#_#dkey#" id="r#row#" keyvalue="#s#" 
						     style="background-color:#iif(currentrow MOD 2,DE('fafafa'),DE('efefef'))#">					
						<cfelse>
						   <tr class="#attributes.classheader# navigation_row" name="f#box#_#dkey#"  id="r#row#" keyvalue="#s#" 
						     style="background-color:#iif(currentrow MOD 2,DE('fafafa'),DE('efefef'))#"> 
						</cfif>				
											
						<td style="padding-left:12;height:21px" id="#s#">#currentrow#.</td>	
										   
						<!--- to be checked 1/9/2013 --->
						  
						   <cfif attributes.selectmode eq "Checkbox">		   
							   <td rowspan="#rowspan#"><input type="checkbox" name="ListSelect" id="ListSelect" value="#s#"></td>		   		   
						   <cfelseif attributes.selectmode eq "Radio">		   		   
							   <td rowspan="#rowspan#"><input type="radio"    name="ListSelect" id="ListSelect" value="#s#"></td>	
						   <cfelseif attributes.navtemplate neq "">
						        <input id="nav#row#" type="hidden" onclick="navtarget('#session.root#/#attributes.navtemplate#?ajax=yes&ajaxid=#s#','#attributes.navtarget#')"> 	   	   		   
						   </cfif>						   			   				   
																				
						   <cfif attributes.listtype eq "Directory">
								
								<td align="center" rowspan="#rowspan#" style="padding-top:1px">							
									<cf_img icon="open" id="img0_#currentrow#" onclick="showtemplate('#attributes.listpath#','#attributes.listquery#\\#name#')">
								</td>
										  							
						   <cfelseif drillmode eq "">
							
								<td align="center" rowspan="#rowspan#" style="padding-top:1px"></td>
								<!--- do not show drill --->
															
						   <cfelseif drillmode eq "Embed" or drillmode eq "EmbedXT" or drillmode eq "Workflow">
						   
						        <cfif drillmode eq "EmbedXT">
									<cfset tdrillmode ="Embed">
								<cfelse>
									<cfset tdrillmode = drillmode>								
								</cfif>
							
							   <cfset cl = "toggledrill('#lcase(tdrillmode)#','box#dkey#','#drilltemplate#','#dkey#','#argument#','#drillbox#','#drillstring#')">							
							   <td align="center" style="padding-top:1px;padding-left:5px">								  						  						   				   						   
							   <img style="cursor:pointer" id="exp#dkey#" 
							     class="regular" src="#client.VirtualDir#/Images/arrowright.gif" align="absmiddle" alt="Expand" height="9" width="7" onclick="#cl#"> 								 
							   <img style="cursor:pointer" id="col#dkey#" 
							     class="hide" src="#client.VirtualDir#/Images/arrowdown.gif" align="absmiddle" height="10" width="9" alt="Hide" onclick="#cl#"> 							 
							   </td>
								 
							<cfelse>						
													
							   <cfset cl = "toggledrill('#lcase(drillmode)#','box#dkey#','#drilltemplate#','#dkey#','#argument#','#drillbox#','#drillstring#')">							   					  	  					 						   
							   <td class="navigation_action" onclick="#cl#">						   						   
							   <cf_img id="exp#currentrow#" icon="open"></td>
							 													 
							</cfif>  		
							
							<!--- ------------------------------------------------------------------- --->
							<!--- -------------------------SHOW FIELD CONTENT------------------------ --->				
							<!--- ------------------------------------------------------------------- --->			
							<cfset rowshow = 1>
							<cfinclude template="ListingContentField.cfm">		
							<cfset endcell = 0>
							
							<!--- ------------------------------------------------------------------- --->	
							<!--- ------------------------------------------------------------------- --->																				
													
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
													
							<cfif deletetable neq "">							
									
								<td align="right" style="padding-top:2px;padding-right:5px;padding-left:3px">	
								     <img src="#session.root#/images/delete.png" 
									   id="del#row#" style="height:17px;cursor:pointer" alt="Remove record" border="0" 
									   onclick="deleterow($(this),'f#box#_#dkey#','#attributes.datasource#','#deletetable#','#drillkey#','#dkey#')">	
									 <!---								
								     <cf_img icon="delete" id="del#row#" onclick="deleterow('#row#','#attributes.datasource#','#deletetable#','#drillkey#','#dkey#')">		
									 --->
								</td>	
								<cfset endcell = endcell+1>										
							</cfif>					
							
						</tr>
											
						<!--- determine if we need to show 2nd and 3rd row --->
																
						<cfif hasContent2 eq  "Yes"> 									
																										
							<tr name="f#box#_#dkey#" style="background-color:##FCFFE0;border-top:1px dotted silver;border-bottom:1px" class="#attributes.classheader#">
								<cfloop index="itm" from="1" to="2"><td style="background-color:#iif(currentrow MOD 2,DE('fafafa'),DE('efefef'))#"></td></cfloop>
								#rowcontent2#
								<cfloop index="itm" from="1" to="#endcell#"><td style="background-color:#iif(currentrow MOD 2,DE('fafafa'),DE('efefef'))#"></td></cfloop>
								</tr>
															
							<cfif hasContent3 eq "No">												
							<tr class="navigation_row_child"><td colspan="#cols#" style="border-bottom:1px solid silver;height:0px"></td></tr>												
							</cfif>
											
						</cfif>					
						
						<cfif hasContent3 eq "Yes">		
																    				    				
							<tr name="f#box#_#dkey#" style="background-color:##FCFFE0;border-top:1px dotted silver;border-bottom:1px solid silver" 
							    class="#attributes.classheader#">
								<cfloop index="itm" from="1" to="2"><td style="background-color:#iif(currentrow MOD 2,DE('fafafa'),DE('efefef'))#"></td></cfloop>
								#rowcontent2#
								<cfloop index="itm" from="1" to="#endcell#"><td style="background-color:#iif(currentrow MOD 2,DE('fafafa'),DE('efefef'))#"></td></cfloop>
								</tr>								
																						
							<tr class="navigation_row_child"><td colspan="#cols#" style="border-bottom:1px solid silver;height:0px"></td></tr>						
							
													
						</cfif>		
						
						<cfif drilltemplate neq "" and drillkey neq "" and drillmode neq "">					
	
							 <cfset divId = replace(evaluate(drillkey)," ","","ALL")>
						
							   <input type="hidden" 	  	   
								   id="workflowlink_c<cfoutput>#divId#</cfoutput>"
								   value="<cfoutput>#SESSION.root#</cfoutput>/tools/listing/listing/ListingDialog.cfm">	  
							  
								<tr class="hide" id="box#divId#" name="f#box#_#dkey#">
								      <td></td>
								      <td align="center" style="padding:4px" id="c#divId#" colspan="#cols+1#"></td>
								</tr>
							
						</cfif>					
									
					</cfif>			
								
				</cfloop>
			
			</cfsavecontent>
			
			#mytablecontent#
		
		</table>	
	
	</cfoutput>
	
</cf_divscroll>


<!---

<cfsavecontent variable="myadd">
<cfloop index="row" from="1" to="500">
	<tr><td>#row#</td><td>fgerfr</td><td>bbggerdgd</td></tr>
</cfloop>
</cfsavecontent>

<cfscript>  
    FileWrite("#session.rootpath#\my_list.txt", "#myadd#");
</cfscript>

--->

<cfoutput>
<tr>
<td id="mdoit"></td>
<td>
<input type="button" value="BUTTON" onclick="ptoken.navigate('#session.root#/tools/listing/listing/_addrow.cfm?box=#box#','mdoit')">
</td></tr>
</cfoutput>   


