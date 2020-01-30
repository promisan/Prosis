<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfparam name="attributes.jobno" default="">
<cfparam name="attributes.orgunit" default="0">
<cfparam name="attributes.class" default="Insurance">

<cfquery name="EventsAll" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT S.*, 
		       F.TrackingDate, 
			   F.TrackingMemo, 
			   F.JobNo as Selected
		FROM   Ref_Tracking  S LEFT OUTER JOIN
               JobVendorTracking F ON F.TrackingCode = S.Code 
			   AND F.JobNo = '#attributes.jobno#'
			   AND F.OrgUnitVendor = '#attributes.orgunit#'
		WHERE  TrackingClass = '#attributes.class#'
		ORDER BY S.ListingOrder 
	</cfquery>
	
	<cfoutput query="EventsAll">
	
	<TR>
	    <TD class="labelit">&nbsp;<cf_tl id="#Description#">
		<input type="hidden" name="Code_#attributes.class#_#CurrentRow#" id="Code_#attributes.class#_#CurrentRow#" value="#Code#" size="4" maxlength="4"></td>
		</TD>
		<TD>
		<table cellspacing="0" cellpadding="0">
		<tr><td>
		
		<cf_intelliCalendarDate9
			FieldName="TrackingDate_#code#" 
			Default="#DateFormat(TrackingDate, '#CLIENT.DateFormatShow#')#"
			AllowBlank="True"
			Class="regularxl">
		</TD>
		<td style="padding-left:10px">
		<input type="text" class="regularxl" name="TrackingMemo_#code#" id="TrackingMemo_#code#"
		value="#TrackingMemo#" size="30" maxlength="50">
		</td>
		</tr>
		</table>
		
	</TR>
	
	</CFoutput>