
<cfparam name="URL.Mission"           default="">
<cfparam name="URL.HierarchyRootUnit" default="">
<cfparam name="URL.HierarchyCode"     default="">
<cfparam name="URL.OrgUnitName"       default="">
<cfparam name="URL.Status"            default="0">
<cfparam name="URL.Parent"            default="All">
<cfparam name="URL.Mode"              default="Control">
<cfparam name="URL.Entity"            default="">

<cfif URL.Mode eq "Dashboard">
	No longer support
	<<cfabort>
</cfif>

<cfparam name="URL.Status" default="0">

<!--- correction hanno 24/10 as sometimes the widget has abother ' --->
<cfif findNoCase("portal",url.mode)>
	<cfset url.mode = "portal">
</cfif>	

<cfif url.mode eq "Control">
	
		<cf_screentop html="No" jQuery="Yes">
	
		<!--- load script stuff --->
	
		<cfajaximport tags="cfform,cfdiv,cfchart">
		<cf_dialogPosition>
		<cf_calendarscript>
		<cfinclude template="../Document/Dialog.cfm">
		
		<cfoutput>
		
		<cf_systemscript>
		
		<script language="JavaScript">
		
		 function printme() {
		    w = 990;
		    h = #CLIENT.height# - 180;
			ptoken.open('ControlListing.cfm?#cgi.query_string#&mode=print', '_blank', 'left=30, top=30, width=' + w + ', height= ' + h + ', menu=no,toolbar=no,status=no, scrollbars=no, resizable=yes'); 
		 }
		
		 function show_box_search() {
			element = document.getElementById('img_search');
			element_row = document.getElementById('dBox');
			if (element_row.className == 'hide') {
				element_row.className = 'normal';
				element.src = '#SESSION.root#/images/arrow-up.gif';
			} else	{
				element_row.className = 'hide';
				element.src = '#SESSION.root#/images/arrow-down.gif';
			}
		
		 }
		 
		 function do_restrict (e) {
		    Prosis.busy('yes')
			_cf_loadingtexthtml='';	
			ptoken.navigate('ControlCriteria.cfm?Entity=#URL.Entity#&Mission=#URL.Mission#&HierarchyRootUnit=#URL.HierarchyRootUnit#&HierarchyCode=#URL.HierarchyCode#&Mode=#URL.Mode#&Status=#URL.Status#&Parent=#URL.Parent#&EntityCode='+e,'dCriteria'); 
		 }
		 
		 function do_search () {
		 	document.fCriteria.onsubmit();
			if( _CF_error_messages.length == 0 ) {
			    _cf_loadingtexthtml='';	
				Prosis.busy('yes')	
				ptoken.navigate('ControlListingResult.cfm?Criteria=Yes&Entity=#URL.Entity#&Mission=#URL.Mission#&HierarchyRootUnit=#URL.HierarchyRootUnit#&HierarchyCode=#URL.HierarchyCode#&Mode=#URL.Mode#&Status=#URL.Status#&Parent=#URL.Parent#','dDetails','','','POST','fCriteria');
			}	
		 
		 }
		
		</script>
	
	</cfoutput>
	
</cfif>

<cfif url.mode neq "Portal" and url.mode neq "Print">
	<div class="screen">
<cfelseif url.mode eq "Print">
  <cf_screentop html="No" jQuery="Yes" scroll="Yes">
  <title>Recruitment Tracks printable version</title>  	
</cfif>

<cfparam name="CLIENT.FileNo" default="">

<cfif CLIENT.FileNo eq "">
	<cfset CLIENT.FileNo = round(rand()*1020) >
</cfif>
	
<!--- we can move this portion up into the topic --->
	
<cfoutput>

<table height="100%" width="96%" align="center">

	<cfif url.mode neq "Portal">	
				
		<tr>		
		    <td style="height:10px">		
			    <table width="100%" border="0" cellspacing="0" cellpadding="0">
				
					<tr>
				    <td align="left" class="labellarge" style="font-weight:200;padding-left:20px;height:46px;font-size:34px;padding-top:4px">
						<cfif url.mode eq "Print">#SESSION.welcome# Recruitment manager</cfif>				
						    <cfif url.mode neq "Print">
							<a href="javascript:show_box_search()">#URL.Mission# <img id="img_search" src="#SESSION.root#/images/arrow-down.gif" alt="" border="0" align="top"></a>													
							<cfelse>
							#URL.Mission#
							</cfif>
						<cfif url.HierarchyRootUnit neq "">&nbsp;#url.orgunitname#</cfif>
					</td>					
				    <td align="right"></td>
					<td align="right" style="padding-right:2px"></td>						
					</tr>
				
				</table>			
		    </td>			
		</tr>	
	
		<tr id="dBox" class="hide">		
			<td width="100%" colspan="3" id="dCriteria" style="padding:5px;border:0px solid silver;height:10px">
				<cfinclude template="ControlCriteria.cfm">
			</td>			
		</tr>			
		
		
	<cfelse>
			
		<cfinclude template="ControlGetTrack.cfm">		
					
	</cfif>	

</cfoutput>

<tr>
	<td colspan="2" valign="top" id="dDetails" style="height:100%">		
		<cfif url.mode neq "Portal">	
	    <cf_divscroll>		
		<cfinclude template = "ControlListingResult.cfm">		
		</cf_divscroll>
		<cfelse>
		<cfinclude template = "ControlListingResult.cfm">		
		</cfif>
	</td>
</tr>

</table>

