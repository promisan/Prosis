<!---
	..Travel/Application/Dialog.cfm
	
	DO NOT OVERWRITE WITH VERSION FROM OTHER MODULES!!
	Contains custom code application to Travel Module only.
	
	Javascript functions that opens	popup windows containing specified data
	
	Modification History:
	15Jan05 - added new param for ShowDocument(): OpenMode
--->
<cfoutput>
<cfset root = "#CLIENT.root#">

<SCRIPT LANGUAGE = "JavaScript">

var root = "#root#";

w = 0
h = 0
if (screen) 
{
w = screen.width - 60
h = screen.height - 110
}

function addcandidate(vacno) {
    w = screen.width - 90;
    h = screen.height - 140;
 	window.open(root + "/Travel/Application/CandidateEntry.cfm?ID=" + vacno, "IndexWindow", "left=35, top=35, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
}

function adddeployedperson(vacno) {
    w = screen.width - 200;
    h = screen.height - 300;
 	window.open("PersonSearch.cfm?ID=" + vacno, "IndexWindow", "left=35, top=35, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
}

function addnewincident() {
    w = screen.width - 90;
    h = screen.height - 140;
	window.open("IncidentEntry.cfm", "IndexWindow", "left=35, top=35, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
}

function addnewcontingent() {
    w = screen.width - 200;
    h = screen.height - 350;
	window.open("ContingentEntry.cfm", "IndexWindow", "left=35, top=35, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
}

function addnewcontingentactivity(contid) {
    w = screen.width - 200;
    h = screen.height - 350;
	window.open("ContingentActivityEntry.cfm?CONT_ID=" + contid, "IndexWindow", "left=35, top=35, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
}

function pm_addnewmsg(parentid, mode) {
	window.open("MessageEntry.cfm?ID=" + parentid + "&ID1=" + mode, "IndexWindow", "width=420, height=450, status=no, toolbar=no, scrollbars=no, resizable=no");
}

function pm_createrequestfax(docno) {
    w = screen.width - 100;
    h = screen.height - 150;
 	window.open("./Document/Request/Document.cfm?ID=" + docno, "RequestFax", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");	
}

function pm_createcpdlist(docno, flag, actdir) {
    w = screen.width - 100;
    h = screen.height - 150;
 	window.open("./Document/Cpd_list/Document.cfm?ID=" + docno + "&ID1=" + flag + "&ID2=" + actdir, "CPD_List", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");	
}

function listincident(formname, fieldname, last, dob, nat) {
    w = screen.width - 90;
    h = screen.height - 140;
    window.open("../Search/IncidentSearchResults.cfm", "SearchIncident", "width=600, height=550, toolbar=no, scrollbars=yes, resizable=yes");
}
	
function showincidentedit(incno) {
    w = screen.width - 90;
    h = screen.height - 140;
    window.open("IncidentEdit.cfm?ID=" + incno, "IncidentEdit", "left=30, top=30, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
}

function showcontingentedit(cont) {
    w = screen.width - 200;
    h = screen.height - 350;
    window.open("ContingentEdit.cfm?ID=" + cont, "ContingentEdit", "left=30, top=30, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}	

function showcontingentdetail(cont) {
    w = screen.width - 200;
    h = screen.height - 350;
    window.open("ContingentDetail.cfm?CONT_ID=" + cont, "ContingentDetail", "left=30, top=30, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}	

function showincidentview(incno) {
    w = screen.width - 80;
    h = screen.height - 130;
	window.open("IncidentView.cfm?ID=" + incno, "IncidentView", "left=30, top=30, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
}

function pm_editassigndates(assno) {
    w = screen.width - 280;
    h = screen.height - 180;
	window.open("PersonAssignmentEdit.cfm?ID=" + assno, "PersonAssignmentEdit", "left=50, top=70, width=" + w + ", height= " + h + ", status=no, toolbar=no, scrollbars=yes, resizable=no");
}

function pm_findperson(formname, fieldname, last, dob, nat) {
	window.open(root + "/Travel/Search/IndexSearchLocate.cfm?ID=" + formname + "&ID1=" + fieldname + "&ID2=" + last + "&ID3=" + dob + "&ID4=" + nat, "FindPerson", "width=600, height=550, toolbar=no, scrollbars=yes, resizable=yes");
}
	
function pm_editperson(persno) {
    window.open(root + "/Travel/Application/PersonEdit.cfm?ID=" + persno, "EditPerson", "width=600, height=450, toolbar=no, scrollbars=yes, resizable=yes");
}	

function pm_editpersonmedical(docno, persno, actid) {
	window.open(root + "/Travel/Application/PersonMedicalClearance.cfm?ID=" + docno + "&ID1=" + persno + "&ID2=" + actid, "PersonMedicalClearanceEdit", "width=700, height=550, toolbar=no, scrollbars=yes, resizable=yes");
}	

function pm_editincidentperson(inc, persno) {
    w = screen.width - 180;
    h = screen.height - 1000;
	window.open(root + "/Travel/Application/IncidentPersonEdit.cfm?ID=" + inc + "&ID1=" + persno, "IncidentPersonEdit", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
}

function showdocument(vacno,candlist,actionid) {
	window.open(root + "/Travel/Application/DocumentEdit.cfm?ID=" + vacno + "&IDCandlist=" + candlist + "&ActionId=" + actionid, "VacancyEdit", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
}

function showdocumentcandidate(vacno,persno) {
    w = screen.width - 80;
    h = screen.height - 130;
	window.open(root + "/Travel/Application/DocumentCandidateEdit.cfm?ID=" + vacno + "&ID1=" + persno, "VacancyCandidateEdit", "left=30, top=30, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
}
function showcertificate(docnum) {
    w = screen.width - 80;
    h = screen.height - 130;
	window.open("TravelCertificate.cfm?DocNo=" + docnum,"ViewCertificate", "status=yes, toolbar=no, scrollbars=yes, resizable=yes");
}

</SCRIPT>
</cfoutput>