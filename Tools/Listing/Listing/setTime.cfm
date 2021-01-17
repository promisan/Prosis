
<!--- shows the time of the query --->

<cfparam name="url.box" default="">
	
<cfif url.box neq "">

	<cfset htm = session.listingdata[url.box]['listingpreparation']>
	<cfset bse = session.listingdata[url.box]['dataprep']>
	
	<cfparam name="session.listingdata[url.box]['dataprepgroup']" default="0">
	<cfparam name="session.listingdata[url.box]['dataprepsort']" default="0">
	
	<cfset grp = session.listingdata[url.box]['dataprepgroup']>
	<cfset srt = session.listingdata[url.box]['dataprepsort']>
	
	<cfif bse neq "-1">
	    <cfset dbtime = bse + grp + srt>
	<cfelse>
	    <cfset dbtime = grp + srt>
	</cfif>
	
	<cfoutput>
	<table>
		<tr class="labelmedium">
		<td><cf_tl id="time for preparation">:</td>
		<td style="padding-left:4px">#htm#s</td>
		<td style="padding-left:4px">(db: #numberformat(dbtime/1000,'.___')#s <cfif bse eq "-1"><b><font color="0A72AF">cached</b></cfif>)</td>
		</tr>
	</table>
	</cfoutput>

</cfif>

	