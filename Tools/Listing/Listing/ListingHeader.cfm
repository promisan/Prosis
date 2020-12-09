<cfoutput>

<cfset stl = "cursor:pointer;font-size:12px;height:30px">

<tr style="height:32px" class="fixrow">

    <td style="min-width:30px"></td>	
    <td style="min-width:30px"></td>	
		
	<cfif attributes.selectmode neq "">
	   <td></td>
	</cfif>
	
	<!--- determine the best width --->
	
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
							 		 
		 <cfelseif current.display eq "1" and current.rowlevel eq "1">
		 
		    <cfset col = col+1>		 				
				
		    <cfif current.width eq "0">
			
			    <cfset size = len(current.label)+5>		
				
				<cfset labelsize = len(current.label)*3>	
				<cfset sizefield = len(current.label)*3>													
																								
				<cfloop query="searchresult" startrow="1" endrow="25">
				
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
		 				 		 
		 <cfif current.display eq "1" 
		     and current.rowlevel eq "1">
		 
		 	<cfset col = col+1>		
			
			<cfif find("%",  current.width)>
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
											
						<td style="width:#dw#;min-width:#size*10#;border-left:1px solid silver;padding-left:5px">								
											
												
					<cfelse> 
										
						<td style="width:#dw#;min-width:#current.width*10#;border-left:1px solid silver;padding-left:5px">				
																							
					</cfif>	
							
			<cfelse>
			
			    <cfif url.listorderdir is "ASC">
				     <cfset dir = "DESC">
				<cfelse>
				     <cfset dir = "ASC">					 
				</cfif>
								
				<cfset sc = "document.getElementById('listorderdir').value='#dir#';document.getElementById('listorderfield').value='#current.field#';document.getElementById('listorder').value='#current.fieldsort#';document.getElementById('listorderalias').value='#current.alias#';applyfilter('','','content')">
								
				<cfif find("%",current.width)> 								
				    <td width="#current.width#" style="border-left:1px solid silver;padding-left:5px" onClick="#sc#">					 					  					  
				<cfelse>				
					<cfparam name="current.formatted" default="#current.field#">						
					<cfif current.formatted eq "">
						<cfset current.formatted = "#current.field#">
					</cfif>																					 																
					<td onClick="#sc#" style="width:#dw#;#stl#;border-left:1px solid silver;padding-left:5px">									
					<cf_space spaces="#wd[col]#">										
				</cfif>	
													
			</cfif>
						
			<!--- table to be shown --->
						  
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
						 	    <img src="#SESSION.root#/Images/sort_asc.gif" alt="" border="0">
							<cfelse>
								<img src="#SESSION.root#/Images/sort_desc.gif" alt="" border="0">
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
	</cfif>
	
	<cfif deletetable neq "">	
	<td align="right" style="min-width:20px;border-left: 1px solid silver;"></td>			
	</cfif>
	
	<cfif annotation neq "">	
	<td align="right" style="min-width:20px;border-left: 1px solid silver;"></td>		
	</cfif>
	
</tr>	
	
</cfoutput>	