
<cfoutput>
<cf_screentop html="No">
<table width="100%" align="center" class="formpadding">

	<tr><td style="Padding-top:50px"></td></tr>
	<tr><td align="center" class="labellarge" style="font-size:30px">#session.welcome# Roster search</td></tr>
	<tr><td></td></tr>
	<tr><td align="center" class="labellarge"><font color="FF0000">We are sorry but your search criteria did not match any candidates</td></tr>
	<tr><td></td></tr>
	<tr><td></td></tr>
	<tr><td></td></tr>
	<tr><td align="center" class="labellarge"><font color="0080C0">
	  <a href="#SESSION.root#/Roster/RosterGeneric/RosterSearch/Search4.cfm?mode=#url.mode#&docno=#url.docno#&id=#URL.ID#">
	  <font color="0080C0"><u><b>Press here</b></u> to adjust your criteria</font>
	  </a></td></tr>

</table>
</cfoutput>