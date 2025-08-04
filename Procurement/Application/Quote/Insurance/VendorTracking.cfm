<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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