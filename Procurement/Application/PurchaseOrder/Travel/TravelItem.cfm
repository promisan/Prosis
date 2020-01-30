
<cfparam name="URL.access" default="#url.mode#">

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*, P.Mission, P.PersonNo
    FROM  PurchaseLine L, Purchase P
	WHERE L.RequisitionNo = '#URL.ID#'
	AND  L.PurchaseNo = P.PurchaseNo
</cfquery>
	
<table width="100%">
  
	<cfquery name="Itin" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  RequisitionLineItinerary I, 
		      TravelClaim.dbo.Ref_CountryCity C, 
			  System.dbo.Ref_Nation R
		WHERE I.CountryCityId = C.CountryCityId
		AND   I.RequisitionNo = '#URL.ID#'
		AND   R.Code = C.LocationCountry
	</cfquery>
	    
   
   <tr>	
    <td colspan="2" width="100%" align="center">
	
    <table width="100%" align="center" class="formpadding">
	
		<cfset jvlink = "ProsisUI.createWindow('dialogitin', 'Maintain Travel Itinerary', '',{x:100,y:100,height:600,width:720,resizable:true,modal:true,center:true})">		
	  	
		<cfif url.access eq "Edit">
		
			<cfoutput>
			<tr class="labelmedium line"><td colspan="8" class="line" style="font-size:19px;height:38px">
				  
				  <A href="javascript:#jvlink#;ptoken.navigate('../../Requisition/Travel/ItineraryEdit.cfm?ID=#URL.ID#&ID2=new','dialogitin')"><cf_tl id="Maintain Itinerary"></a>			
				 
				  <cfif Itin.recordcount gte "1" and Itin.recordcount lte "2">
				  	<font color="FF0000">Incomplete</font>
				  </cfif>
				  
			</td></tr>
			</cfoutput>
					
		</cfif>
			
	     <tr bgcolor="white" class="line labelmedium">
		   <td style="min-width:140"><cf_tl id="Country"></td>	
		   <td style="min-width:140"><cf_tl id="City"></td>	
		   
		   <td style="min-width:140"><cf_tl id="Date"></td>
		   <td style="min-width:100"><cf_tl id="Mode"></td>
		   <td style="min-width:100"><cf_tl id="Class"></td>
		   <td style="width:100%"><cf_tl id="Memo"></td>			      		  		  		  
		   <td width="1%" align="center"></td>
		  
	    </TR>	
									
		<cfoutput query="Itin">	
		
			<cfset jv = "ColdFusion.Window.create('dialogitin', 'Maintain Travel Itinerary', '',{x:100,y:100,height:600,width:720,resizable:true,modal:true,center:true})">		
	        				
			<TR class="linedotted navigation_row labelmedium" style="height:20px">
			    <td>#Name#</td>
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
	    
		<cfquery name="Detail" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  PurchaseLineTravel 
			WHERE RequisitionNo = '#URL.ID#'
		</cfquery>
	  
 	    <tr class="labelmedium line"><td colspan="2" style="font-size:19px;height:38px">
	    Maintain DSA and Travel Expenses</td>	
	    </tr>
	  	  
	    <tr>	
	    <td colspan="2" width="100%" align="center">
	    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table formpadding">
				
		    <tr class="linedotted labelmedium">
			   <td width="80"><cf_tl id="Updated"></td>	
			   <td width="60"><cf_tl id="Category"></td>	
			   <td width="10%"><cf_tl id="Location"></td>
			   <td width="80"><cf_tl id="From"></td>		   
			   <td width="80"><cf_tl id="Until"></td>
			   <td width="60" align="right"><cf_tl id="Quantity"></td>	
			   <td align="right">
			 			   
			   <cfquery name="Parameter" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT * 
				  FROM   Ref_ParameterMission
				  WHERE Mission = '#Line.Mission#'	 
		   </cfquery>	
		   
		   <cfif parameter.EnableCurrency eq "0">
		   
		   Rate
		   
		   <cfelse>
		   
		   Rate in 
		   		   			
				<cfquery name="Currency" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
					FROM Currency
					WHERE EnableProcurement = 1
				</cfquery>
		   
			     <cfif Line.Currency eq "">
					<cfset cur = APPLICATION.BaseCurrency>
				<cfelse>
				    <cfset cur = Line.Currency>
				</cfif>
				
				<cfif url.access eq "view">
				
					<cfoutput>#cur#</cfoutput>
				
				<cfelse>
				
					<cfoutput>	
					
					<select name="ratecurrency" id="ratecurrency" size="1" onchange="ptoken.navigate('PurchaseLineEditTravel.cfm?id=<cfoutput>#url.id#</cfoutput>','saving','','','POST','entry')"		 
			        style="font-size:9px">
					
						<cfloop query="currency">
							<option value="#Currency#" <cfif Currency eq cur>selected</cfif>>
					   		#Currency#
							</option>
						</cfloop>
						
					</select>
					
					</cfoutput>
				
				</cfif>
				
			</cfif>	
			
			</td>	
			
			<td align="right"><cf_tl id="Percent"></td>		   
		    <td align="right"><cf_tl id="Amount"></td> 
			 		  
			<td width="7%" align="center">
			   
			    <cfset jv = "ProsisUI.createWindow('dialogtravel', 'Maintain DSA and Travel Costs', '',{x:100,y:100,height:425,width:620,resizable:false,modal:true,center:true})">		
		         <cfoutput>
				 <cfif url.access eq "Edit">					 		 	
				     <A href="javascript:#jv#;ColdFusion.navigate('../Travel/TravelItemEdit.cfm?ID=#URL.ID#&ID2=new','dialogtravel')"><font color="0080FF">[add]</font></a>
				 </cfif>
				 </cfoutput>
			</td>
			  
		    </TR>	
										
			<cfquery name="Detail" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  PurchaseLineTravel 
				WHERE RequisitionNo = '#URL.ID#'
			</cfquery>
					
			<cfif Detail.recordcount eq "0">
			   <cfparam name="URL.ID2" default="new">
			<cfelse>
			   <cfparam name="URL.ID2" default="">   
			</cfif>
			
			<cfif Detail.recordcount eq "0">
			
				<cfoutput>
				<tr><td colspan="8" height="20" class="labelit">
					<img src="#SESSION.root#/Images/finger.gif" alt="" border="0" align="absmiddle">
					     <A href="javascript:#jv#;ColdFusion.navigate('../Travel/TravelItemEdit.cfm?ID=#URL.ID#&ID2=new','dialogtravel')">Record Travel Expenses</font></a>			
				</td></tr>
				</cfoutput>
				
			</cfif>
			
			<cfoutput query="Detail">			
								
				<TR class="linedotted labelmedium navigation_row">
				    <td style="padding-left:4px">#dateformat(created,CLIENT.DateFormatShow)#</td>
				    <td>#ClaimCategory#</td>
					<td><cfif LocationCode eq "">undefined<cfelse>#LocationCode#</cfif></td>
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
							<cf_img icon="edit" onclick="_cf_loadingtexthtml='';#jv#;ColdFusion.navigate('../Travel/TravelItemEdit.cfm?ID=#URL.ID#&ID2=#detailid#','dialogtravel')">
							</td>					
							<td style="padding-left:3px">
							<cf_img icon="delete" onclick="_cf_loadingtexthtml='';	ColdFusion.navigate('../Travel/TravelItemPurge.cfm?ID=#URL.ID#&ID2=#detailid#','iservice')">				 
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
							
</table>

