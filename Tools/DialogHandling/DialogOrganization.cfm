
<cfparam name="client.height" default="900">

<cfajaximport tags="cfwindow">

<cfoutput>

	<script>
	
	function opentree(mis) {	  
	    ptoken.open(root + "/System/Organization/Application/OrganizationView.cfm?mode=embed&mission=" + mis, "orgtree", "width=980, height=660, status=yes, toolbar=no, scrollbars=yes, resizable=no");		
	}
		
	var root = "#SESSION.root#";
	
	function showparent(form,off,loc) {			
		ProsisUI.createWindow('myparent', 'Parent Office', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,resizable:false,center:true})    						
		ColdFusion.navigate('#SESSION.root#/Staffing/Application/Employee/ParentSelect.cfm?FormName= ' + form + '&parentoffice=' + off + '&parentlocation=' + loc,'myparent') 			
	}
	
	function parentselect(fldoff,fldloc,off,loc) {	    
	    document.getElementById(fldoff).value = off;
		document.getElementById(fldloc).value = loc;	
		try { ProsisUI.closeWindow('myparent',true) } catch(e) {}	
	}	
	
	function workflow(ent,cls) {
	    ptoken.open(root + "/System/EntityAction/EntityFlow/ClassAction/FlowViewPreview.cfm?EntityCode="+ent+"&EntityClass="+cls, "_blank", "width=900, height=720, status=yes, toolbar=no, scrollbars=no, resizable=no")
	}
	
	<!--- ------------------------- --->
	<!--- to be replaced one by one --->
	<!--- ------------------------- --->

	// function selectorg(formname, fldorgunit, fldorgunitcode,fldmission,fldorgunitname,fldorgunitclass,role,mission,orgtype)	{		
    //		ret = window.showModalDialog(root + "/System/Organization/Application/OrganizationSearch.cfm?Mission=" + mission + "&OrgType=" + orgtype + "&FormName=" + formname + "&fldorgunit= " + fldorgunit + "&fldorgunitcode=" + fldorgunitcode + "&fldmission=" + fldmission + "&fldorgunitname=" + fldorgunitname + "&fldorgunitclass=" + fldorgunitclass + "&role=" + role + "&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:yes; dialogHeight:600px; dialogWidth:600px; help:no; scroll:no; center:yes; resizable:no");
    //		if (ret) {
	//		if (ret != 1) {
	//			val = String(ret).split(";");
	//			document.getElementById(fldorgunit).value = val[0];
	//			document.getElementById(fldorgunitcode).value = val[1];
	//			document.getElementById(fldmission).value = val[2];		
	//			document.getElementById(fldorgunitname).value = val[3];
	//			document.getElementById(fldorgunitclass).value = val[4];													
	//		}
	//	}	
	// }
	
	function selectorgN(mission,orgtype,fldorgunit,script,scope,single,modal)	{
	    try { ProsisUI.closeWindow('orgunitwindow') } catch(e) {}
		if (modal == 'modal') {
			ProsisUI.createWindow('orgunitwindow', 'Select', '',{x:0,y:0,height:document.body.clientHeight-100,width:670,modal:true,center:true})
		} else {
			ProsisUI.createWindow('orgunitwindow', 'Select', '',{x:0,y:0,height:document.body.clientHeight-100,width:670,modal:true,center:true})
		}
		ColdFusion.navigate(root + '/System/Organization/Application/OrganizationSearchView.cfm?singlemission='+single+'&mode=cfwindow&script='+script+'&Mission=' + mission + '&OrgType=' + orgtype + '&fldorgunit=' + fldorgunit + '&scope=' + scope,'orgunitwindow')
		
	}	
	
	function selectorgroleN(mission,mandate,period,role,fldorgunit,script,scope,modal,action)	{		
	
	    try { ProsisUI.closeWindow('orgunitwindow') } catch(e) {} 	
		if (modal == 'modal') {
			ProsisUI.createWindow('orgunitwindow', 'Select', '',{x:100,y:100,height:document.body.clientHeight-90,width:670,modal:true,center:true})    		 				
		} else {
			ProsisUI.createWindow('orgunitwindow', 'Select', '',{x:100,y:100,height:document.body.clientHeight-90,width:670,modal:false,center:true})   
		}
		ColdFusion.navigate(root + '/System/Organization/Application/LookupRole/Organization.cfm?mode=cfwindow&script=' + script + '&mission=' + mission + '&mandate=' + mandate + '&period=' +period + '&role=' + role +' &fldorgunit=' + fldorgunit + '&scope=' + scope + '&action=' + action,'orgunitwindow') 				
		// try { ColdFusion.Window.show('orgunitwindow') } catch(e) {}
	
		
	}	
		
	function applyorgunit(fld,val,scope,action) {		   	   

		ColdFusion.navigate(root + '/System/Organization/Application/setOrgUnit.cfm?field='+fld+'&orgunit='+val+'&scope=' + scope+'&action=' + action,'process') 													
		if (action == 'enable') {				  
				try { processorg(val) } catch(e) {}     	
			}		
	}
	
		
	function applyOrgunit(fld,val,scope,action) {		   	   

		ColdFusion.navigate(root + '/System/Organization/Application/setOrgUnit.cfm?field='+fld+'&orgunit='+val+'&scope=' + scope+'&action=' + action,'process') 											
		
		if (action == 'enable') {				  
				try { processorg(val) } catch(e) {}     	
			}		
	}
	
	// to be disabled 2/10/2015
				
	function selectorgsinglemission(formname, fldorgunit, fldorgunitcode,fldmission,fldorgunitname,fldorgunitclass,role,mission,orgtype)	{
		ret = window.showModalDialog(root + "/System/Organization/Application/OrganizationSearch.cfm?singleMission=1&Mission=" + mission + "&OrgType=" + orgtype + "&FormName=" + formname + "&fldorgunit= " + fldorgunit + "&fldorgunitcode=" + fldorgunitcode + "&fldmission=" + fldmission + "&fldorgunitname=" + fldorgunitname + "&fldorgunitclass=" + fldorgunitclass + "&role=" + role + "&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:yes; dialogHeight:600px; dialogWidth:600px; help:no; scroll:no; center:yes; resizable:no");
		if (ret) {
			if (ret != 1) {
				val = String(ret).split(";");
				document.getElementById(fldorgunit).value      = val[0];
				document.getElementById(fldorgunitcode).value  = val[1];
				document.getElementById(fldmission).value      = val[2];		
				document.getElementById(fldorgunitname).value  = val[3];
				document.getElementById(fldorgunitclass).value = val[4];													
			}
		}	
	}
			
	function selectorgmis(formname,fldorgunit,fldorgunitcode,fldmission,fldorgunitname,fldorgunitclass,mission,mandate,effective) {
	
		if (formname == "webdialog") {
			ColdFusion.Window.create('orgunitselectwindow', 'Select', '',{x:0,y:0,height:document.body.clientHeight-100,width:document.body.clientWidth-50,modal:true,center:true})
			ColdFusion.navigate(root + "/System/Organization/Application/Lookup/OrganizationViewView.cfm?FormName=" + formname + "&fldorgunit=" + fldorgunit + "&fldorgunitcode=" + fldorgunitcode + "&fldmission=" + fldmission + "&fldorgunitname=" + fldorgunitname + "&fldorgunitclass=" + fldorgunitclass + "&mission=" + mission + "&mandate=" + mandate + "&effective=" + effective + "&ts="+new Date().getTime(),'orgunitselectwindow');
		 } else {	
		 	ptoken.open(root + "/System/Organization/Application/Lookup/OrganizationView.cfm?FormName=" + formname + "&fldorgunit=" + fldorgunit + "&fldorgunitcode=" + fldorgunitcode + "&fldmission=" + fldmission + "&fldorgunitname=" + fldorgunitname + "&fldorgunitclass=" + fldorgunitclass + "&mission=" + mission + "&mandate=" + mandate + "&effective=" + effective , "IndexWindow", "width=850, height=660, status=yes, toolbar=no, scrollbars=yes, resizable=yes");
		 }
	}
	
	// this is the new code 
	
	function selectorgmisn(mission,mandate,effective) {
	
		// 15/2/2015 newly added to replace modal dialog 	
		try { ColdFusion.Window.destroy('orgunitselectwindow',true) } catch(e) {}
		ColdFusion.Window.create('orgunitselectwindow', 'Unit', '',{x:100,y:100,height:document.body.clientHeight-60,width:850,modal:false,resizable:false,center:true})    					
		ptoken.navigate(root + '/System/Organization/Application/Lookup/Organization.cfm?mission=' + mission + '&mandate=' + mandate + '&effective=' + effective,'orgunitselectwindow') 				
		
	}	
			
	function selectlocation(formname, fldlocationcode, fldlocationname, mission,id) {
			         
		try { ColdFusion.Window.destroy('mylocation',true) } catch(e) {}
		ColdFusion.Window.create('mylocation', 'Location', '',{x:100,y:100,height:document.body.clientHeight-80,width:900,modal:false,resizable:false,center:true})    						
		ColdFusion.navigate(root + '/Staffing/Application/Location/Lookup/LocationView.cfm?id='+ id + '&FormName=' + formname + '&fldlocationcode=' + fldlocationcode + '&fldlocationname=' + fldlocationname + '&mission=' + mission,'mylocation') 		
		
	}
	
	function selectorgmisProcess(source, mission, mandateno, id, id1) {
		ptoken.open(root + "/System/Organization/Application/Lookup/OrganizationViewProcess.cfm?source=" + source + "&mission=" + mission + "&mandateno=" + mandateno + "&id=" + id + "&id1=" + id1, "IndexWindow", "width=850, height=660, status=yes, toolbar=no, scrollbars=yes, resizable=no");
	}
	
	function viewOrgUnit(org) {	      
	    w = 1170;
	    h = #CLIENT.height# - 110;
		ptoken.open(root + "/System/Organization/Application/UnitView/UnitView.cfm?ID=" + org, "OrgUnit"); 
	}
	
	function addOrgUnit(mission,mandate,org,par,src,mode) {
	    window.location  = root + "/System/Organization/Application/OrganizationAdd.cfm?mode="+mode+"&source="+src+"&ID1=" + mission + "&ID2=" + mandate + "&ID3=" + org + "&ID4=" + par
	}
	
	function editOrgUnit(org,node,src) {	    
		ptoken.open(root + "/System/Organization/Application/OrganizationEdit.cfm?source="+src+"&node="+node+"&ID=" + org, "org"+org, "width=860, height=890, status=yes, toolbar=no, scrollbars=yes, resizable=no");		
	}
	
	function hierarchy(mission) {
	     ptoken.open(root+ "/System/Organization/Application/OrganizationHierarchy.cfm?href=" + window.location.href + "&Mission=" + mission, "_blank", "width=300, height=300 status=yes, toolbar=no, scrollbars=no, resizable=yes") 
	}
	
	</script>
	

</cfoutput>