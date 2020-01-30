
<!--- container for editing the asset and related information --->

<cfquery name="get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   ItemTransaction
	WHERE  TransactionId = '#url.id#'	
</cfquery>

<cfset url.assetid = get.assetid>
<cfset url.adate   = get.TransactionDate>

<cfoutput>
	
	<cf_divscroll id="editasset" hide="0" drag="no" float="yes" modal="no" width="680" height="430" overflowy="hidden" zindex="8110" padding="5px">
				
		<cf_tableround mode="modal" totalheight="100%">		
		
			<cf_screentop user="No" label="Amend Beneficiary Information" line="no"  layout="webapp" html="Yes" banner="gray" bannerforce="Yes">	
			
			<form name="transactionform" id="transactionform">
			          
			<table width="100%" align="center" cellspacing="0" cellpadding="0" bgcolor="white" class="formpadding">
			
			<tr><td height="3"></td></tr>						
			<tr><td align="center" style="padding:20px">
			
				<table width="100%" cellspacing="0" cellpadding="0">
			
			    <cfset entrymode = "hidelabel">				
				<cfinclude template="../Inquiry/TransactionEditAssetDetail.cfm">
				
				</table>
			
				</td>
			</tr>
			
			<tr><td class="linedotted"></td></tr>
									
			<tr><td align="center" style="height:36px" id="process">
				
				<table cellspacing="0" align="center" class="formpadding">
				<tr>		
					<td><input type="button" name="Update" value="Update" style="width:140;height:25" onclick="doit('update','#url.id#')"></td>
				</tr>
				</table>
			
			</td></tr>
			
			</table>
			
			</form>
			
			<cf_screenbottom layout="webapp">

        </cf_tableround>
				
    </cf_divscroll>
	
</cfoutput>
	