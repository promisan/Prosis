
<cf_screentop html="No" label="Select Location">

<cfoutput>

<script language="JavaScript1.2">

function check() {
	
	if (window.event.keyCode == "13") {
	   se = document.getElementById("search");
	   se.click()
	}
}

function refreshTree() {
	location.reload(); }

function search(condition) {
	
	<cfif #URL.Mode# eq "Lookup">
		parent.right.location="LocationListingFlat.cfm?Mode=#URL.Mode#&Mission=#URL.Mission#&ID1=" + condition + "&FormName=#URL.formname#&fldlocationcode=#URL.fldlocationcode#&fldlocationname=#URL.fldlocationname#"
	<cfelse>
		parent.right.location="LocationListingFlat.cfm?Mode=#URL.Mode#&Mission=#URL.Mission#&ID1=" + condition
	</cfif>

}

</script>

<table border="0" cellspacing="0" cellpadding="0">
  
  <tr><td height="10"></td></tr>
  
  <tr>
  	<td style="padding-left:5px;padding-right:2px" class="labelmedium"><cf_tl id="Find">:</td>
	
	<td>
	  <input type="text" onKeyUp="javascript:check()" id="condition" name="condition" size="10" maxlength="20" class="regularxl">
    </td>
	
    <td onClick="search(condition.value)" style="padding-left:1px;cursor:pointer">	 
	  <img height="25" width="24" src="#session.root#/Images/search.png" border="0" alt="submit search">  	 
   </td>
   
  </tr>
 
  </table>
  
</cfoutput>
