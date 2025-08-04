<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfoutput>

<cfset stl = "cursor:pointer;font-size:12px;height:30px">

<tr style="height:40px" class="fixrow line">

	<cfset totalcols = 2>
    <td colspan="2" style="min-width:50px;"></td>	
	   		
	<cfif attributes.selectmode neq "">
	   <td></td>
	   <cfset totalcols = totalcols + 1>
	</cfif>
		
	<cfset session.listingdata[box]['colprefix'] = totalcols>	
	
	<!--- ------------------------------------------------------------------------------ --->
	<!--- determine the best width and spans etc based on the config passed into loading --->
	<!--- ------------------------------------------------------------------------------ --->
	
	<cfloop array="#attributes.listlayout#" index="current">
			
		 <cfparam name="current.label"        default="">					
		 <cfparam name="current.formatted"    default="">
		 <cfparam name="current.width"        default="0">		
		 <cfparam name="current.display"      default="1">		
		 <cfparam name="current.alias"        default="">	
		 <cfparam name="current.sort"         default="yes">
		 <cfparam name="current.rowlevel"     default="1">	
		 <cfparam name="current.colspan"      default="1">		
		 <cfparam name="current.align"        default="left">	
		 <cfparam name="current.fieldsort"    default="#current.field#">	
		 <cfparam name="current.column"       default="">	
		 
		 <cfparam name="showcolumn" default="">
		 
		 <cfif current.column neq "">
		 	   <cfset showcolumn = current.field>
		 </cfif>	
		 
		 <cfif showrows lt current.rowlevel>
		       <cfset showrows = current.rowlevel>
		 </cfif> 		
		 			 
		 <cfif current.rowlevel eq "2">
		 
		    <cfparam name="cols2nd" default="0">
		 
		    <!--- precount the cols used --->
		    <cfset cols2nd = cols2nd+current.colspan>					
			<cfset last2nd = current.label>
			
		 <cfelseif current.rowlevel eq "3">
		 
		    <cfparam name="cols3rd" default="0">
		 
		    <!--- precount the cols used --->
		    <cfset cols3rd = cols3rd+current.colspan>					
			<cfset last3rd = current.label>	
			
		 <cfelseif current.field eq url.listgroupfield>
		 
			 <!--- does not count as is shown in grouping --->	
							 		 
		 <cfelseif current.display eq "1" and current.rowlevel eq "1">
		 		 		 
		    <cfset col = col+1>		
			
		    <cfif current.width eq "0">
			
			    <cfset size = len(current.label)+5>		
				
				<cfset labelsize = len(current.label)*3>	
				<cfset sizefield = len(current.label)*3>													
				
				<!--- inspect the first 15 records for the width --->													
				
				<cfloop query="searchresult" startrow="1" endrow="15">				
								    										
				    <cfif current.formatted eq "Rating">					
						<cfset sizefield = "10">					
					<cfelse>					 	
					   							
						<cftry>		
														
						    <cfset selitem = "#evaluate(current.formatted)#">	
							<cfif selitem eq "">
							     <cfset selitem = "#evaluate(current.field)#">	
							</cfif>											
							
						<cfcatch>		
						  				
						     <cfset selitem = "#evaluate(current.field)#">	
															
						</cfcatch>
						</cftry>														
																														
						<cfif len(selitem)*2 gt sizefield>																															
						     <cfset sizefield = len(selitem)*2>									
						</cfif>
						
						<cfif sizefield gte "100">
						     <cfset sizefield = "80">							  
						</cfif>
																															
					</cfif>	
																				
				</cfloop>					
				
				<!--- we set the width in an array --->
				<cfset wd[col] = sizefield>
				<cfset total = total +sizefield>
																
			<cfelse> 
			
			    <cfif find("%",  current.width)>
				    <cfset wd[col] = current.width>
				<cfelse> 
					<cfset wd[col] = current.width>
					<cfset total = total +current.width>
				</cfif>	
				
			</cfif>	
								  
		  </cfif>
		  		  	
    </cfloop>
					
	<!--- apply the width --->
	
	<cfset totalcols = totalcols+col>
	
	<cfset col = 0> 
			
	<cfloop array="#attributes.listlayout#" index="current">
	
		 <cfparam name="current.label"      default="">		
		 <cfparam name="current.formatted"  default="">
		 <cfparam name="current.width"      default="0">		
		 <cfparam name="current.display"    default="1">
		 <cfparam name="current.alias"      default="">	
		 <cfparam name="current.sort"       default="yes">
		 <cfparam name="current.align"      default="left">	
		 <cfparam name="current.fieldsort"  default="#current.field#">		
		 
		 <cfif current.rowlevel gte "2">
		 
		 <!--- n/a --->
		 
		 <cfelseif current.field eq url.listgroupfield>
		 		 
		 <!--- n/a --->
		 				 		 
		 <cfelseif current.display eq "1" and current.rowlevel eq "1">
		 
		 	<cfset col = col+1>		
			
			<cfparam name="wd[#col#]" default="10">
			
			<cfif find("%",current.width)>
				<cfset dw = "#current.width#">
			<cfelse>			
				<cfset dw = "#(wd[col]*100)/total#">
				<cfset dw = "#round(dw)#%">				
			</cfif>	
						
			<cfif current.formatted eq "class">
			
				<td style="min-width:20px;"> 
																	
			<cfelseif current.sort eq "No">
						
				    <cfif current.width eq "0">
					
					    <cfset size = len(current.label)+5>														
																						
						<cfloop query="searchresult" startrow="1" endrow="20">
												
							<cfset item = evaluate("#current.field#")>					
							
							<cfif len(item)*2 gt size>														
							   <cfset size = len(item)*2>
							</cfif>
						
						</cfloop>		
																
						<td style="width:#dw#;min-width:#size#;border-left:1px solid silver;padding-left:5px">	
																																	
						
					<cfelse>										
					
						<td style="width:#dw#;min-width:#current.width#;border-left:1px solid silver;padding-left:5px">		
																															
					</cfif>	
												
			<cfelse>
			
			    <cfif url.listorderdir is "ASC">
				     <cfset dir = "DESC">					
				<cfelse>
				     <cfset dir = "ASC">					 					
				</cfif>
								
				<cfset sc = "document.getElementById('listorderdir').value='#dir#';document.getElementById('listorderfield').value='#current.field#';document.getElementById('listorder').value='#current.fieldsort#';document.getElementById('listorderalias').value='#current.alias#';applyfilter('','','content')">
							
				<cfif find("%",current.width)> 								
				    <td style="min-width:20px;width:#current.width#;border-left:1px solid silver;padding-left:5px" onClick="#sc#">
				<cfelse>				
					<cfparam name="current.formatted" default="#current.field#">						
					<cfif current.formatted eq "">
						<cfset current.formatted = current.field>
					</cfif>																					 																
					<td onClick="#sc#" style="min-width:20px;width:#dw#;#stl#;border-left:1px solid silver;padding-left:5px">														
				</cfif>					
																	
			</cfif>
									
			<!--- header label --->
						  
				<table width="100%">
	
					  <cfset vThisAlign = current.align>
					  <cfset vThisAlignStyle = "padding-left: 0px;">
					  <cfif current.formatted eq 'Rating'>
					  	<cfset vThisAlign = 'center'>
					  </cfif>
					  <cfif vThisAlign eq 'right'>
					  	<cfset vThisAlignStyle = "padding-right: 8px;">
					  </cfif>
				      
					  <tr>
						  <td class="#attributes.classheader#" align="#vThisAlign#" style="#vThisAlignStyle#">#current.label#</td>
						
						  <cfif url.listorder eq current.fieldsort>
						  
						  <td align="right" style="padding-right:3px;">							  
						 
							    <cfif url.listorderdir is "ASC">
							 	    <img src="#SESSION.root#/Images/sort_asc.png" height="19px">
								<cfelse>							
									<img src="#SESSION.root#/Images/sort_desc.png" height="19px">
								</cfif>										  	  
						  </td>
						  
						  </cfif>	
						 
					  </tr>
	
				</table>
			  			  
			</td>
		  
		  </cfif>
		  	
    </cfloop>	
					
	<cfif attributes.listtype eq "Directory">	
		<td width="30" class="#attributes.classheader#"><cf_tl id="sel"></td>	
		<cfset totalcols = totalcols+1>
	</cfif>
	
	<cfif deletetable neq "" or deletescript neq "">	
		<td align="right" style="min-width:20px;border-left: 1px solid silver;border-right: 1px solid silver;"></td>	
		<cfset totalcols = totalcols+1>		
	</cfif>
	
	<cfif annotation neq "">	
		<td align="right" style="min-width:20px;border-left: 1px solid silver;border-right: 1px solid silver;"></td>		
		<cfset totalcols = totalcols+1>
	</cfif>
	
	
	<cfif presentation eq "group" and url.listcolumn1 neq "">
	
		<!--- added by hanno to control the spacing --->
		<td style="width:10%;border-left: 1px solid silver"></td>
		<cfset totalcols = totalcols+1>
	
	</cfif>
	
			
</tr>	

<!--- we put the format of the grid in the session --->
<cfset session.listingdata[box]['columns'] = totalcols>	
	
</cfoutput>	