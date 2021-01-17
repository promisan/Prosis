
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Order class" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<!--- Entry form --->

<table width="92%" class="formspacing formpadding" align="center">

	<tr><td height="10"></td></tr>
   <!--- Field: Id --->
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD class="labelmedium2">
		<cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="20"
		class="regularxxl enterastab">
	</TD>
	</TR>
		 
	 <cfquery name="Mis" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterMission
		WHERE Mission IN (SELECT Mission 
                  FROM Organization.dbo.Ref_MissionModule 
				  WHERE SystemModule = 'Procurement')
	</cfquery>
	 
	 <TR>
	 <TD class="labelmedium2" width="150">Entity:&nbsp;</TD>  
	 <TD>
	 	<select class="regularxxl enterastab" name="Mission" id="Mission">
		<option value="" selected>[Apply to all]</option>
		<cfoutput query="Mis">
		<option value="#Mission#">#Mission#</option>
		</cfoutput>
		</select>
	 </TD>
	 </TR>
	 
		 
	<cfquery name="TaxAccount"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_Account
		WHERE TaxAccount = 1
	</cfquery>

	 
	  <TR class="labelmedium2">
    <TD>Tax Account :</TD>
    <TD>
  	  <select class="regularxxl enterastab" name="glaccounttax">
     	  <option value="">Use System default</option>  
            <cfoutput query="TaxAccount">
        	<option value="#GLAccount#">#GLAccount# #Description#</option>
         	</cfoutput>
	    </select>
    </TD>
	</TR>
	 
	   <!--- Field: Description --->
    <TR>
    <TD class="labelmedium2">Description:</TD>
    <TD class="labelmedium2">
		<cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="30"
		class="regularxxl enterastab">
	</TD>
	</TR>
		
	<TR>
    <td class="labelmedium2">Group:</b></td>
    <TD class="labelmedium2">
	<input type="radio" class="enterastab" name="PreparationMode" id="PreparationMode" value="Job" checked>Standard Procurement (Vendor)<br>
	<input type="radio" class="enterastab" name="PreparationMode" id="PreparationMode" value="Position">Outsourced Position (New and Extension)<br>
	<input type="radio" class="enterastab" name="PreparationMode" id="PreparationMode" value="SSA">Personal Service Agreement<br>
	<input type="radio" class="enterastab" name="PreparationMode" id="PreparationMode" value="Direct">Direct Purchase<br>
	<input type="radio" class="enterastab" name="PreparationMode" id="PreparationMode" value="Travel">Travel / Special Service Extension
    </td>
    </tr>	
	
	<tr><td class="labelmedium2" height="3"><b>Print Template</b></td></tr>
	
	 <!--- Field: Description --->
    <TR height="30">
    <TD class="labelmedium2">&nbsp;Purchase Order:</TD>
    <TD>
		<cfinput type="Text" name="PurchaseTemplate" value="" message="Please enter a template path" required="No" size="40" maxlength="100"
		class="regularxxl enterastab">
	</TD>
	</TR>
	
	<TR height="30">
    <TD class="labelmedium2">&nbsp;Execution&nbsp;Request:&nbsp;</TD>
    <TD>
		<cfinput type="Text" name="ExecutionTemplate" message="Please enter a template path" required="No" size="40" maxlength="100"
		class="regularxxl enterastab">
	</TD>
	</TR>	
			
	<tr><td colspan="2" class="line"></td></tr>
	<tr>	
		<td align="center" colspan="2" height="30">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit ">
		</td>
	</tr>
	    
</TABLE>

</CFFORM>


