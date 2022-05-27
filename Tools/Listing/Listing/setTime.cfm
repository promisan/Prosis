
<!--- shows the time of the query --->

<cfparam name="url.box" default="">
	
<cfif url.box neq "">

	<cfset htm = session.listingdata[url.box]['listingpreparation']>
	<cfset bse = session.listingdata[url.box]['dataprep']>
	
	<cfparam name="session.listingdata[url.box]['dataprepgroup']" default="0">
	<cfparam name="session.listingdata[url.box]['dataprepsort']" default="0">
	
	<cfset grp = session.listingdata[url.box]['dataprepgroup']>
	<cfset srt = session.listingdata[url.box]['dataprepsort']>
	<cfset dte = session.listingdata[url.box]['timestamp']>
	
	<cfif bse neq "-1">
	    <cfset dbtime = bse + grp + srt>
	<cfelse>
	    <cfset dbtime = grp + srt>
	</cfif>
	
	<cfoutput>
	<table style="width:100%">
		<tr class="labelmedium fixlengthlist">
		<td><cf_tl id="time for preparation">:</td>
		<td style="padding-left:4px">#htm#s		
		</td>				
		<td title="#dateformat(dte,client.dateformatshow)# #timeformat(dte,'HH:MM')#" style="padding-left:4px">(db: #numberformat(dbtime/1000,'.___')#s <cfif bse eq "-1">[<font color="0A72AF">cached: #dateformat(dte,client.dateformatshow)# #timeformat(dte,"HH:MM")#]</cfif>)</td>
		</tr>
	</table>
	</cfoutput>

</cfif>

	