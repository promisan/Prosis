
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Displays the groups allowed for the period</proDes>
	<proCom>STL CHANGE</proCom>
</cfsilent>

<cfajaxImport tags="cfdiv">
<cf_dialogREMProgram>
<cf_dialogPosition>

<cfoutput>
<script>

  function apply() {	     
	 ptoken.navigate('ForecastSubmit.cfm?programcode=#url.programcode#&period=#url.period#','process','','','POST','entry')	
  }

  function showPositionDetail(pp, pc, pe, gr) {
  	ColdFusion.navigate('#session.root#/ProgramREM/Application/Budget/Forecast/PositionViewDetail.cfm?PositionParentId='+pp+'&period='+pe+'&programcode='+pc+'&group='+gr,'divPositionDetail');
  }

</script>
</cfoutput>


<cf_screenTop height="100%" html="No" scroll="yes" jquery="Yes">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">

<tr><td style="height:10px;padding-left:10px;padding-right:10px">
    <cfset url.attach = "0">
	<cfinclude template="../../Program/Header/ViewHeader.cfm">
</td></tr>

<tr class="hide"><td id="process"></td></tr>

<cfquery name="Audit" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Audit
	WHERE   Period = '#url.period#' 	
</cfquery>	

<tr><td valign="top" style="height:100%;padding-left:22px;padding-right:22px">

<form name="entry" id="entry" style="height:100%">

<table width="100%" height="100%">

<tr><td class="labelmedium" style="font-weight:200;height:40px;font-size:19px">
	Review calculated forecasts per month and adjust correction settings.
</td></tr>

<tr><td valign="top">

		<table width="100%" height="100%" style="border:1px solid silver">
			
		<tr>
		<td style="border-right:1px solid silver;width:100;padding-left:5px" valign="top">
		
			<table style="width:100%">
			
				<tr><td height="0"></td></tr>
				<tr class="line labelmedium">
					<td style="min-width:40;padding-left:6px"><cf_tl id="Month"></td>
					<td style="min-width:80;padding-left:3px"><cf_tl id="Correction"></td>
				</tr>
				
				<cfoutput query="Audit">
				
					<cfquery name="Get" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   ProgramPeriodForecast
						WHERE  ProgramCode = '#url.ProgramCode#'
						AND    Period      = '#url.period#'
						AND    AuditId     = '#auditid#' 
					</cfquery>
				
					<tr class="line labelit" style="height:20px" bgcolor="FDFEDE">
						<td valign="top" style="height:20px;padding-left:7px;padding-top:2px;font-size:12px;padding-right:8px;min-width:30">#dateformat(AuditDate,"mm/yyyy")#</td>
						<td valign="top" style="padding-top:0px;min-width:30;padding-left:5px">
						<table>
							<tr>
							<td style="padding-left:4px"><input type="text" class="regularh enterastab" name="Correction_#left(auditid,8)#" value="#get.ForecastCorrection#" style="background-color:ffffcf;border:0px;font-size:13px;text-align:right;width:40" onchange="apply()"></td>
							<td style="width:20px;padding-top:2px;padding-left:0px">%</td>
							</tr>
						</table>		
						</td>		
						
					</tr>
					
				</cfoutput>	
			
			</table>
			
		</td>
		
		<td style="padding-left:10px;padding-right:10px;border-right:1px solid silver" valign="top">
		
		<cfquery name="Summary" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
		
				SELECT     FP.PositionParentId, 
						   (SELECT TOP 1 PositionNo
						   FROM Employee.dbo.Position 
						   WHERE PositionParentid = FP.PositionParentId
						   ORDER BY DateEffective DESC) as PositionNo,
						   
						   (SELECT TOP 1 SourcePostNumber
						   FROM Employee.dbo.Position 
						   WHERE PositionParentid = FP.PositionParentId
						   ORDER BY DateEffective DESC) as SourcePostNumber,
						   
				           PP.FunctionDescription, 
						   PP.PostGrade, 
						   PP.DateEffective, 
						   PP.DateExpiration, 
						   FP.Currency, 
						   ROUND(SUM(FP.Amount), 2) AS Amount, 
                           ROUND(SUM(FP.AmountCorrection), 2) AS AmountCorrection
				FROM       ProgramPeriodForecastPosition AS FP INNER JOIN
				           Employee.dbo.PositionParent AS PP ON FP.PositionParentId = PP.PositionParentId INNER JOIN
				           Employee.dbo.Ref_PostGrade AS G ON PP.PostGrade = G.PostGrade
				WHERE      FP.ProgramCode = '#url.programcode#' 
				AND        FP.Period = '#url.period#'
				GROUP BY   FP.PositionParentId, FP.Currency, PP.PostGrade, G.PostOrder, PP.FunctionDescription, PP.DateEffective, PP.DateExpiration
				ORDER BY   G.PostOrder 
				
		</cfquery>
		
			<table class="formpadding navigation_table" width="100%">
			
				<tr class="line labelmedium">
					<td><cf_tl id="Position"></td>
					<td><cf_tl id="Grade"></td>
					<td><cf_tl id="Title"></td>
					<td><cf_tl id="Effective"></td>
					<td align="right"><cf_tl id="Amount"></td>
					<td align="right"><cf_tl id="Adjusted"></td>
				</tr>
				
				<cfoutput query="Summary">
				
				<tr class="line labelmedium navigation_row" onclick="_cf_loadingtexthtml='';ptoken.navigate('#session.root#/ProgramREM/Application/Budget/Forecast/PositionView.cfm?PositionParentId=#PositionParentId#&period=#url.period#&programcode=#url.programcode#','result');">
					<td style="min-width:60px;padding-left:3px">
						<a><cfif sourcePostNumber neq "">#SourcePostNumber#<cfelse>#PositionParentId#</cfif></a>
					</td>
					<td style="min-width:50px">#PostGrade#</td>
					<td style="min-width:300px;width:100%">#FunctionDescription#</td>
					<td style="min-width:140px">#dateformat(DateEffective,client.dateformatshow)#-#dateformat(DateExpiration,client.dateformatshow)#</td>
					<td style="min-width:80px" align="right">#numberformat(amount,',')#</td>
					<td style="min-width:80px" align="right">#numberformat(amountcorrection,',')#</td>
				</tr>
				
				</cfoutput>
				
				<cfif summary.recordcount gte "1">
				
				<cfquery name="Total" dbtype="query">
					SELECT     SUM(Amount) as Amount, SUM(AmountCorrection) as AmountCorrection
					FROM       summary					
				</cfquery>
				
				<cfoutput>
				
				<tr class="line labelmedium ">
					<td colspan="4" style="font-weight:normal"><cf_tl id="Total">#summary.currency#</td>
					<td style="min-width:80px;font-weight:bold;" align="right">#numberformat(Total.amount,',')#</td>
					<td style="min-width:80px;font-weight:bold;" align="right">#numberformat(Total.amountcorrection,',')#</td>
				</tr>
				
				</cfoutput>
				
				</cfif>
			
			</table>		
					
		</td>
		<td style="min-width:200px;height:100%;width:60%;border-right:1px solid silver;padding-right:4px" valign="top">
		
		<cf_divscroll id="result"></cf_divscroll>
		
		</td>
		</tr>
			
	
	</table>

</td>

</tr>

</form>

</td>
</tr>
</table>


<cfset ajaxonload("doHighlight")>

<!--- forecast --->