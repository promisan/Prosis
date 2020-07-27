
<cfparam name="URL.access" default="EDIT">

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  RequisitionLine 
	WHERE RequisitionNo = '#URL.ID#'
</cfquery>

<cfquery name="Detail" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  RequisitionLineTravel 
	WHERE RequisitionNo = '#URL.ID#'
</cfquery>

<cfif Detail.recordcount eq "0">
   <cfparam name="URL.ID2" default="new">
<cfelse>
   <cfparam name="URL.ID2" default="">   
</cfif>
	
<table width="100%">
  
	<cfquery name="Itin" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
	    FROM    RequisitionLineItinerary I 
		        LEFT OUTER JOIN TravelClaim.dbo.Ref_CountryCity C ON I.CountryCityId = C.CountryCityId 
			    LEFT OUTER JOIN System.dbo.Ref_Nation R ON R.Code = C.LocationCountry
		WHERE   I.RequisitionNo = '#URL.ID#'		
	</cfquery>
	
	
	    
   <tr>	
    <td colspan="2" width="100%" align="center">
	
    <table width="100%" class="navigation_table">
	
		<cfset jvlink = "ProsisUI.createWindow('dialogitin', 'Maintain Travel Itinerary', '',{x:100,y:100,height:600,width:820,scrollable:false,resizable:true,modal:true,center:true})">		
	  	
		<cfif url.access eq "Edit">
		
			<cfoutput>
			<tr class="line"><td colspan="8" class="labelmedium line" style="font-size:20px;height:40px">
				  
				  <A href="javascript:#jvlink#;ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Travel/ItineraryEdit.cfm?ID=#URL.ID#&ID2=new','dialogitin')"><cf_tl id="Maintain Itinerary"></a>			
				  
				  <cfif Itin.recordcount gte "1" and Itin.recordcount lte "2">
				  	<font color="FF0000"><cf_tl id="Incomplete"></font>
				  </cfif>
				  
			</td></tr>
			</cfoutput>
			
		<cfelse>	
		
			<cfoutput>
			<tr class="line"><td colspan="8" height="20" class="labelmedium" style="font-size:20px">
				  
				 <cf_tl id="Itinerary">			
				  
				  <cfif Itin.recordcount gte "1" and Itin.recordcount lte "2">
				  	<font color="FF0000"><cf_tl id="Incomplete"></font>
				  </cfif>
				  
			</td></tr>
			</cfoutput>
					
		</cfif>
			
	    <tr bgcolor="white" class="line labelmedium">
		   <td style="padding-left:3px;min-width:140"><cf_tl id="Country"></td>	
		   <td style="min-width:140"><cf_tl id="City"></td>	
		   
		   <td style="min-width:140"><cf_tl id="Date"></td>
		   <td style="min-width:100"><cf_tl id="Mode"></td>
		   <td style="min-width:100"><cf_tl id="Class"></td>
		   <td style="width:100%"><cf_tl id="Memo"></td>			      		  		  		  
		   <td width="1%" align="center"></td>
		  
	    </TR>	
									
		<cfoutput query="Itin">			
		     				
			<TR class="line navigation_row labelmedium" style="height:20px">
			    <td style="padding-left:4px">#Name#</td>
			    <td>#LocationCity#</td>		
				<td><cfif dateArrival neq "">a: #dateformat(dateArrival,CLIENT.DateFormatShow)#<cfelseif dateDeparture neq "">d: #dateformat(dateDeparture,CLIENT.DateFormatShow)#</cfif></td>				
				<td>#TransportMode#</td>			
				<td>#TransportClass#</td>						    	
				<td>#Memo#</td>			
				<td></td>				   		   
		    </TR>	
			
		</cfoutput>
							
	</table>
	</td>
	</tr>
		
	<cfif Itin.recordcount gte "3">
				
		<tr class="line">
	    	<td colspan="2" class="labelmedium" style="font-size:20px;height:40px"><cf_tl id="Other Travellers"></td>	
	    </tr>
		
		<tr>	
	    <td colspan="2" width="100%" align="center">
	   		<cfdiv id="divBeneficiary" bind="url:#session.root#/procurement/application/requisition/travel/beneficiary/beneficiarylisting.cfm?requisitionno=#url.id#&mission=#line.mission#&access=#url.access#">	   
		</td>
		
		</tr>
	    
		<cfquery name="Detail" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  RequisitionLineTravel 
			WHERE RequisitionNo = '#URL.ID#'
		</cfquery>
	  
	    <tr class="line">
	    	<td colspan="2" class="labelmedium" style="font-size:20px;height:40px"><cf_tl id="Per diem and Travel Expenses"></td>	
	    </tr>
	  
	    <tr>	
	    <td colspan="2" width="100%" align="center">
	    <table width="100%" class="formpadding">
				
		    <tr class="line labelmedium">
			   <td style="min-width:90px;padding-left:3px"><cf_tl id="Updated"></td>	
			   <td style="min-width:100px"><cf_tl id="Category"></td>	
			   <td style="min-width:100px"><cf_tl id="Location"></td>
			   <td style="min-width:150px"><cf_tl id="Memo"></td>
			   <td style="min-width:90px"><cf_tl id="From"></td>		   
			   <td style="min-width:90px"><cf_tl id="Until"></td>
			   <td width="50" align="right"><cf_tl id="Qty"></td>	
			   <td align="right">
			   
			   <cfquery name="Parameter" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT * 
				  FROM   Ref_ParameterMission
				  WHERE  Mission = '#Line.Mission#'	 
			   </cfquery>	
		   
		   <table class="navigation_table">
		   
		   <cfif parameter.EnableCurrency eq "0">
		   
		   <td><cf_tl id="Costing"></td>
		   
		  
		   <cfelse>
		   
		   <td></td>
		  
		  		   		   			
				<cfquery name="Currency" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
					FROM Currency
					WHERE EnableProcurement = 1
				</cfquery>
		   
			     <cfif Line.RequestCurrency eq "">
					<cfset cur = APPLICATION.BaseCurrency>
				<cfelse>
				    <cfset cur = Line.RequestCurrency>
				</cfif>
				
				<cfoutput>	
				
				<td style="padding-left:3px">
				
				<cfif url.access eq "edit">
				<select name="ratecurrency" id="ratecurrency" size="1" class="regularxl"		        
		        onChange="document.getElementById('requestcurrency').value=this.value;base2('#url.id#',requestcurrencyprice.value,requestquantity.value);">
				
					<cfloop query="currency">
						<option value="#Currency#" <cfif Currency eq cur>selected</cfif>>
				   		#Currency#
						</option>
					</cfloop>
				</select>
				</cfif>
				
				</td>
				</cfoutput>
				
			</cfif>	
			</tr>
			</table>
			
			</td>	
			
		   <td align="right">%</td>		   
		   <td align="right"><cf_tl id="Amount"></td>
		     		  
			   <td style="min-width:70px" align="right">
			   
			     <cfset jvlink = "ProsisUI.createWindow('dialogtravel', 'Maintain DSA and Travel Costs', '',{x:100,y:100,height:485,width:820,resizable:false,modal:true,center:true})">		
		         <cfoutput>
				 <cfif url.access eq "Edit">				 	
				     <A href="javascript:#jvlink#;ptoken.navigate('../Travel/TravelItemEdit.cfm?ID=#URL.ID#&ID2=new','dialogtravel')">[<cf_tl id="add">]</a>
				 </cfif>
				 </cfoutput>
			   </td>
			  
		    </TR>	
			
			<cfif Detail.recordcount eq "0" and url.access eq "edit">
			
			<cfoutput>
			<tr><td colspan="8" height="20">
				 <A href="javascript:#jvlink#;ptoken.navigate('../Travel/TravelItemEdit.cfm?ID=#URL.ID#&ID2=new','dialogtravel')"><cf_tl id="Record Travel Expenses"></a>			
			</td></tr>
			</cfoutput>
			
			</cfif>
						
			<cfoutput query="Detail">	
			
				<cfset jv = "ProsisUI.createWindow('dialogtravel', 'Maintain DSA and Travel Costs', '',{x:100,y:100,height:485,width:820,resizable:false,modal:true,center:true})">		
		        				
				<TR class="linedotted labelmedium navigation_row" style="height:20px">
				    <td style="padding-left:4px">#dateformat(created,CLIENT.DateFormatShow)#</td>
				    <td>#ClaimCategory#</td>
					<td><cfif LocationCode eq ""><cfelse>#LocationCode#</cfif></td>
					<td>#Memo#</td>
				    <td>#dateformat(dateeffective,CLIENT.DateFormatShow)#</td>
					<td>#dateformat(dateexpiration,CLIENT.DateFormatShow)#</td>				
				    <td align="right" height="20">#quantity#</td>			    
					<td width="100" align="right">#numberformat(UoMRate,",.__")#</td>	
					<td width="100" align="right">#numberformat(UoMPercentage,",._")#</td>		
					<td width="100" align="right">#numberformat(Amount,",.__")#</td>			
				    <td align="right" style="padding-top:3px">
					
						<cfif url.access eq "Edit">
					
						<table>
						
							<tr>
							<td>
							<cf_img icon="edit" onclick="_cf_loadingtexthtml='';#jv#;ptoken.navigate('../Travel/TravelItemEdit.cfm?ID=#URL.ID#&ID2=#detailid#','dialogtravel')">
							</td>					
							<td style="padding-left:3px">
							<cf_img icon="delete" onclick="_cf_loadingtexthtml='';	ptoken.navigate('../Travel/TravelItemPurge.cfm?ID=#URL.ID#&ID2=#detailid#','iservice')">				 
							</td>
							</tr>
						
						</table>
						
						</cfif>
					
				  </td>				   
			    </TR>	
															
			</cfoutput>
								
		  </table>
		  </td>
		  </tr>
	 
		  
	  </cfif>
	  
	  <tr><td style="height:10px"></td></tr>
	
							
</table>

<cfset ajaxonload("doHighlight")>

