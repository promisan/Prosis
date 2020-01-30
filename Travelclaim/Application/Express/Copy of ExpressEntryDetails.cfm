<cfoutput>

<cfset url.topic = "additional">

<cfset bullet = "#SESSION.root#/images/select5.gif">

<table border="0" cellspacing="2" cellpadding="2">
	
	<tr>
	   <td colspan="2"><b><font color="0080FF">Claim Details</font></b></td>
	    <td align="right"><img src="#SESSION.root#/Images/step2.gif" alt="" border="0"></td>
	</tr>
	<tr>
	  <td height="1" colspan="2" bgcolor="EAEAEA"></td>
	</tr>	
			
	<tr>
		  
		<td width="30"><img src="#bullet#" align="absmiddle" alt="" border="0"></td>
		<td colspan="2">
		   <table cellspacing="1" cellpadding="0">
		   	<tr><td>You have travelled by:&nbsp;
		
				<cfquery name="TravelMode" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM Ref_ClaimEvent
					WHERE Operational = 1
					AND PointerExpress = 1
				</cfquery>
				
				<cfquery name="Trip" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT     T.*
					FROM       ClaimEvent E, ClaimEventTrip T
					WHERE ClaimId = '#URL.ClaimId#'
					AND   E.ClaimEventId = T.ClaimEventId
				</cfquery>
			  </td>
			  <td>		
						
				<select name="EventCode">
					<cfloop query="TravelMode">
						    <option value="#code#" <cfif #code# eq "#Trip.EventCode#">selected</cfif>>#Description#</option>
					</cfloop>
				</select>
			
			</td>
			</table>
				
		</td>
		</tr>
								
		<tr>
			 <td width="30"><img src="#bullet#" align="absmiddle" alt="" border="0"></td>
			 <td colspan="2">
			 <table cellspacing="1" cellpadding="0">
			 <tr><td>
			 Was UN or Government vehicle made available to you at any authorised Departure and/or Arrival ?
			 </td><td width="90">
			    <input type="radio" name="vehicle" value="0" checked onclick="show('trip','hide')">No
				<input type="radio" name="vehicle" value="1" onclick="show('trip','show')">Yes
			 </td>
			</tr>
			</table>
			</td>
		</tr>
				
		<script language="JavaScript">
		
			function show(itm,act){					 
				 se = document.getElementById(itm)						 
				 if (act == "hide") {						   
				 se.className = "hide";			 			 
				 } else {
				 se.className = "regular";				 
				 }			
			 }  
		  		
		</script>
					
		<tr id="trip" class="hide">
		<td colspan="3">
		<cfinclude template="ExpressEntryTrip.cfm">
		</td></tr>	
			
		<tr><td height="4" colspan="3"></td></tr>		
		<tr>	
		<td width="30"><img src="#bullet#" align="absmiddle" alt="" border="0"></td>
		<td><b>Travel Advance</b></td>
		</tr>
		<tr>
		<td></td>
		<td width="100%" colspan="2" height="25">
		<table width="100%" align="right" cellspacing="0" cellpadding="0">
			<tr><td>
				<cfinclude template="../ClaimEntry/ClaimAdvance.cfm">
			</td></tr>	
			<tr><td height="1" colspan="2" bgcolor="d3d3d3"></td></tr>
			<tr><td height="4"></td></tr>
			<tr><td colspan="2" bgcolor="ffffff">
			
			<cfquery name= "Trip" 
			datasource   = "appsTravelClaim" 
			username     = "#SESSION.login#" 
			password     = "#SESSION.dbpw#">
			SELECT     TOP 1 T.*
			FROM       ClaimEvent E, ClaimEventTrip T
			WHERE      ClaimId = '#URL.ClaimId#'
			AND        E.ClaimEventId = T.ClaimEventId
			ORDER BY   LocationDate
			</cfquery>
			
			 <cf_ClaimEventEntryIndicatorPointer
				category = "'Additional'"
				fld      = "a1_"
				width    = "100%"
				tripid   = "#Trip.ClaimTripId#">								
								
				<cfset cl = returnval>				
					
			</td></tr>
			<tr><td height="5"></td></tr>
			<tr id="fld_a1_A01" colspan="2" class="#cl#">
			<td align="center">
			
			<cfoutput>
			<cfajaximport tags="CFDIV,CFWINDOW,CFFORM,CFINPUT-DATEFIELD,cftooltip">
	
			<script language="JavaScript1.2">
			
			function currencyFormat(field,amount) {
				// created a comma seperated currency amount
				var objRegExp = new RegExp('(-?\[0-9]+)([0-9]{3})');
				while(objRegExp.test(amount)) amount = amount.toString().replace(objRegExp,'$1,$2');
				document.getElementById(field).value = amount
				}
			
			function insertcost(title,mde,clm,per,ind,id2) {
			   ColdFusion.Window.create('costings', 'Dialog', '',{x:100,y:100,height:300,width:400,modal:true,center:true})		
			   ColdFusion.navigate('../EventEntry/ClaimEventEntryIndicatorEntryDialog.cfm?title='+title+'&editclaim='+mde+'&claimid='+clm+'&personno='+per+'&indicatorcode='+ind+'&id2='+id2,'costings')			
			}
			
			function deletecost(mde,clm,per,ind,id2) {
			   ColdFusion.navigate('../EventEntry/ClaimEventEntryIndicatorEntryCostDelete.cfm?editclaim='+mde+'&claimid='+clm+'&personno='+per+'&indicatorcode='+ind+'&id2='+id2,'b'+per+'_'+ind) 
			}	
					   
			function verify(fld,val) {
			   
			       try {
			   	   se1 = document.getElementById("fld_"+fld)
				   if (se1) {
					   if (val != "No") { 
					    se1.className = "regular"  
						try {
						document.getElementById("addADV").click()						
						} catch(e) {}
					   } else { 
					   se1.className = "hide"  }
				   }
				   
				   } catch(e) {}
				   
			   }
						
			</script>
			
			<cfdiv 
				  bind="url:../EventEntry/ClaimEventEntryIndicatorEntryCostRecord.cfm?editclaim=1&header=1&claimid=#URL.ClaimID#&personNo=#PersonNo#&indicatorcode=ADV" 
				  id="b_ADV">
			
			</cfoutput>
			
			</td>
			</tr>		
			
			<tr><td height="4"></td></tr>
		</table>
		</td>
		</tr>
		
		<tr><td height="4" colspan="3">
		
			<table cellspacing="0" cellpadding="0">
			<tr>
			<td width="30"><img src="#bullet#" alt="" border="0"></td>
			<td height="1" colspan="3"><b>&nbsp;Reimbursement</b>&nbsp;</td> 
			<td>
			  <cf_helpfile code       = "TravelClaim" 
				    id          = "Payment" 
					display     = "Icon"	
					displayText = "Payment Instruction"				
					color       = "006688">
			  </td>
			</tr>
			</table>
		</td></tr>
				
		<tr>
			<td width="30"></td>
			<td colspan="2">
			<table width="99%" align="center">
			<cfset mode = "express">
			<cfinclude template="../ClaimEntry/ClaimInfoPayment.cfm">
			</table>
			</td>
		</tr>
		
		<tr><td height="5" colspan="3"></td></tr>
		<tr><td height="1" colspan="3" bgcolor="e4e4e4"></td></tr>
		<tr><td height="5" colspan="3"></td></tr>
					
		<tr><td colspan="3" align="center">
		
			<table cellspacing="2" cellpadding="2">
			<tr>
				<td>
				
					<input name="Agree" 
					class   = "ButtonNav1"
					value   = "Previous" 
					type    = "button"
					style   = "width:150"
					onclick = "step('hide','regular','hide','hide')"
					onMouseOver = "change(this,'ButtonNav11')"
					onMouseOut  = "change(this,'ButtonNav1')">
				
				</td>
				
				<td>
				
				<!--- custom script --->
												
				<script language="JavaScript">
				 function checksubmit() {

					 se = document.getElementsByName("vehicle")
					 					 					 
					 if (se[1].checked == true) {
					 
					    ck  = 0
					    row = 1
					    while (#trm# >= row) {
						   
						    val = document.getElementsByName(row+"_") 
						    count = 0
						   
						    while (val[count]) {
						       if (val[count].checked == true) { ck = 1 }
						       count++						  	 
						    }   
						    row++							
						}
																		
						if (ck == 0) {
						alert("You did not select any vehicle information.")
						return false
						} else {
						
						   co = document.getElementsByName("a1_")
						 							
						   if (co[0].value == "Yes") {
						   					   
						   		try {
						 	    val = document.getElementById("inv1").value
							    } catch(e) { val = "" }
								
								if (val == "") {
							      alert("Please record an advance before you may proceed.")
							      return false 
								  } else {
								  step('hide','hide','hide','regular')
								  }
							    
						     } else {
							  step('hide','hide','hide','regular')							 
							 }	
						
						 
						}
					  						
					 } else {					 
					 		  
						   co = document.getElementsByName("a1_")
						 							
						   if (co[0].value == "Yes") {
						   					   
						   		try {
						 	    val = document.getElementById("inv1").value
							    } catch(e) { val = "" }
								
								if (val == "") {
							      alert("Please record an advance before you may proceed.")
							      return false 
								  } else {
								  step('hide','hide','hide','regular')
								  }
							    
						     } else {
							  step('hide','hide','hide','regular')							 
							 }	
						  	 						 
					}	
	   
										 
				}
					
				</script>
				
				
				
				<input name = "Agree" 
				class       = "ButtonNav1"
				value       = "Proceed" 
				type        = "button"
				style       = "width:150"
				onclick     = "checksubmit();"
				onMouseOver = "change(this,'ButtonNav11')"
				onMouseOut  = "change(this,'ButtonNav1')">
				
				</td>				
				
			</tr>
			</table>
							
		</td></tr>
		
</table>
	
	
</cfoutput>	