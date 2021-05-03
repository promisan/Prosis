<cfquery name="get" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	JA.*,
				A.Description as AccountDescription,
				A.AccountType,
				J.Mission
	    FROM  	JournalAccount JA
				INNER JOIN Ref_Account A
					ON JA.GLAccount = A.GLAccount
				INNER JOIN Journal J
					ON JA.Journal = J.Journal
		WHERE 	JA.Journal = '#URL.journal#'
		AND		JA.GLAccount = '#url.account#'
</cfquery>

<cfset vAdd = "Edit">
<cfif url.account eq "">
	<cfset vAdd = "Add">
</cfif>

<cfform name="frmJournalAccount" onsubmit="return false">

	<cfoutput>
	
		<input type="hidden" name="origaccount" id="origaccount" value="#url.account#">
		<table width="90%" align="center" class="formpadding formspacing">
			<tr><td height="15"></td></tr>
			<tr class="labelmedium2">
				<td><cf_tl id="Account">:</td>
				<td>
					<cf_tl id="Please select a valid account" var="1">
					<cfinput type="text" name="glaccount"   id="sglaccount"      value="#get.glaccount#"           size="5"  readonly class="regularxxl" style="text-align: center;" required="Yes" message="#lt_text#">
		    	   	<input type="text" name="gldescription" id="sgldescription"  value="#get.AccountDescription#"  size="40" readonly class="regularxxl" style="text-align: center;">
				   	<input type="text" name="debitcredit"   id="sdebitcredit"    value="#get.accounttype#"         size="3"  readonly class="regularxxl" style="text-align: center;">
				   
				   	<cfif url.account eq "">
					    <img src="#SESSION.root#/Images/contract.gif" alt="Select account" name="img3" 
						  onMouseOver="document.img3.src='#SESSION.root#/Images/button.jpg'" 
						  onMouseOut="document.img3.src='#SESSION.root#/Images/contract.gif'"
						  style="cursor: pointer;" alt="" width="16" height="18" border="0" align="absmiddle" 
						  onclick="selectaccountgl('#get.mission#','glaccount','','','applyaccount','')">
					</cfif>
				</td>
				<td id="process"></td>
			</tr>
			<tr class="labelmedium2">
				<td><cf_tl id="Usage">:</td>
				<td>
				    <table class="formspacing">
					<tr class="labelmedium2">
						<td><input type="Radio" name="mode" class="radiol" value="Contra" <cfif get.mode eq "Contra" or url.account eq "">checked</cfif>></td><td style="padding-left:3px"><cf_tl id="Contra"></td>
						<td style="padding-left:4px"><input type="Radio" name="mode" class="radiol"  value="Correction" <cfif get.mode eq "Correction">checked</cfif>></td><td style="padding-left:3px"><cf_tl id="Correction"></td>
						<td style="padding-left:4px"><input type="Radio" name="mode" class="radiol"  value="Standard" <cfif get.mode eq "Standard">checked</cfif>></td><td style="padding-left:3px"><cf_tl id="Detail"></td>
					</tr>
					</table>
				</td>
			</tr>
			<tr class="labelmedium2">
				<td><cf_tl id="Sort">:</td>
				<td>
					<cf_tl id="Please enter a valid listing order" var="1">
					<cfinput 
						type="Text" 
						name="ListOrder" 
						id="ListOrder" 
						maxlength="4" 
						value="#get.ListOrder#" 
						class="regularxxl" 
						required="yes" 
						message="#lt_text#" 
						size="3" 
						style="text-align:center;">
				</td>
			</tr>
			<tr class="labelmedium2">
				<td><cf_tl id="Default">:</td>
				<td>
					<input type="Checkbox" name="ListDefault" id="ListDefault" style="height:20px; width:20px;" <cfif get.ListDefault eq "1">checked</cfif>>
				</td>
			</tr>
			
			<tr><td colspan="2" class="line"></td></tr>
			
			<tr>
				<td colspan="2">
					<cf_tl id="Save" var="1">
					<cf_button2 
						id="btnSubmit"
						onclick="accountvalidate()"
						type="button" 
						style="width:200px"
						text="#lt_text#">
				</td>
			</tr>
		</table>
	</cfoutput>

</cfform>