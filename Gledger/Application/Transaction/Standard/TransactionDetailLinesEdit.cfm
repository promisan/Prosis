
<cfquery name="HeaderSelect"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM #SESSION.acc#GledgerHeader_#client.sessionNo#_#session.mytransaction#
</cfquery>

<cfparam name="url.reference" default="n/a">  
<cfparam name="url.referenceno" default="n/a"> 

<cfif url.reference neq "n/a">

    <cfquery name="Update" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE #SESSION.acc#GledgerLine_#client.sessionNo#_#session.mytransaction#
	SET Reference = '#URL.Reference#'
	WHERE SerialNo = '#URL.SerialNo#' 
    </cfquery> 

</cfif>

<cfif url.referenceno neq "n/a">

    <cfquery name="Update" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE #SESSION.acc#GledgerLine_#client.sessionNo#_#session.mytransaction#
	SET ReferenceNo = '#URL.ReferenceNo#'
	WHERE SerialNo = '#URL.SerialNo#' 
    </cfquery> 

</cfif>

<cfquery name="Get" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM #SESSION.acc#GledgerLine_#client.sessionNo#_#session.mytransaction#
	WHERE SerialNo = '#URL.SerialNo#' 	
</cfquery> 

<cfoutput query="Get">

<table width="100%" align="right" class="formpadding">

<cfif transactiontype neq "Standard" and getAdministrator("*") eq "0">

	<cfif TransactionType eq "Contra-Account">
	<tr bgcolor="white"><td colspan="2" height="1"></td></tr>
	<cfelse>
	<tr><tr colspan="2">#TransactionType#</tr></tr>
	</cfif>

<cfelse>

<tr>
	<td width="80" class="labelit"
	    style="height:25;word-wrap: normal; word-break: keep-all;"><cf_tl id="Description">:</td>
		
	<td width="120" colpsan="2">
	
		<input type  = "text" 
	       size      = "80" 
		   onchange  = "_cf_loadingtexthtml='';ptoken.navigate('TransactionDetailLinesEdit.cfm?serialno=#get.serialNo#&reference='+this.value,'box_#SerialNo#')"
		   class     = "regularxl" 
		   maxlength = "100" 
		   value     = "#Reference#" 
		   name      = "reference_#SerialNo#">
		   
	</td>
</tr>

<tr>
	
	<td width="80" class="labelit"><cf_tl id="Reference">:</td>
	<td colspan="2">
	
	<table cellspacing="0" cellpadding="0"><tr><td class="labelit">
	
		<input type="text" 
	       size="30" 
		   onchange="_cf_loadingtexthtml='';ptoken.navigate('TransactionDetailLinesEdit.cfm?serialno=#get.serialNo#&referenceno='+this.value,'box_#SerialNo#')"
		   class="regularxl" 
		   maxlength="30" 
		   value="#ReferenceNo#" 
		   name="referenceNo_#SerialNo#">
	
		</td>
		<td style="padding-left:3px">
		
			<cf_filelibraryCheck
		    	DocumentURL="Ledger"
				DocumentPath="Ledger"
				SubDirectory="#HeaderSelect.TransactionId#" 
				Filter="#TransactionSerialNo#"		
				target="#serialNo#">	
			
			</td></tr></table>
	
	</td>

</tr>			

<tr><td colspan="2" style="min-width:100px">
	
	<cf_filelibraryN
		DocumentPath="Ledger"
		SubDirectory="#HeaderSelect.TransactionId#" 
		Filter="#TransactionSerialNo#"
		LoadScript="false"
		box="#SerialNo#"
		color="transparent"
		Insert="no"
		Remove="yes"
		reload="true">	
		   
   </td>
   
</tr>

</cfif>

</table>		   
		   
</cfoutput>
     