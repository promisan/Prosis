<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="GLAccount"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_Account G
	WHERE  G.GLAccount = '#URL.Account#'
</cfquery>

<cfquery name="Group"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_AccountGroup 
	WHERE  AccountGroup = '#GLAccount.AccountGroup#'
</cfquery>

<cfquery name="CurPeriod"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT * 
	FROM  Ref_ParameterMission
    WHERE Mission = '#URL.Mission#'
</cfquery>

<!--- retrieve the data to be shown --->

<cfset curr = Application.BaseCurrency>	

<cfparam name="URL.Period"               default="#CurPeriod.CurrentAccountPeriod#">
<cfparam name="url.PAP"                  default="">
<cfparam name="URL.Account"              default="000000">
<cfparam name="URL.Class"                default="">
<cfparam name="URL.Find"                 default="">
<cfparam name="URL.Row"                  default="500">
<cfparam name="URL.Currency"             default="">
<cfparam name="URL.ID"                   default="TransactionDate">
<cfparam name="URL.Mde"                  default="JournalTransactionNo">
<cfparam name="URL.GLCategory"           default="Actuals">
<cfparam name="URL.Page"                 default="1">
<cfparam name="SearchResult.recordCount" default="0">
<cfparam name="url.Mode"                 default="">
<cfparam name="URL.Aggregate"            default="0">
<cfparam name="URL.CostCenter" 			 default="All">
<cfparam name="URL.OrgUnitOwner" 		 default="All">
<cfparam name="URL.Owner" 			 	 default="#url.orgunitowner#">
<cfparam name="URL.Prepare" 	     	 default="Yes">

<cfif url.pap eq "undefined">
	<cfset url.pap = "">
</cfif>

<cfquery name="Category" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_GLCategory
	WHERE  GLCategory = '#URL.GLCategory#' 
</cfquery>

<cfquery name="Period" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   Distinct AccountPeriod 
    FROM     Period
	WHERE    AccountPeriod IN (SELECT AccountPeriod 
	                           FROM   TransactionHeader 
							   WHERE  Mission = '#URL.Mission#')
	ORDER BY AccountPeriod DESC
</cfquery>

<!---get the cost centers --->
<cfquery name="warehouses" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT	Org.OrgUnit, WH.WarehouseName  
	FROM	Organization.dbo.Organization AS Org INNER JOIN Materials.dbo.Warehouse AS WH
			ON	Org.MissionOrgUnitId	= WH.MissionOrgUnitId
	WHERE	Org.Mission = '#URL.Mission#'
	AND		Org.OrgUnit IN (SELECT DISTINCT ReferenceOrgUnit 
							FROM Accounting.dbo.TransactionHeader)
	ORDER BY WH.Warehouse ASC
	
</cfquery>

<cfquery name="getowners" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   
    SELECT	count(1)count_, TH.OrgUnitOwner, Org.OrgUnitName
    FROM 	Accounting.dbo.TransactionHeader as TH
    INNER JOIN Organization.dbo.Organization as org 
    ON TH.OrgUnitOwner  		= org.OrgUnit
    WHERE 	TH.RecordStatus 	!='9'
    AND 	TH.Mission 			= '#URL.Mission#'
    GROUP BY TH.OrgUnitOwner,Org.OrgUnitName
	
</cfquery>

<!--- retrieve the data to be shown --->

<cfif url.prepare neq "quick">
	
	<cfif url.mde eq "Transaction">
			
		<cfinclude template="AccountResultListingCompress.cfm">
			
	<cfelseif url.mde eq "JournalTransactionNo">	
				
		<cfinclude template="AccountResultListingAggregate.cfm">		
						
	<cfelse>
					
		<cfinclude template="AccountResultListingStandard.cfm">
					
	</cfif>
	
</cfif>	

<cf_screentop band="No" 
     html="yes" 
	 banner="gray" 
	 line="no" 
	 jquery="yes" 
	 layout="webapp" 
	 height="100%" 
	 busy="busy10.gif"
	 label="Review #GLAccount.Description#" 	
	 bannerheight="40" 
	 scroll="yes">
	 
<cfajaximport tags="cfdiv">	 

<table width="100%"
       height="99%">
	   
  <tr>
  <td valign="top" height="20">
  
		<table width="100%" height="100%">
		
		<tr><td colspan="2" class="noprint">
						
		   <cf_dialogLedger>
		   <cf_annotationscript>
		
		
		
		    <cfoutput query="GLAccount">
			<table width="100%" align="center" style="height:30px">
			<tr style="labelmedium2;height:30px" class="line">
			<td style="width:160px;text-align:center;font-size:15px;padding-left:5px;background-color:yellow;padding-right:10px;border-right:1px solid gray">#AccountClass# : #AccountType#</td>
			<td align="center" style="font-size:14px;padding-left:5px;padding-right:10px;border-right:1px solid gray">#Group.Description#</td>
			<td align="center" style="color:white;background-color:747474;font-weight:normal;font-size:15px;padding-left:15px;padding-right:10px;border-right:1px solid gray" id="printTitle">
			#GLAccount# : #Description#
			</td>
			</cfoutput>
					
			<td align="right" style="padding-left:10px;padding-right:10px">
			
				<table>
	
					<tr>
					
					<!--- capture the screen result to allow for identical excel export --->  				  
									
					<td style="padding-left:4px"></td>
					
					<cfsavecontent variable="selectme">
					        style="cursor: pointer;padding:2px"
							onMouseOver="this.className='labelit highlight1'"
							onMouseOut="this.className='labelit'"
					</cfsavecontent>
					
					<cfoutput>
					
					<td style="padding-left:1px;padding-right:4px">|</td>
					<td height="20" class="labelit" style="cursor:pointer; padding-top:4px;" valign="top">
					
						<cf_tl id="Print" var="1">
						<cf_button2 
							mode		= "icon"
							type		= "Print"
							title       = "#lt_text#" 
							id          = "Print"					
							height		= "20px"
							width		= "20px"
							imageheight = "15px"
							printTitle	= "##printTitle"
							printContent = "##resultlist"
							printCallback="$('.clsCFDIVSCROLL_MainContainer').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','height:100%;');">
					</td>
					
					</cfoutput>
					
					</tr>
			
				</table>
			</td></tr>
									
			<tr class="line">
			<TD height="40" colspan="5" style="padding-left:10px;padding-right:11px">
			
			<table width="100%">
			
			<tr class="line">
			
			<TD style="width:10%">
			
			  <table width="100%" cellspacing="0" cellpadding="0">
			  <tr>
			  <td class="labelmedium2" style="padding-left:3px;padding-right:3px"><cf_tl id="Fiscal"></td>
			  <td align="right">	
			  					
			    <select name="period" id="period" size"1" class="regularxl" style="border:0px;background-color:e6e6e6" 
				    onChange="reloadForm();ptoken.navigate('getTransactionPeriod.cfm?glcategory=<cfoutput>#url.glcategory#&account=#url.account#&mission=#url.mission#</cfoutput>&period='+this.value,'boxtransactionperiod')">			
					
			   		<option value="All" <cfif "all" is URL.Period>selected</cfif>>All
				    <cfoutput query="Period">
						<option value="#AccountPeriod#" <cfif AccountPeriod is URL.Period>selected</cfif>>#AccountPeriod#</option>
					</cfoutput>
					
			    </select>
				
				</td>
			 
			  </tr>
			  </table>
				
							
			</TD>
			
			<td>
			  <table width="100%" cellspacing="0" cellpadding="0">
			  <tr>
			  <td class="labelmedium2" style="padding-left:3px;padding-right:3px"><cf_tl id="Period"></td>
			  <td id="boxtransactionperiod" align="right">			   
			  
				  <cfinclude template="getTransactionPeriod.cfm">
							  
			  </td>
			 
			  </tr>
			  </table>
			
			</td>			
			
			<td class="labelmedium2" style="padding-left:5px;border-right:0px"><cf_tl id="Expressed"></td>
			
			<td style="border:0px solid silver;;border-left:0px" align="right">
						
			<cfquery name="Currency"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT DISTINCT L.Currency 
				FROM   TransactionHeader H,
				       TransactionLine L
				WHERE  L.GLAccount = '#URL.Account#'
			    AND    H.Mission= '#URL.Mission#'
				AND    H.Journal = L.Journal
				AND    H.JournalSerialNo = L.JournalSerialNo
			</cfquery>			
			
			<select name="currency" id="currency" size"1" class="regularxl" style="border:0px;background-color:e6e6e6;" onChange="reloadForm()">
			
			    <option value="" <cfif "" is URL.currency>selected</cfif>>Default
				<cfoutput query="Currency">
					<option value="#currency#" <cfif currency is URL.currency>selected</cfif>>#currency#</option>				
				</cfoutput>			   
				
		    </select>
			
			</td>
			
			<td class="labelmedium2" style="padding-left:4px;;border-right:0px"><cf_tl id="Type"></td>
			<td style="border:0px solid silver;;border-left:0px" align="right">
						
			<select name="class" id="class" size"1" class="regularxl" style="border:0px;background-color:e6e6e6;" onChange="reloadForm()">
			
			    <option value="" <cfif "" is URL.class>selected</cfif>><cf_tl id="All">
			    <option value="Debit"  <cfif "Debit" is URL.Class>selected</cfif>><cf_tl id="Debit">
				<option value="Credit" <cfif "Credit" is URL.Class>selected</cfif>><cf_tl id="Credit">
				
		    </select>
			</td>			
						 
			  <!---- RFUENTES 5/21/2015, set this filter only for the Result accounts --->
			  
			 <cfif GLACcount.AccountClass eq "Result">
			 	<td class="labelmedium2" style="padding-left:3px;;border-right:0px"><cf_tl id="Warehouse"></td>
				<td style="border:0px solid silver;border-left:0px" align="right">	
					<select style="width:200px;border:0px;background-color:e6e6e6;" name="warehouse" id="warehouse" class="regularxl" size="1" onChange="javascript:reloadForm()">
						<option value="All"><cf_tl id="All">
				    	<cfoutput query="warehouses">
							<option value="#orgUnit#" <cfif URl.costcenter eq orgUnit>selected</cfif>>				
							#WarehouseName#
							</option>
						</cfoutput>
					</SELECT> 
			 	</td>	
			 </cfif>
			 
			 <cfif curPeriod.AdministrationLevel eq "Tree">
			 
			 <cfset url.owner = "all">
			 
			 <td colspan="2"  style="background-color:f1f1f1;padding-left:3px;border-right:0px">			 
			 <input type="hidden" name="owner" id="owner" value="">
			 </td>
			 
			 <cfelse>
			 
			 <td class="labelmedium2" style="padding-left:3px;border-right:0px"><cf_tl id="Owner"></td>
			 <td style="border:0px solid silver;border-left:0px;padding-right:5px" align="right">	
			 
					<select style="width:250px;border:0px;background-color:e6e6e6;" name="owner" id="owner" class="regularxl" size="1" onChange="javascript:reloadForm()">
						<option value="All">All</option>
				    	<cfoutput query="getowners">
							<option value="#orgUnitowner#" <cfif URl.orgunitowner eq orgUnitOwner>selected</cfif>>#OrgUnitName#</option>
						</cfoutput>
					</SELECT> 
			 </td>	
			 
			 </cfif>
			 
			<td style="width:50px;padding-left:3px" width="100" align="right">
			
			<select name="rows" id="rows" size"1" class="regularxl" style="border:0px;background-color:e6e6e6;" onChange="reloadForm('quick')">
			
			    <option value="100">100</option>
			    <option value="250" <cfif "250" is URL.row>selected</cfif>>250
				<option value="500" <cfif "500" is URL.row>selected</cfif>>500
				<option value="1000" <cfif "1000" is URL.row>selected</cfif>>1000
				<option value="5000" <cfif "5000" is URL.row>selected</cfif>>5000
				<option value="25000" <cfif "25000" is URL.row>selected</cfif>>25000
												
		    </select>
			
			</td>
			 
			<td id="pagebox" style="width:150px;border:0px solid silver;padding-left:3px" width="100" align="right"></td>
								
			</tr>
						
			<TR>
			
			<td class="labelmedium2" style="padding-left:3px;border:0px solid silver" colspan="1"><cf_tl id="Find"></td>
			 		  
			  <td colspan="3">
			
			
				<cfoutput>
					<input type="text"
					     name="find" 
						 id="find" 
						 value="#url.find#" 
						 style="width:100%;border:0px;border-left:1px solid gray;border-right:1px solid gray;background-color:BFECFB" 
						 class="regularxl" 
						 onChange="reloadForm()">
				</cfoutput>
				
			</td>			
						
			<td class="labelit" style="padding-left:3px;border:0px solid silver" colspan="2">
			
			<table width="100%">
			  <tr>
			  <td class="labelmedium2" style="padding-left:3px;padding-right:3px"><cf_tl id="Mode"></td>
			  <td align="right" style="border-left:1px solid silver;">		
						
				<select name="modality" id="modality" style="border:0px;width:100%;background-color:e6e6e6;" class="regularxl" size="1" onChange="javascript:reloadForm()">
										 
				     <OPTION value="JournalTransactionNo" <cfif URL.Mde eq "JournalTransactionNo">selected</cfif>><cf_tl id="Transaction (aggregated)">						 					 
					  <OPTION value="Posting" <cfif URL.Mde eq "Posting">selected</cfif>><cf_tl id="Posting detail">
					 <!--- aggregated --->
					 <cfif GLAccount.BankReconciliation eq "1">
					 <OPTION value="Transaction" <cfif URL.Mde eq "Transaction">selected</cfif>><cf_tl id="Parent Transaction">				  
					 </cfif>					 
				</SELECT> 
						
			  </td>	
				
			   </tr>
			  </table>		
			 		 	 
			 </td> 
			 
			 <td class="labelit" style="padding-left:3px;border:0px solid silver" colspan="2">
			 
				<table width="100%" cellspacing="0" cellpadding="0">
				  <tr>
				  
				  <td class="labelmedium2" style="padding-left:3px;padding-right:3px"><cf_tl id="Grouping"></td>
				  <td align="right" style="border-left:1px solid silver;">	
						
					<select name="group" id="group" class="regularxl" style="border:0px;width:100%;background-color:e6e6e6;" size="1" onChange="javascript:reloadForm()">
					
						 <OPTION value="TransactionPeriod" <cfif URL.ID eq "TransactionPeriod">selected</cfif>><cf_tl id="Transaction Period">	
						 <OPTION value="TransactionDate"   <cfif URL.ID eq "TransactionDate">selected</cfif>><cf_tl id="Transaction Date">	
						 <OPTION value="DocumentDate"      <cfif URL.ID eq "DocumentDate">selected</cfif>><cf_tl id="Document Date">					 	
						 <option value="Created"           <cfif URL.ID eq "Created">selected</cfif>><cf_tl id="Recording Date">
						 
						 <!---
						 <option value="Journal" <cfif URL.ID eq "Journal">selected</cfif>><cf_tl id="Journal">
						 --->
					      
						 <!---			
					     <OPTION value="TransactionType" <cfif URL.ID eq "TransactionType">selected</cfif>><cf_tl id="Transaction Type">
						 --->
						
						 
					</SELECT> 
				
				 </td>	
				 
				  <td class="labelmedium2" style="border-left:1px solid silver;padding-left:8px;padding-right:3px"><cf_tl id="Aggregate"></td>
				  <td align="right" style="border-left:1px solid silver;padding-left:8px;padding-right:3px;">	
				  
				  <select name="aggregate" id="aggregate" class="regularxl" style="border:0px;width:100%;background-color:e6e6e6;" size="1" onChange="javascript:reloadForm()">
					
						 <OPTION value="0" <cfif URL.aggregate eq "0">selected</cfif>><cf_tl id="No">	
						 <OPTION value="1" <cfif URL.aggregate eq "1">selected</cfif>><cf_tl id="Yes">	
						
					</SELECT> 
				  
				  
				  </td>
				
			   </tr>
			  </table>		
				
			 </td>		
			
			<td style="padding:1px;border:0px solid silver" colspan="2">				   
			   	<input type="button" name="Reload" value="Reload" class="button10g" style="border:1px solid silver;width:100%;height:100%" onclick="reloadForm()">																
			</td>
			
			</tr>
			</table>						
			
		</td></tr>
						
	</table>
			
	</td></tr>
		
	<cfoutput>
	
	<script>
		
		var acc = "#URL.Account#";
		
		function reloadForm(mode) {
		    row = document.getElementById("rows").value
		    per = document.getElementById("period").value
			grp = document.getElementById("group").value
			pag = document.getElementById("page").value
			cls = document.getElementById("class").value
			fnd = document.getElementById("find").value
			cur = document.getElementById("currency").value
			mde = document.getElementById("modality").value		
			agg = document.getElementById("aggregate").value	
			cc	= document.getElementById("warehouse")
			ow	= document.getElementById("owner").value
			
			if (mode != 'quick') {
			   pag = 1
			}
												
			if(cc!=null){
				cc	= cc.value	
			}else {
				cc="All"
			}
			try {
				pap = document.getElementById("transactionperiod").value	
			} catch(e) {
				pap = ''
			}
			
			Prosis.busy('yes')
			ptoken.navigate('AccountResultListing.cfm?prepare='+mode+'&pap='+pap+'&currency='+cur+'&mission=#URL.mission#&ID=' + grp + '&Find=' + fnd  + '&Class=' + cls + '&Period=' + per + '&Account=' + acc + '&Page=' + pag + '&GLCategory=#URL.GLCategory#'+'&CostCenter='+cc+'&owner='+ow+'&mde='+mde+'&aggregate='+agg+'&row='+row,'resultlist')				
				
		}
						   
		 function moreinfo(jrn,ser,gl,box,row) {
		    
			 rw = document.getElementById(row)
		     se = document.getElementById(box+"Exp")
			 sm = document.getElementById(box+"Min")
			 if (se.className == "regular") {
			     se.className = "hide"
				 rw.className = "regular"
				 sm.className = "regular"
			     ptoken.navigate('AccountResultDetail.cfm?glaccount='+gl+'&journal='+jrn+'&journalserialNo='+ser,box)				 
			 } else {
			     sm.className = "hide"
				 se.className = "regular"
				 rw.className = "hide"				
			 }	 
		 }  
			
		</script>
		
	</cfoutput>
		
	<tr>	
			
		<td colspan="2" valign="top" height="100%" style="padding-left:16px;padding-right:16px" id="resultlist">			
		    						
			<cfinclude template="AccountResultListing.cfm">											
			
		</td>
						
	</tr>
	
</table>	

</td>
</tr>

</table>	

<cf_screenbottom html="yes" layout="webapp">

