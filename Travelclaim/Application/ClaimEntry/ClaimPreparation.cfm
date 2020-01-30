
<cfoutput>

<script language="JavaScript">
	
		ie = document.all?1:0
		ns4 = document.layers?1:0
			
		function hl(itm,fld){
	
	     if (ie){
	          while (itm.tagName!="TR")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TR")
	          {itm=itm.parentNode;}
	     }
					 	 	
		 if (fld != "normal"){
			
		 itm.className = "highlight4";		 
		 }else{		
	     itm.className = "regular";		
		 }
	
	  }
	  
	 function home() {
		window.location = "#SESSION.root#/TravelClaim/Application/ClaimView/ClaimView.cfm?clear=#claim.ClaimId#&PersonNo=#URL.PersonNo#"
	  }
	 		
</script>


<cfif Claim.ActionStatus eq "0">
		
	<cfquery name="UpdateMode" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Claim 
			SET    ClaimAsIs = 0
			WHERE  ClaimId = '#URL.ClaimId#' 
	</cfquery>
	
	<cfquery name="UpdateMode" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE ClaimSection
			SET    ProcessStatus = 0
			WHERE  ClaimId = '#URL.ClaimId#' 
	</cfquery>
		
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="C0C0C0" rules="rows" >

	<tr><td height="30"></td></tr>
	
	<cfset express = 1>
	
	<tr>
		<td align="center">
			<table width="700" border="1" cellspacing="0" cellpadding="0" align="center">
			
			<tr><td height="27" class="top4n">
			
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr><td><font size="2" color="gray">&nbsp;<b>Step 1 of 3 : Select Your Claim Preparation mode</font></td>
					<td align="right"> 
					<b>
							<cf_helpfile 
					        code    = "TravelClaim" 
							class   = "General"
							id      = "PrEx"
							color   = "gray"
							name    = "Help me choose"
							display = "both"
							displaytext = "<B>Help me choose</B>">
					</b>
					</td>
					<td>&nbsp;</td>
					</tr>
				</table>
				
			</td>
			</tr>
			</table>
		</td>
	</tr>
	
	<tr>
	<td align="center">
	
	    <table width="700" border="1" frame="vsides" cellspacing="0" cellpadding="0" align="center" bgcolor="ECF5FF">
		 <cfinclude template="../Process/ValidationRules/ValidationRule_X01.cfm"> 
		 <cfif fileExists("#SESSION.rootPath#/TravelClaim/Application/Process/ValidationRules/ValidationRule_X02.cfm")>
                  <cfinclude template="../Process/ValidationRules/ValidationRule_X02.cfm">
		 </cfif>		 
	    <tr><td height="47">
	
		    <table cellspacing="0"  cellpadding="0" align="center">
			<tr>
		 
				<td><button class="buttonBlue"  onClick="home()" style="width:108px;height=35px">Back</button></td>
															  
			    <cfif express eq "1" <!--- and #Prior.recordcount# eq "0" --->>
				
				  <td width="60">
				    <button class="buttonBlue"  onClick="javascript:claimAs()" style="width:108px;height=35px">Express</button>
				  </td>						
				<cfelse>			
				  <td>			  
				    <button class="buttonRed" style="width:108px;height=35px">Express <br>not available</button>				   
				  </td>							 
				</cfif>	
				
				<cfif URL.Mode eq "0">		
				 <td width="60">
				    <button class="buttonBlue"  onClick="javascript:addevent('')">Detailed</button>			 
			  	 </td>		
				</cfif>
			
			</tr>
				  
		  </table>
		  </td>
		</tr>
		
	</table>
	</td>
	</tr>
	
	
	<tr>
		<td align="center">
		<table width="700" border="1" cellspacing="0" cellpadding="0" align="center">
				<tr><td bgcolor="f4f4f4" height="1"></td></tr>
		</table>
		</td>
	</tr>
	
		
	</table>
	
	
	</cfif>			
	
</cfoutput>		
	

