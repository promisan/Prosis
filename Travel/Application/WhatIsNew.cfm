<!--
    WhatIsNew.cfm
	
	Display what is new list
	
	Modifcation History
	30Jul04 - created file
	16Aug04 - added new entries
-->

<HTML><HEAD><TITLE>What's new</TITLE></HEAD>

<body >
<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>"> 

<BODY background="../Images/background.gif" 
	  bgcolor="#FFFFFF"
	  class="dialog" 
	  onLoad="javascript:document.focus();">

<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr bgcolor="#002350" height="25" valign="middle">
	<td colspan="2" align="center">
		<font face="Tahoma" size="2" color="#FFFFFF">WHAT IS NEW IN PMSTARS</font>		
	</td>	
  <tr><td colspan="2">&nbsp;</td></tr>	
  <tr>
	<td class="regular" width="80 pt" align="center" valign="top">1 Aug 2004</td>
	<td class="regular" width="*">1. Created this WHAT IS NEW IN PMSTARS page.</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
	<td class="regular" >2. Modified Request Document Listing page as follows:</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
	<td class="regular" >
	<ul>
	<li>Added facility to show/hide nominee expected deployment dates and group counts;</li>
	<li>Added grouping by nominee expected deployment date (earliest date in case of multiple expected deployment dates);</li>
	<li>Added facility for filtering records by document number;</li>
	<li>Replaced method of signalling requests needing urgent attention--the red band is gone and instead, the folder icon turns red; and</li>
	<li>An icon appears after the Planned Deployment date field for requests submitted to travel unit within 21 days of the earliest nominee expected deployment date.</li>
	</ul>
  </tr>
  <tr>
	<td>&nbsp;</td>
	<td class="regular" >3. Added validation to prevent marking of Identify Rotating Personnel workflow step (for Military only) as Completed if there is no outbound person already identified.</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
	<td class="regular" >4. Added validation to prevent marking of Enter Nominee Data workflow step as Completed if no active nominees exist under this step.</td>
  </tr>
  <tr height="10"><td>&nbsp;</td></tr>
  <tr>
	<td class="regular" align="center" valign="top">15 Aug 2004</td>
	<td class="regular">1. Modified Personnel Requests List page to add facility for filtering records by rotating person lastname and by nominee lastname.</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
	<td class="regular">2. Modified Request Entry page to remove default planned deployment date.</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
	<td class="regular">3. Modified Nominee Entry and Edit pages to change Planned Deployment Date field label to Expected Deployment Date.</td>
  </tr>
  <tr height="10"><td>&nbsp;</td></tr>
  <tr>
	<td class="regular" align="center" valign="top">27 Aug 2004</td>
	<td class="regular">1. Modified Requests Entry page to set default Planned Deployment date to blank.  A valid date entry is required for this field.</td>
  </tr>
  <tr>
  <tr height="10"><td>&nbsp;</td></tr>
  <tr>
	<td class="regular" align="center" valign="top">09 Sep 2004</td>
	<td class="regular">1. Modified Requests Listing page to set default record layout to DETAIL.</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
	<td class="regular" >2. Modified Request Edit page as follows:</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
	<td class="regular" >
	<ul>
	<li>Show nominees' expected deployment dates;</li>
	<li>Show graphic icons to indicate following conditions for nominees: medically cleared, involved in disciplinary incident, and pass SAT;</li>
	<li>Show column titles for data for nominees.</li>
	</ul>
  </tr>
  <tr>
	<td>&nbsp;</td>
	<td class="regular" >3. Modified Person Assignment Details page to show additional information about the assignment (eg, assignment no, person no).</td>
  </tr>
  <tr height="10"><td>&nbsp;</td></tr>
  <tr>
	<td class="regular" align="center" valign="top">28 Dec 2004</td>
	<td class="regular">1. Modified Action History page to add Effective (Date) column.  Also to re-label the first column from "Date" to "Action Date".</td>
  </tr>
  <tr height="10"><td>&nbsp;</td></tr>
  <tr>
	<td class="regular" align="center" valign="top">09 Jan 2005</td>
	<td class="regular">1. Added new query parameters (Last Name, First Name, Arrival Date, Expected Rotation, Departure, and TOD in the Deployed Personnel and Rotation Plan online views.</td>
  </tr>
  <tr>  
  <tr height="10"><td>&nbsp;</td></tr>
  <tr>
	<td class="regular" align="center" valign="top">15 Jan 2005</td>
	<td class="regular">1. Added code to handle new filters: LastName, FirstName, Expected Deployment, and Category in the Personnel in Process and Personnel on Travel Status online views.</td>
  </tr>
  <tr>
  <tr height="10"><td>&nbsp;</td></tr>
  <tr>
	<td class="regular" align="center" valign="top">01 Apr 2005</td>
	<td class="regular">1. Deployed User Manuals under the Manuals sub-menu.</td>
  </tr>
  <tr>  
  <tr height="10"><td>&nbsp;</td></tr>
  <tr>
	<td class="regular" align="center" valign="top">20 Apr 2005</td>
	<td class="regular">1. Deployed the Stalled Nominations report using the new Nucleus reporting framework.</td>
  </tr>
  <tr>  
  <tr height="10"><td>&nbsp;</td></tr>
  <tr>
	<td class="regular" align="center" valign="top">09 May 2005</td>
	<td class="regular">1. Posted new manual on how to cancel an officer's nomination in PMSTARS.</td>
  </tr>
  <tr>    
</table>

</BODY>
</HTML>