
<cfoutput>

<cfparam name="client.InspectHide" default="true">

<script src="#SESSION.root#/Scripts/Drag/wz_dragdrop.js" type="text/javascript"></script>

<cf_ajaxRequest>
<cf_systemScript>

<script language="JavaScript">

function openflow(connector) {
	window.location="FlowView.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&Connector="+connector;	
	}

function more(bx) {

    icM  = document.getElementById(bx+"Min")
    icE  = document.getElementById(bx+"Exp")
	se   = document.getElementById(bx)
			
	if (se.className == "hide")	{
		se.className  = "regular";
		icM.className = "regular";
	    icE.className = "hide";
		} 
	else {
		se.className  = "hide";
	    icM.className = "hide";
	    icE.className = "regular";
		}
	}

function showaction(drag,action,hl1,hl2) {
	bb = document.getElementById("b"+action)
	bx = document.getElementById(action+drag)
	by = document.getElementById("y"+action)
	bz = document.getElementById("z"+action)
	
	bb.className = hl1 
	bx.className = hl2	
	by.className = hl1	
	bz.className = hl1	
	}		
	
// KRW: 24/01/08 testing
function localPickFunc() {

	if (dd.obj != null) {
		document.onkeydown=KeyDown;
		document.onkeyup=KeyUp;
		if (event.crtlKey) {
			document.getElementById("DragActionConcurrent").className="regular"
			}
		else {	
			document.getElementById("DragActionInsert").className="regular"	
			}
		document.getElementById("DragActionNone").className="hide"	
		}	

	}

function KeyUp () {

	if (dd.obj != null) {
		document.getElementById("DragActionInsert").className="regular"
		document.getElementById("DragActionConcurrent").className="hide"
		}
	}

function KeyDown () {

	if ((dd.obj != null) && (event.ctrlKey)) {
		document.getElementById("DragActionInsert").className="hide"	
		document.getElementById("DragActionConcurrent").className="regular"
		}	
	}

function localdrag() {

	var buffer = 3
	var count = 1
	var found = false
	
	document.onkeydown='';
	document.onkeyup='';
	document.getElementById("DragActionInsert").className="hide"
	document.getElementById("DragActionConcurrent").className="hide"
	document.getElementById("DragActionNone").className="regular"	
	
	
	while (document.getElementById("bd"+count)) { 
		bx = document.getElementById("bd"+count)
		bx.className = "regular"
		count++
		}	
	
	count = 1
	
	
		
	while (document.getElementById("d"+count) && !found) { 
			
		bx = document.getElementById("bd"+count)
		se = document.getElementById("d"+count)	
		dh = se.offsetHeight;
		dw = se.offsetWidth;
		dx = se.offsetLeft;
		dy = se.offsetTop;		
						
		while (se.offsetParent) {
			se = se.offsetParent
			dx = dx+se.offsetLeft;
			dy = dy+se.offsetTop;
			}
								
		if (dd.obj.x >= dx-buffer && dd.obj.x <= dx+dw+buffer) {
			 
			 
			if (dd.obj.y >= dy-buffer && dd.obj.y <= dy+dh+buffer) {
					
				bx.className = "highlight"	
				action = document.getElementById("action"+count).value;
				type   = document.getElementById("type"+count).value;
				leg    = document.getElementById("leg"+count).value;
				
// krw: 24/01/08 add step as concurrent by holding down the CTRL key while dropping   				
				if (event.ctrlKey) {
					concurrent = "Yes"
				} else {
					concurrent = "No"
				}
				
				window.location = "ActionStepConnectionQuery.cfm?"+
				                  "&entitycode=#URL.entityCode#"+
								  "&entityclass=#URL.entityClass#"+
								  "&publishno=#URL.publishNo#"+
			                      "&child="+dd.obj.name+
								  "&parent="+action+
								  "&type="+type+
								  "&leg="+leg+
								  "&connector=#URL.connector#"+
								  "&concurrent="+concurrent
				found = true				  
				}
			}
		count++
		
		}

					
// if not found, then return to original position in missing
	if (!found) {
	
		var stepDist = 40
		var movex
		var movex
		var x
		
		var diffx = dd.obj.x - dd.obj.defx;
		var diffy = dd.obj.y - dd.obj.defy;
		var iterx = Math.floor(diffx/stepDist);
		var itery = Math.floor(diffy/stepDist);
		var iter = Math.max(Math.abs(iterx),Math.abs(itery));
		
		var stepx = diffx/iter
		var stepy = diffy/iter
								
		returnDrag(dd.obj.name, stepx, stepy, iter)
	
		}
	
	}

function flowreset() {		
	if (confirm("Do you want to reset the workflow configurations ?")) {
	   	window.location = "FlowViewReset.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#"
	   }
	return false
	}

function publish() {
      location = "WorkflowPublish.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#";
	}

function log() {
		
	 ptoken.navigate('WorkflowLog.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#','noRefresh');
     alert("The Workflow configuration was successfully logged.");
	 
	}

function restore() {
      location = "WorkflowRestore.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#";
	}

function copyto() {
	
	var vWidth = 450;
   	var vHeight = 375;       
   	ProsisUI.createWindow('mydialog', 'Copy Workflow Settings', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});       					
   	ptoken.navigate("#SESSION.root#/system/entityAction/EntityFlow/ClassAction/WorkflowCopyDialog.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#",'mydialog'); 
	
}

function copytoreturn() {
	var collection;
	var x = '';
	collection = document.getElementById("EClass");
	
	for (i=0;i<collection.length;i++) {
   		if (collection[i].selected)
			x = collection[i].value;
	}	
	
	if (x != '') {
		ptoken.navigate("WorkflowRestoreTo.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&TargetEntityClass="+x+"&PublishNo=#URL.PublishNo#",'mydialog');
	}
}

function compareto() {
	ptoken.open("WorkflowCompare.cfm?ts="+new Date().getTime()+"&EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#", "Add", "left=50, top=50, width=900, height=900, toolbar=no, status=yes, scrollbars=yes, resizable=yes");
	
}

function load(no) {
    location = "FlowView.cfm?PublishNo="+no+"&EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#";
}

function stepreset(id,tpe,steptpe,leftText,rightText) {	

	//krw: 27/02/08 added pop on removing a step if 1) is in a workflow tree and 2) is a decision step
	// leftText and rightText are used to prompt which branch to conserve in the work flow (the other branch steps are reset)
	
	saveBranch = "Yes";
	
	if ((steptpe == 'Decision') && ((tpe == 'Action') || tpe == 'Decision')) {
	
			message = "Which branch to SAVE ?" ;			
			window.location = "ActionStepDecisionQuery.cfm?entitycode=#url.entitycode#&entityclass=#url.entityclass#&publishno=#url.publishno#&id="+id+"&scope=leg&Message="+message+"&leftOption="+leftText+"&rightOption="+rightText			
				
	} else {  
	    parent.Prosis.busy('yes')
		window.location = "FlowViewReset.cfm?tpe="+tpe+"&id="+id+"&steptpe="+steptpe+"&saveBranch="+saveBranch+"&EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#"			
	}
}	
	
function stepresetapply(id,saveBranch) {
		window.location = "FlowViewReset.cfm?id="+id+"&saveBranch="+saveBranch+"&EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#"	
}	
 

function remove(pub) {		
	if (confirm("Do you want to remove this workflow ?")) {
	   	window.location = "FlowViewReset.cfm?tpe=remove&id="+pub+"&EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#"
	   }
	}


function showStep(id,pub){
	if (window.dialogArguments) {			     
			mywin = dialogArguments.window.open("ActionStepContainer.cfm?ts="+new Date().getTime()+"&EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&ActionCode="+id+"&PublishNo="+pub, "stepedit", "left=10, top=10, width=950, height=870, toolbar=no, status=yes, scrollbars=no, resizable=yes");									
	   } else  {					    	 
	   		mywin = window.open("ActionStepContainer.cfm?ts="+new Date().getTime()+"&EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&ActionCode="+id+"&PublishNo="+pub, "stepedit", "left=10, top=10, width=990, height=910, toolbar=no, status=yes, scrollbars=no, resizable=no");
	   }
}
		
function stepedit(id,pub) {

	if (id != "") {	    		 		 
		 try {  
			if (mywin.name=="stepedit"){
				mywin.focus()
			 	mywin.addtab(id,pub)
			} else {
				showStep(id,pub);			
			}
		 } catch(e) { 
			showStep(id,pub);			
		}		 		
	}
}
	
function PrintWFX() {

	var vWidth = 500;
   	var vHeight = 400;       
   	ProsisUI.createWindow('mydialog', 'Print', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});       				
   	ptoken.navigate('#SESSION.root#/system/entityAction/EntityFlow/EntityPrint/EntityPrint.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#','mydialog'); 
}

function printWFDetails() {
	var pnt = new Array
    pnt[1] = document.getElementById("ptworkflow").checked
    pnt[2] = document.getElementById("ptdocuments").checked
    pnt[3] = document.getElementById("ptconfig").checked

	ptoken.open("#SESSION.root#/system/entityAction/EntityFlow/EntityPrint/EntityPrintWebPDF.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&Print=1&PrintWF="+pnt[1]+"&PrintDocs="+pnt[2]+"&PrintConfig="+pnt[3], "WFX", "left=10, top=10, width=930, height=823, toolbar=no, status=yes, scrollbars=yes, resizable=yes");
	ProsisUI.closeWindow('mydialog');
}

function PrintWF() {
	ptoken.open("#SESSION.root#/system/entityAction/EntityFlow/EntitityPrint/EntityFlowPrint/WFPrint.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&Print=1", "stepprint", "left=10, top=10, width=930, height=823, toolbar=no, status=yes, scrollbars=yes, resizable=yes");				  
}
	
function PrintDetails() {
	ptoken.open("#SESSION.root#/system/entityAction/EntityFlow/EntityConfigPrint/ActionStepPrint.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#", "stepprint", "left=10, top=10, width=930, height=823, toolbar=no, status=yes, scrollbars=yes, resizable=yes");				  
}
	
function stepinspect(id,pub) {

    <cfif url.scope eq "Object">
	
	    <cfquery name="Obj" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT O.OrgUnit, R.Role
			FROM   OrganizationObject AS O INNER JOIN
                   Ref_Entity AS R ON O.EntityCode = R.EntityCode
			WHERE Objectid = '#url.objectid#'	   
		</cfquery>		   
					
		ProsisUI.createWindow('actorshow', 'Actors', '',{x:100,y:100,height:350,width:700,resizable:false,modal:true,center:true});		
		url = "#SESSION.root#/tools/EntityAction/ActionListingActor.cfm?Objectid=#url.objectid#&OrgUnit=#Obj.OrgUnit#&Role=#Obj.Role#&ActionPublishNo="+pub+"&ActionCode="+id+"&box=actorshow"				
		ptoken.navigate(url,'actorshow')					 
 	  		
	<cfelse>
	
	if (id != "") {

		<cfif Client.InspectHide eq "true"> 
			 parent.toggleArea('wfcontainer', 'inspect');
		<cfelse>	 
			 parent.expandArea('wfcontainer', 'inspect');
		</cfif>	
				
		parent._cf_loadingtexthtml='';					 
	    parent.ptoken.navigate('WorkflowInspect.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&ActionCode='+id+'&PublishNo='+pub,'inspect')
	 			  
		 }
		  
	</cfif>	  
	}	
		
function stepadd() {
     
	try { parent.ProsisUI.closeWindow('mystep',true) } catch(e) {}
	parent.ProsisUI.createWindow('mystep', 'Workflow steps', '',{x:100,y:100,height:parent.document.body.clientHeight-140,width:parent.document.body.clientWidth-140,modal:true,resizable:false,center:true})    
	parent.ptoken.navigate('#session.root#/System/EntityAction/EntityFlow/ClassAction/ActionStepAdd.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#','mystep') 	

}

function flowprint() {
	ptoken.open("FlowViewPrint.cfm?flowchart="+'flowchart', "Add", "left=80, top=80, width=640, height=700, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function exportFlow() {
	ptoken.open("FlowExport/FlowExport.cfm?EntityCode=#URL.EntityCode#", "Export", "left=80, top=80, width=1000, height=800, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>

</cfoutput>
