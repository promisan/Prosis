<cfoutput>
<cfparam name="URL.link" default="">

<cf_DialogPosition>

<cfset link = "#replace('#url.link#','_','&','ALL')#">	
<cf_tl id="Zoom In/Out" var="vZoomMsg">
	
<script>

function showtree(tree,mission,man) {

	_cf_loadingtexthtml='';
    Prosis.busy('yes')
    url = "#SESSION.root#/System/Organization/Tree/OrgTreeShow.cfm?mandateno="+man+"&mission="+mission+"&tree="+tree	
	ColdFusion.navigate(url,'tree')	
	collapseArea('lOrgTree','treedetail');

}

function tree(parent,name) {
  
    vTree=document.getElementById('treeselect');	
	vOrgUnit=document.getElementById('_OrgUnit');
	vOrgUnit.value=parent;
	vName=document.getElementById('_Name');
	vName.value=name;
	vPostClass=document.getElementById('_PostClass');	
	vFund=document.getElementById('_Fund');
	vLayout=document.getElementById('_AllDetails');	
	vSummary=document.getElementById('_Summary');	
	vShowColumns=document.getElementById('_ShowColumns');	
	vDate=document.getElementById('selectiondate');		
	_cf_loadingtexthtml='';
    Prosis.busy('yes')
	url = "OrgTreeLevel.cfm?direction=horizontal&parent="+parent+"&tree="+vTree.value+"&nme="+name+"&selectiondate="+vDate.value+"&fund="+vFund.value+"&postClass="+vPostClass.value+"&Layout="+vLayout.value+"&Summary="+vSummary.value+"&ShowColumns="+vShowColumns.value;
	ColdFusion.navigate(url,'treeview')
}

function refreshtree() {   
    <!--- refreshes the tree --->
	
	_cf_loadingtexthtml='';
    Prosis.busy('yes')
    vOrgUnit  = document.getElementById('_OrgUnit');	
	vName     = document.getElementById('_Name');	
    url       = "OrgTreeRefresh.cfm?parent="+vOrgUnit.value+"&nme="+vName.value
	ColdFusion.navigate(url,'prepare')				   
}

function details(id,org,act) {
     
     icM  = document.getElementById(id+"Min");
     icE  = document.getElementById(id+"Exp");
     se   = document.getElementById(id);

	 vTree        = document.getElementById('treeselect');	
	 vPostClass   = document.getElementById('_PostClass');
	 vFund        = document.getElementById('_Fund');
 	 vSummary     = document.getElementById('_Summary');
	 vDate        = document.getElementById('selectiondate');	
	 vShowColumns = document.getElementById('_ShowColumns');	
	 		  		 		 
	 if (se.className=="hide" || act=="show") {	  	   
	   	 icM.className = "regular";
	     icE.className = "hide";		
         se.className  = "regular";				
		 // ColdFusion.navigate('OrgTreeAssignmentDetail.cfm?mode='+act+'&showcolumns='+vShowColumns.value+'&tree='+vTree.value+'&selectiondate='+selectiondate.value+'&unit='+org+'&postClass='+_PostClass.value+'&Fund='+_Fund.value+'&Summary='+_Summary.value,id)		
		 ColdFusion.navigate('OrgTreePicture.cfm?tree='+vTree.value+'&selectiondate='+vDate+'&orgunit='+org,'picturebox')  
		 
	 } else {	    
	 	 icM.className = "hide";
	     icE.className = "regular";		 
     	 se.className  = "hide";		 
	 }	
		 		
  }

function maintainQuick(org,id,se,tree) {
	
    if (tree == "Operational") {
		expandArea('lOrgTree','treedetail');
		var iframe = document.getElementById('treedetailcontent');
		iframe.src = "#SESSION.root#/Staffing/Application/Position/MandateView/MandateViewGeneral.cfm?header=no&ID=ORG&ID1="+org+"&ID2=#URL.Mission#&ID3=#URL.MandateNo#";
		//window.open("#SESSION.root#/Staffing/Application/Position/MandateView/MandateViewGeneral.cfm?header=no&ID=ORG&ID1="+org+"&ID2=#URL.Mission#&ID3=#URL.MandateNo#", "treedetailcontent", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes")	
	} else {
		alert('Details not supported yet');
		expandArea('lOrgTree','treedetail');
	}
	
	node = document.getElementsByName("selectnode")
	cnt = 0	
	while (node[cnt]) {	   
	   node[cnt].className = ""
	   cnt++	  
   	}  		
	se.className = "topn"	
	
}  

function returnmain() {   
	 window.open("#SESSION.root#/Staffing/Reporting/PostView/Staffing/PostViewLoop.cfm?#link#","_self")
}	


function printchart() {
   
    vTree=document.getElementById('treeselect');	
	vOrgUnit=document.getElementById('_OrgUnit');	
	vPostClass=document.getElementById('_PostClass');
	vFund=document.getElementById('_Fund');
	vDate=document.getElementById('selectiondate');	
	vPrint=document.getElementById('_PrintDetails');
    vShowColumns=document.getElementById('_ShowColumns');		
	
	window.open("OrgTreePrint.cfm?Tree="+vTree.value+"&PrintDetails="+vPrint.value+"&Mission=#URL.Mission#&Mandate=#URL.MandateNo#&selectiondate="+vDate.value+"&OrgUnitCode="+vOrgUnit.value+"&fund="+vFund.value+"&postClass="+vPostClass.value+"&ShowColumns="+vShowColumns.value,"OrgChart", "menubar=yes,status=yes,scrollbars=yes,resizable=yes,width=900,height=800");

}	

function setPostClass(v) {
	vPostClass=document.getElementById('_PostClass');
	vPostClass.value=v;
}			

function setFund(v) {
	vFund=document.getElementById('_Fund');
	vFund.value=v;
}			

function setDetails(o) {
	vAllDetails=document.getElementById('_AllDetails');
	if (o.checked==false) {
		o.value='hide';
	} else {
		o.value='show';
	}
	vAllDetails.value=o.value;		
}			

function setPrint(o) {
	vPrintDetails=document.getElementById('_PrintDetails');
	if (o.checked==false) {
		o.value='hide';
	} else {
		o.value='show';
	}
	vPrintDetails.value=o.value;	
	
}			

function setSummary(o) {
	vSummary=document.getElementById('_Summary');

	vGrade = document.getElementById('ShowGrade');
	vPosition = document.getElementById('ShowPosition');
	vFund = document.getElementById('ShowFund');
	vAdmin = document.getElementById('ShowAdmin');		
	vPersonGrade = document.getElementById('ShowPersonGrade');
	vFullName = document.getElementById('ShowFullName');
	
	if (o.checked==false) {
		o.value='0';
		vGrade.disabled = false;
		vPosition.disabled = false;
		vAdmin.disabled = false;	
		vFund.disabled = false;
		vPersonGrade.disabled = false;
		vFullName.disabled = false;			

	} else {
		o.value='1';

		vGrade.disabled = true;
		vPosition.disabled = true;
		vAdmin.disabled = true;			
		vFund.disabled = true;
		vPersonGrade.disabled = true;
		vFullName.disabled = true;		
	}
	vSummary.value=o.value;		

	
}	

function setShowColumn(o) {
	val = document.getElementById('_ShowColumns');
	
	vSummary=document.getElementById('Summary');
	if (o.checked == false) {
		val.value = val.value.replace(o.value+'|','');
	} else {
		val.value= val.value + o.value + '|';
	}	
	
	vGrade = document.getElementById('ShowGrade');
	vPosition = document.getElementById('ShowPosition');
	vFund = document.getElementById('ShowFund');
	vAdmin = document.getElementById('ShowAdmin');	
	vPersonGrade = document.getElementById('ShowPersonGrade');
	vFullName = document.getElementById('ShowFullName');
	
	if (vGrade.checked || vPosition.checked || vFund.checked || vPersonGrade.checked || vFullName.checked || vAdmin.checked)
		vSummary.disabled = true;
	else
		vSummary.disabled = false;			
	
}	

ie = document.all?1:0
ns4 = document.layers?1:0
				
function hlnode(itm,fld) {		
								 	 	
	 if (fld != "normal"){
		 itm.className = "nodHover titleTree white";		
	 } else {	     
	     if (itm.className != "nodHover") {
	         itm.className = "titleTree";		
		 }
	 }
 }		 


function ZoomChange(e) {
	newZoom     = e.value*10;
	currentZoom = 100+newZoom+'%'
    treeview.style.zoom = currentZoom;	
}


function createWindowZoom(){
	var window = $("##wZoom");
	if (!window.data("kendoWindow")) {
        window.kendoWindow({
            width: "210px",
			height: "65px",
			actions: ["Minimize"],
			resizable: false,
			title: "#vZoomMsg#"
        });
		
    }	

}

function doZoom(){
	var dzoom = $("##zoom").data("kendoSlider");
	if (!dzoom) {
		$("##zoom").show();
		$("##zoom").kendoSlider({
			orientation: "horizontal",
			min: -9,
			max: 9,
			smallStep: 1,
			largeStep: 9,
			showButtons: true,
			change: ZoomChange
		});
		createWindowZoom();
	}  
}

</script>

</cfoutput>
