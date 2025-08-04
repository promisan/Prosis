<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cf_screentop height="100%" jquery="Yes" scroll="Yes" layout="webapp" option="Journal Settings and Parameters" label="Record Journal Voucher">

<cfquery name="MissionSelect"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ParameterMission
</cfquery>

<cfquery name="Bank" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_BankAccount	
</cfquery>

<cfquery name="Category"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_TransactionCategory
	ORDER By OrderListing
</cfquery>

<cfquery name="Type"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_JournalType
</cfquery>

<cfquery name="Currency"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Currency
</cfquery>

<cfquery name="Workflow"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM         Ref_EntityClass
	WHERE     EntityCode = 'GLTransaction'
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

<cfparam name="URL.ID" default="Payables">

<script>

function reloadForm(cat) {
  ptoken.location('RecordAdd.cfm?ID=' + cat); 
}

function applyaccount(acc) {
   ptoken.navigate('setAccount.cfm?account='+acc,'process')
}  

function formvalidate() {
	document.dialog.onsubmit() 
	if( _CF_error_messages.length == 0 ) {    	    
		ptoken.navigate('RecordSubmit.cfm?mode=insert','process','','','POST','dialog')
	 }   
}	 	

</script>

<cf_dialogLedger>

<!--- Entry form --->

<cfform onsubmit="return false" method="POST" name="dialog">

<table width="92%" align="center" class="formpadding">

	
	<tr class="xxxhide"><td id="process"></td></tr>
	<tr><td height="10"></td></tr>	
	
	<TR class="labelmedium2">
    <TD class="fixlength labelmedium2"><cf_tl id="Entity">:</TD>
    <TD>
	 
  	    <select name="mission" id="mission" class="regularxxl" onChange="javascript:system()">
     	   <cfoutput query="missionselect">
        	<option value="#Mission#" <cfif url.mission eq mission>selected</cfif>>#Mission#
			</option>
         	</cfoutput>
	    </select>
    </TD>
	</TR>
	
	<TR>
    <TD class="fixlength labelmedium2"><cf_tl id="Ledger Class">:</TD>
    <TD>
  	    <select name="GLCategory" class="regularxxl" onChange="glclass(this.value)">
     	   <cfoutput query="GLCategory">
        	<option value="#GLCategory#">#GLCategory#
			</option>
         	</cfoutput>
	    </select>
    </TD>
	</TR>
	
	<cfoutput>
		
	<script language="JavaScript">
	
	function glclass(cat) {
				
		url = "getCategory.cfm?cat="+cat;
		_cf_loadingtexthtml='';	
		ptoken.navigate(url,'categorybox')	 
	}

	</script>

	</cfoutput>

    <TR class="labelmedium2">
    <TD class="fixlength labelmedium2"><cf_tl id="Category">:</TD>
    <TD id="categorybox">
	
  	    <select name="transactioncategory" id="transactioncategory" class="regularxxl" onChange="system()">
     	   <cfoutput query="category">
        	<option value="#TransactionCategory#"<cfif URL.ID is TransactionCategory>selected</cfif>>#TransactionCategory#
			</option>
         	</cfoutput>
	    </select>
		
    </TD>
	</TR>
	      	
	
	
    <TR class="labelmedium2">
    <TD class="fixlength labelmedium2"><cf_tl id="Journal Code">:</TD>
    <TD>
  	   <cfinput type="Text"
	       name="Journal"
	       message="Please enter a code"
	       required="Yes"
	       visible="Yes"
	       enabled="Yes"
	       size="10"
	       maxlength="10"
	       class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD class="fixlength labelmedium2"><cf_tl id="Description">:</TD>
    <TD>
  	    <cfinput type="Text"
	       name="Description"
	       message="Please enter a description"
	       required="Yes"
	       visible="Yes"
	       enabled="Yes"
	       size="40"
	       maxlength="50"
	       class="regularxxl">
    </TD>
	</TR>
	
	<cfoutput>
		
	<script language="JavaScript">
	
	function system(pg) {
				
		mis = document.getElementById("mission").value;
		cat = document.getElementById("transactioncategory").value
		url = "getSystemJournal.cfm?mis="+mis+"&cat="+cat;
		ptoken.navigate(url,'systembox')	 
	}

	</script>

	</cfoutput>
	
	
	<TR class="labelmedium2">
    <TD class="fixlength labelmedium2"><cf_tl id="System Journal for">:</TD>
    <TD id="systembox">	 
	     
		<cfquery name="Preset" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_SystemJournal
		WHERE  Area NOT IN (SELECT DISTINCT SystemJournal 
		                    FROM   Journal 
						    WHERE  Mission              = '#url.Mission#'
						    AND    TransactionCategory != '#Category.TransactionCategory#'
						    AND    SystemJournal is not NULL) 
		</cfquery>
					 
  	    <select name="SystemJournal" id="SystemJournal" class="regularxxl">
		   <option value="" selected>N/A</option>
     	   <cfoutput query="Preset">
        	<option value="#Area#">#area#</font>
			</option>
         	</cfoutput>
	    </select>
				
    </TD>
	</TR>
	
	<tr class="labelmedium2">
	
		<td class="fixlength labelmedium2" style="cursor:pointer" title="Workflow associated to transactions under this journal"><cf_tl id="Workflow Class">:</td>
		<td>		
		 <select name="EntityClass" class="regularxxl">
	     	   <cfoutput query="Workflow">
	        	<option value="#EntityClass#">#EntityClassName#</option>
	         	</cfoutput>
		 </select>
		</td>		
	</tr>
	      	
	<TR class="labelmedium2">
    <TD class="fixlength labelmedium2"><cf_tl id="Type">:</TD>
     <TD>
  	    <select name="journaltype" class="regularxxl">
     	   <cfoutput query="type">
	        	<option value="#JournalType#">#JournalType#</option>
           </cfoutput>
	    </select>
    </TD>
	</TR>
	
	<cfif Category.TransactionCategory eq "Payment" or Category.TransactionCategory eq "DirectPayment">
		<cfset cl = "regular">
	<cfelse>
		<cfset cl = "hide">
	</cfif>
			
	<TR class="labelmedium2">
    <TD class="fixlength labelmedium2"><cf_tl id="Journal Currency">:</TD>
     <TD>
  	    <select name="currency" class="regularxxl">
     	   <cfoutput query="currency">
        	<option value="#Currency#" <cfif currency eq APPLICATION.BaseCurrency>selected</cfif>>#Currency#
			</option>
         	</cfoutput>
	    </select>
    </TD>
	</TR>
	
	<TR id="bank" class="<cfoutput>#cl#</cfoutput>">
    <TD class="fixlength labelmedium2" style="cursor:pointer" title="<cf_tl id='Pay Through'>":</TD>
    <TD>
  	      <select name="bankid" class="regularxxl">
		    <option value="">Any</option>
            <cfoutput query="Bank">
        	<option value="#BankId#">#BankName# (#Currency#)</font>
			</option>
         	</cfoutput>
	    </select>
    </TD>
	</TR>	
		
	<TR class="labelmedium2">
    <TD class="fixlength labelmedium2" style="cursor: pointer;" title="Contra-Book transactions recorded for this journal on the selected account"><cf_tl id="Contra-account">:</TD>
    <TD>
	    <cfoutput>	 
		   <table><tr><td>
		      <input type="Text" name="glaccount" id="glaccount" size="6" class="regularxxl" readonly>
		   </td>
		   <td style="padding-left:4px">
    	      <input type="text" name="gldescription" id="gldescription" value="" class="regularxxl" size="50" readonly>
		   </td style="padding-left:4px">
		      <input type="hidden" name="debitcredit" id="debitcredit" value="" class="regularxxl" size="6">
		   <td style="padding-left:4px">
		    <img src="#SESSION.root#/Images/search.png" alt="Select account" name="img3" 
				  onMouseOver="document.img3.src='#SESSION.root#/Images/contract.gif'" 
				  onMouseOut="document.img3.src='#SESSION.root#/Images/search.png'"
				  style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
				  onClick="selectaccountgl(document.getElementById('mission').value,'','','','applyaccount')">
			</td>
			</tr>
			</table>				  
		</cfoutput>   
	</TD>
	</TR>
	
	<tr class="labelmedium2">
	<td class="fixlength labelmedium2" style="cursor: pointer;" title="Allow to schedule transactions for this journal"><cf_tl id="Schedule Transactions">:</td>
	<TD><table>
	    <tr class="labelmedium2">
		    <td><input type="radio" class="radiol" name="EnableScheduler" value="1"></td>
		    <td style="padding-left:5px">Yes</td>
			<td style="padding-left:10px"><input type="radio" class="radiol"  name="EnableScheduler" value="0" checked></td>
			<td style="padding-left:5px">No</td>
		</tr>
		</table>
    </TD>
	</tr>	
	
	<tr class="labelmedium2">
    <td class="fixlength labelmedium2" valign="top" style="padding-top:5px"><cf_tl id="Transaction Sub period">:</td>
    <td>
	
	  <table cellspacing="0" cellpadding="0" class="formspacing">
		  <tr class="labelmedium2">
		   <td style="cursor:pointer" title="Cluster Transactions under a single batch">No:</td>
		   <td>&nbsp;</td>
		   <td>
	  	    <cfinput type="Text" name="JournalBatchNo"
		       value="0" validate="integer" required="No"
		       visible  = "Yes" 
			   enabled  = "Yes"
			   class    = "regularxxl"		       
		       size     = "4"
			   style    = "width:40px;text-align: center;">
		   </td>
		   </tr>
		   <tr>
		   <td class="labelmedium2"><cf_tl id="Reference">:</td>		
		   <td>&nbsp;</td> 
		   <td>
			   <cfinput type="Text"
		       name="BatchCategory"
		       required="No"
		       visible="Yes"
			   class="regularxxl"			   
		       enabled="Yes"
		       size="20"
		       maxlength="20">
		   </td>		   
		  </tr>
		   <tr class="labelmedium2">
		   <td><cf_tl id="Description">:</td>	
		   <td>&nbsp;</td>	 
		   <td>
			   <cfinput type = "Text"
		       name          = "BatchDescription"
		       required      = "No"
		       visible       = "Yes"
			   class         = "regularxxl"
		       enabled       = "Yes"
		       size          = "40"
		       maxlength     = "50">
		   </td>		   
		  </tr>
	  </table>
    </TD>
	</TR>
			
	<TR class="labelmedium2">
    <TD class="fixlength labelmedium2"><cf_tl id="Speedtype">:</TD>
    <TD>
	
  	    <select name="speedtype" class="regularxxl">
    		<option value="">N/A</option>  
     	   <cfoutput query="speedtype">
        	<option value="#Speedtype#">#Speedtype# #Description#</option>
         	</cfoutput>
	    </select>
		
    </TD>
	</TR>
	<tr><td height="5"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="35">	
		<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
		<input class="button10g" type="button" name="Insert" value="Save" onclick="formvalidate()">	
	</td>
	</tr>
				
</TABLE>

</CFFORM>
	
<cf_screenbottom layout="webapp">
