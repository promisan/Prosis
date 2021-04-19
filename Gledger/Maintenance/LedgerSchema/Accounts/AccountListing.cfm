<!--- Create Criteria string for query from data entered thru search form --->
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" scroll="Yes" html="No" jQuery="Yes" menuAccess="Yes" systemfunctionid="#url.idmenu#">

<cfquery name="MissionSelect" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ParameterMission
WHERE Mission IN (SELECT Mission 
                  FROM Organization.dbo.Ref_MissionModule
				  WHERE SystemModule = 'Accounting')
</cfquery>

<cfparam name="URL.Mission" default="#MissionSelect.Mission#">
<cfparam name="URL.Parent" default="All">
<cfparam name="URL.OP" default="0">

<!--- Query returning search results --->

<cfquery name="Parent"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_AccountParent P
</cfquery>

<cfoutput>
   <cfif URL.Parent eq "All">
     <cfset cond = "">
   <cfelse>
     <cfset cond = "AND P.AccountParent = '#URL.Parent#'">  
   </cfif>
</cfoutput>


<cfquery name="Last"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   TOP 1 *
	FROM     TransactionHeader WITH(NOLOCK)
	WHERE    Mission = '#url.mission#'
	AND      Journal IN (SELECT Journal FROM Journal WITH(NOLOCK) WHERE SystemJournal = 'Opening')
	ORDER BY AccountPeriod DESC
</cfquery>

<cfif Last.AccountPeriod eq "">
	
	<cfquery name="Last"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM   Period WITH(NOLOCK)
		WHERE   ActionStatus = '0'
		ORDER BY PeriodDateEnd 
	</cfquery>
	
</cfif>

<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   A.*, 
	         	(SELECT  count(*) 
				 FROM    TransactionLine L 
				         INNER JOIN TransactionHeader H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo
				 WHERE   H.Mission         = '#url.mission#'
				 AND     H.AccountPeriod  = '#last.AccountPeriod#'	
				 AND     L.GLAccount       = A.GLAccount
				 <!--- makes it slow AND     H.RecordStatus   != '9' --->
				) as Used,
	          G.AccountGroup as AccountGroup1,
	          G.Description as GroupDescription, 
			  P.AccountParent, P.Description as Parentdescription
	FROM      Ref_AccountParent P INNER JOIN
              Ref_AccountGroup G ON P.AccountParent = G.AccountParent LEFT OUTER JOIN
              Ref_Account A ON G.AccountGroup = A.AccountGroup 
	WHERE 1=1 #PreserveSingleQuotes(cond)# 		 		 
	ORDER BY P.AccountParent, G.AccountGroup, A.GLAccount 
</cfquery>

<!---
<cfoutput>#cfquery.executiontime#</cfoutput>
--->

<cf_ajaxRequest>

<cfoutput>

<script>

function reloadForm(mis,filter,op) {
    			
    if (op == true || op == "true") {		 
     ptoken.location('AccountListing.cfm?idmenu=#url.idmenu#&op=true&Mission='+mis+'&Parent='+filter);
	 } else {	 
	 ptoken.location('AccountListing.cfm?idmenu=#url.idmenu#&op=false&Mission='+mis+'&Parent='+filter);
	 }	 
}

function add(grp) {	 
     ptoken.open("AccountCodeAdd.cfm?idmenu=#url.idmenu#&ts="+new Date().getTime()+"&mission=#url.mission#&ID1=" + grp, "Add", "left=80, top=80, width=800, height=760, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function edit(acc,par) {  
     ptoken.open("AccountEdit.cfm?idmenu=#url.idmenu#&ts="+new Date().getTime()+"&mission=#url.mission#&ID1=" + acc +"&ID2=" + par, "Edit", "left=50, top=30, width=820, height=910, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function grpadd(par) {
     ptoken.open("AccountGroupAdd.cfm?idmenu=#url.idmenu#&ts="+new Date().getTime()+"&ID1=" + par, "Add", "left=80, top=80, width=550, height= 350, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function grpedit(grp) {
     ptoken.open("AccountGroupEdit.cfm?idmenu=#url.idmenu#&ts="+new Date().getTime()+"&ID1=" + grp, "Edit", "left=80, top=80, width= 550, height= 350, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function parentEdit(id) {
	ptoken.open("AccountParentEdit.cfm?idmenu=#url.idmenu#&ts="+new Date().getTime()+"&ID=" + id, "Edit", "left=80, top=80, width= 550, height= 350, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function accounttoggle(mis,acc,act) {
			
	url = "AccountListingAction.cfm?ts="+new Date().getTime()+"&mis=#URL.mission#&acc="+acc+"&toggle="+act;
   	
	AjaxRequest.get({
        'url':url,
        'onSuccess':function(req){ 
		
	document.getElementById("i"+acc).innerHTML = req.responseText;
	
	if (act == "1")	{
	document.getElementById(acc).className = "regular"
	} else {
	document.getElementById(acc).className = "highlight1"
	}		
	},
					
        'onError':function(req) { 
	document.getElementById("i"+acc).innerHTML = req.responseText;}	
         }
	 );					 
}
</script>	

</cfoutput>
	
<cf_dialogLedger>
<cf_presentationScript>

<cfset curr = 0>

<table width="97%" height="100%" align="center">
<tr>
<td class="labellarge" style="font-weight:200;font-size:45px;padding-top:9px;padding-left:7px;height:43px"><cfoutput>#url.Mission#</cfoutput><b></td>
<td align="right" style="width:40%">
	<cfoutput>
		<table>
			<tr>
				<td class="labelmedium2" align="right" style="width:300px;padding-right:6px">
					<cfif url.op eq "1">
					<a href="javascript:reloadForm('#url.mission#',filter.value,'false')">					
					<cf_tl id="Show All available GL accounts">
					<cfelse>
					<a href="javascript:reloadForm('#url.mission#',filter.value,'true')">					
					<cf_tl id="Show the enabled GL accounts only">
					</cfif>					
					</a>
				</td>
				<td>:
					<input type="checkbox" class="radiol" name="op" value="1" onClick="parent.Prosis.busy('yes');reloadForm('#url.mission#',document.getElementById('filter').value,this.checked)" <cfif url.op eq "1">checked</cfif>>
				</td>
				<td valign="top" class="labelmedium" style="padding-bottom:6px;padding-left:8px; padding-right:10px;">
										
					<cf_tl id="Print" var="1">
					
					<cf_button2 
						type		= "Print"
						mode		= "icon"						
						id          = "Print"					
						width       = "28px"
						height		= "25px"
						printTitle	= "##printTitle"
						printContent= "##divPrintContent">
						
						<span style="display:none;" id="printTitle">#url.Mission# <cf_tl id="Chart of Accounts"></span>
						
				</td>
			</tr>
		</table>
	</cfoutput>
</td>
</tr>	

<tr><td height="20" colspan="2">

	<table><tr>
	
	<td style="padding-left:4px">
	 <select name="filter" id="filter" class="regularxxl" size"1" onChange="reloadForm('<cfoutput>#url.mission#</cfoutput>',this.value,'<cfoutput>#url.op#</cfoutput>')">
	 	    <option value="All" <cfif "All" is URL.Parent>selected</cfif>><cf_tl id="All"></option>
		    <cfoutput query="Parent">
			<option value="#AccountParent#" <cfif AccountParent is URL.Parent>selected</cfif>>
				#AccountParent# #Description#
			</option>
			</cfoutput>
		</select>
	
	</td>
	
	<td style="padding-left:4px"></td>
	
	<td>
	
			<cfinvoke component = "Service.Presentation.tableFilter"  
					   method           = "tablefilterfield" 					   
					   name             = "filtersearch"
					   filtermode       = "direct"
					   style            = "font:14px;height:25px;width:200px;"
					   rowclass         = "clsSearchrow"
					   rowfields        = "ccontent">
	
	</td>
	
	</tr>
	</table>

</td></tr>

<tr><td colspan="2" class="line"></td></tr>	

<tr>
<td colspan="2" style="border:0px solid silver" height="100%">

<cf_divscroll id="divPrintContent">

	<table width="99%" class="navigation_table">
		
		<tr class="labelmedium2 line fixrow">
		    <td height="18" width="40"></td>
			<td width="60"></td>
		    <td style="min-width:120px"><cf_tl id="Code"></td>
			<td width="60%"><cf_tl id="Description"></td>
			<td style="width:80px"><cf_tl id="System"></td>
			<td style="min-width:30px" align="center"><cf_tl id="T"></td>
			<td style="min-width:30px" align="center"><cf_tl id="C"></td>
			<td style="min-width:50px" align="center"><cf_UItooltip  tooltip="Usage: Neutral,Customer,Vendor"><cf_tl id="U"></cf_UItooltip></td>
		    <td align="center" width="6%" ><cf_tl id="Tax"></td>
		    <td style="min-width:100px"><cf_tl id="Bank"></td>
			<td style="min-width:40px;cursor: pointer;"><cf_UItooltip  tooltip="Monetary Account"><cf_tl id="Mon"></cf_UItooltip></td>
			<td style="min-width:40px;cursor: pointer;"><cf_UItooltip  tooltip="Enforce Program Entry"><cf_tl id="Prg"></cf_UItooltip></td>
			<td style="min-width:40px;cursor: pointer;"><cf_UItooltip  tooltip="Tax Account"><cf_tl id="T"></cf_UItooltip></td>
			<td style="min-width:40px;cursor: pointer;"><cf_UItooltip  tooltip="Stock"><cf_tl id="I"></cf_UItooltip></td>
			<td align="right" style="min-width:40px;cursor: pointer;"><cf_UItooltip  tooltip="Used"><cfoutput>#last.AccountPeriod#</cfoutput></cf_UItooltip></td>						
			<td style="width:50px"></td>
		</tr>	
	
	<cfoutput query="SearchResult" group="AccountParent">
	
	     <tr class="line2 clsSearchrow fixrow2">
		 	 <td style="display:none;" class="ccontent"><b>#AccountParent# #Parentdescription#</td>
			 <td style="padding-left:4px;padding-top:2px" align="absmiddle">
			 	<table>
			 		<tr>
			 			<td>
			 				<cf_img buttonClass="clsNoPrint" icon="add" onClick="grpadd('#AccountParent#')">
			 			</td>
			 			<td style="padding-left:5px; padding-right:5px;">		
			    			<cf_img buttonClass="clsNoPrint" icon="open" onclick="parentEdit('#AccountParent#');">
						 </td>
			 		</tr>
			 	</table>
			 </td>
		     <td colspan="15" class="labellarge" style="font-size:24px;height:40px;cursor: pointer;" onclick="reloadForm('#url.mission#','#AccountParent#','#url.op#')">#AccountParent# #Parentdescription#</td>	 	 
		 </tr>	
					 	
	<cfoutput group="AccountGroup1">
	   
	     <tr class="line navigation_row clsSearchrow labelmedium2">
		 <td style="display:none;" class="ccontent">#AccountGroup1# #GroupDescription#</td>
	     <td></td>	
	     <td colspan="1">
			 <table cellspacing="0" cellpadding="0">
			  <tr><td style="padding-top:1px;">
		  	  	  <cf_img buttonClass="clsNoPrint" icon="add" onClick="add('#AccountGroup1#')"> 			
				  </td>
				  <td style="padding-left:4px;padding-top:2px;">		
				  <cf_img buttonClass="clsNoPrint" icon="open" onclick="grpedit('#AccountGroup1#');">
				  </td>
			   </tr>
		     </table>
		 </td>
		 <td style="padding-left:6px">#AccountGroup1#</td>
		 <td colspan="12" style="padding-left:4px;font-size:18px;height:30px"><a href="javascript:grpedit('#AccountGroup1#')">#GroupDescription#</a></td>
		 <td></td>
		 </tr>
		   
	<CFOUTPUT>
	
		<cfquery name="Mission"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_AccountMission 
			WHERE Mission = '#URL.Mission#' AND GLAccount = '#GLAccount#'		
		</cfquery>
	
	    <cfif mission.recordcount eq "1">
		  <cfset cl = "">
		<cfelse>	
		  <cfset cl = "##9DCEFF">
		</cfif>
				
		<cfif mission.recordcount eq "0" and url.op eq "1">
		
			<!--- hide --->
		
		<cfelse>
		
			<cfif glaccount neq "">
			
			<cfset curr = curr+1>
			
				<cfset vBankAccountNo = "">
				<cfif BankId neq "">
				
					<cfquery name="Bank"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT * 
						FROM Ref_BankAccount
						WHERE BankId = '#BankId#'
					</cfquery>
				
					<cfset vBankAccountNo = Bank.AccountNo>
				
				</cfif>
			
			    <tr class="line labelmedium2 cellcontent navigation_row clsSearchrow" bgcolor="#cl#">
				<td style="display:none;" class="ccontent">#AccountParent# #Parentdescription# #AccountGroup1# #GroupDescription# #GlAccount# #Description# #Mission.SystemAccount# #AccountType# #AccountClass# #TaxCode# #vBankAccountNo#</td>
				<td></td>
				<td></td>
			    <td style="padding-left:1px"><a class="navigation_action" onClick="javascript:edit('#GLAccount#','#AccountParent#')">#GlAccount#</td>
				<td style="padding-left:1px">#Description#</td>
				<td align="center" style="border-left:1px solid silver">#Mission.SystemAccount#</td>
				<td align="center" style="padding-left:2px">#Left(AccountType,1)#</td>
				<td align="center" style="padding-left:2px">#Left(AccountClass,1)#</td>
				<td align="center" style="padding-left:2px">#Left(AccountCategory,3)#</td>
				<td align="center" style="padding-left:2px">#TaxCode#</td>
			    <td align="center" style="padding-left:2px">#vBankAccountNo#</td>
				<td align="center" style="padding-left:2px"><cfif MonetaryAccount eq "1" and ForceCurrency eq "">Yes<cfelseif MonetaryAccount eq "1" and ForceCurrency neq "">#ForceCurrency#<cfelse></cfif></td>
				<td align="center" style="padding-left:2px"><cfif forceProgram eq "1">Yes</cfif></td>
			    <td align="center" style="padding-left:2px"><cfif TaxAccount eq "1">Yes</cfif></td>
				<td align="center" style="padding-left:2px"><cfif StockAccount eq "1">Yes</cfif></td>
				<td align="right" style="padding-right:2px">#used#</td>
				<td align="center" style="min-width:30px;padding-left:2px;border-left:1px solid silver" id="i#glaccount#">
				
				<cfif mission.recordcount eq "1">
						 
					 <img src="#SESSION.root#/Images/light_green1.gif"
					     border="0" alt="de-activate" 
						 height="13"
						 width="13"
						 align="absmiddle"
					     style="cursor: pointer;" onClick="accounttoggle('#URL.mission#','#glaccount#','0')">
					 
				<cfelse>
						 
					  <img src="#SESSION.root#/Images/light_red1.gif"
					     border="0" alt="activate account" width="13" height="13"
						 align="absmiddle"
					     style="cursor: pointer;" onClick="accounttoggle('#URL.mission#','#glaccount#','1')">
						
				</cfif>
				</td>
			    </tr>
				
			</cfif>	
			
		</cfif>	
		
	</CFOUTPUT>
	
	</CFOUTPUT>
	
	<!---
	<cfif currentrow neq recordcount>
		 <tr><td colspan="13" bgcolor="silver"></td></tr>
	</cfif>
	--->
	
	</CFOUTPUT>
	
	</table>

</cf_divscroll>

</td>

</tr>

<tr style="border-top:1px solid silver"><td style="height:25px"></td></tr>

</table>

<script>
	parent.Prosis.busy('no')
</script>
