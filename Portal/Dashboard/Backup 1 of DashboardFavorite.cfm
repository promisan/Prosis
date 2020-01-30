
<!--- get the favorate reports for this user --->
 
<cfquery name="Favorite" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   TOP 10 U.*, R.*, L.TemplateReport, L.LayoutName, S.Description
	FROM     UserReport U,
	         Ref_ReportControlLayout L,
	         Ref_ReportControl R, 
	         Ref_SystemModule S
	WHERE    U.LayoutId     = L.LayoutId
	AND      L.ControlId    = R.ControlId
	AND      R.SystemModule = S.SystemModule
	AND      U.Account      = '#SESSION.acc#'
	AND      L.Operational  = '1'
	AND      S.Operational  = '1'
	AND      U.Status NOT IN ('5','6')
	AND      U.ShowPopular  = '1'		
	ORDER BY R.SystemModule, R.MenuClass, R.FunctionName, U.DateExpiration   
</cfquery>

<cf_screentop height="100%" html="No" JQuery="yes">

<script>

	function report() {
			window.location = "#SESSION.root#/System/Modules/Subscription/RecordListing.cfm?ts="+new Date().getTime()});
		}
	
	function toggle(opt) {
	
		if (window.innerHeight){ 
			h = window.innerHeight 
		}else{ 
		    h = document.body.clientHeight
		} 
		   
		if (opt == "dashboard") {
		    window.location = "Dashboard.cfm?h="+h	 		  
		} else {
		    window.location = "DashboardFavorite.cfm?h="+h	  
		}

	}
	
</script>


<table width="100%" height="100%" cellspacing="0" cellpadding="0">

	<tr><td height="20" class="labellarge" style="font-size:35px;padding-top:10px;padding-left:40px"><b><cf_tl id="Launch Popular reports"></td></tr>
	<tr><td height="10"></td></tr>

<!---

<tr><td>

<cfsavecontent variable="menu">
		
	<cfmenu name="maninfo"
          font="verdana"
          fontsize="9"
          type="horizontal"
          bgcolor="transparent"
          selectedfontcolor="808080">
				  	  		 		 		 		 		  		  
		  <cfmenuitem 
          display="My Dashborad"
          name="menureport"
          href="javascript:toggle('dashboard')"
          image="#SESSION.root#/Images/favorite.gif"/>
		 		  
				 	
	</cfmenu>	
	
</cfsavecontent>	

<cf_tl id="My Favorite reports" var="1">

<cf_ViewTopMenu option="#menu#" close="Yes" label="#lt_text#">

</td>

</tr>

--->

<tr><td valign="top" align="center" style="height:100%;padding-left:40px;padding-right:20px">

<cfif favorite.recordcount eq "0">

<cfoutput>
<table width="50%" align="center">
  <tr><td style="padding-top:90px" height="30" align="center" class="labellarge"><font color="0080FF"><cf_tl id="No reports were set as POPULAR by you">.</font></td></tr>
  <tr><td height="20"></td></tr>
  <tr><td class="labelmedium" align="center"><font color="gray">Please define one or more report variants that you subscribed to a popular under <a href="#SESSION.root#/System/Modules/Subscription/RecordListing.cfm"                                                                                                                                                    target="_self"><font color="0080C0">[Report Subscription]</font></a>; then you will be able to quickly launch them from this function at any time you need.</font></td></tr>
  </table>
</cfoutput>  
  
<cfelse>  
 
<cf_layoutScript>
		
<cf_layout type="Accordion" name="favorite">
				
	<cfoutput query="favorite">
	
		<cf_layoutarea 
          	name="rep#currentrow#"			 
		  	title="#Description# #distributionsubject# - #LayoutName#"
          	overflow="auto"
			onshow="if ($.trim($('##divReport#currentrow#').html()) == '') { ColdFusion.navigate('DashboardFavoriteOpen.cfm?name=rep#currentrow#&reportid=#reportid#','divReport#currentrow#'); }"
		   	onrefresh="ColdFusion.navigate('DashboardFavoriteOpen.cfm?name=rep#currentrow#&reportid=#reportid#','divReport#currentrow#');">
		  
		  		<cfdiv style="height:100%; min-height:100%; border:1px dotted silver;" id="divReport#currentrow#" />
		
		</cf_layoutarea>  
				 
	</cfoutput>			
		
</cf_layout>


</cfif>

</td></tr>

</table>