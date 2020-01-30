
<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<cfquery name="Parent" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT * 
    FROM   Ref_AccountParent	
</cfquery>

<cfoutput query="Parent" maxrows=1>

	<cfparam name="URL.IDParent" default="#AccountParent#">
	
</cfoutput>
		 
<cfquery name="Ledger" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

    SELECT  A.*, 
	        G.Description as GroupDescription 
    
	FROM    Ref_Account A, 
	        Ref_AccountGroup G
	
	WHERE   A.AccountGroup = G.AccountGroup 
	
	<cfif URL.IDParent neq "">
	AND     G.AccountParent = '#URL.IDParent#'
	</cfif>
	
	<cfif URL.ID1 neq "">
	
		AND A.GLAccount IN  (SELECT GLAccount 
	                         FROM   Ref_AccountMission 
							 WHERE  Mission IN (SELECT DISTINCT Mission 
							                    FROM   Purchase.dbo.RequisitionLine L, Purchase.dbo.RequisitionLineFunding LF
												WHERE  L.RequisitionNo = LF.RequisitionNo
												AND    LF.Fund = '#URL.ID1#')
							)
	</cfif>		
	
	AND  Operational = 1
																	
	ORDER BY A.AccountGroup
	
</cfquery>


<!--- added a safeguard --->

<cfif Ledger.recordcount eq "0">
		 
	<cfquery name="Ledger" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
	    SELECT  A.*, 
		        G.Description as GroupDescription 
	    
		FROM    Ref_Account A, 
		        Ref_AccountGroup G
		
		WHERE   A.AccountGroup = G.AccountGroup 
		
		<cfif URL.IDParent neq "">
		AND     G.AccountParent = '#URL.IDParent#'
		</cfif>
		
		<cfif URL.ID1 neq "">
	
		AND A.GLAccount IN  (SELECT GLAccount 
	                         FROM   Ref_AccountMission WHERE GLAccount = A.GLAccount) 
		</cfif>		
		
		AND  Operational = 1
																				
		ORDER BY A.AccountGroup
		
	</cfquery>

</cfif>


<cf_dialogLedger>

<cfoutput>	
	
	<script>
		
		function reloadForm(parent) {
		     window.location = "DefaultLedgerSelectContent.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&IDParent="+parent;
		}
		
		function selected(acc) {
			window.location  = "DefaultLedgerSelectSubmit.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&IDSelect="+acc;	
		}
	
	</script>

</cfoutput>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

  <tr height="30">
  <td style="padding-left:4px">
  
    <select name="parent" class="regularxl"
	style="background: transparent; font-style: normal; border: thin none; font-family: Tahoma; font-stretch: normal; font-weight: bold; color: black;" accesskey="P" title="Parent Selection" onChange="javascript:reloadForm(this.value)">    
	    <cfoutput query="Parent">
			<option value="#AccountParent# <cfif #AccountParent# is '#URL.IDParent#'>selected</cfif>">#AccountParent# #Description#</option>
		</cfoutput>
    </select>
  </tr>
  </td>
   
  <tr>
  <td>
    
     <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" style="padding-left:10px;padding-right:10px" class="formpadding">
     <TR class="labelit linedotted"> 
       <td width="8%" height="19"></td>
       <TD width="12%" align="left">Account</font></TD>
       <TD width="60%" align="left">Description</font></TD>
	   <TD width="10%" align="left">Type</font></TD>
	   <TD width="10%" align="left">Class</font></TD>
     </TR>
	   
	 
	 <cfoutput query="Ledger" group="AccountGroup">
	    <TR>
	 	<td colspan="4" align="left" style="padding-left:10px" class="labelmedium"><b>#GroupDescription#</b></font></td> 
		</TR>
		
	 <cfoutput>
	 
	 <TR class="labelit navigation_row" bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('f1f1f1'))#">
	 <TD align="right" style="padding-top:2px;padding-left:10px;padding-right:10px"><cf_img icon="select" onClick="javascript:selected('#GLAccount#');"></TD>
	 <TD>#GLAccount#</TD>
     <TD>#Description#</TD>
	 <TD>#AccountType#</TD>
	 <TD>#AccountClass#</TD>
	 </tr>
	 
	 </cfoutput>
	 
	 <tr><td>&nbsp;</td></tr>
	 </cfoutput>
	 
	 </table>
  
  </td>
  
  </tr>
  
</table>

</form>

<cfset ajaxonload("doHighlight")>
