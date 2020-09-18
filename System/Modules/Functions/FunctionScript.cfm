<cfoutput>

	<script language="JavaScript">
			
			function process() {
			if (document.irole.role) {  
			  document.irole.role.submit() }
				<cfif #Line.AccessUserGroup# eq "1">
				  document.igroup.group.submit()
				</cfif>
				document.entry.submit()
			}
			
			function showmissions(id, role, type){
				var vWidth = $(document).width() - 100;
			   	var vHeight = $(document).height() - 100;    
			   
			   	ColdFusion.Window.create('mydialog', 'Entity', '',{x:30,y:30,height:vHeight,width:vWidth,modal:false,center:true,closable:false});    
			   	ColdFusion.Window.show('mydialog'); 				
			   	ColdFusion.navigate("#SESSION.root#/System/Modules/Functions/RecordMissionListing.cfm?ID=" + id + "&role=" + role + "&alltype=" + type + "&ts="+new Date().getTime(),'mydialog'); 
			}
			
			function editSection(id, section) {
				//window.showModalDialog("#SESSION.root#/System/Modules/PortalBuilder/Section/FunctionSectionEdit.cfm?id="+id+"&section="+section+"&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:no; dialogHeight:525px; dialogWidth:800px; help:no; scroll:no; center:yes; resizable:yes");	
				//ColdFusion.navigate('#SESSION.root#/System/Modules/PortalBuilder/Section/FunctionSection.cfm?id='+id, 'contentbox1');
				
				var vWidth = $(document).width() - 50;
			   	var vHeight = $(document).height() - 50;    
			   
			   	ColdFusion.Window.create('mydialog', 'Sections', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true,closable:true});    
			   	ColdFusion.Window.show('mydialog'); 				
			   	ColdFusion.navigate("#SESSION.root#/System/Modules/PortalBuilder/Section/FunctionSectionEdit.cfm?id="+id+"&section="+section+"&ts="+new Date().getTime(),'mydialog'); 
			}
			
			function removeSection(id, section) {
				ColdFusion.navigate('#SESSION.root#/System/Modules/PortalBuilder/Section/FunctionSectionDelete.cfm?id='+id+'&section='+section, 'contentbox1');
			}						
						
			function helpedit(mod,cde,cls,id,mid) {
			    ptoken.open("../helpBuilder/RecordEdit.cfm?code="+cde+"&class="+cls+"&idmenu="+mid+"&id="+id+"&ts="+new Date().getTime(), "help", "status=yes, height=950px, width=1030, scrollbars=yes, center=yes, resizable=yes");
				// help(mid)
			}			
			
			function addAuthorizationCode(id) {
				ptoken.navigate('#SESSION.root#/System/Modules/Functions/Authorization/AuthorizationRoles.cfm?id='+id+'&mode=new', 'contentbox1');
			}					

			function submitAuthorizationCode(id) {
				ac = document.getElementById("AuthorizationCode");				
				if (ac.value!='')
					ptoken.navigate('#SESSION.root#/System/Modules/Functions/Authorization/AuthorizationRolesSubmit.cfm?id='+id+'&mode=new', 'contentbox1','','','POST','editauthorizationform');
				else
					alert('Please define an authorization code');	
			}	

			function showAndHide(id,mde) {				
				ptoken.navigate('#SESSION.root#/System/Modules/Functions/Authorization/AuthorizationRoles.cfm?id='+id+'&mode='+mde, 'contentbox1');
			}	
			
			function selectValidation(c, sel) {
				if (c.checked) { 
					$(sel).css('display',''); 
				} else { 
					$(sel).css('display','none'); 
				}
			}				

	</script>

</cfoutput>

<cf_calendarscript>