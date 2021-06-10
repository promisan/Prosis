
<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  J.* 
	FROM    Journal J 
	WHERE   Journal = '#URL.ID1#'	
</cfquery>

<cfquery name="Used" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  TOP 1 Journal 
	FROM    TransactionLine J 
	WHERE   Journal = '#URL.ID1#'	
</cfquery>

<cfquery name="DefaultContraAccount"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   TOP 1 A.*, R.Description as GLDescription, R.AccountType
		FROM     JournalAccount A INNER JOIN Ref_Account R ON A.GLAccount = R.GLAccount		
		WHERE    Journal = '#URL.ID1#' 	
		AND      Mode = 'Contra'
		ORDER BY ListDefault DESC <!--- first the default --->
</cfquery>

<cfquery name="Bank" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_BankAccount	
	WHERE  Currency = '#Get.Currency#'
</cfquery>

<cfquery name="Workflow"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM         Ref_EntityClass
	WHERE     EntityCode = 'GLTransaction'
</cfquery>

<cfquery name="Preset" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_SystemJournal
	WHERE Area NOT IN (SELECT DISTINCT SystemJournal 
    	               FROM   Journal 
					   WHERE  Mission  = '#Get.Mission#'
					   AND    TransactionCategory != '#get.TransactionCategory#'
					   AND    SystemJournal is not NULL) 
</cfquery>

<cfquery name="Mission" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   Ref_ParameterMission
WHERE  Mission = '#get.Mission#'
</cfquery>

<cfquery name="Type"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_JournalType
</cfquery>

<cfquery name="GLCategory"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_GLCategory
</cfquery>

<cfquery name="Speedtype"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Speedtype
</cfquery>

<cfoutput>

<script language="JavaScript">

function askjournal() {
	if (confirm("Do you want to remove this Journal ?")) {		
	ptoken.navigate('RecordSubmit.cfm?mode=delete','contentbox1','','','POST','f_journal_edit')
	}	
	return false	
}	

function batchperiod() {    
	ProsisUI.createWindow('mydialog', 'Subperiod', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})    		
	ptoken.navigate('#session.root#/Gledger/Maintenance/LedgerSchema/Journal/BatchView.cfm?Journal=#url.id1#','mydialog') 	

}

function batchrefresh(id) {
    ptoken.navigate('journalbatch.cfm?journal=#url.id1#','subperiod')	
}	

</script>

</cfoutput>

<cf_dialogLedger>

<cfform  method="POST" name="f_journal_edit">

<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
   
	<cfoutput>
	
	<tr><td colspan="2" style="height:30" class="labelmedium2"><b><cf_tl id="Journal Classification"> #get.mission#</font></td></tr>
	<tr><td colspan="2" height="1" class="linedotted"></td></tr>
	<tr class="hide"><td id="process"></td></tr>
				
	<TR>
    <TD height="20" class="labelmedium2"><font color="0080C0">#get.glcategory#:</TD>
    <TD> 
	
	<cfif used.recordcount eq "0">
						
		<cfquery name="Category"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM Ref_TransactionCategory
			ORDER By OrderListing
		</cfquery>
		
		<cfquery name="Currency"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM Currency
		</cfquery>
	
		<table>
		<tr>
		<td>
		
		   <select name="transactioncategory" id="transactioncategory" class="regularxxl" onChange="system()">
	     	   <cfloop query="category">
	        	<option value="#TransactionCategory#"<cfif get.transactioncategory is TransactionCategory>selected</cfif>>#TransactionCategory#
				</option>
	         	</cfloop>
		    </select>
		</td>
		
		<td style="padding-left:3px">
		
		    <select name="currency" class="regularxxl">
	     	   <cfloop query="currency">
	        	<option value="#Currency#" <cfif currency eq get.currency>selected</cfif>>#Currency#
				</option>
	         	</cfloop>
		    </select>
		
		</td>
		
		</tr>
		</table>
	
	<cfelse>
	
	   <input type="text" name="transactioncategory" value="#get.transactioncategory#" class="regularxxl" size="10" readonly  style="background-color:e4e4e4;text-align: center;">
	   <input type="text" name="currency" value="#get.currency#" size="4" readonly class="regularxxl" style="background-color:e4e4e4;text-align: center;">
	   
	</cfif>   
   
	</TD>
	</TR>
   	
	<TR>
    <TD class="labelmedium2"><cf_tl id="Journal No">:</TD>
    <TD>
  	   <input type="Text" name="Journal" value="#get.journal#" size="10" class="regularxxl" maxlength="10" readonly style="text-align: center;">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium2"><cf_tl id="Description">:</TD>
    <TD>
		<input type="Text" name="Description" value="#get.Description#" size="40" class="regularxxl" maxlength="50" style="text-align: left;">
    </TD>
	</TR>
	
		
	<cfif Mission.AdministrationLevel eq "Parent">
	
		
		<cfquery name="Mandate" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		      SELECT   DISTINCT MandateNo, Description, DateEffective, DateExpiration 
		      FROM     Ref_Mandate
		   	  WHERE    Mission = '#get.Mission#' 
			  ORDER BY DateEffective DESC
		</cfquery>
		
		<!--- show only the last parent org structure --->
		 <cfquery name="getOwner" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		      SELECT  *
		      FROM    Organization
		   	  WHERE   OrgUnit = '#get.OrgUnitOwner#'			 
		 </cfquery>
		
		 <!--- show only the last parent org structure --->
		 <cfquery name="Parent" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		      SELECT DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode, OrgUnitNameShort, MissionOrgUnitId
		      FROM   #Client.LanPrefix#Organization
		   	  WHERE (ParentOrgUnit is NULL OR ParentOrgUnit = '' or Autonomous = 1)
			  AND    Mission     = '#get.Mission#'
			  AND     MandateNo   = '#Mandate.MandateNo#'
			  ORDER BY TreeOrder, OrgUnitName
		 </cfquery>
	
	<TR>
    <TD class="labelmedium2"><cf_tl id="Enabled for owner">:</TD>
    <TD>
	 
  	    <select name="OrgUnitOwner" class="regularxxl">
		   <option value="" <cfif get.OrgUnitOwner is "">selected</cfif>>Any</option>
     	   <cfloop query="Parent">
        	    <option value="#OrgUnit#" <cfif getOwner.MissionorgUnitid is MissionOrgUnitId>selected</cfif>>#OrgUnitName#</option>
           </cfloop>
	    </select>
		
    </TD>
	</TR>	
	<cfelse>
		<input type="hidden" name="OrgUnitOwner" id="OrgUnitOwner" value="">	
	</cfif>
	
	
	<TR>
    <TD class="labelmedium2"><cf_tl id="System Journal">:</TD>
    <TD>
	 
  	    <select name="SystemJournal" class="regularxxl">
		    <option value="" <cfif get.systemjournal is "">selected</cfif>>N/A</option>
     	   <cfloop query="Preset">
        	<option value="#Area#" <cfif get.systemjournal is area>selected</cfif>>#area#</font>
			</option>
         	</cfloop>
	    </select>
		
    </TD>
	</TR>	
	
	</cfoutput>
		      	
	<TR>
    <TD class="labelmedium2"><cf_tl id="Type">:</TD>
     <TD>
  	    <select name="journaltype" class="regularxxl">
     	   <cfoutput query="type">
        	<option value="#JournalType#" <cfif get.journaltype is journaltype>selected</cfif>>#JournalType#</option>
         	</cfoutput>
	    </select>
    </TD>
	</TR>
			
	<cfoutput>
		
	<cfif get.TransactionCategory eq "Payment" or get.TransactionCategory eq "DirectPayment">
		
		<TR>
	    <TD class="labelmedium2"><cf_UItooltip  tooltip="Bank account"><cf_tl id="Bank Account">:</cf_UItooltip>:</TD>
	    <TD>
	  	      <select name="bankid" class="regularxxl">
			    <option value="">Any</option>
	            <cfloop query="Bank">
	        	<option value="#BankId#" <cfif Get.BankId eq BankId>selected</cfif>>#BankName#</font>
				</option>
	         	</cfloop>
		    </select>
	    </TD>
		</TR>	
		<tr><td></td><td width="70%" class="labelmedium2"><i>Transactions under this journal will be routed to the selected bank account for payment. You must
		define this bank account to a contra-account of a banking journal to ensure reconciliation. 
		</td></tr>
		
	<cfelse>
		
		<input type="hidden" name="bankid" value="">
			
	</cfif>
		
	</cfoutput>
	
	<tr><td class="labelmedium2" style="height:20px;cursor: pointer;"><cf_UItooltip  tooltip="Allow to schedule transactions for this journal"><cf_tl id="Schedule Transactions">:</cf_UItooltip></td>
	<TD class="labelmedium2">
	    <input type="radio" class="radiol" name="EnableScheduler" value="1" <cfif get.EnableScheduler is "1">checked</cfif>>
		Yes
		<input type="radio" class="radiol" name="EnableScheduler" value="0" <cfif get.EnableScheduler is "0">checked</cfif>>
		No
    </TD>
	</tr>
	
	<tr><td class="labelmedium2" style="height:20"><cf_tl id="Operational">:</td>
	<TD class="labelmedium2">
	    <input type="radio" class="radiol" name="Operational" value="1" <cfif get.operational is "1">checked</cfif>>
		Yes
		<input type="radio" class="radiol" name="Operational" value="0" <cfif get.operational is "0">checked</cfif>>
		No
    </TD>
	</tr>
	
	<tr><td height="4"></td></tr>
	<tr><td colspan="2" style="height:30" class="labelmedium2">Transaction Recording Settings</td></tr>
	<tr><td colspan="2" height="1" class="linedotted"></td></tr>
	<tr><td height="4"></td></tr>
	
	<cfoutput>
	
	<TR>
    <TD class="labelmedium2" style="cursor: pointer;">
	  <cf_UItooltip tooltip="Contra-Book transactions recorded for this journal on the selected account"><cf_tl id="Default contra-account">:</cf_UItooltip>
	</TD>
   
    <TD>
	
		<table cellspacing="0" cellpadding="0"><tr>
								  
  		   <td><input type="text" name="glaccount"     id="glaccount"      value="#DefaultContraAccount.glaccount#"      size="5"  readonly class="regularxxl" style="text-align: center;"></td>
    	   <td style="padding-left:1px"><input type="text" name="gldescription" id="gldescription"  value="#DefaultContraAccount.gldescription#"  size="50" readonly class="regularxxl" style="text-align: center;"></td>
		   		   
		   <td style="padding-left:1px"> 
		   <!---
		       <img src="#SESSION.root#/Images/search.png" alt="Select account" name="img3" 
			  onMouseOver="document.img3.src='#SESSION.root#/Images/contract.gif'" 
			  onMouseOut="document.img3.src='#SESSION.root#/Images/search.png'"
			  style="cursor: pointer;border-radius:3px" alt="" width="25" height="25" border="0" align="absmiddle" 
			  onClick="selectaccountgl('#get.mission#','glaccount','','','applyaccount')"></td>
			  --->
			  
			</tr></table>  
	</TD>
	</TR>
	
	
	<TR>
    <TD class="labelmedium2" style="cursor: pointer;">
	  <cf_UItooltip tooltip="Main purpose of the journal is to record an asset or liability">Purpose:</cf_UItooltip>
	</TD>
   
     <td style="padding-left:1px">
	 <table>
	 <tr class="labelmedium2">
	 <td>	 
	 <input type="radio" name="debitcredit"   id="debitcredit"    value="Debit"  <cfif get.AccountType eq "Debit">checked</cfif> class="radiol" style="text-align: center;">
	 </td>
	 <td>Asset</td>
	 <td style="padding-left:10px">
	  <input type="radio" class="radiol"  name="debitcredit"   id="debitcredit"    value="Credit" class="regularxxl" <cfif get.AccountType eq "Credit">checked</cfif> style="text-align: center;">
	 </td> 
	 <td>Liability</td>
	 </tr>
	 </table>
	 
		   		   
		
	</TD>
	</TR>
	
	
	<tr>
	
		<td class="labelmedium2"><cf_UItooltip tooltip="Workflow associated to transactions under this journal"><cf_tl id="Workflow Trigger">:</cf_UItooltip></td>
		<td>		
		 <select name="EntityClass" class="regularxxl">
	     	   <cfloop query="Workflow">
	        	<option value="#EntityClass#" <cfif get.entityClass is EntityClass>selected</cfif>>#EntityClassName#</option>
	         	</cfloop>
		 </select>
		</td>		
		
	</tr>		
			
	</cfoutput>
		
	<cfquery name="Batch"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   JournalBatch
		WHERE  Journal = '#URL.ID1#'	
		AND    JournalBatchNo = #get.JournalBatchNo#	
	</cfquery>
	
	<cfoutput>
		
	<TR>
    <TD height="20" class="labelmedium2">
	  Subperiods:
	</td>
		
	<td>
	
		<table cellspacing="0" cellpadding="0">
		<tr><td class="labelmedium2"><cf_tl id="Default">:</td>
		   <td>	
		   <cfdiv id="subperiod" bind="url:journalbatch.cfm?journal=#url.id1#"/>	   
		   </td>	
		   <td>&nbsp;</td>   
		   <td>	   
		   <input type="button" onclick="batchperiod()" name="subperiodmaintain" value="Maintain" style="height:24;width:120" class="button10g">
		   </td>	   
		</tr>
	    </table>
	
	</td>
	
	</TR>
	
	<TR>
    <TD class="labelmedium2"><cf_tl id="Speedtype"></TD>
    <TD>
  	    <select name="speedtype" class="regularxxl">
		<option value=''>N/A</option>  
     	   <cfloop query="speedtype">
        	<option value="#Speedtype#" <cfif get.speedtype is speedtype>selected</cfif>>#Speedtype# #Description#
			</option>
         	</cfloop>
	    </select>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2"><cf_tl id="Next Journal SerialNo">: </font> </TD>
     <TD>
	 <!---
  	    <cfinput type="Text"
       name="JournalSerialNo"
       value="#get.JournalSerialNo+1#"
       validate="integer"
       required="No"
       visible="Yes"
	   class="regular"
       enabled="Yes"
       tooltip="Set the next transaction number to be used <br> If you enter an already used transaction number<br> the system will automatically assign the last used number"
       size="4"
	   style="width:40px;text-align: center;">
	   --->
	   <input type="Text" name="JournalSerialNo" value="#get.JournalSerialNo+1#" size="4" class="regularxxl" maxlength="50" style="text-align: center;">
    </TD>
	</TR>
		
	</cfoutput>
			
	<tr><td height="1" class="linedotted" colspan="2"></td></tr>
	
	<tr><td colspan="2" align="center" style="padding-top:4px">
	
	<cfquery name="CountRec" 
	      datasource="AppsLedger" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT *
	      FROM TransactionHeader
	      WHERE Journal  = '#URL.ID1#' 
	</cfquery>
	
	<cfif countrec.recordcount eq "0">
		<input class="button10g" style="width:200px;height:28px" type="button" name="Delete" value=" Delete " onclick="return askjournal()">
	</cfif>
	<input class="button10g" style="width:200px;height:28px" type="button" name="Update" value=" Update " onclick = "javascript:do_submit()">
	</td></tr>
	
</table>

</cfform>	
