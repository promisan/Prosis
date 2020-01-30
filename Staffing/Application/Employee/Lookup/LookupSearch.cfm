
<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cf_screentop height="100%" 
    html="Yes" 
	scroll="Yes" 
	label="Locate Employee" 
	option="Enter your search criteria" 
    layout="webapp" 
	banner="gray" 
	bannerforce="Yes">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td width="100%" height="100%" style="overflow:hidden">

<cfoutput>

<cfparam name="url.formname"     default="">
<cfparam name="url.fldpersonno"  default="">
<cfparam name="url.fldlastname"  default="">
<cfparam name="url.fldfirstname" default="">
<cfparam name="url.fldfull"      default="">
<cfparam name="url.fldindexno"   default="">
<cfparam name="url.orgunit"      default="">
<cfparam name="url.mission"      default="">
<cfparam name="url.fldnationality"  default="">
<cfparam name="url.flddob"          default="">
<cfparam name="url.fnselected"      default="">
<cfparam name="url.showadd"         default="1">

<iframe name="result" id="result"
      src="LookupSearchSelect.cfm?FormName=#URL.FormName#&fldpersonno=#URL.fldpersonno#&fldindexno=#URL.fldindexno#&fldlastname=#URL.fldlastname#&fldfirstname=#URL.fldfirstname#&fldfull=#URL.fldfull#&flddob=#URL.flddob#&fldnationality=#URL.fldnationality#&OrgUnit=#URL.OrgUnit#&Mission=#url.mission#&fnselected=#url.fnselected#&showadd=#url.showadd#&mid=#mid#" width="100%" height="100%" frameborder="0"></iframe>

</cfoutput>	  
</td></tr>
</table>

<cf_screenbottom layout="webapp">