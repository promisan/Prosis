<cfif client.editing eq "1">

	<cfoutput>

	<script language="JavaScript">
			function tl_edit(cls,id) {
			
				<cfif client.browser eq "Explorer">
				
					ret = window.showModalDialog("#SESSION.root#/tools/language/TL_edit.cfm?ts="+new Date().getTime()+"&cls="+cls+"&clsid="+id, window, "unadorned:yes; edge:raised; status:yes; dialogHeight:390px; dialogWidth:500px; help:no; scroll:no; center:yes; resizable:no");
					if (ret) {
					history.go()
					}
				
				<cfelse>						
					window.open("#SESSION.root#/tools/language/TL_edit.cfm?ts="+new Date().getTime()+"&cls="+cls+"&clsid="+id, null, "width=400, height=535, status=no, toolbar=no, scrollbars=no, resizable=no, modal=yes");				   
				</cfif>
			}		
		</script>
	</cfoutput>	
	
</cfif>