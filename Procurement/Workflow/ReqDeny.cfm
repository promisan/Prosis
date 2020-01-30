
<cfoutput>
<link rel="stylesheet" type="text/css" href="Req.css">

<cfset Today = "#Now()#">

<!--- number of lines printed in invoice and max needed for nice formatting --->
<cfset maxlines = 10>
<cfset numlines = 0>

<!--- Get this requisition Line --->
<cfquery name="Requisition" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  R.Reference, R.RequisitionNo, RequestAmountBase, O.OrgUnit, O.OrgUnitname
	FROM    RequisitionLine R Inner JOIN Organization.dbo.Organization O
				ON R.OrgUnit = O.OrgUnit
	WHERE   R.RequisitionNo = '#Req#' 
	</cfquery>
	
<!--- Get Beneficiary OrgUNits --->
<cfquery name="Beneficiaries" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  O.OrgUnitname
	FROM    RequisitionLineUnit R Inner JOIN Organization.dbo.Organization O
				ON R.OrgUnit = O.OrgUnit
	Where R.RequisitionNo = '#Req#' 
	AND R.OrgUnit != '#Requisition.OrgUnit#'
	</cfquery>	
	
<cfset BeneList = "#Requisition.OrgUnitName#">
	
<cfloop query="Beneficiaries">
	<cfset BeneList = BeneList & ", #OrgUnitName#">
</cfloop>	

<cfquery name="Reasons" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_StatusReason
	WHERE  Status = '9'
</cfquery>

<!--- Get deny reasons for this requisition Line --->
<cfquery name="Denies" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    RequisitionLineActionReason R RIGHT OUTER JOIN
            Ref_StatusReason S ON R.ReasonCode = S.Code 
			AND R.RequisitionNo = '#Req#' 
			AND S.Status = '9'
</cfquery>
	
<cfset DenyList = "">

<cfloop query="Denies">
	<cfset DenyList = DenyList & ", #ReasonCode#">	
</cfloop>	

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
  <tr><td>
  
  	<cfset logo		= "">
	
	<cfquery name="Param" 
	datasource="AppsPurchase"
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT top 1*
		FROM   Parameter.dbo.Parameter
		WHERE  hostname = '#CGI.HTTP_HOST#' 
	</cfquery>
  
  	<cfif Param.recordCount gte 1>
		<cfset path		= replaceNoCase(Param.LogoPath,Param.ApplicationRootPath,"","ALL")>
		<cfset path		= replaceNoCase(path,"\","/","ALL")>
  		<cfset logo		= Client.root&path&Param.LogoFileName>
  	</cfif>
	
<p class="SATMemoLeft">
<!----<img src="#SESSION.root#/images/UN_LOGO_BLUE.gif"> ---->
<img src="#logo#"> 
</p>
<p class="SATMemoLeftSM</p>">
<strong>#Parameter.Mission#</strong>
<BR><BR>
</P>
</td></tr></table>

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding"> 
  	<tr><td>
		<p class="SATMemoCenterBIG">
		
		<cfif CLIENT.LanPrefix eq "ESP" or (CLIENT.LanPrefix eq "" and Language.Code eq "ESP")> 
				<strong>DENEGACI&OacuteN de Requisici&oacute;n de Compra</strong>
		<cfelse>
				<strong>DENIAL of Procurement Request</strong>
		</cfif>
		</p>
	</td></tr>
</table>

<table width="97%" border="1" cellspacing="0" cellpadding="0" align="center" class="formpadding">
<tr><td>		
	<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		<tr><td align="center" style="font-size: smaller;">
		<cfif CLIENT.LanPrefix eq "ESP" or (CLIENT.LanPrefix eq "" and Language.Code eq "ESP")> 
				<strong>INFORMACI&OacuteN GENERAL</strong>
		<cfelse>
				<strong>GENERAL INFORMATION</strong>
		</cfif>
		</td></tr>
		<tr><td>
			<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			
				<cfif CLIENT.LanPrefix eq "ESP" or (CLIENT.LanPrefix eq "" and Language.Code eq "ESP")> 
				<tr><td width="8%" style="font-size: smaller;">Requisici&oacute;n No.</td>
				<cfelse>
				<tr><td width="8%" style="font-size: smaller;">Request Number</td>
				</cfif>
				
				<td width="20%" height="35" class="SatMemo">
					<table width="90%" cellspacing="0" cellpadding="0" Border="1" frame="below" Rules="none">
					<tr><td align="Center">
					<strong>#Requisition.Reference#</strong>
					</td></tr>
					</table>
				</td>		
				<td width="5%" style="font-size: smaller;">Amount</td>
				<td width="25%" height="35" class="SatMemo">
					<table width="90%" cellspacing="0" cellpadding="0" Border="1" frame="below" Rules="none">
					<tr><td align="Center">
					<strong>#NumberFormat(Requisition.RequestAmountBase,"___,___.__")#</strong>
					</td></tr>
					</table>
				</td>
				<td width="10%" style="font-size: smaller;">Denial Date</td>
				<td height="35" class="SatMemo">
					<table width="90%" cellspacing="0" cellpadding="0" Border="1" frame="below" Rules="none">
					<tr><td align="Center">
					<strong>#DateFormat(Today,"dd/mm/yy")#</strong>
					</td></tr>
					</table>
				</td>
				</tr>
			</table>	
		</td></tr>		
		<tr><td>
			<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				<tr><td width="10%" style="font-size: smaller;">Unit</td>
				<td width="65%" height="35" class="SatMemo">
					<table width="90%" cellspacing="0" cellpadding="0" Border="1" frame="below" Rules="none">
					<tr><td align="Center">
					<strong>#Requisition.OrgUnitName#</strong>
					</td></tr>
					</table>
				</td>		
				<td width="6%" style="font-size: smaller;">Index No.</td>
				<td height="35" class="SatMemo">
					<table width="90%" cellspacing="0" cellpadding="0" Border="1" frame="below" Rules="none">
					<tr><td align="Center">&nbsp;
					</td></tr>
					</table>
				</td>
				</tr>
			</table>	
		</td></tr>		
		<tr><td>
			<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				<tr><td width="15%" style="font-size: smaller;">BID</td>
				<td height="35" class="SatMemo">
					<table width="90%" cellspacing="0" cellpadding="0" Border="1" frame="below" Rules="none">
					<tr><td align="Center">&nbsp;
					</td></tr>
					</table>
				</td>		
				</tr>
			</table>	
		</td></tr>		
	</table>	
</td></tr>	

</table>
	
<br>	
	
<table width="97%" border="1" cellspacing="0" cellpadding="0" align="center" class="formpadding">
<tr><td>		
	<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		<tr><td align="center" style="font-size: smaller;"><strong>
		<cfif CLIENT.LanPrefix eq "ESP" or (CLIENT.LanPrefix eq "" and Language.Code eq "ESP")> 
				Raz&oacute;n de denegaci&oacute;n
				<cfelse>
				Denial Reason
			</cfif>
		
		</strong></td></tr>
		<tr><td height="20"></td></tr>
		<tr><td>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			<tr>
			<td width="40%">
			<td width="2%">
			<td width="8%">
			<td width="40%">
			<td width="2%">
			<td width="8%">
			</tr>
			<cfset colnum = 0>
			<cfloop query="Reasons">
				<cfif colnum mod 2 eq 0>
					<tr>
				</cfif>
				<td>#Reasons.Description#</td><td align="center" valign="bottom"><cfif Find(Code,DenyList) gt 0><strong>X</strong><cfelse><u>&nbsp;&nbsp;&nbsp;&nbsp;</u></cfif></td><td></td> 
				<cfif colnum mod 2 eq 1>
					</tr>
				</cfif>
				<cfset colnum++>
			</cfloop>		
		</table>
		</td></tr>	
					
		<tr><td height="20"></td></tr>

		<tr><td>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		<tr>
			<td width="10%"><strong>
			<cfif CLIENT.LanPrefix eq "ESP" or (CLIENT.LanPrefix eq "" and Language.Code eq "ESP")> 
				DETALLES
				<cfelse>
				DETAILS
			</cfif>
			</strong></td>
			<td style="border-bottom: 1px solid black">
			<table width="100%">
			<cfloop query="Denies">
				<cfif remarks neq "">
					<tr>
						<td>#Remarks#</td>
						<td>#OfficerFirstName# #OfficerLastName#</td><td>#dateformat(Created,CLIENT.DateFormatShow)#</td>
					</tr>	
				</cfif>		
			</cfloop>
			</table>
			</td>
			</td>
		</tr>
		</table>

		</td></tr>		
		
		<tr><td height="20"></td></tr>
		
		<tr><td>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			<tr><td align="center"><strong>
			<cfif CLIENT.LanPrefix eq "ESP" or (CLIENT.LanPrefix eq "" and Language.Code eq "ESP")> 
				RETORNAR ESTE FORMULARIO
				<cfelse>
				RETURN THIS FORM
				</cfif>
			</strong></td></tr>
			<tr><td><hr style="text-align: 'left'; width: '100%'"></td></tr>
		</table>
		</td></tr>
	</table>

</td></tr>
</table>

<br>	


</cfoutput>

		