<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="attributes.ObjectId" default="">
<cfparam name="attributes.Journal" default="">
<cfparam name="attributes.edit" default="1">

<cfparam name="URL.IDStatus" default="All">
<cfparam name="URL.IDSorting" default="Journal">
	
<!--- Query returning search results --->
<cfquery name="TransactionListing"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   R.*, J.Description as JournalDescription
		FROM     TransactionHeader R, Journal J
		WHERE    R.ReferenceId = '#Attributes.ObjectId#'		
		AND      R.Journal = J.Journal
		<cfif attributes.journal neq "">
		AND      R.Journal = '#attributes.journal#'
		</cfif>
		AND      R.RecordStatus = '1'
		ORDER BY R.Created
</cfquery>
	
<cfinvoke component="Service.Presentation.Presentation" 
     method="highlight" 
	 returnvariable="stylescroll">
 </cfinvoke>

<!--- disabled 				 	
<cf_dialogLedger>
--->

<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0"> 

<table width="100%" border="0" frame="hsides" cellspacing="0" cellpadding="0">

<TR>

<td colspan="2">

	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<cfif attributes.edit eq "1">
	   
		<tr bgcolor="f4f4f4"><td colspan="7">
		<cfdiv bind="url:#SESSION.root#/tools/ledgerobject/LedgerObjectAccount.cfm?objectid=#attributes.objectid#" 
		  id="objectaccount"/>	
		</td>
		<td align="center">
		<cfoutput>
		<input type="button" class="button10g" name="Save" id="Save" value="Save" 
		onclick="ColdFusion.navigate('#SESSION.root#/tools/ledgerobject/LedgerObjectAccount.cfm?objectid=#attributes.objectid#&action=save','objectaccount','','','POST','formaccount')">
		</cfoutput>
		</td></tr>
		
		<tr><td colspan="8" class="linedotted"></td></tr>
	
	</cfif>
	
	<tr>
	    <TD height="21" width="3%">No</b></TD>
	    <TD width="55">Trans.No</TD>
		<TD width="10%">Date</TD>
		<TD width="36%">Description</TD>
		<TD width="15%">Reference</TD>
	    <TD width="5%">Curr</TD>
		<td width="11%" align="right">Amount</td>
		<td width="11%" align="right">Outstanding&nbsp;</td>
	</TR>
	
	<tr><td colspan="8" class="linedotted"></td></tr>
	
	<cfset amtT    = 0>
	<cfset amtOutT = 0>
	
	<cfoutput query="TransactionListing" group="Currency" startrow="1">
	
	<cfoutput group="#URL.IDSorting#">
	    
	   <cfswitch expression = #URL.IDSorting#>
	     <cfcase value = "Journal">
	     <td colspan="6">&nbsp;&nbsp;#JournalDescription#:</td>
	     </cfcase>
	     <cfcase value = "ReferenceName">
	     <td colspan="6">&nbsp;&nbsp;#ReferenceName#:</td> 
	     </cfcase>	 
	     <cfcase value = "TransactionDate">
	     <td colspan="6">&nbsp;&nbsp;#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#:</td> 
	     </cfcase>
	     <cfdefaultcase>
	     <td colspan="6">&nbsp;&nbsp;#JournalDescription#:</td>
	     </cfdefaultcase>
	   </cfswitch>
	   
	    <!--- Query returning search results --->
		<cfquery name="Total"
	         dbtype="query">
			SELECT SUM(Amount) as Amount, 
			       SUM(AmountOutstanding) as AmountOutstanding
			FROM   TransactionListing
		    WHERE  Journal = '#Journal#'
		</cfquery>   
	   
		<td align="right"><b>#NumberFormat(Total.amount,'_____,__.__')#&nbsp;</td>	
		<td align="right"><b>#NumberFormat(Total.AmountOutstanding,'_____,__.__')#&nbsp;</td>	
	   </TR>
	   
	   <tr><td colspan="8" class="linedotted"></td></tr>
	         
	<CFOUTPUT>
	
	    <cfif actionStatus eq "0">
		<cfset color = "ffffdf">
		<cfelse>
		<cfset color = "transparent">
		</cfif>
	
	    <TR bgcolor="#color#" #stylescroll#>
	    <td align="center">
		
		   <img src="#SESSION.root#/Images/pointer.gif" alt="Ledger Transaction" name="img1#currentRow#" 
					  onMouseOver="document.img1#currentRow#.src='#SESSION.root#/Images/button.jpg'" 
					  onMouseOut="document.img1#currentRow#.src='#SESSION.root#/Images/pointer.gif'"
					  style="cursor: pointer;" alt="" width="9" height="9" border="0" align="absmiddle" 
					  onClick="javascript:ShowTransaction('#Journal#','#JournalSerialNo#','1')">
		
		</td>
		<TD>
		<A HREF ="javascript:ShowTransaction('#Journal#','#JournalSerialNo#','1')">#JournalTransactionNo#</A>
		</TD>
		<TD>#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#</TD>
		<TD>#Description#</TD>
		<TD>#ReferenceName#</TD>
	    <TD align="left">#Currency#</TD>
	    <td align="right">#NumberFormat(Amount,'_____,__.__')#&nbsp;</td>	
		<td align="right">#NumberFormat(AmountOutstanding,'_____,__.__')#&nbsp;</td>	
		
	    </TR>
		<!---
		 <tr><td height="1" colspan="8" bgcolor="e8e8e8"></td></tr>
		 --->
	
	</CFOUTPUT> 
	</CFOUTPUT> 
	
	</CFOUTPUT>
	
	<!---
	   <cfoutput>
	   <tr bgcolor="f1f1f1">    
	   	   <td colspan="6" align="center"></td> 
		   <td align="right"><font color="0080FF"><b>#NumberFormat(AmtT,'_____,__.__')#&nbsp;</b></td>	
	       <td align="right"><font color="0080FF"><b>#NumberFormat(AmtOutT,'_____,__.__')#&nbsp;</b></td>	
	   </TR>   
	   </cfoutput>
	--->   
	
	</TABLE>

</td>
</tr>

</TABLE>


