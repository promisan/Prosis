
<cfsilent>

	<proUsr>administrator</proUsr>
	<proOwn>Hanno van Pelt</proOwn>
	<proDes></proDes>
	<proCom></proCom>
	<proCM></proCM>
	<proInfo>
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td>
	This template is the is the master template loaded for ADDITIONAL information screen. 
	</td></tr>
	</table>
	</proInfo>

</cfsilent>

<cfoutput>
<link href="#SESSION.root#/#client.style#" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="#SESSION.root#/print.css" media="print">
</cfoutput>

<div class="screen">
<body leftmargin="5" topmargin="0" rightmargin="0" bottommargin="0">	

<cfset header = "ffffff">

<cfquery name="Claim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 *
	FROM  Claim 
	WHERE ClaimId = '#URL.ClaimId#' 
</cfquery>

<cfquery name="ClaimTitle" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT C.*, 
	       R.PointerStatus, 
		   R.Description as StatusDescription, 
		   P.Description as Purpose,
		   Org.OrgUnitName
	FROM   ClaimRequest C, 
	       Ref_Status R, 
		   Ref_ClaimPurpose P,
		   Organization.dbo.Organization Org
	WHERE  ClaimRequestId = '#Claim.ClaimRequestId#'
	AND C.ActionStatus *= R.Status
	AND C.ActionPurpose *= P.Code
	AND C.OrgUnit *= Org.OrgUnit 
	AND R.StatusClass = 'ClaimRequest'
</cfquery>

<cfoutput>

<table width="100%" height="100%" bgcolor="ffffff" frame="hsides" border="0" cellspacing="2" cellpadding="2" bordercolor="d4d4d4" >

<cfform name="additional" action="ClaimEventAdditionalSubmit.cfm?Section=#URL.Section#&claimId=#URL.ClaimId#" method="POST">

<tr><td height="4"></td></tr>

<tr><td height="1" colspan="2">	  
	  <cfinclude template="ClaimPreparation.cfm">	  
 </td></tr>

<tr>
<td height="22">
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr>
		<td>
		<table cellspacing="0" cellpadding="0">
		<tr>
		<td width="25"><cfoutput><img src="#SESSION.root#/Images/join.gif" alt="" border="0"></cfoutput></td>	
		<td><font face="Verdana" size="2"><b>Additional Information</TD>
		<td>&nbsp;</td>
		<TD>		
		<cf_helpfile code       = "TravelClaim" 
			    id          = "Addt" 
				display     = "Icon"	
				displayText = "Additional Information"				
				color       = "006688">
		
		</td>
		</table>
		</td>
	</tr>
	</table>
</tr>	
<tr><td height="1" colspan="2" valign="top" bgcolor="C0C0C0"></td></tr>

<cfset topic = "E9ECF5">

<cfinclude template="../Inquiry/eMail/eMail.cfm">
		
<tr><td valign="top">

	<table width="100%" border="0" cellspacing="1" cellpadding="0" bordercolor="eaeaea">
	
	<tr bgcolor="#header#">
		<td colspan="2" height="23">
		<table cellspacing="0" cellpadding="0">
		<tr>
		  <td width="30" align="center"><img src="#SESSION.root#/Images/bullet.gif" alt="Travel Advance" border="0" align="absmiddle"></td>
		  <td><font face="Verdana"><b>Travel Advance</b>&nbsp;</td>
		</tr>
		</table>
		</td>		
	</tr>
			 
	<tr>	
		<td width="3%" style="border-right: 0px solid Silver;"></td>
		<td width="97%" height="25" >
		<table width="99%" align="right" cellspacing="0" cellpadding="0">
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
			
			<script language="JavaScript1.2">
			   
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
			
			<!--- selectbox --->
			
			 <cf_ClaimEventEntryIndicatorPointer
				category   = "'Additional'"
				fld        = "1_"
				width      = "100%"
				editclaim  = "#editclaim#"
				formsubmit = "ClaimEventAdditionalSubmit.cfm?Section=#URL.Section#&claimId=#URL.ClaimId#"
			    formname   = "additional"	
				status     = "#claim.actionstatus#"
				tripid     = "#Trip.ClaimTripId#">
				
				<cfset cl = returnval>		
				
					
			</td></tr>
			<tr><td height="4"></td></tr>
		</table>
		</td>
	</tr>
				
	<!--- hardcoded the reference 17/8/2006 --->		
		
	<tr id="fld_1_A01" class="#cl#">
	<td width="3%" style="border-right: 0px solid Silver;"></td>
	<td align="center">
	
	<cfajaximport tags="CFDIV,CFWINDOW,CFFORM,CFINPUT-DATEFIELD,cftooltip">
	
	<script language="JavaScript1.2">
	
	function currencyFormat(field,amount) {
		// created a comma seperated currency amount
		var objRegExp = new RegExp('(-?\[0-9]+)([0-9]{3})');
		while(objRegExp.test(amount)) amount = amount.toString().replace(objRegExp,'$1,$2');
		document.getElementById(field).value = amount
		}
	
	function insertcost(title,mde,clm,per,ind,id2) {
	   ColdFusion.Window.create('costings', 'Dialog', '',{x:100,y:100,height:400,width:500,modal:true,center:true})		
	   ColdFusion.navigate('ClaimEventEntryIndicatorEntryDialog.cfm?title='+title+'&editclaim='+mde+'&claimid='+clm+'&personno='+per+'&indicatorcode='+ind+'&id2='+id2,'costings')			
	}
	
	function deletecost(mde,clm,per,ind,id2) {
	   ColdFusion.navigate('ClaimEventEntryIndicatorEntryCostDelete.cfm?editclaim='+mde+'&claimid='+clm+'&personno='+per+'&indicatorcode='+ind+'&id2='+id2,'b'+per+'_'+ind) 
	}
	
	
	
	</script>
	
	  <cfdiv 
		  bind="url:ClaimEventEntryIndicatorEntryCostRecord.cfm?title=Record Advance&editclaim=1&header=1&claimid=#URL.ClaimID#&personNo=#PersonNo#&indicatorcode=ADV" 
		  id="b_ADV">
		  
		  
		</td>
	</tr>		
					
	<tr><td colspan="1" bgcolor="C0C0C0" id="fld_1_A01_2" class="hide"></td></tr>
	
	<tr bgcolor="#header#">
		<td colspan="2" height="23">
		<table cellspacing="0" cellpadding="0">
		<tr>
		  <td width="30" align="center"><img src="#SESSION.root#/Images/bullet.gif" alt="Remarks" border="0" align="absmiddle"></td>
		  <td><font face="Verdana"><b>Remarks and Attachments</b>&nbsp;</td>
		  <td>
		  <cf_helpfile code       = "TravelClaim" 
						    id          = "Remarks" 
							display     = "Icon"	
							displayText = "Remarks and Attachments"				
							color       = "006688">
		  
		  </td>
		</tr>
		</table>
		</td>
		
	</tr>
		
	<tr>
		<td width="3%" style="border-right: 0px solid Silver;"></td>
		<td width="96%">
		<table width="99%" align="right" cellspacing="0" cellpadding="0">				
		<tr><td colspan="1">
		<cfif claim.actionStatus lte "1" and editclaim eq "1">
		<img src="#SESSION.root#/Images/finger.gif" alt="" border="0" align="absmiddle">
		<font color="3388aa">Any remarks entered here will cause this claim to be forwarded to your EO/Substantive Office for additional review</font>
		</cfif>
		</td></tr>
		
		<tr>
			<td>
			
			<cfif claim.actionStatus lte "1" and editclaim eq "1">
				<textarea style="width:94%" rows="5" name="Remarks" onchange="ColdFusion.Ajax.submitForm('additional','ClaimEventAdditionalRemarks.cfm?claimid=#url.claimid#')" class="regular">#claim.remarks#</textarea>
			<cfelse>
			<cfif claim.remarks eq "">
			[no remarks]
			<cfelse>
			#claim.remarks#
			</cfif>
			</cfif>	
			</td>
		</tr>
		<tr><td height="7"></td></tr>
		<tr>
		  <td colspan="1">
		    <cfif claim.actionStatus gte "2" and editclaim eq "1">
				<cfset url.mode = "Inquiry">
			<cfelse>
			    <cfset url.mode = "Edit">
			</cfif>
		    <cfinclude template="ClaimEventAdditionalAttachment.cfm">
		  </td>
		</TR>
		<tr><td height="7"></td></tr>
		</table>
	</td></tr>	
	
	<tr bgcolor="#header#">
		<td colspan="2" height="23">
		<table cellspacing="0" cellpadding="0">
		<tr>
		  <td width="30" align="center"><img src="#SESSION.root#/Images/bullet.gif" alt="Mode of payment" border="0" align="absmiddle"></td>
		  <td><font face="Verdana"><strong>Reimbursement</strong>&nbsp;</td>
		  <td>
		  <cf_helpfile code       = "TravelClaim" 
			    id          = "Payment" 
				display     = "Icon"	
				color       = "006688">
				<!--- displayText = "Payment Instruction"	--->
		  </td>
		</tr>
		</table>
		</td>
		
	</tr>
	
	<tr>	
		<td width="4%" style="border-right: 0px solid Silver;"></td>
		<td>
		<table width="100%" cellspacing="0" cellpadding="0" align="right">
			<cfset mode = "express">
			<cfinclude template="../ClaimEntry/ClaimInfoPayment.cfm">
		</table>
		</td>
	</tr>
	
			
	<tr><td height="5"></td></tr>
	
	<tr bgcolor="#header#">
		<td colspan="2" height="23">
		<table cellspacing="0" cellpadding="0">
		  <tr>
		  <td width="30" align="center"><img src="#SESSION.root#/Images/bullet.gif" alt="EMail address" border="0" align="absmiddle"></td>
		  <td><font face="Verdana"><b><b>Send correspondence to eMail address:</b>&nbsp;</td>
		  <td>
		   <cf_helpfile code       = "TravelClaim" 
			    id          = "eMail" 
				display     = "Icon"	
				displayText = "EMail Address"				
				color       = "006688">
		  </td>
		  </tr>		 
		 </table>
		</td>
	</tr>	
	<tr>	
	  <td width="3%" style="border-right: 0px solid Silver;"></td>	  
	  <td height="27">&nbsp;
	  
	      <cfif claim.actionstatus lt "2" and editclaim eq "1">
		  
			  <cfinput type="Text" 
	           name="eMailAddress" 
			   value="#mail#" 
			   onchange="ColdFusion.Ajax.submitForm('additional','ClaimEventAdditionalRemarks.cfm?claimid=#url.claimid#')"
			   message="You must submit your Internet eMail address." 
			   validate="email" 
			   required="Yes" 
			   visible="Yes" 
			   enabled="Yes" 
			   size="40" 
			   maxlength="50">
			   
		  <cfelse>
				 <font color="0080C0"><b>#mail#</b></font>
		  </cfif>
		  
		  </td>
		  
    </tr>
			
	<tr><td height="1"></td></tr>
		
	</table>
	
	</td>
	</tr>
	
	<cfif claim.actionStatus lte "1" and editclaim eq "1">

	<tr><td height="1" colspan="2" valign="bottom" bgcolor="C0C0C0"></td></tr>

	<tr><td valign="bottom" height="35">
			  
	  <script>
		 function checksubmit() {
		  
		  	 co = document.getElementsByName("1_")
		     if (co[0].value == "Yes") {
		     try {
		 	 val = document.getElementById("inv1").value
			 } catch(e) { 
			     alert("Please record an advance before you proceed.")
				 return false
			    }
			 }	
			 }	
	  </script>
	 	 
	  <cfif Object.recordcount eq "0" and Claim.ExportNo is "" or SESSION.isAdministrator eq "Yes">
		 <cfset reset = "1">			
	  <cfelse>
	     <cfset reset = "0">		
	  </cfif>
	  
	  <cfif disb eq "1">
	  
	  <!--- if not disbursement options are found just hide this !! --->
	  
	  <cf_Navigation
			 Alias         = "AppsTravelClaim"
			 Object        = "Claim"
			 Group         = "TravelClaim" 
			 Section       = "#URL.Section#"
			 Id            = "#URL.ClaimId#"
			 ButtonClass   = "ButtonNav1"
			 BackEnable    = "1"
			 HomeEnable    = "#reset#"
			 ResetEnable   = "#reset#"
			 ProcessEnable = "0"
			 NextSubmit    = "1" <!--- perform next as a form submit action ClaimEventAdditionalSubmit.cfm --->
			 NextScript    = "checksubmit()" <!--- perform addition script action --->
			 NextEnable    = "1"
			 NextMode      = "1" <!--- allow next to be indeed clicked for action, 0 means a message will appear --->
			 SetNext       = "0"> <!--- do not set this section is completed upon loading of the page --->
			 
		</cfif>	 
			 
	</td></tr>		 
		 
	</cfif>	 
	
  </cfform>
	
</table>	

</cfoutput>