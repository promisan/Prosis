
<cfparam name="URL.action" default="">

<cfif url.action eq "save">

	<cfquery name="ResetTopic" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM OrganizationObjectLedger
		WHERE ObjectId = '#URL.ObjectId#'
	</cfquery>
		
	<cfquery name="Gledger" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  *
		     FROM  Ref_AreaGLedger		
	</cfquery>
		
	<cfloop query="GLedger">
		
		<cfset acc  = Evaluate("Form.#Area#_Account")>
		<cfset cur  = Evaluate("Form.#Area#_Currency")>
		<cfset bnk  = Evaluate("Form.#Area#_Bank")>
					  
	   <cfquery name="Insert" 
			 datasource="AppsOrganization" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 INSERT INTO OrganizationObjectLedger
					 (ObjectId,Area,GLAccount,BankId,Currency)
			 VALUES  ('#URL.ObjectId#', '#Area#', '#acc#','#bnk#','#cur#') 
		</cfquery>
		
	</cfloop>		

</cfif>

<table cellspacing="0" cellpadding="0" class="formpadding">

<form method="post" name="formaccount" id="formaccount">
	
	<cfquery name="Area"
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM   Ref_AreaGLedger		
	</cfquery>
	
	<cfquery name="Curr" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  *
		  FROM    Currency	
		  WHERE Currency IN (SELECT Currency FROM Ref_BankAccount)	 
		</cfquery>	
	
	<cfoutput query="Area">
	<tr>
	<td><b>#Description#:&nbsp;</b></td>
	<td>Posting Account:</td>
	<td width="50%">
	
	    <cfquery name="Account" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  P.*, A.Description
		  FROM    OrganizationObjectLedger P, 
		          Accounting.dbo.Ref_Account A
		  WHERE   ObjectId = '#url.ObjectId#'
		    AND   Area     = '#Area#'
			AND   P.GLAccount = A.GLAccount
		</cfquery>		
	
	   <cfoutput>	 
	   
		    <img src="#SESSION.root#/Images/contract.gif" alt="Select item master" name="img3" 
				  onMouseOver="document.img3.src='#SESSION.root#/Images/button.jpg'" 
				  onMouseOut="document.img3.src='#SESSION.root#/Images/contract.gif'"
				  style="cursor: pointer;" width="18" height="20" border="0" align="absmiddle" 
				  onClick="javascript:selectaccount('#Area#_Account','#Area#_Description','#Area#cls','');">
		    <input type="text" name="#Area#_Account" id="#Area#_Account" size="6"  value="#Account.glaccount#"     class="regularH" readonly style="text-align: center;">
		    <input type="text" name="#Area#_Description" id="#Area#_Description" value="#Account.Description#" class="regularH" size="40" readonly style="text-align: center;">
			<input type="hidden" name="#Area#cls" id="#Area#cls">
		 
	   </cfoutput>		
	
	</td>
	<td>Currency:</td>
	<td>
	<select name="#Area#_Currency" id="#Area#_Currency">
	<cfloop query="Curr">
		<option value="#Currency#" <cfif currency eq account.currency>selected</cfif>>#Currency#</option>
	</cfloop>
	</select>
	</td>
	
	<td width="100">
	
	 <cfquery name="Account" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  P.*
		  FROM    OrganizationObjectLedger P
		  WHERE   ObjectId = '#url.ObjectId#'
		</cfquery>		
	
	<cfdiv bind="url:#SESSION.root#/tools/ledgerobject/LedgerObjectBank.cfm?area=#Area#&bankid=#account.bankid#&currency={#Area#_Currency}"
	 id="box_#Area#_bank">
		
	</td>
	
	
	</tr>
	</cfoutput>
	</form>	
	</table>
	
