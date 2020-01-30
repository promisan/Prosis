<cfset dateValue = "">
<CF_DateConvert Value="#URL.date#">
<cfset DTS = dateValue>

<cfset VARIABLES.Instance.dateSQL = DateFormat(URL.date,"DDMMYYY")/>

<cfquery name="qSteps"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	  SELECT P.RouteId,P.Step,PO.PositionNo, PO.FunctionDescription, 
	  	(SELECT  COUNT(1) 
			FROM stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# D 
			INNER JOIN stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# N ON N.Date = D.Date AND N.Node = D.Node 
			WHERE D.RouteId = P.RouteId AND D.ActionStatus in ('1','1a') 
			AND N.ActionStatus in ('1','1a')
			AND N.Branch = 0) as Total
	  FROM  stWorkPlan_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# P INNER JOIN Employee.dbo.Position PO ON P.PositionNo = PO.PositionNo
	  WHERE Date         = #dts#
	  ORDER BY P.Step ASC
</cfquery>

<cfoutput>
<table width="100%" cellspacing="0" cellpadding="0">
	
	<cfloop query="qSteps">
	
	<tr>		
		<td align="left" height="40px">
			<input type="button" value="#qSteps.FunctionDescription# (#qSteps.Total#)" class="button10" style="height:34px;width:80px;background-color:<cfif qSteps.Step eq URL.Step>DADADA<cfelse>83839B</cfif>; color:<cfif qSteps.Step eq URL.Step>000000<cfelse>fff</cfif>;" <cfif qSteps.Step eq URL.Step>disabled="disabled"</cfif> onclick="processcluster('#qSteps.RouteId#','#url.date#','#qSteps.Step#')">
		</td>
	</tr>	
	
	</cfloop>
	
	<cfquery name="qFlowCheck"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT *
		FROM stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
		WHERE ActionStatus in ('1','1a')
		AND Date         = #dts#
	</cfquery>
	
	<cfif qFlowCheck.recordcount neq 0>
		<tr>
			<td>
				<input type="button" value="View all" class="button10" style="height:34px;width:80px;background-color:5553A9; color:fff;" onclick="seeAll('#url.date#')" <cfif URL.Step eq "final">disabled="disabled"</cfif>>
			</td>	
		</tr>
	</cfif>
		
</table>
</cfoutput>

<script>	
	Prosis.busy('no')
</script>