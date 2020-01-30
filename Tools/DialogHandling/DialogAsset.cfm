
<cfoutput>

<cfset root = SESSION.root>

<cfparam name="client.widthfull" default="1000">
<cfparam name="client.height"    default="1000">

<script>

var root = "#root#";

function AssetDialog(ind) {  

    w = "#client.widthfull-100#";
    h = "#client.height-100#";
    ptoken.open(root + "/Warehouse/Application/Asset/AssetAction/AssetView.cfm?assetid=" + ind, ind);
	}

function addLocation(mission,org,par) {
    ptoken.location(root + "/Warehouse/Maintenance/Location/LocationAdd.cfm?ID1=" + mission + "&ID3=" + org + "&ID4=" + par);
}

function editLocation(location) {

	try { parent.ColdFusion.Window.destroy('mylocation',true) } catch(e) {}
	parent.ColdFusion.Window.create('mylocation', 'Location', '',{x:100,y:100,height:parent.document.body.clientHeight-80,width:parent.document.body.clientWidth-80,modal:true,resizable:false,center:true})    				
	parent.ColdFusion.navigate(root + '/Warehouse/Maintenance/Location/Location.cfm?id=' + location,'mylocation') 	

}

function editwarehouselocation(warehouse,location,access,idmenu) {		    
    try { ColdFusion.Window.destroy('locationdetail',true) } catch(e) {}; 
	ColdFusion.Window.create('locationdetail', 'Location Detail', '',{x:100,y:100,height:document.body.clientHeight-30,width:document.body.clientWidth-30,resizable:true,modal:true,center:true})	
	ColdFusion.navigate('#SESSION.root#/Warehouse/Maintenance/WarehouseLocation/LocationMain.cfm?systemfunctionid='+idmenu+'&access='+access+'&warehouse='+warehouse+'&location=' + location,'locationdetail')
}

function selectloc(formname,fldlocation,fldlocationcode,fldlocationname,fldorgunit,fldorgunitname,fldpersonno,fldname,mission) {
	w = "900";
    h = "700";
	ptoken.open("#SESSION.root#/Warehouse/Maintenance/Location/Lookup/LocationView.cfm?FormName=" + formname + "&fldlocation=" + fldlocation + "&fldlocationcode=" + fldlocationcode + "&fldlocationname=" + fldlocationname + "&fldorgunit=" + fldorgunit + "&fldorgunitname=" + fldorgunitname + "&fldpersonno=" + fldpersonno + "&fldname=" + fldname + "&mission=" + mission + "&ts="+new Date().getTime(), "_blank", "left=100, top=100, width=" + w + ", height= " + h + ", menubar=no, status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

/*
	 ret = window.showModalDialog(root + "/Warehouse/Maintenance/Location/Lookup/LocationView.cfm?FormName=" + formname + "&fldlocation=" + fldlocation + "&fldlocationcode=" + fldlocationcode + "&fldlocationname=" + fldlocationname + "&fldorgunit=" + fldorgunit + "&fldorgunitname=" + fldorgunitname + "&fldpersonno=" + fldpersonno + "&fldname=" + fldname + "&mission=" + mission + "&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:yes; dialogHeight:620px; dialogWidth:740px; help:no; scroll:yes; center:yes; resizable:yes");
	 if (ret) {	
	    val = ret.split(";") 
		document.getElementById(fldlocation).value = val[0]
	    document.getElementById(fldlocationcode).value = val[1]
		document.getElementById(fldlocationname).value = val[2]
		try {
			if (document.getElementById(fldorgunit).value == '') {			
   				document.getElementById(fldorgunit).value = val[3]
				}
			} catch(e) {}
		try {
			if (document.getElementById(fldorgunitname).value == '') {
				document.getElementById(fldorgunitname).value = val[4] 
				}
			} catch(e) {}
									
		try {
		   if (document.getElementById(fldpersonno).value == '') {
			   document.getElementById(fldpersonno).value = val[5] 
			   }
			}   catch(e) {}
		try {
		
			 if (document.getElementById(fldname).value == '') {
				document.getElementById(fldname).value = val[6]
			  }
		   } catch(e) {}
		try { processloc(val[0]) } catch(e) {}     	
      }
  	}
*/

</script>

</cfoutput>