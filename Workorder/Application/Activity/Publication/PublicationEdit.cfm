<cfif trim(url.publicationId) eq "">
	<cf_tl id="Add Publication" var="1">
<cfelse>
	<cf_tl id="Edit Publication" var="1">
</cfif>

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="#lt_text#" 
			  banner="blue"
			  jQuery="yes"
			  user="no">
			  
<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	Publication
		<cfif trim(url.publicationId) eq "">
		WHERE	1=0
		<cfelse>
		WHERE	PublicationId = '#url.publicationId#'
		</cfif>
</cfquery>

<cfform name="frmPublish" method="POST" onsubmit="return false;">

	<table width="93%" height="100%" align="center" class="formpadding">
		<tr><td height="15"></td></tr>
		<tr>
			<td class="labelit"><cf_tl id="Description">:</td>
			<td>
				<cfinput name="description" id="description" maxlength="50" value="#get.description#" size="30" required="Yes" message="Please, enter a valid description." class="regularxl">
			</td>
		</tr>
		
		<tr>
			<td class="labelit"><cf_tl id="Effective">:</td>
			<td style="position:relative; z-index:10;">
				<cfset vPeriodEffective = now()>
				<cfif trim(url.publicationId) neq "">
					<cfset vPeriodEffective = get.PeriodEffective>
				</cfif>
				<cf_intelliCalendarDate9
					FieldName="PeriodEffective" 
					Default="#dateformat(vPeriodEffective,CLIENT.DateFormatShow)#"
					class="regularxl"
					AllowBlank="False">	
			</td>
		</tr>
		
		<tr>
			<td class="labelit"><cf_tl id="Expiration">:</td>
			<td>
				<cfset vPeriodExpiration = now()>
				<cfif trim(url.publicationId) neq "">
					<cfset vPeriodExpiration = get.PeriodExpiration>
				</cfif>
				<cf_intelliCalendarDate9
					FieldName="PeriodExpiration" 
					class="regularxl"
					Default="#dateformat(vPeriodExpiration,CLIENT.DateFormatShow)#"
					AllowBlank="False">	
			</td>
		</tr>
		<tr><td height="5"></td></tr>
		<tr><td class="line" colspan="2"></td></tr>
		<tr><td height="5"></td></tr>
		<tr>
			<td colspan="2" align="center">
				<cf_tl id="Save" var="1">
				<cfoutput>
					<input 
						type="Button" 
						id="btnSubmitPub" 
						name="btnSubmitPub" 
						value="#lt_text#" 
						class="button10g" 
						onclick="submitPublishForm('#url.workorderid#','#url.publicationId#');">
				</cfoutput>
			</td>
		</tr>
	</table>
</cfform>  

<table><tr><td id="processPublication"></td></tr></table>

<cfset AjaxOnLoad("doCalendar")>
