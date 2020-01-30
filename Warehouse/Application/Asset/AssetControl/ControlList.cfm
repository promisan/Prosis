
<cfparam name="ID" default="Loc">
<cfparam name="ID1" default="">
<cfparam name="ID2" default="">

<cfif URL.ID eq "Loc">
	<cfset down = "hide">
	<cfset up   = "regular">	
<cfelse>
	<cfset down = "hide">
	<cfset up   = "regular">
</cfif>	

<cfoutput>

<cf_screentop height="100%" scroll="Yes" html="No">


<!--- Search form --->
	
	<table width="99%" height="100%" align="center">
	
	<tr onclick="maximize('locate')" style="cursor:pointer">
	<td height="26" width="97%" class="labelmedium" style="font-weight:200;padding-left:6px">
	<cf_tl id="Filter"></td>
	<td align="right" style="padding-right:10px">
		<img src="#SESSION.root#/images/up6.png" 
		    id="locateMin"		  
			style="border: 0px solid Silver;cursor: pointer;"
			class="#up#">
		<img src="#SESSION.root#/images/down6.png" 		    
			id="locateExp"
			style="border: 0px solid Silver;cursor: pointer;"
			class="#down#">
	</td>
	</tr>
		
	<cfinclude template="ControlListPrepare.cfm">
		
	<tr><td colspan="2" class="line"></td></tr>
	<tr name="locate" id="locate" class="#up#"><td colspan="2">
	 	<cfinclude template="ControlListFilter.cfm"> 	
	</td></tr>
		
	<tr id="locate" class="#up#"><td class="line" colspan="2"></td></tr>
	
	<tr><td colspan="2" valign="top" height="100%">
	
	    <cf_divscroll id="listing">			
			<cfinclude template="ControlListData.cfm">			
		</cf_divscroll>		
	
	</td></tr>
	
	</table>


</cfoutput>

	