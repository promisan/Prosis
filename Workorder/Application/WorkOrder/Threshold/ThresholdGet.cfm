
<cfparam name="url.workorderline" default="0">

<cfquery name="getThreshold" 
		datasource="appsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   TOP 1 * 
		FROM     WorkorderThreshold
		WHERE    WorkOrderid   = '#url.workorderid#'				
		AND      WorkorderLine = '#url.workorderline#'
		ORDER BY DateEffective DESC
	</cfquery>	

<cfif getThreshold.recordcount eq "0" and url.workorderline neq "0">
		
	<cfquery name="getThreshold" 
		datasource="appsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   TOP 1 * 
		FROM     WorkorderThreshold
		WHERE    WorkOrderid   = '#url.workorderid#'				
		AND      WorkorderLine = '0'
		ORDER BY DateEffective DESC
	</cfquery>	
	
</cfif>

<cfoutput>	
			
	<table cellspacing="0" cellpadding="0">
	<tr>
		<td class="labelmedium" style="padding-left:4px"><cf_tl id="Effective">:&nbsp;</td>
		<td style="z-index:10; position:relative;padding:0px">
		
		<cfquery name="getThreshold" 
			datasource="appsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   TOP 1 * 
			FROM     WorkorderThreshold
			WHERE    WorkOrderid   = '#url.workorderid#'				
			AND      WorkorderLine = '#url.workorderline#'
			ORDER BY DateEffective DESC
		</cfquery>	
		
		<cf_intelliCalendarDate9
			FieldName="thresholddateeffective" 
			Manual="True"		
			Class="regularxl"							
			Default="#dateformat(getThreshold.DateEffective,CLIENT.DateFormatShow)#"
			AllowBlank="True">	
		
		</td>
	
		<td class="labelmedium" style="padding-left:10px" style="padding-left:6px"><cf_tl id="Amount in"> #APPLICATION.BaseCurrency#:&nbsp;&nbsp;&nbsp;</td>			
		<td  style="padding-left:3px">
		<input class="regularxl" name="thresholdamount" id="thresholdamount" value="#getthreshold.threshold#" type="text" size="10" maxlength="8" style="text-align:right">
		</td>	
	
		
		<td style="padding-left:3px">
		<cf_tl id="Save" var="vSave">
		<input type="button" 
		      onclick="ColdFusion.navigate('../Threshold/ThresholdSet.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#','thresholdbox','','','POST','workorderform')" 
			  value="#vSave#" 
			  style="width:88;height:25" 
			  class="button10g">
		</td>
		<td height="22" id="thresholdbox" class="labelit" style="padding-left:5px"></td>
	
	</tr>
	</table>		
	
</cfoutput>

<cfset ajaxonload("doCalendar")>