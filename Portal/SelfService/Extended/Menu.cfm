
<cfquery name="Menu"
	datasource="AppsSystem"
	username="#SESSION.login#"
	Password="#SESSION.dbpw#">
	SELECT	 *
	FROM     xl#CLIENT.LANGUAGEID#_Ref_ModuleControl
	WHERE	 SystemModule	= 'SelfService'	
	AND		 MenuClass		= 'Menu'
	AND		 Functionclass	= '#URL.ID#'
	AND      Operational     = '1'
	ORDER BY MenuOrder
</cfquery>	

<cfoutput>
<script>	
	
	 function menuselect(d) {
		var myArray = new Array();
		var i;

		<cfloop query="menu">
			myArray[#menuorder#] = 'menu#menuorder#';
		</cfloop>
		
		if ($('##'+d).attr("class") == 'submenuregular') {$('##'+d).attr("class", "submenuselected")}
		else{}
		
		for ( i=1;i<=myArray.length-1;i++)
		{
			if(myArray[i] != d) 
			{$('##'+myArray[i]).removeClass('submenuselected').addClass('submenuregular');}
			
		}
	}	
	
</script>
</cfoutput>

<table cellpadding="0" cellspacing="0" border="0" width="100%" align="center">
	<tr>
	
	<cfif FileExists ("#SESSION.rootpath##Menu.FunctionDirectory##Menu.FunctionPath#")>
		
		<cfoutput query="Menu">
			
			<td width="10px"></td>
				
				<td class="<cfif currentrow eq "1">submenuselected<cfelse>submenuregular</cfif>" id="menu#menuorder#" align="center"
					
					<cfif FileExists ("#SESSION.rootPATH##LayoutBanner.FunctionDirectory##LayoutBanner.FunctionPath#") 
							and LayoutBanner.Operational eq "1" 
							and find(".cfm",LayoutBanner.FunctionPath) gt "1">						
						
						OnClick="menuselect('menu#menuorder#'); ColdFusion.navigate('Extended/Option.cfm?id=#url.id#&menu=1&link=../../../#Menu.FunctionDirectory##Menu.FunctionPath#','dmenu'); 
								
								<!---This will be replaced by a database placed image file for each menu item --->
								<cfif FileExists ("#SESSION.rootPATH#Custom/portal/#URL.ID#/Images/Banner#Menu.Menuorder#.jpg")>
									<cfset ext = ".jpg">
								<cfelseif FileExists ("#SESSION.rootPATH#Custom/portal/#URL.ID#/Images/Banner#Menu.Menuorder#.png")>
									<cfset ext = ".png">
								<cfelseif FileExists ("#SESSION.rootPATH#Custom/portal/#URL.ID#/Images/Banner#Menu.Menuorder#.gif")>
									<cfset ext = ".gif">
								<cfelseif FileExists ("#SESSION.rootPATH#Custom/portal/#URL.ID#/Images/Banner#Menu.Menuorder#.swf")> 
									<cfset ext = ".swf">
								<cfelse>
									<cfset ext = "">
								</cfif>
								
								<cfif ext neq "">
								ColdFusion.navigate('#SESSION.root#/Custom/portal/#URL.ID#/Banner.cfm?id=#url.id#&order=#Menu.Menuorder#&ftype=#ext#&webapp=#url.id#','banner')</cfif> ">
					
					<cfelse>				
						
						OnClick="menuselect('menu#menuorder#'); ColdFusion.navigate('Extended/Option.cfm?id=#url.id#&menu=1&webapp=#url.id#&link=../../../#Menu.FunctionDirectory##Menu.FunctionPath#','dmenu'); ">
					
					</cfif>
					
					<cfif menu.functionmemo neq "">
						#menu.FunctionMemo#
					<cfelse>
						#menu.FunctionName#
					</cfif>
			</td>
		
		</cfoutput>
			<td>&nbsp;</td>
		<cfelse>
		<td valign="middle" style="color:red">Menu has not been configured in Portal Maintenance</td>
		</cfif>
	</tr>
</table>