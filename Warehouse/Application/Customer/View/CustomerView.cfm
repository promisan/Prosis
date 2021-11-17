<cf_screentop html="yes" label="Customer view #url.mission#" layout="webapp" jquery="yes">

<cf_ListingScript>
<cf_dialogmaterial>

<table width="97%" height="100%" align="center">
 
 <tr>
 
   <td height="100%" style="padding-top:5px;padding-bottom:5px">
    <cfset url.systemfunctionid = url.idmenu>
    <cfinclude template="CustomerViewListing.cfm"> 
   </td>
 </tr>
 

</table>