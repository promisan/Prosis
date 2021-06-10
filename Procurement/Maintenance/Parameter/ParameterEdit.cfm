<HTML><HEAD>
	<TITLE>Parameters - Purchase Edit Form</TITLE>
</HEAD>

<cfinclude template="../../../Tools/CFReport/Anonymous/PublicInit.cfm">

<script>

	 function fundingvalidation() {
	 
	   se = document.getElementsByName("EnableFundingCheck")
	   if (se[0].checked == true) {
	      ve = document.getElementsByName("FundingCheckPointer")
		  cnt = 0; while (ve[cnt]) { ve[cnt].disabled = false; cnt++ }
		  ve = document.getElementsByName("FundingCheckTolerance")
		  cnt = 0; while (ve[cnt]) { ve[cnt].disabled = false; cnt++ }
		  ve = document.getElementsByName("FundingClearRollup")
		  cnt = 0; while (ve[cnt]) { ve[cnt].disabled = false; cnt++ }
		  ve = document.getElementsByName("FundingClearTransaction")
		  cnt = 0; while (ve[cnt]) { ve[cnt].disabled = false; cnt++ }
		  ve = document.getElementsByName("FundingCheckCleared")
		  cnt = 0; while (ve[cnt]) { ve[cnt].disabled = false; cnt++ }	 	
		  ve = document.getElementsByName("FundingClearResource")
		  cnt = 0; while (ve[cnt]) { ve[cnt].disabled = false; cnt++ }	 	  
		  } else {
		  ve = document.getElementsByName("FundingCheckPointer")
		  cnt = 0; while (ve[cnt]) { ve[cnt].disabled = true; cnt++ }
		  ve = document.getElementsByName("FundingCheckTolerance")
		  cnt = 0; while (ve[cnt]) { ve[cnt].disabled = true; cnt++ }
		  ve = document.getElementsByName("FundingClearRollup")
		  cnt = 0; while (ve[cnt]) { ve[cnt].disabled = true; cnt++ }
	      ve = document.getElementsByName("FundingClearTransaction")
		  cnt = 0; while (ve[cnt]) { ve[cnt].disabled = true; cnt++ }
		  ve = document.getElementsByName("FundingCheckCleared")
		  cnt = 0; while (ve[cnt]) { ve[cnt].disabled = true; cnt++ }	
		  ve = document.getElementsByName("FundingClearResource")
		  cnt = 0; while (ve[cnt]) { ve[cnt].disabled = true; cnt++ }	 	   	 
		  }
	 }
	 
</script>

<cf_screentop height="100%" jquery="yes" scroll="no" html="No">
 
 <cf_dialoglookup>
 
<!--- script to load workflow object --->

<cfajaximport tags="cfform,cfdiv">
<cfinclude template="../../../System/EntityAction/EntityFlow/EntityAction/EntityScript.cfm">
 
<cfquery name="MissionList" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterMission
	WHERE Mission IN (SELECT Mission 
    	              FROM   Organization.dbo.Ref_MissionModule 
					  WHERE  SystemModule = 'Procurement')
</cfquery>

<cfparam name="URL.Mission" default="#MissionList.Mission#">

<cfif url.mission eq "">
	<cfset url.mission = MissionList.Mission>
</cfif>
 
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterMission
	WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfoutput>
<script>
	
	function reload(mis) {
		 ptoken.location('ParameterEdit.cfm?idmenu=<cfoutput>#url.idmenu#</cfoutput>&mission='+mis)
	 }
				
		
	  function funddialog(val) {
	  
	  if (val == 'show') {
	    document.getElementById("funddialog0").className = "regular" 
	    document.getElementById("funddialog1").className = "regular"
		document.getElementById("funddialog2").className = "regular"
		document.getElementById("funddialog3").className = "regular"
		document.getElementById("funddialog4").className = "regular"
		document.getElementById("funddialog8").className = "regular"
		document.getElementById("funddialog5").className = "regular"
		document.getElementById("funddialog6").className = "hide"
		document.getElementById("funddialog7").className = "hide"
	  } else {
 	    document.getElementById("funddialog0").className = "hide"
		document.getElementById("funddialog1").className = "hide"
		document.getElementById("funddialog2").className = "hide"
		document.getElementById("funddialog3").className = "hide"
		document.getElementById("funddialog4").className = "hide"
		document.getElementById("funddialog8").className = "hide"
		document.getElementById("funddialog5").className = "hide"
		document.getElementById("funddialog6").className = "regular"
		document.getElementById("funddialog7").className = "regular"
	  } 
	  
	  }
		
	function defaultCurrency(setClass){
		alert(setClass);
		s = document.getElementById('defaultCurrency_id');
		s.className = setClass;
	}
	
	function applyDiffAccount(val, scope, fld) {
		ptoken.navigate('#session.root#/procurement/maintenance/parameter/setGLAccount.cfm?codefld=DifferenceGLAccount&descfld=DifferenceGLDescription&glaccount='+val,'tdSubmit');
	}
	
	function applyReceiptAccount(val, scope, fld) {
		ptoken.navigate('#session.root#/procurement/maintenance/parameter/setGLAccount.cfm?codefld=ReceiptGLAccount&descfld=ReceiptGLDescription&glaccount='+val,'tdSubmit');
	}
	
	function applyAdvanceAccount(val, scope, fld) {
		ptoken.navigate('#session.root#/procurement/maintenance/parameter/setGLAccount.cfm?codefld=AdvanceGLAccount&descfld=AdvanceGLDescription&glaccount='+val,'tdSubmit');
	}
		
</script>
</cfoutput>

<cfset Page         = "0">
<cfset add          = "0">

<cf_dialogLedger>

<cf_divscroll>

<cfoutput query="get">

<!--- Entry form --->

<table width="100%" height="100%">

	<cfsavecontent variable="option">
	
		<cfform action="ParameterSubmit.cfm?mission=#URL.mission#"
        method="POST"
        name="general">	
	
	    <table width="800" align="right" class="formpadding"><tr>
		
	       <td class="labelmedium" style="padding-left:4px"><cf_tl id="Entity"></td>
			<td style="padding-left:4px">
			
			 <select name="mission" id="mission" class="regularxxl" onChange="document.getElementById('menu1').click();ptoken.navigate('ParameterEditGeneral.cfm?mission='+this.value,'generalbox')">
			
				<cfloop query="MissionList">
				 <option value="#Mission#" <cfif mission eq URL.mission>selected</cfif>>#Mission#
				</cfloop>
			
			 </select>
			
			</td>
			
			<td id="generalbox">
				<cfinclude template="ParameterEditGeneral.cfm">			
			</td>
			
			</tr>
		</table>
	
		</cfform>	
			
	</cfsavecontent>	

    <tr><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>
	
	<tr><td height="100%" width="100%">

	<table height="100%" width="100%">
	      		
		<tr class="hide"><td id="save"></td></tr>	
					
		<cf_menuscript>
		
		<tr>
		
		<td colspan="1" height="30" align="center" style="padding-left:20px;padding-right:10px">		
				
			<!--- top menu --->
					
			<table width="100%" height="100%" align="center">		  		
							
				<cfset ht = "54">
				<cfset wd = "54">
				
				<cfset add = 1>
						
				<tr class="line" style="border-top:1px solid silver">					
							
						<cf_menutab item       = "1" 
						            iconsrc    = "New-Request.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									class      = "highlight"
									name       = "Request"
									source     = "ParameterEditRequisition.cfm?mission={mission}">			
										
						<cf_menutab item       = "2" 
						            iconsrc    = "Funding.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									targetitem = "1"
									name       = "Funding"
									source     = "ParameterEditFunding.cfm?mission={mission}">
									
						<cf_menutab item       = "3" 
						            iconsrc    = "Workflow-Methods.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									targetitem = "1"
									name       = "Request Flow"
									source     = "ParameterEditReqProcess.cfm?mission={mission}">	
									
						<cf_menutab item       = "4" 
						            iconsrc    = "Job-Quote.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									targetitem = "1"
									name       = "Job and RfQ"
									source     = "ParameterEditJob.cfm?mission={mission}">			
									
						<cf_menutab item       = "5" 
						            iconsrc    = "Logos/Procurement/Purchase-Order.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									targetitem = "1"
									name       = "Obligation"
									source     = "ParameterEditPurchase.cfm?mission={mission}">		
									
						<cf_menutab item       = "6" 
						            iconsrc    = "Logos/Procurement/Receipt-Inspect.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									targetitem = "1"
									name       = "Receipt"
									source     = "ParameterEditReceipt.cfm?mission={mission}">						
									
						<cf_menutab item       = "7" 
						            iconsrc    = "Invoice.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									targetitem = "1"
									name       = "Account Payable"
									source     = "ParameterEditInvoice.cfm?mission={mission}">																		
					
						
															 		
					</tr>
			</table>
			
			</td>
		</tr>
		
		<tr><td height="100%" style="padding-top:5px">
		
		   <cf_divscroll>
			
			<table width="100%" 
			      border="0"
				  height="100%"
				  cellspacing="0" 
				  cellpadding="0" 
				  align="center" 
			      bordercolor="d4d4d4">	  	 		
				  				  									
					<cf_menucontainer item="1" class="regular">
					   <cf_securediv bind="url:ParameterEditRequisition.cfm?mission=#missionlist.mission#">
					 
					<cf_menucontainer>
					
				<tr>	
		
			<td valign="top">
			
				<table width="100%" cellspacing="0" cellpadding="0" bgcolor="fafafa" style="border:1px dotted silver" class="formpadding">
								
					<tr><td class="labelit" style="padding-left:4px" align="center">
					<font face="Calibri" size="2"  color="gray"><b>Attention:&nbsp;</b>
					<font face="Calibri" size="2" color="808080">
					Procurement Setup Parameters are applied per Entity (Mission) and should <b>only</b> be changed if you are absolutely certain of their effect on the system.
					</td></tr>
						
					<tr><td class="labelit"  align="center" style="padding-left:4px"><font face="Calibri" size="2"  color="gray">In case you have any doubt always consult your assignated focal point.</td></tr>
								
				</table>
				
			</td>	
			
			</tr>					
								
			</table>
			
			</cf_divscroll>
			
			</td>
		</tr>		
						
		</table>

	</td></tr>

</table>

</cfoutput>
</cf_divscroll>
